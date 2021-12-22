// Shifts the user in a custom rakshasa shape permanently.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/07/2018 Kamina           Initial Release
//

#include "x2_inc_switches"
#include "amia_include"
#include "x2_inc_itemprop"
#include "x2_inc_shifter"
#include "amia_include"
#include "inc_td_shifter"

void ActivateItem( )
{
    // Declare variables
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );

    // Visual effect
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_POLYMORPH ), oPC );

    if ( !GetHasFeat( FEAT_EPIC_OUTSIDER_SHAPE	, oPC ) )
    {
        FloatingTextStringOnCreature( "<cþ>- This ability is tied to your U Outsider shape, which has no more uses today! -</c>", oPC, FALSE );
        return;
    }
    else
    {
        // Decrement a feat usage.
        DecrementRemainingFeatUses( oPC, FEAT_EPIC_OUTSIDER_SHAPE	 );
    }

    object oWeaponOld   = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oPC );
    object oArmor       = GetItemInSlot( INVENTORY_SLOT_CHEST, oPC );
    object oRing1       = GetItemInSlot( INVENTORY_SLOT_LEFTRING, oPC );
    object oRing2       = GetItemInSlot( INVENTORY_SLOT_RIGHTRING, oPC );
    object oBoots       = GetItemInSlot( INVENTORY_SLOT_BOOTS, oPC );
    object oSheild      = GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oPC );
    object oAmulet      = GetItemInSlot( INVENTORY_SLOT_NECK, oPC );
    object oCloak       = GetItemInSlot( INVENTORY_SLOT_CLOAK, oPC );
    object oHands       = GetItemInSlot( INVENTORY_SLOT_ARMS, oPC );
    object oBelt        = GetItemInSlot( INVENTORY_SLOT_BELT, oPC );
    object oHelm        = GetItemInSlot( INVENTORY_SLOT_HEAD, oPC );

    //Drowning!
    int nCannotDrown = ds_check_uw_items( oPC );

        effect ePoly = EffectPolymorph( 249 );

    if( GetSubString( Get2DAString( "polymorph", "Name", 249 ), 0, 12 ) == "CUSTOM_TYPE_" ) {

        ePoly = EffectShifterProgressionACEffect( oPC, ePoly );

        // Addition for Shifter AB buff.
        if ( StringToInt( Get2DAString( "polymorph", "NATURALACBONUS", 249 ) ) > 0 )
        {
            ePoly = EffectLinkEffects( EffectAttackIncrease( StringToInt( Get2DAString( "polymorph", "NATURALACBONUS", 249 ) ) ), ePoly );
        }
    }
    else if( GetHasFeat( 260 ) ){

        ePoly = EffectLinkEffects( EffectACDecrease( GetAbilityModifier( ABILITY_WISDOM ) ), ePoly );
    }

    // Variables
    int nStrBefore,nConBefore,nDexBefore,nStrAfter,nConAfter,nDexAfter;
    nStrBefore = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE);
    nConBefore = GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE);
    nDexBefore = GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE);
    nStrAfter = StringToInt( Get2DAString( "polymorph", "STR", 249 ) );
    nConAfter = StringToInt( Get2DAString( "polymorph", "CON", 249 ) );
    nDexAfter = StringToInt( Get2DAString( "polymorph", "DEX", 249 ) );
    SendMessageToPC( oPC, "<c þ >STR: " + IntToString(nStrBefore) + " -> " + IntToString(nStrAfter));
    SendMessageToPC( oPC, "<c þ >DEX: " + IntToString(nDexBefore) + " -> " + IntToString(nDexAfter));
    SendMessageToPC( oPC, "<c þ >CON: " + IntToString(nConBefore) + " -> " + IntToString(nConAfter));
    if ( nStrBefore > nStrAfter ) {
        ePoly = EffectLinkEffects( EffectAbilityIncrease( ABILITY_STRENGTH, ( nStrBefore - nStrAfter ) ), ePoly);
    }
    if ( nConBefore > nConAfter ) {
        ePoly = EffectLinkEffects( EffectAbilityIncrease( ABILITY_CONSTITUTION, ( nConBefore - nConAfter ) ), ePoly);
    }
    if ( nDexBefore > nDexAfter ) {
        ePoly = EffectLinkEffects( EffectAbilityIncrease( ABILITY_DEXTERITY, ( nDexBefore - nDexAfter ) ), ePoly);
    }

    ePoly = SupernaturalEffect( ePoly );
    ClearAllActions(); // prevents an exploit
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePoly, oPC );
    //--------------------------------------------------------------------------
    // This code handles the merging of item properties
    //--------------------------------------------------------------------------

    SetLocalInt( oPC, "CannotDrown", nCannotDrown );

    //This is it
    ShifterMerge( oPC, oWeaponOld, oArmor, oRing1, oRing2, oBoots, oSheild, oAmulet, oCloak, oHands, oBelt, oHelm, 212 );

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
