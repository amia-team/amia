// Bane Bow
//
// Grants a +1 attack and mighty bonus per 3 ranger levels till 25, then an additional +1 at 26, and +1 at 27. Level 27 also grants keen.
//
//

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
    int nDuration = GetLevelByClass(CLASS_TYPE_RANGER,OBJECT_SELF);
    int nCasterLvl = nDuration / 3;
    int nMetaMagic = GetMetaMagicFeat();
    int nKeen;
    string sMessage;
    object oTarget = GetSpellTargetObject();

    //Every 5 levels you get +1 AB/Mighty to Ranged, level 26 you get +6 and 27 +7 and keen
    if(nCasterLvl > 5)
    {
        nCasterLvl = 5;
    }

    if(nDuration >= 27)
    {
        nCasterLvl = 7;
        nKeen = 1;
    }
    else if(nDuration >= 26)
    {
        nCasterLvl = 6;
    }

    object oMyWeapon;

    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
      oMyWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget);
    }
    else
    {
      oMyWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    }

    int nType = GetBaseItemType(oMyWeapon);

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }

    if(GetIsObjectValid(oMyWeapon) &&  (nType == BASE_ITEM_LONGBOW || nType == BASE_ITEM_LIGHTCROSSBOW
    || nType == BASE_ITEM_SHORTBOW || nType == BASE_ITEM_HEAVYCROSSBOW))
    {
        SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if (nDuration>0)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), TurnsToSeconds(nDuration));
            IPSafeAddItemProperty(oMyWeapon, ItemPropertyAttackBonus(nCasterLvl), TurnsToSeconds(nDuration) ,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            IPSafeAddItemProperty(oMyWeapon, ItemPropertyMaxRangeStrengthMod(nCasterLvl), TurnsToSeconds(nDuration) ,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            sMessage = "Attack bonus and mighty";
            if(nKeen == 1)
            {
              IPSafeAddItemProperty(oMyWeapon, ItemPropertyKeen(), TurnsToSeconds(nDuration) ,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
              sMessage = "Attack bonus, mighty, and keen";
            }
            SendMessageToPC(OBJECT_SELF, "<c þ > "+sMessage+" successfully added to "+GetName(GetItemPossessor(oMyWeapon))+"'s Weapon.");
        }
        return;
    }

           FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
           return;


}

