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
    object oPC         = GetEnteringObject( );
    string sBossRef    = GetTag( OBJECT_SELF );

    // Player characters only.
    if( !GetIsPC( oPC ) && !GetIsPossessedFamiliar( oPC ) ){

        return;
    }

    //DM spawnblock
    int nSpawnDisabled  = GetLocalInt( GetArea( oTrigger ), "no_spawn" );

    if( nSpawnDisabled ){

        return;
    }

    int nDay    = GetLocalInt( oTrigger, "Day" );
    int nNight  = GetLocalInt( oTrigger, "Night" );
    int nHour   = GetTimeHour();

    if ( nDay && !nNight ){

        if ( nHour >= 18 && nHour < 6 ){

            SendMessageToPC( oPC, "*They only come out at day!*" );
            return;
        }
    }

    if ( !nDay && nNight ){

        if ( nHour <= 18 && nHour >= 6 ){

            SendMessageToPC( oPC, "*They only come out at night!*" );
            return;
        }
    }

    //some boss triggers have a limit of spawns per pc per reset
    int nLimit  = GetLocalInt( oTrigger, "Limit" );
    int nSpawns = GetLocalInt( oPC, sBossRef );

    if( GetIsBlocked( oTrigger ) > 0 ){

        SendMessageToPC( oPC, "*There are signs of recent fighting here...*" );
        return;
    }
    else{

        if ( nLimit > 0 ){

            if ( nSpawns >= nLimit ) {

                SendMessageToPC( oPC, "Sorry. You can only spawn this boss "+IntToString(nLimit)+" times a reset." );
                return;
            }
        }

        // Block. Do this when spawning fails as well, but not for people surpassing their
        // spawn/ limit. This way other party members get a chance to trigger the boss as well.
        SetBlockTime( oTrigger, 15, 0 );

        if ( d100() <= GetLocalInt( oTrigger, "FailRate" ) ){

            SendMessageToPC( oPC, "*It looks like something frequents this area, but there's no sign of it now*" );
            return;
        }
     }

    // Scan spawn trigger for spawn points.
    object oWaypoint = GetNearestObjectByTag( "CS_WP_BOSS", oTrigger );

    if( GetIsObjectValid( oWaypoint ) ){

        // Boss monster blueprint resref available and boss spawn point valid.
        if( sBossRef != "" ){

            //only increase spawn limit counter if anything can be spawned
            if ( nLimit > 0 ) {

                SetLocalInt( oPC, sBossRef, ( nSpawns + 1 ) );
            }

            // Spawn.
            object oBoss = ds_spawn_critter( oPC, sBossRef, GetLocation( oWaypoint ) );

            if ( GetLocalInt( OBJECT_SELF, "trace" ) == 1 ){

                DelayCommand( 0.5, log_to_exploits( oPC, "Spawned "+GetName( oBoss ), sBossRef, 0 ) );
            }
        }
        else{

            SendMessageToPC( oPC, "[Error: no boss resref]" );
        }
    }
}

