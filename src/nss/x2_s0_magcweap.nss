// Magic Weapon
//
// Grants a +1 enhancement bonus.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/28/2002 Andrew Nobbs     Initial release.
// 07/07/2003 Georg Zoeller    Stacking Spell Pass
// 07/17/2003 Andrew Nobbs     Complete Rewrite to make use of Item Property
//                             System.
// 02/15/2004 jpavelch         Changed duration from turns to rounds.
// 04/01/2004 jpavelch         Spell no longer works with Thayvian crafted
//                             items.
// 10/09/2004 jpavelch         Change duration back to turns.

#include "nw_i0_spells"
#include "x2_i0_spells"
#include "x2_inc_spellhook"
#include "tcs_include"


void  AddEnhancementEffectToWeapon(object oMyWeapon, float fDuration)
{
   IPSafeAddItemProperty(oMyWeapon,ItemPropertyEnhancementBonus(1), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,TRUE);
   return;
}

object GetTargetedWeaponOrEquipedWeapon()
{
object oTarget  =  GetSpellTargetObject();

    if(GetObjectType(oTarget)== OBJECT_TYPE_CREATURE)
    {
    object oRightHand   = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
    object oBite        = IPGetTargetedOrEquippedMeleeWeapon();
    if(GetIsObjectValid( oRightHand ) ) return oRightHand;
    if(GetIsObjectValid( oBite ) )      return oBite;
    }
    if( IPGetIsMeleeWeapon( oTarget ) || IPGetIsRangedWeapon( oTarget ) )
    return oTarget;

return OBJECT_INVALID;
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

    //--------------------------------------------------------------------------
    // Transmutation
    //--------------------------------------------------------------------------
    int nTransmutation    = GetLocalInt( OBJECT_SELF, "ds_spell_"+IntToString( SPELL_GREATER_MAGIC_WEAPON ) );


    //Declare major variables
    effect eVis     = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nDuration   = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic  = GetMetaMagicFeat();

    object oMyWeapon   =  GetTargetedWeaponOrEquipedWeapon();
    int nType          = GetBaseItemType(oMyWeapon);

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }

    if((GetIsObjectValid(oMyWeapon) &&
    (IPGetIsMeleeWeapon( oMyWeapon )    ||
    nType == BASE_ITEM_CREATUREITEM     ||
    nType == BASE_ITEM_CPIERCWEAPON     ||
    nType == BASE_ITEM_CBLUDGWEAPON     ||
    nType == BASE_ITEM_CSLASHWEAPON)
    && nTransmutation <= 1 ) )
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
            AddEnhancementEffectToWeapon(oMyWeapon, TurnsToSeconds(nDuration));
            SendMessageToPC(OBJECT_SELF, "<c þ > Enchantment bonus successfully added to "+GetName(GetItemPossessor(oMyWeapon))+"'s Weapon.");
        }
        return;
    }

    if( GetIsObjectValid(oMyWeapon) && nTransmutation == 2 )
    {
        SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if ( TCS_GetIsThayvian(oMyWeapon) ) {
            SendMessageToPC( OBJECT_SELF, "This spell does not work on Thayvian crafted items" );
            return;
        }

        if (nDuration>0)
        {
            string sMessage = "Attack bonus";
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), TurnsToSeconds(nDuration));
            IPSafeAddItemProperty(oMyWeapon, ItemPropertyAttackBonus(1), TurnsToSeconds(nDuration) ,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            switch (nType)
            {
            case BASE_ITEM_HEAVYCROSSBOW:
            case BASE_ITEM_LIGHTCROSSBOW:
            case BASE_ITEM_LONGBOW:
            case BASE_ITEM_SHORTBOW:
            case BASE_ITEM_SLING:
            IPSafeAddItemProperty(oMyWeapon, ItemPropertyMaxRangeStrengthMod(1), TurnsToSeconds(nDuration) ,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            sMessage = "Attack bonus and mighty";
            break;
            default: break;
            }
            SendMessageToPC(OBJECT_SELF, "<c þ > "+sMessage+" successfully added to "+GetName(GetItemPossessor(oMyWeapon))+"'s Weapon.");

        }
        return;

    }

    FloatingTextStrRefOnCreature(83615, OBJECT_SELF);

}
