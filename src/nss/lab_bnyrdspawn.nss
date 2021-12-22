/*
    Custom spawn trigger for the Boneyard boss event in
    the Labyrinth: Massacre level.
*/

#include "amia_include"
#include "x2_inc_toollib"

void SpawnBoneyard( object oPC, string sBossRef, object oWaypoint );

void main(){

    object oTrigger = OBJECT_SELF;
    object oPC = GetEnteringObject( );
    string sBossRef = GetTag( OBJECT_SELF );

    // Player characters only.
    if( !GetIsPC( oPC ) && !GetIsPossessedFamiliar( oPC ) )
    {
        return;
    }

    //DM spawnblock
    int nSpawnDisabled  = GetLocalInt( GetArea( oTrigger ), "no_spawn" );

    if( nSpawnDisabled ){

        return;
    }

    //some boss triggers have a limit of spawns per pc per reset
    int nLimit  = GetLocalInt( oTrigger, "Limit" );
    int nSpawns = GetLocalInt( oPC, sBossRef );

    if( GetIsBlocked( oTrigger ) > 0 )
    {
        SendMessageToPC( oPC, "*There are signs of recent fighting here...*" );
        return;
    }
    else
    {
        if ( nLimit > 0 )
        {
            if ( nSpawns >= nLimit )
            {
                SendMessageToPC( oPC, "Sorry. You can only spawn this boss "+IntToString(nLimit)+" times a reset." );
                return;
            }
        }

        // Block. Do this when spawning fails as well, but not for people surpassing their
        // spawn/ limit. This way other party members get a chance to trigger the boss as well.
        SetBlockTime( oTrigger, 15, 0 );
     }

    // Scan spawn trigger for spawn points.
    object oWaypoint = GetNearestObjectByTag( "CS_WP_BOSS", oTrigger );

    if( GetIsObjectValid( oWaypoint ) )
    {
        // Boss monster blueprint resref available and boss spawn point valid.
        if( sBossRef != "" )
        {
            //only increase spawn limit counter if anything can be spawned
            if ( nLimit > 0 )
            {
                SetLocalInt( oPC, sBossRef, ( nSpawns + 1 ) );
            }

            //Spawn in effects sequence
            effect eBone = EffectVisualEffect( VFX_COM_CHUNK_BONE_MEDIUM );
            effect eSwirl = EffectVisualEffect( VFX_FNF_SUMMON_EPIC_UNDEAD );
            effect eDragon = EffectVisualEffect( VFX_FNF_UNDEAD_DRAGON );
            object oPile = GetWaypointByTag( "wp_bonepile" );
            object oArea = GetArea( oPC );
            location lRandom;
            lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eBone, lRandom );
            lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
            DelayCommand( 1.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eBone, lRandom ) );
            lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
            DelayCommand( 2.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eBone, lRandom ) );
            lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
            DelayCommand( 3.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eBone, lRandom ) );
            lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
            DelayCommand( 4.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eBone, lRandom ) );
            lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
            DelayCommand( 5.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eBone, lRandom ) );
            DelayCommand( 5.1, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eSwirl, GetLocation( oWaypoint ) ) );
            lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
            DelayCommand( 6.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eBone, lRandom ) );
            lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
            DelayCommand( 7.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eBone, lRandom ) );
            lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
            DelayCommand( 8.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eBone, lRandom ) );
            lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
            DelayCommand( 9.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eBone, lRandom ) );
            DelayCommand( 9.1, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eSwirl, GetLocation( oWaypoint ) ) );
            lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
            DelayCommand( 10.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eBone, lRandom ) );
            DelayCommand( 10.1, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eDragon, GetLocation( oWaypoint ) ) );
            lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
            DelayCommand( 11.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eBone, lRandom ) );
            DelayCommand( 11.1, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eSwirl, GetLocation( oWaypoint ) ) );
            DelayCommand( 13.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eSwirl, GetLocation( oWaypoint ) ) );
            DelayCommand( 14.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eSwirl, GetLocation( oWaypoint ) ) );
            DelayCommand( 14.9, TLVFXPillar( VFX_COM_CHUNK_BONE_MEDIUM, GetLocation( oWaypoint ), 5, 0.1f, 0.0f, 2.0f ) );

            DelayCommand( 15.0, SpawnBoneyard( oPC, sBossRef, oWaypoint ) );

            //Lock them in
            object oDoor1 = GetNearestObjectByTag( "massacre_sec_to_bone", oPC );
            object oDoor2 = GetNearestObjectByTag( "massacre_bone_to_sec", oPC );
            object oDoor3 = GetNearestObjectByTag( "massacre_bone_to_lib", oPC );
            object oDoor4 = GetNearestObjectByTag( "massacre_lib_to_bone", oPC );
            SetLocked( oDoor1, TRUE );
            SetLocked( oDoor2, TRUE );
            SetLocked( oDoor3, TRUE );
            SetLocked( oDoor4, TRUE );
            DelayCommand( 600.0, SetLocked( oDoor1, FALSE ) );
            DelayCommand( 600.1, SetLocked( oDoor2, FALSE ) );
            DelayCommand( 600.2, SetLocked( oDoor3, FALSE ) );
            DelayCommand( 600.3, SetLocked( oDoor4, FALSE ) );
        }
        else
        {
            SendMessageToPC( oPC, "[Error: no boss resref]" );
        }
    }
}

void SpawnBoneyard( object oPC, string sBossRef, object oWaypoint )
{
    object oBoss = ds_spawn_critter( oPC, sBossRef, GetLocation( oWaypoint ) );

    if ( GetLocalInt( OBJECT_SELF, "trace" ) == 1 )
    {
        DelayCommand( 0.5, log_to_exploits( oPC, "Spawned "+GetName( oBoss ), sBossRef, 0 ) );
    }

    object oArea = GetArea( oPC );
    object oSpawner = GetFirstObjectInArea( oArea );
    while( GetIsObjectValid( oSpawner ) )
    {
        if( GetObjectType( oSpawner ) == OBJECT_TYPE_CREATURE )
        {
            if( ds_check_partymember( oPC, oSpawner ) == TRUE || oSpawner == oPC )
            {
                SetLocalInt( oSpawner, "BoneyardSpawner", 1 );
            }
        }
        oSpawner = GetNextObjectInArea( oArea );
    }
}
