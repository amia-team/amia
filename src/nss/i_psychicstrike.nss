// Item event script for Psychic Strike - adds 1d8 magic bonus to damage equal
// to rounds of strength modifier, reduces ki strike each use.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 07/15/2006 PaladinOfSune    Initial release.
// 03/14/2011 PaladinOfSune    Clean-up to my horrible code.
//

#include "x2_inc_switches"
#include "x2_inc_itemprop"
#include "inc_ds_records"

void ActivateItem( )
{
    // Variables.
    object oTarget      = GetItemActivatedTarget();
    object oPC          = GetItemActivator();

    // Return if PC has no more Ki Damage uses.
    if ( !GetHasFeat( FEAT_KI_DAMAGE, oPC ) ) {
        FloatingTextStringOnCreature( "<cþ>- You do not have any remaining uses for this ability! -</c>", oPC, FALSE );
        return;
    }

    // Checks for a valid object.
    if ( !GetIsObjectValid( oTarget ) ) {
        SendMessageToPC( oPC, "You need to target something!" );
        return;
    }

    // Determines if it's a weapon or PC being targeted.
    if ( ( GetIsPC( oTarget ) || GetIsDM( oTarget ) ) ) {
        oTarget = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oTarget );
    }

    // Melee weapons only.
    if ( !IPGetIsMeleeWeapon( oTarget ) ) {
        SendMessageToPC( oPC, "You may only target melee weapons!" );
        return;
    }

    // Only your own weapons.
    if ( GetItemPossessor( oTarget ) != oPC ) {
        SendMessageToPC( oPC, "You may only target your own items!" );
        return;
    }

    // Ability duration, based on Strength modifier.
    int nStrengthBonus      = GetAbilityModifier( ABILITY_STRENGTH, oPC );
    float fDuration         = RoundsToSeconds( nStrengthBonus );

    // VFX and effects.
    itemproperty ipGlow     = ItemPropertyVisualEffect( ITEM_VISUAL_SONIC );
    itemproperty ipDamage   = ItemPropertyDamageBonus( IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d8 );
    effect eDur             = EffectVisualEffect( VFX_DUR_GLOW_WHITE );
    effect eVis             = EffectVisualEffect( VFX_IMP_SUPER_HEROISM );

    // Add the weapon damage and visuals.
    IPSafeAddItemProperty( oTarget, ipGlow, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
    IPSafeAddItemProperty( oTarget, ipDamage, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );

    // Visuals to the PC.
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDur, oPC, fDuration );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );

    // Decrement the remaining uses of Ki Damage.
    DecrementRemainingFeatUses( oPC, FEAT_KI_DAMAGE );
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
