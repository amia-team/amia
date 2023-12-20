//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  inc_ds_spawns
//group:   rest/spawn fucntions
//used as: library
//date:    2008-10-07
//author:  disco

//update:  06-10-2014
//         msheeler - changed value on line 389 from <4 to <8
// Edit: 12/20/2023 - Mav - Fixing ambush for post EE
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"
#include "cs_inc_superboss"

//-------------------------------------------------------------------------------
// Constants
//-------------------------------------------------------------------------------
const int DEFAULT_SPAWN_FAILURE     = 15;
const int DEFAULT_SPAWN_COUNT       = 3;
const int SUPER_MINIBOSS_CHANCE     = 5;
const int TREASURE_CHEST_CHANCE     = 1;
const string SPAWNED                = "spawned";
const string SPAWN_DISABLED         = "no_spawn";
const string SPAWN_FAILURE          = "CS_ENCOUNTER_FAILURE";
const string SPAWN_COUNT            = "CS_ENCOUNTER_MONSTER_COUNT";
const string MONSTER_PREFIX_REF     = "monster";
const string BOSS_REF               = "boss";
const string SPAWNPOINT_TAG         = "ds_spwn";


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//returns the distance to closest spawn point
//if oPC is within 10 meters of a spawnpoint.
//otherwise it returns 0
float IsCloseToSpawnpoint( object oPC );

//checks if this area contains spawntriggers and spawnable critters
//returns TRUE if so, and FALSE if not. Fixed to work POST EE! - MAV
int AreaHasCritters( object oArea );

//spawns nCritters on lSpawnpoint based on what's available in oArea
//Returns number of critters spAwned on succces
//returns -1 if there are no critters available in this area
int SpawnAreaCritters( object oPC, object oArea );

//spawns boss critter at oSpawnPoint
void SpawnBoss( object oPC, object oSpawnPoint, string sResRef, int nSuperBossChance = 0 );

//spawns critter at fSpread distance from oSpawnPoint. nTypes is the number of critters inb a group
void SpawnCritter( object oPC, object oSpawnPoint, string sGroup, int nTypes, float fSpread );

//reads data from area and fires SpawnBoss and SpawnCritter
void GetCrittersFromArea( object oPC, object oArea, object oSpawnPoint );

//reads data from MySQL and stores it on area for fast access
//returns the number of stored groups
int SetCrittersOnArea( object oPC, object oArea );

//returns a semi-random spawnpoint in the trigger
object GetRandomSpawnpoint( object oSpawntrigger );

//debug function
void Notify( object oPC, string sMessage );

//reads resrefs from a waypoint called "spawn_test"
void SpawnTestCritters( object oPC, object oSpawnPoint );

//translates size int to actual spawn size
int GetSpawngroupSize( int nSizeInt );

//returns day/night time corrected spawn group
//returns "" on failure (which probably means that there's nothing to spawn right now)
string GetRandomSpawngroup( object oArea, int nGroups );

//Add this to a trigger script to spawn stuff from the db
void DoSpawn( object oPC, object oArea );

// spawn a critter from blueprint sResRef and trace if local var BossTrace = 1
void SpawnAndTrace( object oPC, string sResRef, location lDest );

// spawns a critter with dragon strike effects
void SpawnWithEffects( object oPC, object oTrigger, object oWaypoint, string sResRef, int nVFX );

//spawns a custom boss from a resref on a db trigger
void SpawnCustomBoss( object oPC, object oTrigger );

//stores CR of the first critter spawned by a trigger
void RecordCR( object oCritter, object oTrigger );



//-------------------------------------------------------------------------------
// stuff from en_spawntrigger
//-------------------------------------------------------------------------------

// Creates a location in a randomized, burst-spread pattern.
location en_HexRadiate( object oArea, location lOrigin, int iPn, float fSpread );

// Gets a random Monster blueprint resref from the Area.
string en_GetRandomMonster( object oArea );

//spawns monsters with the area based spawner
//returns TRUE if a monster has been spawned
int en_SpawnBoss( object oPC, object oArea, object oOriginBoss );

//spawns monsters with the area based spawner
//returns TRUE if a monster has been spawned
//set nSpawnTreasure to 1 if you want to add a chance on a treasure chest
int en_SpawnCritters( object oPC, object oArea, object oOrigin, int nSpawnCount, int nSpawnTreasure=0 );

//-------------------------------------------------------------------------------
// stuff from ds_spawntrigger2
//-------------------------------------------------------------------------------

//sets the spawn scripts
void ds_spawn_wrapper( object oPC, object oArea );

//spawns the group boss and sets the group composition
//returns TRUE if it found spawn resrefs
int ds_spawn_group( object oPC, string sSpawnTemplate, location lSpawnpoint );

//spawn the boss
void ds_spawn_boss(object oPC, object oSpawnTemplate, location lSpawnpoint);

//trigger delayed spawning ofnMaxSpawn creatures
void ds_spawn_goons(object oPC, string sCreatureResRef, int nSpawnDie, location lSpawnpoint);

//spawns nMaxSpawn creatures of sCreatureResRef around lSpawnpoint
void ds_spawn_goon(object oPC, string sCreatureResRef, location lSpawnpoint);

//get a random spawn template out of the nSpawnTemplates placed in the area
string ds_random_spawn_template(object oPC, object oArea, int nSpawnTemplates);

//get random spawnpoint
location ds_random_spawnpoint( object oSpawntrigger );

//deal with patrolling routines, returns 1 if the trigger is blocked by patrol
int ds_patrol( object oPC, object oArea, object oSpawntrigger );

//void main(){}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

float IsCloseToSpawnpoint( object oPC ){

    float fDist = GetDistanceBetween( oPC, GetNearestObjectByTag( SPAWNPOINT_TAG, oPC ) );

    if ( fDist < 15.0 ){

        return fDist;
    }

    return 0.0;
}

int AreaHasCritters( object oArea ){

    if ( GetLocalString( oArea, "night_spawn1" ) != "" ){

        return TRUE;
    }
    else if ( GetLocalString( oArea, "day_spawn1" ) != "" ){

        return TRUE;
    }
    else if ( GetLocalInt( oArea, "spawns_vary" ) > 0 ){

        return TRUE;
    }

    return FALSE;
}

//spawns nCritters on lSpawnpoint based on what's available in oArea
//Returns TRUE when critters are spawned
//returns FALSE if there are no critters available in this area
int SpawnAreaCritters( object oPC, object oArea ){

    object oSpawnPoint = GetNearestObjectByTag( SPAWNPOINT_TAG, oPC );

    if ( !GetIsObjectValid( oSpawnPoint ) ){


        Notify( oPC, "No spawnpoint." );

        return FALSE;
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

            DelayCommand( 2.0, GetCrittersFromArea( oPC, oArea, oSpawnPoint ) );
            return TRUE;
        }
    }
    else if ( GetLocalInt( oArea, "spw_grps_set" ) != -1  ) {

        GetCrittersFromArea( oPC, oArea, oSpawnPoint );
        return TRUE;
    }

    if ( GetLocalInt( oArea, "spw_grps_set" ) < 1 ){

        string sResRef      = GetLocalString( oArea, "monster0" );

        if ( sResRef != "" ){

            return en_SpawnCritters( oPC, oArea, oSpawnPoint, ( 4+d3() ) );
        }
        else if ( GetLocalInt( oArea, "tst" ) > 0 ){

            //variables
            string sSpawnTemplate = ds_random_spawn_template( oPC, oArea, GetLocalInt( oArea, "tst" ) );

            return ds_spawn_group( oPC, sSpawnTemplate, GetLocation( oSpawnPoint ) );
        }
    }

    return FALSE;
}

void SpawnBoss( object oPC, object oSpawnPoint, string sResRef, int nSuperBossChance = 0 ){

    //debug function
    Notify( oPC, " - Spawning Boss: "+sResRef );

    //create boss
    object oBoss = ds_spawn_critter( oPC, sResRef, GetLocation( oSpawnPoint ) );

    //treasure chest
    SpawnTreasureChest( oSpawnPoint, oBoss );

    if( Random( 100 ) < nSuperBossChance ){

        //create nice boss
        CreateSuperBoss( oBoss, TRUE, TRUE );
    }
}

void SpawnCritter( object oPC, object oSpawnPoint, string sGroup, int nTypes, float fSpread  ){

    string sSlot            = sGroup+"_critter"+IntToString( Random( nTypes ) + 1 );
    string sResRef          = GetLocalString( GetArea( oSpawnPoint ), sSlot );
    float fAngleFacing      = IntToFloat( Random( 361 ) );
    location lSpawnPosition = GenerateNewLocationFromLocation( GetLocation( oSpawnPoint ), fSpread, fAngleFacing, fAngleFacing );

    Notify( oPC, " - spawning slot: "+sSlot );
    Notify( oPC, " - spawning resref: "+sResRef );

    //skip anything with this res-ref, but count them as a spawned critter (for small groups)
    if (  sResRef == "ds_placeholder" || sResRef == "" ){

        return;
    }

    object oCritter = ds_spawn_critter( oPC, sResRef, lSpawnPosition );

    RecordCR( oCritter, OBJECT_SELF );
}

void GetCrittersFromArea( object oPC, object oArea, object oSpawnPoint ){

    int nGroups         = GetLocalInt( oArea, "spw_grps" );

    if ( nGroups == 0 ){

        Notify( oPC, "No Spawngroups found." );
        return;
    }

    int i;
    int nBossChance;
    int nSuperBossChance;
    string sCritter;
    string sGroup       = GetRandomSpawngroup( oArea, nGroups );

    if ( sGroup ==  "" ){

        Notify( oPC, "No Spawngroups for this time of day" );
        return;
    }

    string sBoss        = GetLocalString( oArea, sGroup + "_boss" );
    int nNumber         = GetSpawngroupSize( GetLocalInt( oArea, sGroup + "_size" ) );
    float fDelay;
    float fSpread       = GetLocalFloat( oArea, sGroup + "_radius" );
    int nTypes          = GetLocalInt( oArea, sGroup + "_types" );
    int nSpawned;
    object oBoss;

    Notify( oPC, "Spawning Group: "+sGroup );

    Notify( oPC, " - spawn size: "+IntToString( nNumber ));

    //spawn boss if there's a valid res_ref
    if ( sBoss != "" && sBoss != "ds_placeholder" ){

        nBossChance         = GetLocalInt( oArea, sGroup + "_boss_chance" );
        nSuperBossChance    = GetLocalInt( oArea, sGroup + "_superboss_chance" );

        //spawn failure
        if ( d100() > nBossChance ){

            Notify( oPC, " - failure: boss" );

            if ( nTypes == 0 ){

                nNumber = 0;
            }
        }
        else{

            SpawnBoss( oPC, oSpawnPoint, sBoss, nSuperBossChance );

            ++nSpawned;

            //boss is included in total spawn size
            --nNumber;
        }
    }

    for ( i=0; i<nNumber; ++i ){

        fDelay = i/5.0;

        DelayCommand( fDelay, SpawnCritter( oPC, oSpawnPoint, sGroup, nTypes, fSpread ) );

        ++nSpawned;
    }

    if ( nSpawned ){

        //spawn effect
        effect eSpawn           = EffectVisualEffect( 5 );
        ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eSpawn, GetLocation( oSpawnPoint ), 3.0 );

        int nDistance = FloatToInt( GetDistanceBetween( oPC, oSpawnPoint ) );

        if ( nDistance > 10 ){

            if ( GetIsSkillSuccessfulPrivate( oPC, SKILL_SPOT, 10 + nDistance ) ){

                FloatingTextStringOnCreature( "*spots some enemies nearby!*", oPC );
            }
            else if ( GetIsSkillSuccessfulPrivate( oPC, SKILL_LISTEN, 10 + ( 2 * nDistance ) ) ){

                FloatingTextStringOnCreature( "*hears something wandering around close by!*", oPC );
            }
        }
    }
}

int SetCrittersOnArea( object oPC, object oArea ){

    string sGroup;
    string sCritter;
    int nGroups;
    int nCritters;
    int nSize;
    int nTime;
    string sTableSuffix     = "";
    int nModule             = GetLocalInt( GetModule(), "Module" );

    if ( nModule == 2 ){

        sTableSuffix = "_2";
    }

    string sQuery = "SELECT spawngroups"+sTableSuffix+".* FROM spawngroups"+sTableSuffix+",area_spawngroups"+sTableSuffix+" WHERE"
                  + " area_spawngroups"+sTableSuffix+".area_resref = '"+GetResRef( oArea )+"'"
                  + " AND area_spawngroups"+sTableSuffix+".group_id = spawngroups"+sTableSuffix+".id";

    SQLExecDirect( sQuery );

    while ( SQLFetch() == SQL_SUCCESS && nGroups<8 ){

        ++nGroups;
        nCritters= 0;

        sGroup = "spw_grp_" + IntToString( nGroups );

        Notify( oPC, "Spawngroup '"+SQLGetData(2)+"' stored on area." );

        SetLocalFloat( oArea, sGroup + "_radius", StringToFloat( SQLGetData(3) ) );
        SetLocalString( oArea, sGroup + "_boss", SQLGetData(4) );
        SetLocalInt( oArea, sGroup + "_boss_chance", StringToInt( SQLGetData(5) ) );
        SetLocalInt( oArea, sGroup + "_superboss_chance", StringToInt( SQLGetData(6) ) );

        Notify( oPC, " - group id:  "+sGroup );
        Notify( oPC, " - boss resref:  "+SQLGetData(4) );

        sCritter = SQLGetData(7);

        if ( sCritter != "" ){

            ++nCritters;
            SetLocalString( oArea, sGroup + "_critter"+IntToString( nCritters ), sCritter );
            Notify( oPC, " - critter slot:  "+sGroup + "_critter"+IntToString( nCritters ) );
            Notify( oPC, " - critter resref:  "+sCritter );
        }

        sCritter = SQLGetData(8);

        if ( sCritter != "" ){

            ++nCritters;
            SetLocalString( oArea, sGroup + "_critter"+IntToString( nCritters ), sCritter );
            Notify( oPC, " - critter slot:  "+sGroup + "_critter"+IntToString( nCritters ) );
            Notify( oPC, " - critter resref:  "+sCritter );
        }

        sCritter = SQLGetData(9);

        if ( sCritter != "" ){

            ++nCritters;
            SetLocalString( oArea, sGroup + "_critter"+IntToString( nCritters ), sCritter );
            Notify( oPC, " - critter slot:  "+sGroup + "_critter"+IntToString( nCritters ) );
            Notify( oPC, " - critter resref:  "+sCritter );
        }

        nSize = StringToInt( SQLGetData( 10 ) );

        if ( nSize > 0 ){

            Notify( oPC, "Spawngroup "+IntToString( nGroups )+" size="+IntToString( nSize ) );
            SetLocalInt( oArea, sGroup + "_size", nSize );
        }

        nTime = StringToInt( SQLGetData( 11 ) );

        if ( nTime > 0 ){

            Notify( oPC, "Spawngroup "+IntToString( nGroups )+" time="+IntToString( nTime ) );
            SetLocalInt( oArea, sGroup + "_time", nTime );
        }

        SetLocalInt( oArea, sGroup+"_types", nCritters );
        Notify( oPC, " - types: "+IntToString( nCritters ) );
        Notify( oPC, "" );
    }

    if ( nGroups > 0 ){

        SetLocalInt( oArea, "spw_grps", nGroups );
        SetLocalInt( oArea, "spw_grps_set", 1 );
        Notify( oPC, IntToString( nGroups )+" spawngroups stored on area." );
    }
    else{

        //facilitate "no groups defined" check
        SetLocalInt( oArea, "spw_grps_set", -1 );
    }

    return nGroups;
}

object GetRandomSpawnpoint( object oSpawntrigger ){

    object oWaypoint         = GetFirstInPersistentObject( oSpawntrigger, OBJECT_TYPE_WAYPOINT );
    object oSpawnpoint;
    int nSpawnpoints         = GetLocalInt( oSpawntrigger, "nSpawnpoints" );
    int nRandom;
    int i;

    //get a random waypoint or the first one if the local int isn't set yet
    if ( nSpawnpoints == 0 ) {

         nRandom = 1;
    }
    else{

         nRandom = Random( nSpawnpoints ) + 1;
    }

    //loop waypoints in trigger
    while( oWaypoint != OBJECT_INVALID ){

        if ( GetTag( oWaypoint ) == SPAWNPOINT_TAG ){

            ++i;

            if ( i == nRandom ) {

                oSpawnpoint = oWaypoint;
            }
        }

        oWaypoint = GetNextInPersistentObject( oSpawntrigger, OBJECT_TYPE_WAYPOINT );
    }

    //set the number of waypoints on the trigger
    if ( nSpawnpoints == 0 ) {

         SetLocalInt( oSpawntrigger, "nSpawnpoints", i );
    }

    return oSpawnpoint;
}

void Notify( object oPC, string sMessage ){

    if ( GetLocalInt( GetModule(), "testserver" ) == 1 ){

        SendMessageToPC( oPC, sMessage );
    }
}

void SpawnTestCritters( object oPC, object oSpawnPoint ){

    object oSpawntest       = GetNearestObjectByTag( "ds_spawntest" );
    location lSpawn         = GetLocation( oSpawnPoint );
    effect eSpawn           = EffectVisualEffect( 4 );
    string sCritter;
    int i;
    int nGobboTime;
    float fDelay;

    if ( !GetIsObjectValid( oSpawntest ) ){

        SendMessageToPC( oPC, "Can't find test critters. Spawning goblins instead." );
        nGobboTime = 1;
    }

    //spawn up to 10 critters ( or 5 gobbos)
    for ( i=1; i<11; ++i ){

        if ( nGobboTime == 1 ){

            sCritter        = "nw_goblina";

            if ( i > 5 ){

                break;
            }
        }
        else{

            sCritter        = GetLocalString( oSpawntest, "c_"+IntToString( i ) );

            if ( sCritter == "" ){

                break;
            }
        }

        fDelay = i/5.0;

        DelayCommand( fDelay, SpawnBoss( oPC, oSpawnPoint, sCritter ) );

    }

    //spawn effect
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eSpawn, lSpawn, 3.0 );
}


//translates size int to actual spawn size
int GetSpawngroupSize( int nSizeInt ){

    switch ( nSizeInt ) {

        case  1:     return 1;    break;
        case  2:     return 2;    break;
        case  3:     return 3;    break;
        case  4:     return 4;    break;
        case  5:     return 5;    break;
        case  6:     return 6;    break;
        case  7:     return d2();    break;
        case  8:     return d3();    break;
        case  9:     return d4();    break;
        case 10:     return d6();    break;
        case 11:     return d2(2);    break;
        case 12:     return d3(2);    break;
        case 13:     return d4(2);    break;
        case 14:     return d2(3);    break;
        case 15:     return d3(3);    break;
        case 16:     return d2()+1;    break;
        case 17:     return d3()+1;    break;
        case 18:     return d4()+1;    break;
        case 19:     return d6()+1;    break;
        case 20:     return d2()+2;    break;
        case 21:     return d3()+2;    break;
        case 22:     return d4()+2;    break;
        case 23:     return d2()+3;    break;
        case 24:     return d3()+3;    break;
        case 25:     return d4()+3;    break;
        case 26:     return d2()+4;    break;
        case 27:     return d3()+4;    break;
    }

    return d4()+3;
}

string GetRandomSpawngroup( object oArea, int nGroups ){

    int nIsDay          = GetIsDay();
    string sGroup       = "spw_grp_" + IntToString( Random( nGroups ) + 1 );
    int nGroupTime      = GetLocalInt( oArea, sGroup+"_time" );
    int i;

    if ( nGroupTime == 0 ){

        return sGroup;
    }
    else if ( nGroupTime == 1 && nIsDay ){

        //it's day and the group spawns during day
        return sGroup;
    }
    else if ( nGroupTime == 2 && !nIsDay ){

        //it's night and the group spawns during night
        return sGroup;
    }
    else{

        //just loop through the groups and get the first one that fits
        for ( i=1; i<=nGroups; ++i ){

            sGroup      = "spw_grp_" + IntToString( i );
            nGroupTime  = GetLocalInt( oArea, sGroup+"_time" );

            if ( nGroupTime == 0 ){

                return sGroup;
            }
            else if ( nGroupTime == 1 && nIsDay ){

                //it's day and the group spawns during day
                return sGroup;
            }
            else if ( nGroupTime == 2 && !nIsDay ){

                //it's night and the group spawns during night
                return sGroup;
            }
        }
    }

    return "";
}

void DoSpawn( object oPC, object oArea ){

    //get objects
    object oSpawnPoint  = GetRandomSpawnpoint( OBJECT_SELF );

    //check if area settings have been loaded. If not, load.
    if ( GetLocalInt( oArea, "spw_grps_set" ) == -1 ){

        Notify( oPC, "There are no spawngroups assigned to this area." );

        if ( GetLocalInt( GetModule(), "testserver" ) == 1 ){

            Notify( oPC, "Test Server: Spawning test critter!" );

            ds_spawn_critter( oPC, "ds_tester", GetLocation( oSpawnPoint ) );
        }

        return;
    }
    else if ( GetLocalInt( oArea, "spw_grps_set" ) == 0 ){

        Notify( oPC, "Initialising Area." );

        SetCrittersOnArea( oPC, oArea );
    }

    DelayCommand( 1.0, GetCrittersFromArea( oPC, oArea, oSpawnPoint ) );

    if ( GetLocalInt( GetModule(), "testserver" ) == 1 ){

        Notify( oPC, "Test Server: Spawning test critter!" );

        ds_spawn_critter( oPC, "ds_tester", GetLocation( oSpawnPoint ) );
        return;
    }
}

// function definitions
void SpawnAndTrace( object oPC, string sResRef, location lDest ){

    object oBoss = ds_spawn_critter( oPC, sResRef, lDest, TRUE );

    if ( GetLocalInt( OBJECT_SELF, "BossTrace" ) == 1 ){

        DelayCommand( 0.5, log_to_exploits( oPC, "Spawned "+GetName( oBoss ), sResRef, 0 ) );
    }
}

void SpawnWithEffects( object oPC, object oTrigger, object oWaypoint, string sResRef, int nVFX ){

    // vars
    location lDest          = GetLocation( oWaypoint );
    effect eShake           = EffectVisualEffect( 356 );
    effect eDebris          = EffectVisualEffect( nVFX );
    effect eDragonStrike    = EffectLinkEffects( eShake, eDebris );

    // cycle for 6 objects within the trigger, and apply candy vfx to them
    int nLimit      = 0;
    float fDelay    = 0.0;
    object oCandy   = GetFirstInPersistentObject( oTrigger, OBJECT_TYPE_PLACEABLE );

    while ( oCandy != OBJECT_INVALID ){

        // exit after 6th object
        if ( nLimit > 6 ){

            break;
        }

        // display vfxs for 2 seconds
        DelayCommand( fDelay, ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eDragonStrike, GetLocation(oCandy), 2.0));

        nLimit++;
        fDelay += 1.0;

        oCandy = GetNextInPersistentObject( oTrigger, OBJECT_TYPE_PLACEABLE );
    }

    // spawn the dragon in 6 seconds
    DelayCommand( 6.0, SpawnAndTrace( oPC, sResRef, lDest ) );

    return;
}

void SpawnCustomBoss( object oPC, object oTrigger ){

    string sResRef = GetLocalString( oTrigger, "BossResRef" );

    if ( sResRef == "" ){

        return;
    }

    if ( d100() <= GetLocalInt( oTrigger, "BossFail" ) ){

        SendMessageToPC( oPC, "*It seems that the local leader doesn't want to face you in battle. The coward!*" );
        return;
    }


    //some boss triggers have a limit of spawns per pc per reset
    int nLimit  = GetLocalInt( oTrigger, "BossLimit" );
    int nSpawns = GetLocalInt( oPC, sResRef );

    if ( nLimit > 0 && nSpawns >= nLimit ) {

        SendMessageToPC( oPC, "Sorry. You can only spawn this boss "+IntToString(nLimit)+" times a reset." );
        return;
    }

    // Scan spawn trigger for spawn points.
    object oWaypoint = GetNearestObjectByTag( "CS_WP_BOSS", oTrigger );

    if ( GetIsObjectValid( oWaypoint ) ){

        int nVFX = GetLocalInt( oTrigger, "BossVFX" );

        if ( nVFX > 0 ){

            SpawnWithEffects( oPC, oTrigger, oWaypoint, sResRef, nVFX );
        }
        else{

            // Spawn.
            object oBoss = ds_spawn_critter( oPC, sResRef, GetLocation( oWaypoint ) );

            if ( GetLocalInt( oTrigger, "BossTrace" ) == 1 ){

                DelayCommand( 0.5, log_to_exploits( oPC, "Spawned "+GetName( oBoss ), sResRef, 0 ) );
            }
        }

        //only increase spawn limit counter if anything can be spawned
        if ( nLimit > 0 ) {

            SetLocalInt( oPC, sResRef, ( nSpawns + 1 ) );
        }
    }
}

//stores CR of the first critter spawned by a trigger
void RecordCR( object oCritter, object oTrigger ){

    if ( GetLocalInt( oTrigger, "cr" ) == 0 ){

        SetLocalInt( oTrigger, "cr", 1 );

        string sModule = IntToString( GetLocalInt( GetModule(), "Module" ) );
        string sCR     = FloatToString( GetChallengeRating( oCritter ), 3, 0 );
        string sArea   = GetResRef( GetArea( oCritter ) );
        string sQuery  = "INSERT INTO area_cr VALUES ( '"+sArea+"',"+sModule+","+sCR+", NOW() ) ON DUPLICATE KEY UPDATE cr=(cr+"+sCR+")/2";

        SQLExecDirect( sQuery );
    }
}



// Creates a location in a randomized, burst-spread pattern.
location en_HexRadiate( object oArea, location lOrigin, int iPn, float fSpread ){

    // Variables.
    vector vOrigin          = GetPositionFromLocation( lOrigin );
    vector vNewOrigin       = Vector( );

    float fFacing           = IntToFloat( Random( 361 ) );

    int iLevel              = iPn / 6;
    iPn                     = iPn - 6 * iLevel;

    float fLevel            = fSpread * ( 1.0 + IntToFloat( iLevel ) );

    vector vModifier        = Vector( );

    // Select a pregenerated burst pattern vectors. Thx's to Selmak for the pregens!
    switch( iPn ){

        case 0:     vModifier = Vector( 0.0, 3.0 * fLevel );                    break;
        case 1:     vModifier = Vector( 0.0, -3.0 * fLevel );                   break;
        case 2:     vModifier = Vector( 2.598 * fLevel, 1.5 * fLevel );         break;
        case 3:     vModifier = Vector( -2.598 * fLevel, 1.5 * fLevel );        break;
        case 4:     vModifier = Vector( 2.598 * fLevel, -1.5 * fLevel );        break;
        case 5:     vModifier = Vector( -2.598 * fLevel, -1.5 * fLevel );       break;
        case 6:     vModifier = Vector( -1.3 * fLevel, -1.2 * fLevel );         break;
        default:    vModifier = Vector( -20.0, -20.0 );                         break;

    }

    // Transform the spawn point vector with the selected pregen'ed burst pattern vector.
    vNewOrigin = vOrigin + vModifier;

    // Create the new burst pattern location.
    return( Location( oArea, vNewOrigin, fFacing ) );
}

// Gets a random Monster blueprint resref from the Area.
string en_GetRandomMonster( object oArea ){

    // Variables.
    int nCounter            = GetLocalInt( oArea, "ds_monsters" );

    if ( nCounter == 0 ){

        string szCurrentResRef  = GetLocalString( oArea, "monster" + IntToString( nCounter ) );

        // Iterate the Area's total number of monster blueprints resrefs to obtain a count of them.
        while( szCurrentResRef != "" ){

            // Tally the total.
            szCurrentResRef = GetLocalString( oArea, "monster" + IntToString( ++nCounter ) );
        }

        if ( nCounter == 0 ){

            nCounter = -1;
        }

        SetLocalInt( oArea, "ds_monsters", nCounter );
    }

    if ( nCounter == -1 ){

        return "";
    }

    // Unfudge the Bioware dice.
    Random( 2 );

    // Randomly determine the monster blueprint resref from the total count.
    nCounter = Random( nCounter );

    // Create the monster's blueprint resref.
    return( GetLocalString( oArea, "monster" + IntToString( nCounter ) ) );

}

int en_SpawnBoss( object oPC, object oArea, object oOriginBoss ){

    // Variables.
    object oCreature;
    string szBossRef = GetLocalString( oArea, BOSS_REF );

    Notify( oPC, "Spawning boss" );

    // Boss monster blueprint resref available and boss spawn point valid.
    if( szBossRef != "" && GetIsObjectValid( oOriginBoss ) ){

        // Spawn.
        location lSpawnpoint = Location( oArea, GetPosition( oOriginBoss ), IntToFloat( Random( 361 ) ) );
        oCreature            = ds_spawn_critter( oPC, szBossRef, lSpawnpoint );

        if ( GetLocalInt( OBJECT_SELF, "trace" ) == 1 ){

            log_to_exploits( oPC, "Spawned "+GetName( oCreature ), szBossRef, 0 );
        }
    }

    if ( GetIsObjectValid( oCreature ) ){

        return TRUE;
    }

    return FALSE;
}

int en_SpawnCritters( object oPC, object oArea, object oOrigin, int nSpawnCount, int nSpawnTreasure=0 ){

    // Variables.
    object oMonster                     = OBJECT_INVALID;
    string szLastRef                    = "";
    string szCurrRef                    = "";
    location lOrigin                    = GetLocation( oOrigin );
    location lSpawnpoint;
    float fSpread                       = 0.0;
    int nMonsterCount                   = 0;
    int nSuperMiniBoss                  = ( d100( ) <= SUPER_MINIBOSS_CHANCE ? TRUE : FALSE ); // Default 5% chance to spawn a mini superboss.

    Notify( oPC, "Spawning critters" );

    // Regular spawn point valid.
    if( GetIsObjectValid( oOrigin ) ){

        if( nSpawnCount < 1 || nSpawnCount > 16 ){

            nSpawnCount                 = d3( ) + DEFAULT_SPAWN_COUNT;              // Default spawn count.
        }

        // Spawn the regular monsters.
        for( nMonsterCount = 0; nMonsterCount < nSpawnCount; nMonsterCount++ ){

            // Mostly ensure a unique monster blueprint (without too much CPU overhead).
            if( szLastRef == ( szCurrRef = en_GetRandomMonster( oArea ) ) ){

                szCurrRef = en_GetRandomMonster( oArea );
            }

            szLastRef = szCurrRef;

            fSpread = ( IntToFloat( d6( ) ) / 4.0 ) + 0.5;

            // Spawn.
            lSpawnpoint    = en_HexRadiate( oArea, lOrigin, nMonsterCount, fSpread );
            oMonster       = ds_spawn_critter( oPC, szCurrRef, lSpawnpoint );
        }
    }

    if ( GetIsObjectValid( oMonster ) ){

        RecordCR( oMonster, OBJECT_SELF );

        // If applicable, spawn a mini superboss from the last monster.
        if( nSuperMiniBoss ){

            CreateSuperBoss( oMonster );
        }

        //spawn treasure chest
        if( nSpawnTreasure ){

            SpawnTreasureChest( oOrigin, oMonster );
        }

        return TRUE;
    }

    return FALSE;
}


//-------------------------------------------------------------------------------
//ds spawn functions
//-------------------------------------------------------------------------------

//sets the spawn scripts
void ds_spawn_wrapper(object oPC,object oArea){

    //variables
    string sSpawnTemplate = ds_random_spawn_template( oPC, oArea, GetLocalInt( oArea, "tst" ) );

    //random spawn location inside trigger.
    location lSpawnpoint  =  ds_random_spawnpoint( OBJECT_SELF );

    ds_spawn_group( oPC, sSpawnTemplate, lSpawnpoint );
}

//spawns the group boss and sets the group composition
int ds_spawn_group( object oPC, string sSpawnTemplate, location lSpawnpoint ){

    //variables
    object oSpawnpoint;       //the spawn waypoint object
    object oSpawnTemplate;    //the template waypoint object
    int nSpawnpoint;          //we pick spawn waypoint #nSpawnpoint
    int nSpawnDie;            //number of creatures of a type, stored on template
    int i;                    //counter
    int nSpawntypes;          //the number of creature types stored on template
    float fBossDelay;         //boss delay
    float fDelay;             //spawngroup delay
    string sCreatureResRef;   //resref of a creaturetype, stored on template

    //get spawngroup info from template
    oSpawnTemplate = GetNearestObjectByTag(sSpawnTemplate,oPC);
    fBossDelay=GetLocalFloat(oSpawnTemplate,"tst_boss_delay");

    effect eVis = EffectVisualEffect(2);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lSpawnpoint);

    int nDistance = FloatToInt( GetDistanceBetweenLocations( GetLocation( oPC ), lSpawnpoint ) );

    if ( nDistance > 10 ){

        if ( GetIsSkillSuccessfulPrivate( oPC, SKILL_SPOT, 10 + nDistance ) ){

            FloatingTextStringOnCreature( "*spots some enemies nearby!*", oPC );
        }
        else if ( GetIsSkillSuccessfulPrivate( oPC, SKILL_LISTEN, 10 + ( 2 * nDistance ) ) ){

            FloatingTextStringOnCreature( "*hears something wandering around close by!*", oPC );
        }
    }

    DelayCommand(fBossDelay, ds_spawn_boss(oPC, oSpawnTemplate, lSpawnpoint));

    //spawn the rest of the gang. First we get the number of resrefs available
    nSpawntypes = GetLocalInt(oSpawnTemplate,"tst_spawntypes");

    if (nSpawntypes>0){

        for (i=1; i<=nSpawntypes; ++i){

            //walk through them and spawn the creatures of each type
            sCreatureResRef = GetLocalString(oSpawnTemplate,"tst_resref_"+IntToString(i));
            nSpawnDie       = GetLocalInt(oSpawnTemplate,"tst_die_"+IntToString(i));

            //send the data to the group spawner with 0.2 secs delay
            fDelay = i/5.0;
            DelayCommand(fDelay,ds_spawn_goons(oPC, sCreatureResRef, nSpawnDie, lSpawnpoint));
        }

        return TRUE;
    }

    return FALSE;
}

//spawn the boss
void ds_spawn_boss(object oPC, object oSpawnTemplate, location lSpawnpoint){

    //percentage chance on a superboss in the group
    int nSuperBossChance = GetLocalInt(oSpawnTemplate,"tst_superboss_chance");
    object oBoss         = ds_spawn_critter( oPC, GetLocalString( oSpawnTemplate, "tst_resref_boss" ), lSpawnpoint );

    if( oBoss != OBJECT_INVALID ){

        if( Random(100) < nSuperBossChance ){

            //create nice boss
            CreateSuperBoss( oBoss, TRUE, TRUE );
        }
    }
}

//trigger delayed spawning ofnMaxSpawn creatures
void ds_spawn_goons(object oPC, string sCreatureResRef, int nSpawnDie, location lSpawnpoint){

    //variables
    int nDie;                   //random number
    int i;                      //counter
    float fDelay;               //spawn delay

    //randomise the amount of critters spawned
    nDie = Random(nSpawnDie)+1;

    for (i=0; i<nDie; ++i){

        //spawn each critter with 0.1 secs delay
        fDelay = i/10.0;
        DelayCommand(fDelay,ds_spawn_goon(oPC, sCreatureResRef, lSpawnpoint));
    }
}

//spawns nMaxSpawn creatures of sCreatureResRef around lSpawnpoint
void ds_spawn_goon(object oPC, string sCreatureResRef, location lSpawnpoint){

    //variables
    object oCreature;           //used to test if the creature is spawned or not
    location lSpawnLocation;    //location derived from spawnpoint lSpawnpoint
    float fAngle;               //angle to spawn creature on
    float fDistance;            //distance to spawn creature on

    //make new but close by location and spawn creature
    fAngle = IntToFloat(Random(361));
    fDistance = IntToFloat( d2() );
    lSpawnLocation = GenerateNewLocationFromLocation(lSpawnpoint, fDistance, fAngle, fAngle);

    //spawn critter
    oCreature = ds_spawn_critter( oPC, sCreatureResRef, lSpawnLocation );

    RecordCR( oCreature, OBJECT_SELF );
}

//get a random spawn template out of the nSpawnTemplates placed in the area
string ds_random_spawn_template(object oPC, object oArea, int nSpawnTemplates){

    //variables
    int nDie;                   //random number
    string sTemplate;           //the template tag stored on the area

    nDie = 1+Random(nSpawnTemplates);

    //the check_waypoints function stores the template tags on the area
    sTemplate = GetLocalString(oArea,"tst_"+IntToString(nDie));
    return sTemplate;
}

location ds_random_spawnpoint( object oSpawntrigger ){

    object oWaypoint;
    object oSpawnpoint;
    int i                    = 0;
    int nSpawnpoints         = GetLocalInt( oSpawntrigger, "nSpawnpoints" );
    int nRandom;


    //get a random waypoint or the first one if the local int isn't set yet
    if ( nSpawnpoints == 0 ) {

        oWaypoint = GetFirstInPersistentObject( oSpawntrigger, OBJECT_TYPE_WAYPOINT );

        //loop waypoints in trigger
        while( oWaypoint != OBJECT_INVALID ){

            if ( GetTag( oWaypoint ) == SPAWNPOINT_TAG ){

                ++nSpawnpoints;

            }

            oWaypoint = GetNextInPersistentObject( oSpawntrigger, OBJECT_TYPE_WAYPOINT );
        }

        //set the number of waypoints on the trigger
        SetLocalInt( oSpawntrigger, "nSpawnpoints", nSpawnpoints );
    }

    oWaypoint = GetFirstInPersistentObject( oSpawntrigger, OBJECT_TYPE_WAYPOINT );
    nRandom   = Random( nSpawnpoints ) + 1;

    //loop waypoints in trigger
    while( oWaypoint != OBJECT_INVALID ){

        if ( GetTag( oWaypoint ) == SPAWNPOINT_TAG ){

            ++i;

            if ( i == nRandom ) {

                oSpawnpoint = oWaypoint;

            }
        }

        oWaypoint = GetNextInPersistentObject( oSpawntrigger, OBJECT_TYPE_WAYPOINT );
    }

    return GetLocation( oSpawnpoint );
}


int ds_patrol( object oPC, object oArea, object oSpawntrigger ){

    //abort as soon as possible
    if ( GetLocalInt( oArea, "no_patrol" ) ){

        return 0;
    }

    //get patrol variables
    object oCache   = GetCache( "ds_patrol_storage" );
    string sKey     = GetResRef( oArea );
    string sPatrol  = GetLocalString( oCache, sKey );
    object oPatroller;

    //no patrol, make sure that early abortion is guaranteed
    if ( sPatrol == "" ){

        SetLocalInt( oArea, "no_patrol", 1 );

        return 0;
    }

    //check PC and party for patrol tag
    oPatroller = GetPartyMemberWithLocalString( oPC, "ds_patrol", sPatrol );

    //at least 1 pc has the patrol item
    if ( oPatroller != OBJECT_INVALID ){

        //patrol block active?
        if ( GetIsBlocked( oSpawntrigger, "ds_patrol" ) > 0 ){

            //do nothing, patrol time
            SendMessageToPC( oPatroller, "OOC: This location is still under the influence of the previous patrol" );

            return 1;
        }
        else{

            //create patrolling point
            SendMessageToPC( oPatroller, "OOC: A patrolling point has been created..." );

            location lWP = ds_random_spawnpoint( oSpawntrigger );

            object oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_patrol", lWP );

            SetLocalObject( oPLC, "trigger", oSpawntrigger );
            SetLocalString( oPLC, "ds_patrol", sPatrol );

            DelayCommand( 300.0, SafeDestroyObject( oPLC ) );

        }
    }

    return 0;
}


