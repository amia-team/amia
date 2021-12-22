/*  ds_underwater

--------
Verbatim
--------


---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
08-19-06  Disco       Start of header
20080507  Disco       Updated and using amia_include now
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    //get PC
    object oPC      = GetEnteringObject();

    if ( !GetIsObjectValid( oPC ) ){

        oPC = GetClickingObject();
    }

    object oArea    = GetArea( oPC );

    //check for items/races
    if ( ds_check_uw_items ( oPC ) ){

        //go to underwater area
        object oTarget = GetWaypointByTag( GetTag( OBJECT_SELF ) );

        if ( oTarget != OBJECT_INVALID ){

            AssignCommand( oPC, JumpToObject( oTarget ) );
            return;
        }

        //no entry
        SendMessageToPC( oPC, "*TARGET WAYPOINT MISSING*" );
    }
    else{

        //no entry
        SendMessageToPC( oPC, "*you need gear that allows you to stay underwater to use this transition*" );
    }
}
