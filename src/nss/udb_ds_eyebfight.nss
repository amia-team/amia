//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  udb_ds_eyebfight
//group:   varia
//used as: convo action. Starts an eyeball fight.
//date:    nov 01 2007
//author:  disco
//notes:   modified by Nekhy from disco's original chickfight script for the underdark
//         perhaps idea to make a generic one at some point?

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oEyeball1    = GetObjectByTag( "udb_ds_eball_1" );
    object oEyeball2    = GetObjectByTag( "udb_ds_eball_2" );
    int nResult;

    if (  GetIsObjectValid( oEyeball1 ) ){

        nResult = 1;
    }

    if (  GetIsObjectValid( oEyeball2 ) ){

        nResult = nResult + 2;
    }

    if ( nResult == 1 ){

        SpeakString( "Let me get " + GetName( oEyeball1 ) + " first..." );
        DestroyObject( oEyeball1 );
        return;
    }
    else if ( nResult == 2 ){

        SpeakString( "Let me get " + GetName( oEyeball2 ) + " first..." );
        DestroyObject( oEyeball2 );
        return;
    }
    else if ( nResult == 3 ){

        SpeakString( "There is already a fight going on." );
        return;
    }
    else{

        object oPC          = GetPCSpeaker();
        int nGold           = GetGold( oPC );

        if ( nGold < 250 ){

            SpeakString( "This is my price and I give no discount!" );
            return;
        }

        SpeakString( "Enjoy your fight. Watch out for the rays!" );

        TakeGoldFromCreature( 250, oPC, TRUE );

        object oWaypoint1   = GetWaypointByTag( "udb_ds_arena_1" );
        object oWaypoint2   = GetWaypointByTag( "udb_ds_arena_2" );

        oEyeball1           = ds_spawn_critter( OBJECT_INVALID, "udb_ds_eball_1", GetLocation( oWaypoint1 ), FALSE, "udb_ds_eball_1" );
        oEyeball2           = ds_spawn_critter( OBJECT_INVALID, "udb_ds_eball_2", GetLocation( oWaypoint2 ), FALSE, "udb_ds_eball_2" );

        SetName( oEyeball1, RandomName( NAME_FIRST_HALFORC_FEMALE ) );
        SetName( oEyeball2, RandomName( NAME_FIRST_ELF_FEMALE ) );


    }

    //DelayCommand( 2.0, SetIsTemporaryEnemy( oEyeball1, oEyeball2 ) );

}
