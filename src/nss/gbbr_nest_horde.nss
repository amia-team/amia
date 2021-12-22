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
// prototypes
//-------------------------------------------------------------------------------
void HordeCount( object oWaypoint, object oTrigger, object oPC );
void SpawnHorde( object oWaypoint, object oTrigger, object oPC );

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
    int nSpawnDisabled  = GetLocalInt( GetArea( OBJECT_SELF ), "no_spawn" );

    if( nSpawnDisabled ){

        return;
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
        SetBlockTime( oTrigger, 25, 0 );

        if ( d100() <= GetLocalInt( oTrigger, "FailRate" ) ){

            SendMessageToPC( oPC, "*It looks like something frequents this area, but there's no sign of it now.*" );
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
            DelayCommand( 6.0, HordeCount( oWaypoint, oTrigger, oPC ) );
            AssignCommand( oPC, SpeakString( "<c¥  >**as you encroach upon the central nest, a veritable horde begins to dig up from the very ground beneath your feet! Prepare yourself! It looks like it's going to be a long, hard fight!**</c>" ) );

            if ( GetLocalInt( OBJECT_SELF, "trace" ) == 1 ){

                DelayCommand( 0.5, log_to_exploits( oPC, "Spawned Gibberling Horde", sBossRef, 0 ) );
            }
        }
        else{

            SendMessageToPC( oPC, "[Error: no boss resref]" );
        }
    }
}

void HordeCount( object oWaypoint, object oTrigger, object oPC )
{
    int nCount = GetLocalInt( oTrigger, "Counter" );
    string sTarget      = GetLocalString( oTrigger, "target" );
    string sSpawnpoint  = GetLocalString( oTrigger, "spawnpoint" );
    string sResref      = GetLocalString( oTrigger, "resref" );
    object oPLC;

    nCount = nCount - 1;
    SetLocalInt( oTrigger, "Counter", nCount);

    if( nCount == 10 )
    {
        AssignCommand( oPC, SpeakString( "<c¥  >**there seems to be no end to the horde of Gibberlings rushing towards you!**</c>" ) );
    }
    if( nCount == 6 )
    {
        AssignCommand( oPC, SpeakString( "<c¥  >**the horde seems to reach its peak, a writhing mass of teeth, claws and fur**</c>" ) );
    }
    if( nCount == 2 )
    {
        AssignCommand( oPC, SpeakString( "<c¥  >**it seems as though the horde is beginning to thin! The end is in sight!**</c>" ) );
    }
    if( nCount == 0 )
    {
        oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, sResref, GetLocation( GetWaypointByTag( sSpawnpoint ) ), FALSE, sTarget );

        effect eHint = EffectVisualEffect( VFX_DUR_PROTECTION_GOOD_MINOR );

        ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eHint, GetLocation( oPLC ), TurnsToSeconds( 15 ) );

        DestroyObject( oPLC, TurnsToSeconds( 15 ) );

        AssignCommand( oPC, SpeakString( "<c¥  >**in the wake of the horde you spot a tunnel opening, larger than the others, that seems to lead further down...**</c>" ) );

        SetLocalInt( oTrigger, "Counter", 15 );
    }
    if( nCount >= 1 )
    {
        SpawnHorde( oWaypoint, oTrigger, oPC );
    }
}

void SpawnHorde( object oWaypoint, object oTrigger, object oPC )
{
    int nRandom = d3(1);
    location lSpawn = GetLocation( oWaypoint );
    effect eShake = EffectVisualEffect( VFX_FNF_SCREEN_SHAKE );

    if( nRandom == 1 )
    {
        CreateObject( OBJECT_TYPE_CREATURE, "gibberling_norml", lSpawn );
        CreateObject( OBJECT_TYPE_CREATURE, "gibberling_norml", lSpawn );
        CreateObject( OBJECT_TYPE_CREATURE, "gibberling_norml", lSpawn );
        CreateObject( OBJECT_TYPE_CREATURE, "gibberling_norml", lSpawn );
        CreateObject( OBJECT_TYPE_CREATURE, "gibberling_norml", lSpawn );
    }
    else if( nRandom == 2 )
    {
        CreateObject( OBJECT_TYPE_CREATURE, "gibberling_norml", lSpawn );
        CreateObject( OBJECT_TYPE_CREATURE, "gibberling_brood", lSpawn );
        CreateObject( OBJECT_TYPE_CREATURE, "gibberling_norml", lSpawn );
        CreateObject( OBJECT_TYPE_CREATURE, "gibberling_norml", lSpawn );
    }
    else if( nRandom == 3 )
    {
        CreateObject( OBJECT_TYPE_CREATURE, "gibberling_brood", lSpawn );
        CreateObject( OBJECT_TYPE_CREATURE, "gibberling_brood", lSpawn );
        CreateObject( OBJECT_TYPE_CREATURE, "gibberling_norml", lSpawn );
    }
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eShake, lSpawn );

    DelayCommand( 36.0, HordeCount( oWaypoint, oTrigger, oPC ) );
}
