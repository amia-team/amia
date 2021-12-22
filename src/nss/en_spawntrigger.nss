/*  Amia :: Trigger :: Spawn Monster

    --------
    Verbatim
    --------
    This script spawns a monster encounter. Parameters are stored on the Area and Trigger as variables.

    Parameter detail :-

    Monster spawn blueprint resrefs are stored on the Area as variables named: monster0  ..  monsterN
    Monsters are spawned in a randomized, burst-spread pattern at the first available waypoint

    A boss monster blueprint resref is stored on the Area as a variable named: boss
    Its spawned in at the waypoint designated by tag: CS_WP_BOSS



    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    122903  jp          Initial release.
    022505  sune        Changed spawn delay to 10 minutes.
    111505  kfw         New release.
    040806  kfw         New version: Better creature and PLC iteration.
    060406  kfw         Added super minibosses, credit to Discosux.
    080806  kfw         Optimization.
    100606  kfw         More optimization!
    121506  disco       Added critter tracker.
    010907  disco       Randomised amount and radius.
    033107  kfw         Made the treasure chests bashable,
                        added random glows to them,
                        and traps!
    033107  kfw         Revised spawn count variable.
  20070820  disco       Added new database tracker
  20070910  disco       Added trace option
  20071119  disco       Removed CS_ tags

    ----------------------------------------------------------------------------

*/
//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "inc_ds_spawns"



//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main( ){

    //-------------------------------------------------------------------------------
    // Failure handling I
    //-------------------------------------------------------------------------------

    // Player characters only.
    object oTrigger                 = OBJECT_SELF;
    object oPC                      = GetEnteringObject( );

    if ( !GetIsPC( oPC ) && !GetIsPossessedFamiliar( oPC ) ){

        return;
    }

    // Verify zone spawns aren't disabled.
    object oArea                    = GetArea( oTrigger );
    int nSpawnDisabled              = GetLocalInt( oArea, SPAWN_DISABLED );
    if( nSpawnDisabled ){

        return;
    }

    //-------------------------------------------------------------------------------
    // Time blocking
    //-------------------------------------------------------------------------------
    //block
    int nBlocked = GetIsBlocked( oTrigger );

    if ( nBlocked > 0 ){

        Notify( oPC, "Blocked" );

        return;
    }

    SetBlockTime( oTrigger, 15, 0 );



    //-------------------------------------------------------------------------------
    // Failure handling II
    //-------------------------------------------------------------------------------
    int nSpawnFailure               = GetLocalInt( oTrigger, SPAWN_FAILURE );
    if( nSpawnFailure == 0 )
        nSpawnFailure               = DEFAULT_SPAWN_FAILURE; // Default spawn failure to 15%.

    // Check failure chance.
    if( nSpawnFailure != -1 && d100( ) <= nSpawnFailure ){

        Notify( oPC, "Spawn Failure" );
        return;
    }


    //-------------------------------------------------------------------------------
    // Determine spawn points.
    //-------------------------------------------------------------------------------
    // Variables.
    location lSpawnpoint;
    object oOrigin                  = GetLocalObject( OBJECT_SELF, "wp" );
    object oOriginBoss              = GetLocalObject( OBJECT_SELF, "wp_boss" );

    if ( GetLocalInt( OBJECT_SELF, "wp_set" ) != 1 ){

        Notify( oPC, "Loading spawnpoints on trigger." );

        // Scan spawn trigger for spawn points.
        object oWaypoint                = GetFirstInPersistentObject( oTrigger, OBJECT_TYPE_WAYPOINT );

        while( GetIsObjectValid( oWaypoint ) ){

            // Variables.
            string szWaypointTag        = GetTag( oWaypoint );

            // Boss spawn point.
            if( szWaypointTag == "CS_WP_BOSS" ){

                oOriginBoss             = oWaypoint;
                Notify( oPC, "Found boss spawnpoint." );
            }
            // Regular spawn point.
            else if ( szWaypointTag == SPAWNPOINT_TAG ){

                oOrigin                 = oWaypoint;
                Notify( oPC, "Found standard spawnpoint." );
            }

            // Get next point.
            oWaypoint                   = GetNextInPersistentObject( oTrigger, OBJECT_TYPE_WAYPOINT );
        }

        SetLocalObject( OBJECT_SELF, "wp", oOrigin );
        SetLocalObject( OBJECT_SELF, "wp_boss", oOriginBoss );
        SetLocalInt( OBJECT_SELF, "wp_set", 1 );
    }


    //-------------------------------------------------------------------------------
    // Check Database
    //-------------------------------------------------------------------------------
    //check if area settings have been loaded. If not, load.
    //spw_grps_set == 1 if there is a database group available, which overrides the usual script
    //spw_grps_set == -1 if there is no database group.
    if ( GetLocalInt( oArea, "spw_grps_set" ) == 0 ){

        Notify( oPC, "Initialising Area." );

        if ( SetCrittersOnArea( oPC, oArea ) > 0 ){

            DelayCommand( 2.0, GetCrittersFromArea( oPC, oArea, oOrigin ) );
            return;
        }
    }
    else if ( GetLocalInt( oArea, "spw_grps_set" ) != -1  ) {

        GetCrittersFromArea( oPC, oArea, oOrigin );
        return;
    }


    //-------------------------------------------------------------------------------
    // Spawn boss
    //-------------------------------------------------------------------------------
     en_SpawnBoss( oPC, oArea, oOriginBoss );

    //-------------------------------------------------------------------------------
    // Spawn monsters
    //-------------------------------------------------------------------------------
    int nSpawnCount = GetLocalInt( oTrigger, SPAWN_COUNT );

    en_SpawnCritters( oPC, oArea, oOrigin, nSpawnCount, 1 );

}
