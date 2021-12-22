// Deafening Clang
//
// Grants a +1 to attack and +3 bonus sonic damage to a weapon. Also the
// weapon will deafen on hit.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/28/2002 Andrew Nobbs     Initial release.
// 07/07/2003 Georg Zoeller    Stacking Spell Pass
// 07/07/2003 Andrew Nobbs     Complete Rewrite to make use of Item Property
//                             System.
// 04/01/2004 jpavelch         Spell no longer works with Thayvian crafted
//                             items.
// 12/29/2014 Glim             Enabled usage with Unarmed Strike.
//

#include "nw_i0_spells"
#include "x2_i0_spells"
#include "x2_inc_spellhook"
#include "tcs_include"


void  AddDeafeningClangEffectToWeapon(object oMyWeapon, float fDuration)
{
   IPSafeAddItemProperty(oMyWeapon,ItemPropertyAttackBonus(1), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,FALSE);
   IPSafeAddItemProperty(oMyWeapon,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_3), fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING ,FALSE,FALSE);
   IPSafeAddItemProperty(oMyWeapon, ItemPropertyOnHitCastSpell(137, 5),fDuration,  X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE,FALSE);
   IPSafeAddItemProperty(oMyWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_SONIC), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );
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
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();

    object oMyWeapon   =  IPGetTargetedOrEquippedMeleeWeapon();
    int nItem = IPGetIsMeleeWeapon(oMyWeapon);
    object oTarget = GetSpellTargetObject();

    if(GetObjectType(oMyWeapon)!=OBJECT_TYPE_ITEM && GetObjectType(oTarget)==OBJECT_TYPE_CREATURE){

        oMyWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS,oTarget);
    }

    int nType = GetBaseItemType( oMyWeapon );

    if(!IPGetIsMeleeWeapon( oMyWeapon ) && nType != BASE_ITEM_GLOVES){
        SendMessageToPC(OBJECT_SELF, "<cþ  > Invalid target, melee weapons or gloves only.");
        return;
    }

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }
    if (nDuration == 0)
    {
      nDuration =1;
    }

    if(GetIsObjectValid(oMyWeapon) )
    {
        SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if ( TCS_GetIsThayvian(oMyWeapon) ) {
            SendMessageToPC( OBJECT_SELF, "This spell does not work on Thayvian crafted items" );
            return;
        }

        if (nDuration>0)
        {

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), TurnsToSeconds(nDuration));
            AddDeafeningClangEffectToWeapon(oMyWeapon, TurnsToSeconds(nDuration));
        }
        return;
    }
    else
    {
        FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
        return;
    }
}
