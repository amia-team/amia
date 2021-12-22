//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_rental_ini
//group: housing
//used as: onFailToOpen script
//date: 2008-12-02
//author: disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC   = GetClickingObject();
    string sName = GetName( OBJECT_SELF );
    int i;

    clean_vars( oPC, 4 );

    SetLocalString( oPC, "ds_action", "ds_rental_act" );
    SetLocalObject( oPC, "ds_target", OBJECT_SELF );

    if ( GetLocalInt( OBJECT_SELF, "taken" ) != 1 ){

        if ( sName == "Rental Room, Basic" ){

            SetLocalInt( oPC, "ds_check_1", 1 );
        }
        else if ( sName == "Rental Home, Small" ){

            SetLocalInt( oPC, "ds_check_1", 1 );
        }
        else if ( sName == "Rental Room, Deluxe" ){

            SetLocalInt( oPC, "ds_check_2", 1 );
        }
        else if ( sName == "Rental Home, Medium" ){

            SetLocalInt( oPC, "ds_check_2", 1 );
        }
        if ( sName == "Rental Room, Luxury" ){

            SetLocalInt( oPC, "ds_check_3", 1 );
        }
        else if ( sName == "Rental Home, Large" ){

            SetLocalInt( oPC, "ds_check_3", 1 );
        }
    }

    ActionStartConversation( oPC, "", TRUE, TRUE );
}
