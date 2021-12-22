// Shifts the user in a custom scorpion shape permanently.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/24/2012 PaladinOfSune    Initial Release
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
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_POLYMORPH ), oPC );

    if( !GetHasSpell( SPELL_SHAPECHANGE, oPC ) )
    {
        FloatingTextStringOnCreature( "You do not have any uses left for this ability", oPC, FALSE );
        return;
    }
    else
    {
        DecrementRemainingSpellUses( oPC, SPELL_SHAPECHANGE );
    }

    // Variables
    effect ePoly = EffectPolymorph( 211 );

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

    effect eAB      = EffectAttackIncrease( 5 );
    effect eLink    = EffectLinkEffects( eAB, ePoly );
    eLink           = SupernaturalEffect( eLink );

    //Apply the VFX impact and effects
    ClearAllActions(); // prevents an exploit
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oPC );

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
