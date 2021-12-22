//-------------------------------------------------------------------------------
// Header
//-------------------------------------------------------------------------------
// script:  i_se_skinpaint
// group:   Items
// used as: item activation script
// date:    19 October 2011
// author:  Selmak
// Notes:   Activation script for paint pots and paint dispenser.
//          Item requested by GreatPigeon.

//-------------------------------------------------------------------------------
// Changelog
//-------------------------------------------------------------------------------
//

//-------------------------------------------------------------------------------
//Constants
//-------------------------------------------------------------------------------

const int TEST_MODE         = 0;  //Shows DM options when set to 1


//-------------------------------------------------------------------------------
//Main
//-------------------------------------------------------------------------------

void main(){

    object oPC, oPaintItem, oTarget;

    int nCheck1, nCheck2, nCheck3, nCheck4;

    oPC = GetItemActivator();

    //Error, abort
    if ( !GetIsObjectValid( oPC ) ) return;

    oTarget = GetItemActivatedTarget();
    oPaintItem = GetItemActivated();

    //Set conversation checks
    //1 if item is paint pot and paint is not already applied
    nCheck1 = ( GetResRef( oPaintItem ) == "imsc_paint" &&
                !GetLocalInt( oPaintItem, "paint_applied" ) );
    //1 if item is paint pot and paint is already applied
    nCheck2 = ( GetResRef( oPaintItem ) == "imsc_paint" &&
                GetLocalInt( oPaintItem, "paint_applied" ) );
    //1 if item is paint dispenser
    nCheck3 = ( GetResRef( oPaintItem ) == "imed_paint_disp" );
    //1 if DM is using item or test mode is on
    nCheck4 = ( GetIsDM( oPC ) || TEST_MODE );

    SetLocalInt( oPC, "ds_check_1", nCheck1 );
    SetLocalInt( oPC, "ds_check_2", nCheck2 );
    SetLocalInt( oPC, "ds_check_3", nCheck3 );
    SetLocalInt( oPC, "ds_check_4", nCheck4 );
    SetLocalObject( oPC, "paint_item", oPaintItem );
    SetLocalObject( oPC, "dispense_target", oTarget );
    SetLocalString( oPC, "ds_action", "se_skinpaint_act" );
    AssignCommand( oPC, ActionStartConversation( oPC, "se_skinpaint", TRUE, FALSE ) );

}



