/*
Jumps user to faction bindpoint (if applicable).

---------
Changelog
---------

Date        Name        Reason
------------------------------------------------------------------
2014-10-15  Glim        Creation
2015-06-27  msheeler    simplified to port to home location, weather faction or not
------------------------------------------------------------------
*/

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_porting"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main()
{
    object oPC = GetLastUsedBy ();
    string sStartWP = GetStartWaypoint( oPC, TRUE );

    if ( sStartWP != "" ){

        object oDest    = GetWaypointByTag( sStartWP );

        AssignCommand( oPC, ClearAllActions() );

        //testing
        //SendMessageToPC( oPC, "<c¥  >Test: sStartWP="+sStartWP+"</c>" );
        //SendMessageToPC( oPC, "<c¥  >Test: JumpTo="+GetName( GetArea( oDest ) )+"</c>" );

        DelayCommand( 0.2f, AssignCommand( oPC, JumpToObject( oDest ) ) );
    }
    else{

        SendMessageToPC( oPC, "Error: Can't find a valid home or faction to jump you to!" );
    }
}
