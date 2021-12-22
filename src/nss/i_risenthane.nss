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

    if ( !GetHasFeat( FEAT_EPIC_WILD_SHAPE_UNDEAD, oPC ) )
    {
        FloatingTextStringOnCreature( "<c�>- This ability is tied to your Undead Shape, which has no more uses today! -</c>", oPC, FALSE );
        return;
    }
    else
    {
        // Decrement a feat usage.
        DecrementRemainingFeatUses( oPC, FEAT_EPIC_WILD_SHAPE_UNDEAD );
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

        effect ePoly = EffectPolymorph( 212 );

    if( GetSubString( Get2DAString( "polymorph", "Name", 212 ), 0, 12 ) == "CUSTOM_TYPE_" ) {

        ePoly = EffectShifterProgressionACEffect( oPC, ePoly );

        // Addition for Shifter AB buff.
        if ( StringToInt( Get2DAString( "polymorph", "NATURALACBONUS", 212 ) ) > 0 )
        {
            ePoly = EffectLinkEffects( EffectAttackIncrease( StringToInt( Get2DAString( "polymorph", "NATURALACBONUS", 212 ) ) ), ePoly );
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
    nStrAfter = StringToInt( Get2DAString( "polymorph", "STR", 212 ) );
    nConAfter = StringToInt( Get2DAString( "polymorph", "CON", 212 ) );
    nDexAfter = StringToInt( Get2DAString( "polymorph", "DEX", 212 ) );
    SendMessageToPC( oPC, "<c � >STR: " + IntToString(nStrBefore) + " -> " + IntToString(nStrAfter));
    SendMessageToPC( oPC, "<c � >DEX: " + IntToString(nDexBefore) + " -> " + IntToString(nDexAfter));
    SendMessageToPC( oPC, "<c � >CON: " + IntToString(nConBefore) + " -> " + IntToString(nConAfter));
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
