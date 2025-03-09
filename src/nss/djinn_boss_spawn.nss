/* ds_spawn_boss

--------
Verbatim
--------
Spawns a single boss at the nearest boss waypoint

---------
Changelog
---------

Date        Name        Reason
------------------------------------------------------------------
2007-02-09  Disco       Start of header
2007-11-16  Disco       Added ds_ai support
2007-11-19  disco       Moved cleanup scripts to amia_include
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

    object oTrigger    = OBJECT_SELF;
    object oArea       = GetArea(OBJECT_SELF);
    object oPC         = GetEnteringObject( );
    object oSign       = GetObjectByTag("djinni_boss_sign");
    string sBossRef    = GetLocalString(oArea,"challengeboss");
    string bossMsg     = GetLocalString(OBJECT_SELF,"boss_message");


    // Player characters only.
    if( !GetIsPC( oPC ) && !GetIsPossessedFamiliar( oPC ) ){

        return;
    }




    // Scan spawn trigger for spawn points.
    object oWaypoint = GetNearestObjectByTag( "CS_WP_BOSS", oTrigger );

    if( GetIsObjectValid( oWaypoint ) ){

        // Boss monster blueprint resref available and boss spawn point valid.
        if( sBossRef != "" ){

            // Spawn.
            object oBoss = ds_spawn_critter( oPC, sBossRef, GetLocation( oWaypoint ) );

            if ( GetLocalInt( OBJECT_SELF, "trace" ) == 1 ){

                DelayCommand( 0.5, log_to_exploits( oPC, "Spawned "+GetName( oBoss ), sBossRef, 0 ) );
            }

            DeleteLocalString(oArea,"challengeboss");
            SetName(oSign,"Beware!");
            SetDescription(oSign,"");
        }
    }
}

