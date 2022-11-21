//-------------------------------------------------------------------------------
// Randomized Placeable Spawner
//-------------------------------------------------------------------------------
/*

    Created by Lord-Jyssev 10/14/2022

    This script will spawn placeable objects at a randomly-selected waypoint within the area that this trigger is placed.
    By default, the appearance of the placeable will be Invisible Object but this can be customized with the "PLCAppearance" variable.
    Setting the "DestinationWP" variable will add a transport script, make it usable, and set the waypoint that it will transport you to.
    Setting the "ItemResref" variable will add a give item script, make it usable, and set the item to be given
        "OncePerReset" variable will only allow 1 item per server reset
        "questname" variable will only give an item while the quest isn't completed. This must exactly match the "questname" variable of the actual quest NPC
    Setting the "MapPin" variable will enable a map pin on the randomly chosen waypoint and set its text to the variable
    Setting the "DestroyMessage" variable will add a floating message when the placeable is destroyed
    After a certain amount of time (int BlockTime), the placeable will destroy itself.

*/
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "amia_include"
#include "nwnx_object"


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

//Spawns a PLC
object SpawnRandomPlaceable( object oPLC, object oPC, int nBlockTime, string sResref, location lWaypoint, float fFacing );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC              = GetEnteringObject();
    string sResref          = GetLocalString( OBJECT_SELF, "resref" );
    string sMapPin          = GetLocalString( OBJECT_SELF, "MapPin" );
    string sDestroyMessage  = GetLocalString( OBJECT_SELF, "DestroyMessage");
    int nBlockTime          = GetLocalInt( OBJECT_SELF, "BlockTime" );
    int nCount              = 1;
    float fFacing;
    object oPLC             = GetNearestObjectByTag( sResref, OBJECT_SELF, 1 );
    object oWaypoint;
    location lWaypoint;

    if ( GetIsBlocked( ) > 0 ){

        //SendMessageToPC( oPC, "You're blocked!" );                                                              ///
        return;
    }

    //Count the number of valid waypoints and stop if an existing placeable is found
    while(GetNearestObjectByTag( "lj_randplcspwn", OBJECT_SELF, nCount) != OBJECT_INVALID)
    {
/*        //Check to make sure that a placeable chest with the resref isn't already in the area
        if ( GetObjectType( GetNearestObjectByTag( resref , OBJECT_SELF, nCount) ) == OBJECT_TYPE_PLACEABLE )
        {
            return;
        }                   */
        nCount++;
    }

    //Set the cooldown time from the trigger's variables
    SetBlockTime( OBJECT_SELF, 0, nBlockTime );

    //Get a randomized waypoint and get the location from it for spawning
    oWaypoint    = GetNearestObjectByTag( "lj_randplcspwn", OBJECT_SELF, Random(nCount) );
    if(oWaypoint == OBJECT_INVALID)
    {
        SendMessageToPC( oPC, "DEBUG: Can't find a vaild waypoint! Please report to a Dev." );
    }
    fFacing      = GetFacing( oWaypoint );
    lWaypoint    = GetLocation( oWaypoint );

    if(sMapPin != "")
    {
        NWNX_Object_SetMapNote( oWaypoint, sMapPin);
        SetMapPinEnabled( oWaypoint, 1);
    }

    oPLC = SpawnRandomPlaceable( oPLC, oPC, nBlockTime, sResref, lWaypoint, fFacing );

    //Destroy the PLC after the cooldown duration
    if( sDestroyMessage != "") { DelayCommand( IntToFloat(nBlockTime-5), AssignCommand(oPLC, SpeakString( sDestroyMessage ))); }
    DelayCommand ( IntToFloat(nBlockTime), SetMapPinEnabled( oWaypoint, 0));
    DestroyObject( oPLC, IntToFloat(nBlockTime) );

}


object SpawnRandomPlaceable( object oPLC, object oPC, int nBlockTime, string sResref, location lWaypoint, float fFacing )
{
    int nPLCAppearance        = GetLocalInt (OBJECT_SELF, "PLCAppearance");
    int nOncePerReset         = GetLocalInt (OBJECT_SELF, "OncePerReset");
    string sDestination       = GetLocalString (OBJECT_SELF, "DestinationWP");
    string sItem              = GetLocalString (OBJECT_SELF, "ItemResref");
    string sPLCName           = GetLocalString (OBJECT_SELF, "PLCName");
    string sPLCDescription    = GetLocalString (OBJECT_SELF, "PLCDescription");
    string sQuestName         = GetLocalString (OBJECT_SELF, "questname");

    oPLC                      = CreateObject( OBJECT_TYPE_PLACEABLE, sResref, lWaypoint);

    AssignCommand(oPLC, SetFacing( fFacing + 180.0));

    //Set variables on the placeable only if they are set on the trigger
    if (nPLCAppearance != 0)    { NWNX_Object_SetAppearance(oPLC, nPLCAppearance); }
    if (nOncePerReset != 0)     { SetLocalInt( oPLC, "OncePerReset", nOncePerReset); }
    if (sPLCName != "")         { SetName( oPLC, sPLCName); }
    if (sPLCDescription != "")  { SetDescription( oPLC, sPLCDescription); }
    if (sQuestName != "")       { SetLocalString ( oPLC, "questname", sQuestName ); }

    //Set object to usable and give it the proper script if it is a destination or item giver
    if (sDestination != "" || sItem != "")
    {
        NWNX_Object_SetPlaceableIsStatic( oPLC, FALSE);
        SetPlotFlag( oPLC, 1);
        SetUseableFlag( oPLC, 1);

        if      ( sDestination != "" )  { SetEventScript( oPLC, EVENT_SCRIPT_PLACEABLE_ON_USED, "us_jump_to_tag"); SetTag( oPLC, sDestination); }
        else if ( sItem != "")          { SetEventScript( oPLC, EVENT_SCRIPT_PLACEABLE_ON_USED, "us_give_item"); SetLocalString( oPLC, "ds_item", sItem); }
    }

    return oPLC;
}
