//::///////////////////////////////////////////////
//:: Craft Harper Item
//:: x0_s2_HarpItem
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Will create various items.

    Can create a Harper Pin, which allows another
    to gain access to the Harper Prestige Class. It
    will also grant a token AC bonus. (Floodgate will have to
    script the Harper Item granting access to Harper levels themselves, the
    description will have to remain vague).

    100 gp, 50xp

    Can also create a potion of Cat's Grace or
    a Potion of Eagle's Splendor.

    60gp, 5xp  is the cost

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 2002
//:://////////////////////////////////////////////
#include "nw_i0_spells"
#include "inc_ds_actions"

//2008-05-12  Disco     Updated for action scripts
//2011-07-07  Selmak    Updated for Master Scout.
void main( ){

    // Variables.
    object oPC          = OBJECT_SELF;

    //Fire cast spell at event for the specified target
    //SignalEvent( oPC, EventSpellCastAt( oPC, 479, FALSE ) );

    // Unlimited uses.
    IncrementRemainingFeatUses( oPC, 440 );

    //Set checks
    int nScoutLevel = GetLevelByClass( CLASS_TYPE_HARPER, oPC );

    if ( nScoutLevel >= 2 ) SetLocalInt( oPC, "ds_check_1", 1 );
    if ( nScoutLevel >= 3 ) SetLocalInt( oPC, "ds_check_2", 1 );
    if ( nScoutLevel >= 4 ) SetLocalInt( oPC, "ds_check_3", 1 );
    if ( nScoutLevel == 5 ) SetLocalInt( oPC, "ds_check_4", 1 );

    //set action script
    SetLocalString( oPC, "ds_action", "se_scout_act" );

    //clean up
    clean_vars( oPC, 3 );
    DeleteLocalInt( oPC, "ds_section" );

    // Begin Harper Crafting Convo.
    DelayCommand( 0.5, ActionStartConversation( oPC, "scout_gear", TRUE, FALSE ) );

}
