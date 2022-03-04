// Greater Magic Weapon
//
// Grants a +1 enhancement bonus per 3 caster levels (maximum of +5).
// Lasts 1 hour per level.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/28/2002 Andrew Nobbs     Initial release.
// 07/07/2003 Georg Zoeller    Stacking Spell Pass
// 07/17/2003 Andrew Nobbs     Complete Rewrite to make use of Item Property
//                             System.
// 04/01/2004 jpavelch         Changed duration from turns to rounds and
//                             made spell no longer work with Thayvian
//                             crafted items.
// 12/20/2004 jpavelch         Changed duration to turns/level.
//
// 2/8/2022   The1Kobra        Copied GMW and adjusted to work for RDD formula.
//                             CL is RDD level + bard + sorc levels, based on
//                             RDD being the caster.

#include "nw_i0_spells"
#include "x2_i0_spells"
#include "x2_inc_spellhook"
#include "tcs_include"
#include "inc_td_itemprop"


void  AddGreaterEnhancementEffectToWeapon(object oMyWeapon, float fDuration, int nBonus)
{
   IPSafeAddItemProperty(oMyWeapon,ItemPropertyEnhancementBonus(nBonus), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
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
    object oCaster = OBJECT_SELF;
    int nBardLevels = GetLevelByClass(CLASS_TYPE_BARD,oCaster);
    int nSorcLevels = GetLevelByClass(CLASS_TYPE_SORCERER,oCaster);
    int nDDLevels = GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE);

     // Casted From item
    if(!GetIsObjectValid( GetSpellCastItem( ))) {
        if (GetLastSpellCastClass() == CLASS_TYPE_DRAGON_DISCIPLE) {
            nDuration = nDuration + nBardLevels + nSorcLevels;
        }
    }

    int nCasterLvl = nDuration / 3;
    int nMetaMagic = GetMetaMagicFeat();

    //--------------------------------------------------------------------------
    // Transmutation
    //--------------------------------------------------------------------------
    int nTransmutation    = GetLocalInt( OBJECT_SELF, "ds_spell_"+IntToString( SPELL_GREATER_MAGIC_WEAPON ) );


    //Limit nCasterLvl to 5, so it max out at +5 enhancement to the weapon.
    if(nCasterLvl > 5)
    {
        nCasterLvl = 5;
    }

     object oMyWeapon   = GetTargetedOrEquippedWeaponForSpell(SPELL_GREATER_MAGIC_WEAPON);
     int nType          = GetBaseItemType(oMyWeapon);

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }

    if((GetIsObjectValid(oMyWeapon) &&
    (IPGetIsMeleeWeapon( oMyWeapon )    ||
    nType == BASE_ITEM_GLOVES           ||
    nType == BASE_ITEM_CSLSHPRCWEAP     ||
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
            AddGreaterEnhancementEffectToWeapon(oMyWeapon, (TurnsToSeconds(nDuration)), nCasterLvl);
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
            IPSafeAddItemProperty(oMyWeapon, ItemPropertyAttackBonus(nCasterLvl), TurnsToSeconds(nDuration) ,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            switch (nType)
            {
            case BASE_ITEM_HEAVYCROSSBOW:
            case BASE_ITEM_LIGHTCROSSBOW:
            case BASE_ITEM_LONGBOW:
            case BASE_ITEM_SHORTBOW:
            case BASE_ITEM_SLING:
            IPSafeAddItemProperty(oMyWeapon, ItemPropertyMaxRangeStrengthMod(nCasterLvl), TurnsToSeconds(nDuration) ,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            sMessage = "Attack bonus and mighty";
            break;
            default: break;
            }
            SendMessageToPC(OBJECT_SELF, "<c þ > "+sMessage+" successfully added to "+GetName(GetItemPossessor(oMyWeapon))+"'s Weapon.");
        }
        return;

    }
    FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
    return;

}
