// Shifts the user in a the relevant Dragon Shape
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 24/07/2018 Kamina           Initial Release
// 01/11/2018 Hrothmus         Tweaked to standardize and remove CUSTOM_TYPE Code
// 04/02/2021 Jes              Made standalone Shifter variants

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
       string sITag = GetTag( oItem );
    int iPoly;

    //Only procede if oPC has uses of Wild_Shape_Dragon left
    if ( !GetHasFeat( 1244 , oPC ))
    {
        FloatingTextStringOnCreature( "<cþ>- This ability is tied to Gargantuan Shape! You can't use this! -</c>", oPC, FALSE );
        return;
    }
    else
    {
        // Decrement a feat usage.
        DecrementRemainingFeatUses( oPC, 1244 );
    }

    // Visual effect
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_POLYMORPH ), oPC );

    //Drowning!
    int nCannotDrown = ds_check_uw_items( oPC );

    // Set poly and drown variables. Black, Bronze, and Gold dragons cannot drown
    if (sITag == "polysdragblac"){
        nCannotDrown = 1; iPoly = 119;}
    else if (sITag == "polysdragbron"){
        nCannotDrown = 1; iPoly = 122;}
    else if (sITag == "polysdraggold"){
        nCannotDrown = 1; iPoly = 116;}
    else if (sITag == "polysdragbras"){
        iPoly = 118;}
    else if (sITag == "polysdragsilv"){
        iPoly = 117;}
    else if (sITag == "polysdragshad"){
        iPoly = 250;}
    else if (sITag == "polysdragwhit"){
        iPoly = 120;}
    else if (sITag == "polysdragcopp"){
        iPoly = 121;}
    else if (sITag == "polysdragblue"){
        iPoly = 71;}
    else if (sITag == "polysdragred"){
        iPoly = 72;}
    else if (sITag == "polysdraggrn"){
        iPoly = 73;}

    //Capture worn Armor, Weapons, and Items
    object oWeaponOld   = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND,oPC );
    object oArmor       = GetItemInSlot( INVENTORY_SLOT_CHEST,oPC );
    object oRing1       = GetItemInSlot( INVENTORY_SLOT_LEFTRING,oPC );
    object oRing2       = GetItemInSlot( INVENTORY_SLOT_RIGHTRING,oPC );
    object oBoots       = GetItemInSlot( INVENTORY_SLOT_BOOTS,oPC );
    object oSheild      = GetItemInSlot( INVENTORY_SLOT_LEFTHAND,oPC );
    object oAmulet      = GetItemInSlot( INVENTORY_SLOT_NECK,oPC );
    object oCloak       = GetItemInSlot( INVENTORY_SLOT_CLOAK,oPC );
    object oHands       = GetItemInSlot( INVENTORY_SLOT_ARMS,oPC );
    object oBelt        = GetItemInSlot( INVENTORY_SLOT_BELT,oPC );
    object oHelm        = GetItemInSlot( INVENTORY_SLOT_HEAD,oPC );

    effect ePoly = EffectPolymorph( iPoly );

    if( GetHasFeat( 260 ) ){

        ePoly = EffectLinkEffects( EffectACDecrease( GetAbilityModifier( ABILITY_WISDOM ) ), ePoly );
    }

    // More Variables
    int nStrBefore,nConBefore,nDexBefore,nStrAfter,nConAfter,nDexAfter;
    nStrBefore = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE);
    nConBefore = GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE);
    nDexBefore = GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE);
    nStrAfter = StringToInt( Get2DAString( "polymorph", "STR", iPoly ) );
    nConAfter = StringToInt( Get2DAString( "polymorph", "CON", iPoly ) );
    nDexAfter = StringToInt( Get2DAString( "polymorph", "DEX", iPoly ) );
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
    ShifterMerge( oPC, oWeaponOld, oArmor, oRing1, oRing2, oBoots, oSheild, oAmulet, oCloak, oHands, oBelt, oHelm, iPoly );

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
