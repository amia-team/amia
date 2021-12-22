// Item to add flame weapon to a weapon, in exchange for Alchemist's Fire.
// It lasts a total of 10 turns, and cannot be stacked!
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/14/2006 bbillington      Initial Release

#include "x2_inc_switches"
#include "x2_inc_itemprop"
#include "nw_i0_tool"
#include "tcs_include"
#include "inc_ds_records"


void ActivateItem()
{

    // Declare the variables.

    object oItem   = GetItemActivatedTarget();
    object oPC     = GetItemActivator();
    object oAlFire = GetItemPossessedBy(oPC, "X1_WMGRENADE002");

    // For security - cannot be cast on non-weapons, thayvian weapons,
    // or without at least one alchemist's fire.


    if ( TCS_GetIsThayvian(oItem) ) {
        SendMessageToPC( oPC, "This does not work on Thayvian crafted items!" );
        return;
    }

    if ( !GetIsObjectValid(oItem) || (GetObjectType(oItem) != OBJECT_TYPE_ITEM) ) {
        SendMessageToPC( oPC, "You must target an item!" );
        return;
    }

    if ( !IPGetIsMeleeWeapon(oItem) ) {
        SendMessageToPC( oPC, "This may only target melee weapons!" );
        return;
    }

    if ( !HasItem(oPC, "X1_WMGRENADE002") ) {
        SendMessageToPC( oPC, "You must have Alchemist's Fire to use this item!" );
        return;
    }

    // Remove the alchemist's fire from the user's inventory.

       DestroyObject(oAlFire);

    // Here's the duration! It lasts 10 turns.

    float fDuration = TurnsToSeconds(10);

    // Add the properties to the item. If this property is added again, it will
    // replace the old property.

   IPSafeAddItemProperty(
        oItem,
        ItemPropertyOnHitCastSpell(124, 10),
        fDuration,
        X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);


   IPSafeAddItemProperty(
        oItem,
        ItemPropertyVisualEffect(ITEM_VISUAL_FIRE),
        fDuration,
        X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,
        FALSE,
        FALSE);

    // VFX candy.

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_PULSE_FIRE),
        oPC);

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_FLAME_M),
        oPC);

    return;

}

void main( ){

    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;

        case X2_ITEM_EVENT_EQUIP:

            log_to_exploits( GetPCItemLastEquippedBy(), "Equipped: "+GetName(GetPCItemLastEquipped()), GetTag(GetPCItemLastEquipped()) );
            break;
   }
}
