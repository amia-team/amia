//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  core_fugue
//group:   core, death
//used as: action script
//date:    aug 18 2008
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"
#include "inc_ds_actions"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC       = OBJECT_SELF;
    object oNPC      = GetLocalObject( oPC, "ds_target" );
    string sWP       = "d_"+GetName( GetPCKEY( oPC ) );
    object oWP       = GetWaypointByTag( sWP );
    int nNode        = GetLocalInt( oPC, "ds_node" );

    clean_vars( oPC, 2 );

    if ( !GetIsObjectValid( oWP ) ){

        nNode = 2;
    }

    ClearAllActions( TRUE );

    if ( nNode == 1 ){

        //go to death location
        JumpToObject( oWP );

        //remove WP
        DestroyObject( oWP, 1.0 );

    }
    else if ( nNode == 2 ){

        //go to home location
        object oWP = GetWaypointByTag( GetStartWaypoint( oPC, TRUE ) );

        JumpToObject( oWP );
    }
}

