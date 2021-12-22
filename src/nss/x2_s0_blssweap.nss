// Bless Weapon
//
// If cast on a crossbow bolt, it adds the ability to slay rakshasa's on
// hit.
// If cast on a melee weapon,
//  grants a +1 enhancement bonus
//  grants a +2d6 damage divine to undead
// will add a holy vfx when command becomes available.
//
// If cast on a creature it will pick the first melee weapon without these
// effects
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/28/2002 Andrew Nobbs     Initial release.
// 07/07/2003 Georg Zoeller    Stacking Spell Pass.
// 07/15/2003 Andrew Nobbs     Complete Rewrite to make use of Item Property
//                             System.
// 02/15/2004 jpavelch         Changed duration from turns to rounds.
// 04/01/2004 jpavelch         Spell will no longer work on Thayvian items.
// 12/20/2004 jpavelch         Changed duration to turns/level.
// 12/29/2014 Glim             Enabled usage with Unarmed Strike.
//

#include "nw_i0_spells"
#include "x2_i0_spells"
#include "x2_inc_spellhook"
#include "tcs_include"


void AddBlessEffectToWeapon( object oPC, object oTarget, float fDuration ){

    //--------------------------------------------------------------------------
    // Transmutation
    //--------------------------------------------------------------------------
    int nTransmutation    = GetLocalInt( oPC, "ds_spell_"+IntToString( SPELL_BLESS_WEAPON ) );
    //SendMessageToPC( oPC, "[test: Transmutation="+IntToString( nTransmutation )+"]" );

    if ( GetIsObjectValid( GetSpellCastItem() ) ) {

        nTransmutation = 1;
    }


   // If the spell is cast again, any previous enhancement boni are kept
   IPSafeAddItemProperty(oTarget, ItemPropertyEnhancementBonus(1), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE);

   // Replace existing temporary anti undead boni
   if ( nTransmutation == 2 ){

        //SendMessageToPC( oPC, "[test: applying Positive damage vs Undead]" );
        IPSafeAddItemProperty(oTarget, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_POSITIVE, IP_CONST_DAMAGEBONUS_2d6), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
   }
   else{

        //SendMessageToPC( oPC, "[test: applying Divine damage vs Undead]" );
        IPSafeAddItemProperty(oTarget, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d6), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
   }

   IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );

   return;
}


void main()
{

    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook


    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    object oTarget = GetSpellTargetObject();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration * 2; //Duration is +100%
    }

    // ---------------- TARGETED ON BOLT  -------------------
    if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
    {
        // special handling for blessing crossbow bolts that can slay rakshasa's
        if (GetBaseItemType(oTarget) ==  BASE_ITEM_BOLT)
        {
           SignalEvent(GetItemPossessor(oTarget), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
           IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(123,1), TurnsToSeconds(nDuration), X2_IP_ADDPROP_POLICY_KEEP_EXISTING );
           ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
           ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oTarget), TurnsToSeconds(nDuration));
           return;
        }
    }

   object oMyWeapon   =  IPGetTargetedOrEquippedMeleeWeapon();
   int nItem = IPGetIsMeleeWeapon(oMyWeapon);
   int nType = GetBaseItemType( oMyWeapon );

   if(nItem == TRUE || nType == BASE_ITEM_GLOVES || nType == BASE_ITEM_BRACER )
   {
        if(GetIsObjectValid(oMyWeapon) )
        {
            SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

            if ( TCS_GetIsThayvian(oMyWeapon) ) {
                SendMessageToPC( OBJECT_SELF, "This spell does not work on Thayvian crafted items" );
                return;
            }

            if (nDuration>0)
            {
                AddBlessEffectToWeapon( OBJECT_SELF, oMyWeapon, TurnsToSeconds(nDuration) );
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), TurnsToSeconds(nDuration));
            }
            return;
        }
            else
        {
            FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
            return;
        }
    }
}
