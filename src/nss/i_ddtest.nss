#include "x2_inc_switches"
#include "amia_include"
#include "inc_ds_records"
#include "nwnx_dynres"
#include "inc_language"
#include "inc_td_sysdata"

#include "nwnx_areas"
#include "inc_td_rest"
#include "x2_inc_switches"
#include "inc_nwnx_events"

void main()
{
// This is being built to test out the lua aspect of the DD script before adding it to the server wide script. Nov 12 2016 - Mav

    object oTarget = GetItemActivatedTarget();
    int nPoly = 222;
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly;
     int nDuration = 10;

      ePoly           = EffectPolymorph( nPoly );
       ePoly = ExtraordinaryEffect(ePoly);

       SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELLABILITY_WILD_SHAPE, FALSE));

    int bWeapon = StringToInt(Get2DAString("polymorph","MergeW",nPoly)) == 1;
    int bArmor  = StringToInt(Get2DAString("polymorph","MergeA",nPoly)) == 1;
    int bItems  = StringToInt(Get2DAString("polymorph","MergeI",nPoly)) == 1;

    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget);
    object oArmorOld = GetItemInSlot(INVENTORY_SLOT_CHEST,oTarget);
    object oRing1Old = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oTarget);
    object oRing2Old = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oTarget);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,oTarget);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,oTarget);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,oTarget);
    object oBeltOld = GetItemInSlot(INVENTORY_SLOT_BELT,oTarget);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,oTarget);
    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oTarget);

    if (GetIsObjectValid(oShield)){

        if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
        {
            oShield = OBJECT_INVALID;
        }
    }

    int nCannotDrown = ds_check_uw_items( oTarget );

    //Apply the VFX impact and effects
    ClearAllActions(); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oTarget, NewHoursToSeconds(nDuration));

    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oTarget);

    SetLocalInt( oTarget, "CannotDrown", nCannotDrown );

    if (bWeapon)
    {
            IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);
    }
    if (bArmor)
    {
        IPWildShapeCopyItemProperties(oShield,oArmorNew);
        IPWildShapeCopyItemProperties(oHelmetOld,oArmorNew);
        IPWildShapeCopyItemProperties(oArmorOld,oArmorNew);
    }
    if (bItems)
    {
        IPWildShapeCopyItemProperties(oRing1Old,oArmorNew);
        IPWildShapeCopyItemProperties(oRing2Old,oArmorNew);
        IPWildShapeCopyItemProperties(oAmuletOld,oArmorNew);
        IPWildShapeCopyItemProperties(oCloakOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBootsOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBeltOld,oArmorNew);
    }


}
