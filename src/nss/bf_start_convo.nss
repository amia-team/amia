//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_actions"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC     = GetLastSpeaker();
    object oNPC    = OBJECT_SELF;
    object oArea   = GetArea( oNPC );
    string sTag    = GetTag( oNPC );
    string sConvo;
    string sAction = "bf_actions";

    clean_vars( oPC, 4 );

    if ( sTag == "bf_rat_racer" ){

        sConvo  = "bf_ratrace";

        if ( GetLocalInt( oArea, "bf_rats" ) > 0 ){

            SetLocalInt( oPC, "ds_check_1", 1 );
        }

        SetLocalObject( oArea, "bf_rathin", oNPC );
    }
    else if ( sTag == "bf_roulette" ){

        sConvo = "bf_roulette";
    }
    else if ( sTag == "bf_fatarse" ){

        sConvo = "bf_fatarse";
    }
    else if ( sTag == "DIRTY_ONE_EYE_DEALER" ){

        sConvo = "bf_dirtyoneeye";
    }



    SetLocalString( oPC, "ds_action", sAction );
    SetLocalObject( oPC, "ds_target", oNPC );

    ActionStartConversation( oPC, sConvo, TRUE );
}
