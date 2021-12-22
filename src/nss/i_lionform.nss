// Shifts the user in a custom lion shape permanently.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/26/2011 PaladinOfSune    Initial Release
// 06/06/2012 PaladinOfSune    Added missing item merge functionality (mostly taken from the Wild Shape script)
//

#include "x2_inc_switches"
#include "amia_include"
#include "x2_inc_itemprop"

void ActivateItem( )
{
    // Declare variables
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );

    // Visual effect
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_COM_CHUNK_RED_LARGE ), oPC );

    // Variables
    effect ePoly = EffectPolymorph( 194 );
    ePoly = SupernaturalEffect( ePoly );

    int bWeapon = StringToInt(Get2DAString("polymorph","MergeW",194)) == 1;
    int bArmor  = StringToInt(Get2DAString("polymorph","MergeA",194)) == 1;
    int bItems  = StringToInt(Get2DAString("polymorph","MergeI",194)) == 1;

    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oArmorOld = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
    object oRing1Old = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oPC);
    object oRing2Old = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oPC);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,oPC);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,oPC);
    object oBeltOld = GetItemInSlot(INVENTORY_SLOT_BELT,oPC);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);

    if (GetIsObjectValid(oShield)){

        if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
        {
            oShield = OBJECT_INVALID;
        }
    }

    int nCannotDrown = ds_check_uw_items( oPC );

    //Apply the VFX impact and effects
    ClearAllActions(); // prevents an exploit
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePoly, oPC );

    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);

    SetLocalInt( oPC, "CannotDrown", nCannotDrown );

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


void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
