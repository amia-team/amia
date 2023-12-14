/*  se_gen_portal

--------
Verbatim
--------
Starts conversation file for generic portals
Opens a temp portal based on the list of DestN (tag of destination waypoint)
and DestmN (destination module)


---------
Changelog
---------

Date        Name        Reason
------------------------------------------------------------------
2011-01-16  Selmak      Start of header
2011-01-25  Selmak      Bugfixes: Wrapped delayed commands so that they execute
                        properly when needed.
2013-01-12  Glim        Bugfix: Clean variablies on PC before conversation begins
                        to allow proper choice of destination and activation.
2023-12-04 Maverick     Fixed a bug where the clean variables function wasnt in the right spot
------------------------------------------------------------------

*/
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_actions"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//Wrapper.  The object self-destructs after fTime seconds
void DoSelfDestruct( float fTime );

//Wrapper.  The object stops being busy after fTime seconds
void UnsetBusy( float fTime );

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void DoSelfDestruct( float fTime ){

    DestroyObject( OBJECT_SELF, fTime );

}

void UnsetBusy( float fTime ){

    DelayCommand( fTime, DeleteLocalInt( OBJECT_SELF, "busy" ) );

}

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main()
{
    object oPC;
    object oDevice;


    oPC   = GetPCSpeaker();

    if ( !GetIsObjectValid( oPC ) ) oPC   = GetLastUsedBy();
    if ( !GetIsObjectValid( oPC ) ) return;


    oDevice = GetLocalObject( oPC, "ds_target" );

    if ( oDevice == OBJECT_INVALID ){

        oDevice = OBJECT_SELF;

    }

    //We find out which action has been picked by the PC.
    int nNode;

    if(GetLocalString(oPC, "ds_action") != "se_gen_portal") {
           nNode = 0;
    }
    else {
        nNode = GetLocalInt( oPC, "ds_node" );
    }
    // After we have got nNode, we delete ds_node so that it doesn't produce
    // unexpected results on a subsequent run.
    clean_vars( oPC, 4 );

    if ( nNode > 0 ){

        //We are in conversation, convert action picked to destination.

        //We find the tag we need to give the portal by doing a variable lookup
        //on the device itself.
        string sTag = GetLocalString( oDevice, "Dest" + IntToString( nNode ) );
        //We also need to know which module this destination is in.
        int nModule = GetLocalInt( oDevice, "Destm" + IntToString( nNode ) );

        //We find out which module we are currently in
        int nCurrentModule  = GetLocalInt( GetModule(), "Module" );

        //Now we pick which portal appearance to use
        string sPortalResref;

        if ( nModule > 0 && nModule != nCurrentModule ){
            //White portal (going to other module)
            sPortalResref = "se_gen_portal01";

        }
        else{
            //Red portal (porting within module)
            sPortalResref = "se_gen_portal02";

        }

        //Get location for portal to appear
        string sWP = GetLocalString( oDevice, "wp_localportal" );
        location lLoc = GetLocation( GetWaypointByTag( sWP ) );

        //Finally we create the portal
        //Note the sTag at the end here, this sets the tag of the portal so it
        // can be used for porting
        object oPortal = CreateObject( OBJECT_TYPE_PLACEABLE, sPortalResref, lLoc, TRUE, sTag );
        SetLocalInt( oPortal, "module", nModule );
        //It's a temporary portal, so have it fade away after fifteen seconds.
        AssignCommand( oPortal, DoSelfDestruct( 15.0 ) );

        //We set the device to busy so that you cannot open a portal on
        // top of another portal
        SetLocalInt( oDevice, "busy", 1 );
        //Remove busy flag on device.
        AssignCommand( oDevice, UnsetBusy( 15.0 ) );

        //Clean the PC of ds_check variables
        clean_vars( oPC, 4 );
    }
    else {

        int nBusy = GetLocalInt( oDevice, "busy" );

        if ( nBusy ){

            SendMessageToPC( oPC, "The device is currently active, wait for portal closure." );
            return;
        }

        //Conversation has not yet started, start it

        //First find out which conversation file to use
        string sConvo = GetLocalString( oDevice, "convo" );
        //Clean the PC of ds_check variables to prevent interference from other sources
        clean_vars( oPC, 4 );
        //Then set ds_action on the PC so that this script is called when an
        //action is picked
        SetLocalString( oPC, "ds_action", "se_gen_portal" );

        //Then we set the checks for the conversation
        string sCheck;
        int nLoop;
        //Although there are 40 checks we could use, we might want to leave a
        //couple of them free.
        for ( nLoop = 1; nLoop <= 38 ; nLoop++ ){

            //Getting the destination tag
            sCheck = GetLocalString( oDevice, "Dest" + IntToString( nLoop ) );
            if ( sCheck != "" ){
                //If there is a non-null destination tag, we set this check to 1.
                SetLocalInt( oPC, "ds_check_" + IntToString( nLoop ), 1 );

            }
        }

        //Save the device as a local object on the PC so it can be tracked
        //during conversation actions
        SetLocalObject( oPC, "ds_target", oDevice );

        //Then add this action to the PC's action queue to start the desired conversation file
        AssignCommand( oPC, ActionStartConversation( oPC, sConvo, TRUE, FALSE ) );

    }


}


