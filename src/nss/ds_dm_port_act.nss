//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_dm_port_act
//group:  dm tools
//used as: convo action script
//date: 2008-12-16
//author: disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void JumpPC( object oDM, object oTarget, string sDest );
void JumpBack( object oDM, object oTarget );
void PortRandom( object oDM, object oTarget );
int InitRandom();


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oDM       = OBJECT_SELF;
    object oTarget   = GetLocalObject( oDM, "ds_target" );
    int nNode        = GetLocalInt( oDM, "ds_node" );

    if ( nNode == 1 ){

        JumpPC( oDM, oTarget, "b_71" );
    }
    else if ( nNode == 2 ){

        JumpPC( oDM, oTarget, "b_74" );
    }
    else if ( nNode == 3 ){

        JumpBack( oDM, oTarget );
    }
    else if ( nNode == 4 ){

        JumpPC( oDM, oTarget, "b_73" );
    }
    else if ( nNode == 5 ){

        JumpPC( oDM, oTarget, "b_82" );
    }
    else if ( nNode == 6 ){

        JumpPC( oDM, oTarget, "b_83" );
    }
    else if ( nNode == 7 ){

        JumpPC( oDM, oTarget, "b_72" );
    }
    else if ( nNode == 8 ){

        JumpPC( oDM, oTarget, "start" );
    }
    else if ( nNode == 9 ){

        PortRandom( oDM, oTarget );
    }
}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------
void JumpPC( object oDM, object oTarget, string sDest ){

    object oDest;

    //store origin
    SetLocalLocation( oTarget, "ds_back", GetLocation( oTarget ) );

    //home and start locations
    if ( sDest == "start" ){

        oDest = GetWaypointByTag( GetStartWaypoint( oTarget ) );

        SendMessageToPC( oDM, "Ported "+GetName( oTarget )+" to "+GetName( GetArea( oDest ) ) );
    }
    else{

        oDest = GetWaypointByTag( sDest );
    }

    AssignCommand( oTarget, ClearAllActions() );
    AssignCommand( oTarget, JumpToObject( oDest, FALSE ) );
}


void JumpBack( object oDM, object oTarget ){

    location lOrigin = GetLocalLocation( oTarget, "ds_back" );

    AssignCommand( oTarget, ClearAllActions() );
    AssignCommand( oTarget, JumpToLocation( lOrigin ) );

    SendMessageToPC( oDM, "Ported "+GetName( oTarget )+" to "+GetName( GetAreaFromLocation( lOrigin ) ) );
}


void PortRandom( object oDM, object oTarget ){

    //get random area
    int nAreas = GetLocalInt( GetModule(), "ds_areas" );

    if ( !nAreas ){

        nAreas = InitRandom();
    }

    object oDest = GetObjectByTag( "is_area", Random( nAreas ) );
    string sChar = GetStringLeft( GetName( GetArea( oDest ) ), 1 );

    while ( sChar == "_" || sChar == " " ){

        //we don't want people to enter DM or system areas
        oDest = GetObjectByTag( "is_area", Random( nAreas ) );
        sChar = GetStringLeft( GetName( GetArea( oDest ) ), 1 );
    }

    //store origin
    SetLocalLocation( oTarget, "ds_back", GetLocation( oTarget ) );

    AssignCommand( oTarget, ClearAllActions() );
    AssignCommand( oTarget, JumpToObject( oDest, FALSE ) );

    SendMessageToPC( oDM, "Ported "+GetName( oTarget )+" to "+GetName( GetArea( oDest ) ) );
}

int InitRandom(){

    int i;
    object oAreaWP = GetObjectByTag( "is_area", i );

    while ( GetIsObjectValid( oAreaWP ) ){

        ++i;

        oAreaWP = GetObjectByTag( "is_area", i );
    }

    //counting starts at 0, so add one more
    ++i;

    SetLocalInt( GetModule(), "ds_areas", i );

    SendMessageToPC( GetFirstPC(), "Area Count: "+IntToString( i ) );

    return i;
}

