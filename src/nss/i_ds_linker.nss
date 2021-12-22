//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: i_ds_linker
//group: DM widgets
//used as: activation script
//date:    oct 13 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_nwnx_events"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_INSTANT:
        case X2_ITEM_EVENT_ACTIVATE:

            if(nEvent==X2_ITEM_EVENT_INSTANT)
                EVENTS_Bypass();


            // item activate variables
            object oPC       = InstantGetItemActivator();
            object oItem     = InstantGetItemActivated();
            object oTarget   = InstantGetItemActivatedTarget();
            location lTarget = InstantGetItemActivatedTargetLocation();
            int nStatus      = GetLocalInt( oPC, "ds_linker" );
            string sTag1     = "ds_link1_"+GetPCPublicCDKey( oPC );
            string sTag2     = "ds_link2_"+GetPCPublicCDKey( oPC );
            object oWP1      = GetWaypointByTag( sTag1 );
            object oWP2      = GetWaypointByTag( sTag2 );


            if ( GetIsObjectValid( oWP1 ) == FALSE ){

                SendMessageToPC( oPC, "Creating first portal" );
                CreateObject( OBJECT_TYPE_WAYPOINT, "ds_link", lTarget, FALSE, sTag1 );
                CreateObject( OBJECT_TYPE_PLACEABLE, "ds_link", lTarget, FALSE, sTag2 );
                SetLocalInt( oPC, "ds_linker", 1 );
            }
            else if ( GetIsObjectValid( oWP2 ) == FALSE  ){

                SendMessageToPC( oPC, "Creating second portal" );
                CreateObject( OBJECT_TYPE_WAYPOINT, "ds_link", lTarget, FALSE, sTag2 );
                CreateObject( OBJECT_TYPE_PLACEABLE, "ds_link", lTarget, FALSE, sTag1 );
                SetLocalInt( oPC, "ds_linker", 2 );
            }
            else{

                SendMessageToPC( oPC, "Removing portals" );
                DeleteLocalInt( oPC, "ds_linker" );
                DestroyObject( oWP1 );
                DestroyObject( oWP2 );
                DelayCommand( 1.0, DestroyObject( GetObjectByTag( sTag1 ) ) );
                DelayCommand( 1.0, DestroyObject( GetObjectByTag( sTag2 ) ) );
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
// functions
//----------------------------





