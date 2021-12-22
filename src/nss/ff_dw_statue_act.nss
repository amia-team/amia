//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: khm_ds_travel_ac
//group: travel
//used as: convo action script
//date: 2008-09-13
//author: disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"
#include "inc_ds_actions"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//does nDamage to the nearest two bystanders
void DamageBystanders( location lWP, int nDamage, int nDamageType );

int CheckStatues( int nTestValue );

void CleanStatues( );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC          = OBJECT_SELF;
    object oPLC         = GetLocalObject( oPC, "ds_target" );
    object oLight       = GetLocalObject( oPLC, "light" );
    int nNode           = GetLocalInt( oPC, "ds_node" );
    effect eShow;
    location lWaypoint;
    effect eCandy;
    string sLight;

    clean_vars( oPC, 2 );


    if ( GetTag( oPLC ) == "ff_dw_ancestor" ){

        if ( nNode == 1 ){

            if ( !GetIsObjectValid( GetNearestObjectByTag( "ff_dw_key_2" ) ) ){

                lWaypoint = GetLocation( GetWaypointByTag( "ff_dw_ancestor_key" ) );
                eCandy    = EffectVisualEffect( VFX_IMP_GOOD_HELP );

                CreateObject( OBJECT_TYPE_ITEM, "ff_dw_key_2", lWaypoint );
                ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eCandy, lWaypoint );

                TakeGoldFromCreature( 5, oPC, TRUE );
            }
        }
        else if ( nNode == 2 ){

            lWaypoint = GetLocation( GetObjectByTag( "ff_dw_spawnboss_2", Random(2) ) );
            eCandy    = EffectVisualEffect( VFX_FNF_SUMMON_UNDEAD );

            ds_spawn_critter_void( oPC, "ff_dw_boss_1", lWaypoint );
            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eCandy, lWaypoint );
        }
        else{

            return;
        }
    }
    else {

        if ( nNode == 1 ){

            eShow  = EffectVisualEffect( VFX_IMP_GOOD_HELP );
            sLight = "plc_magicblue";

            TakeGoldFromCreature( 5, oPC, TRUE );
        }
        else if ( nNode == 2 ){

            eShow = EffectVisualEffect( VFX_IMP_DOOM );
            sLight = "plc_magicred";
            DamageBystanders( GetLocation( oPLC ), d10(), DAMAGE_TYPE_DIVINE );
        }
        else{

            return;
        }

        SafeRemoveAllEffects( oPLC );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eShow, oPLC );

        DestroyObject( oLight );

        oLight = CreateObject( OBJECT_TYPE_PLACEABLE, sLight, GetLocation ( oPLC ), TRUE, "ff_dw_remove" );

        SetLocalInt( oPLC, "state", nNode );
        SetLocalObject( oPLC, "light", oLight );

        if ( CheckStatues( 1 ) ){

            if ( !GetIsObjectValid( GetNearestObjectByTag( "ff_dw_key" ) ) ){

                lWaypoint = GetLocation( GetWaypointByTag( "ff_dw_spawnkey" ) );
                eCandy    = EffectVisualEffect( VFX_FNF_SUNBEAM );

                CreateObject( OBJECT_TYPE_ITEM, "ff_dw_key", lWaypoint );
                ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eCandy, lWaypoint );
            }

            CleanStatues( );
        }
        else if ( CheckStatues( 2 ) ){

            lWaypoint = GetLocation( GetObjectByTag( "ff_dw_spawnboss", Random(3) ) );
            eCandy    = EffectVisualEffect( VFX_FNF_SUMMON_UNDEAD );

            ds_spawn_critter_void( oPC, "ff_dw_boss_2", lWaypoint );
            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eCandy, lWaypoint );

            CleanStatues( );
        }
    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void DamageBystanders( location lWP, int nDamage, int nDamageType ){

    effect eDamage = EffectDamage( nDamage, nDamageType );
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 15.0, lWP );

    if ( GetIsObjectValid( oTarget ) ){

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );

        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 15.0, lWP );

        if ( GetIsObjectValid( oTarget ) ){

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
        }
    }
}

int CheckStatues( int nTestValue ){

    int i;
    object oStatue;

    for ( i=0; i<11; ++i ){

        oStatue = GetObjectByTag( "ff_dw_statue", i );

        //testing
        //SendMessageToPC( GetFirstPC(), "state="+IntToString( GetLocalInt( oStatue, "state" ) ) );

        if ( GetIsObjectValid( oStatue ) ){

            if ( GetLocalInt( oStatue, "state" ) != nTestValue ){

                return FALSE;
            }
        }
    }

    return TRUE;
}

void CleanStatues( ){

    int i;
    object oStatue;
    object oLight;

    for ( i=0; i<11; ++i ){

        oStatue = GetObjectByTag( "ff_dw_statue", i );
        oLight = GetLocalObject( oStatue, "light" );

        SetLocalInt( oStatue, "state", 0 );

        DestroyObject( oLight, 1.0 );
    }
}
