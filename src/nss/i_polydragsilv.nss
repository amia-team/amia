// Shifts the user in a the relevant Dragon Shape
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 24/07/2018 Kamina           Initial Release
// 01/11/2018 Hrothmus         Tweaked to standardize and remove CUSTOM_TYPE Code
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
       string sITag = GetTag( oItem );
    int iPoly;

    //Only procede if oPC has uses of Wild_Shape_Dragon left
    if ( !GetHasFeat( FEAT_EPIC_WILD_SHAPE_DRAGON  , oPC ))
    {
        FloatingTextStringOnCreature( "<c�>- This ability is tied to Dragonshape! You can't use this! -</c>", oPC, FALSE );
        return;
    }
    else
    {
        // Decrement a feat usage.
        DecrementRemainingFeatUses( oPC, FEAT_EPIC_WILD_SHAPE_DRAGON    );
    }

    // Visual effect
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_POLYMORPH ), oPC );

    //Drowning!
    int nCannotDrown = ds_check_uw_items( oPC );

    // Set poly and drown variables. Black, Bronze, and Gold dragons cannot drown
    if (sITag == "polydragblac"){
        nCannotDrown = 1; iPoly = 119;}
    else if (sITag == "polydragbron"){
        nCannotDrown = 1; iPoly = 122;}
    else if (sITag == "polydraggold"){
        nCannotDrown = 1; iPoly = 116;}
    else if (sITag == "polydragbras"){
        iPoly = 118;}
    else if (sITag == "polydragsilv"){
        iPoly = 117;}
    else if (sITag == "polydragshad"){
        iPoly = 250;}
    else if (sITag == "polydragwhit"){
        iPoly = 120;}
    else if (sITag == "polydragcopp"){
        iPoly = 121;}

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
