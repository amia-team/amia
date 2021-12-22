//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: kohl_travel_act
//group: travel
//used as: convo action script
//date: 2019-06-18
//author: Jes


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"
#include "inc_ds_porting"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC       = OBJECT_SELF;
    object oPLC      = GetLocalObject( oPC, "ds_target" );
    int nNode        = GetLocalInt( oPC, "ds_node" );
    string sWaypoint = GetTag( oPLC );
    int nAmbush      = GetLocalInt( oPLC, "ambush" );
    object oDest     = GetWaypointByTag( sWaypoint );
    int nAmbushed    = 0;

    //SendMessageToPC( oPC, "<c¥  >Test: WP="+sWaypoint+"</c>" );

    if ( nNode != 1 || sWaypoint == "" ){

        return;
    }

    if ( GetIsDM( oPC ) ){

        AssignCommand( oPC, ClearAllActions( TRUE ) );
        AssignCommand( oPC, JumpToObject( oDest, FALSE ) );

        return;
    }

    if ( nAmbush > 0 && d6() == 3 ){

        oDest = GetWaypointByTag( "ff_ambush_"+IntToString( nAmbush ) );
        nAmbushed = 1;
    }
    else{

        oDest = GetWaypointByTag( sWaypoint );
    }

    //load/store party trigger
    object oTrigger = GetLocalObject( oPLC, "party_trigger" );

    if ( !GetIsObjectValid( oTrigger ) ){

        oTrigger = GetNearestObjectByTag( "party_trigger" );
        SetLocalObject( oPLC, "party_trigger", oTrigger );
    }

    //transport party
    object oObject  = GetFirstInPersistentObject( oTrigger );

    while ( GetIsObjectValid( oObject ) ) {

        if ( ds_check_partymember( oPC, oObject ) ) {

            AssignCommand( oObject, ClearAllActions( TRUE ) );
            AssignCommand( oObject, JumpToObject( oDest, FALSE ) );
        }

        if ( nAmbushed ){

            DelayCommand( 2.0, SendMessageToPC( oObject, "You've been ambushed!" ) );
        }
        oObject = GetNextInPersistentObject( oTrigger );
    }

}
