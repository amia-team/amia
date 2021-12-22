//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  bh_ds_chickfight
//group:   varia
//used as: convo action. Starts a chicken fight in Kompo's
//date:    nov 01 2007
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oChicken1    = GetObjectByTag( "bh_ds_chick_1" );
    object oChicken2    = GetObjectByTag( "bh_ds_chick_2" );
    int nResult;

    if (  GetIsObjectValid( oChicken1 ) ){

        nResult = 1;
    }

    if (  GetIsObjectValid( oChicken2 ) ){

        nResult = nResult + 2;
    }

    if ( nResult == 1 ){

        SpeakString( "Lemme get " + GetName( oChicken1 ) + " first..." );
        DestroyObject( oChicken1 );
        return;
    }
    else if ( nResult == 2 ){

        SpeakString( "Lemme get " + GetName( oChicken2 ) + " first..." );
        DestroyObject( oChicken2 );
        return;
    }
    else if ( nResult == 3 ){

        SpeakString( "Dere be a fight on, stoopid." );
        return;
    }
    else{

        object oPC          = GetPCSpeaker();
        int nGold           = GetGold( oPC );

        if ( nGold < 250 ){

            SpeakString( "Oi! I ent doing discount or summink!" );
            return;
        }

        SpeakString( "'njoy yer fight. Don't git too close to da pit or ye'll get a peckin'!" );

        TakeGoldFromCreature( 250, oPC, TRUE );

        object oWaypoint1   = GetWaypointByTag( "bh_ds_arena_1" );
        object oWaypoint2   = GetWaypointByTag( "bh_ds_arena_2" );

        oChicken1           = ds_spawn_critter( OBJECT_INVALID, "bh_ds_chick_1", GetLocation( oWaypoint1 ), FALSE, "bh_ds_chick_1" );
        oChicken2           = ds_spawn_critter( OBJECT_INVALID, "bh_ds_chick_2", GetLocation( oWaypoint2 ), FALSE, "bh_ds_chick_2" );

        SetName( oChicken1, RandomName( NAME_FIRST_HUMAN_FEMALE ) );
        SetName( oChicken2, RandomName( NAME_FIRST_HUMAN_FEMALE ) );


    }

    //DelayCommand( 2.0, SetIsTemporaryEnemy( oChicken1, oChicken2 ) );

}
