// Item to add 1d10 sonic damage to a weapon, in exchange for 50 HP.
// It lasts a total of 5 turns, and cannot be stacked!
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 09/16/2006 bbillington      Initial Release

#include "x2_inc_switches"
#include "x2_inc_itemprop"
#include "inc_ds_records"

void ActivateItem()
{

    // Declare the variables.

    object oTarget   = GetItemActivatedTarget();
    object oPC       = GetItemActivator();
    object oMyWeapon = OBJECT_INVALID;


    // Determines if it's a weapon or PC being targeted.

    if ((GetIsPC(oTarget) || GetIsDM(oTarget))) {
       oMyWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
    }

    else{

    if ( IPGetIsMeleeWeapon(oTarget))
       oMyWeapon = oTarget;
    }

    // Check if the PC has bard songs remaining.

    if ( !GetHasFeat(FEAT_BARD_SONGS, oPC) ) {
       SendMessageToPCByStrRef( oPC, 40063 );
       return;
    }

    // Check to make sure it's a valid target.

    if ( !GetIsObjectValid(oTarget)) {
       SendMessageToPC( oPC, "You need to target something!" );
       return;
    }

    // For security - cannot be cast on weapons with
    // darkfire/flame weapon already cast onto them.

    if ( GetHasSpellEffect(SPELL_FLAME_WEAPON, oMyWeapon) ) {
       SendMessageToPC( oPC, "This ability may not be used with Flame Weapon or Darkfire!" );
       return;
    }

    if ( GetHasSpellEffect(SPELL_DARKFIRE, oMyWeapon) ) {
       SendMessageToPC( oPC, "This ability may not be used with Flame Weapon or Darkfire!" );
       return;
    }

    // Define the item properties, which is 1d10 sonic damage, and an
    // sonic visual effect.

    itemproperty ipSCDamage =

       ItemPropertyDamageBonus(
           IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1d10);

     itemproperty ipSCVisual =

        ItemPropertyVisualEffect(
           ITEM_VISUAL_SONIC);

    // Here's the duration! It lasts 10 turns.

    float fDuration = TurnsToSeconds(10);

    // Add the properties to the item. If this property is added again, it will
    // replace the old property.

    IPSafeAddItemProperty(
        oMyWeapon,
        ipSCVisual,
        fDuration,
        X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,
        FALSE,
        FALSE);

    IPSafeAddItemProperty(
        oMyWeapon,
        ipSCDamage,
        fDuration,
        X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,
        FALSE,
        FALSE);

    // VFX candy.

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_SUPER_HEROISM),
        GetItemPossessor(oMyWeapon),
        0.0);

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_SOUND_BURST_SILENT),
        oPC,
        0.0);

    AssignCommand(
        oPC,
        PlaySound("as_cv_flute2"));

    // Set INT so it does not stack with Flame Weapon/Darkfire if
    // cast in the opposite order.

    SetLocalInt(
        oMyWeapon,
        "EnchantWeapon",
        1);

    DelayCommand(600.0f,
        DeleteLocalInt(
            oMyWeapon,
            "EnchantWeapon"));

    // Remove a Bard Song use.

    DecrementRemainingFeatUses(
        oPC,
        FEAT_BARD_SONGS );

        return;

}

void main( )
{
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
