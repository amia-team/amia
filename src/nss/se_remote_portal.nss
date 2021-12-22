/*  se_remote_portal

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
------------------------------------------------------------------

*/
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_actions"

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

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
    int nNode = GetLocalInt( oPC, "ds_node" );
    // After we have got nNode, we delete ds_node so that it doesn't produce
    // unexpected results on a subsequent run.
    DeleteLocalInt( oPC, "ds_node" );

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

        //We set the device to busy (open) so that you cannot open a portal on
        // top of another portal
        SetLocalInt( oDevice, "open", 1 );

        //It's a temporary portal, so have it fade away after fifteen seconds.
        DelayCommand( 15.0, DestroyObject( oPortal ) );

        //Remove busy flag on device.
        DelayCommand( 15.0, DeleteLocalInt( oDevice, "open" ) );

        //Clean the PC of ds_check variables
        clean_vars( oPC, 4 );
    }
    else {

        //Conversation has not yet started, start it

        //First find out which conversation file to use
        string sConvo = GetLocalString( oDevice, "convo" );
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

        int nOpen = GetLocalInt( oDevice, "open" );

        SetLocalInt( oPC, "ds_check_40", nOpen );

        //Save the device as a local object on the PC so it can be tracked
        //during conversation actions
        SetLocalObject( oPC, "ds_target", oDevice );

        //Then add this action to the PC's action queue to start the desired conversation file
        AssignCommand( oPC, ActionStartConversation( oPC, sConvo, TRUE, FALSE ) );

    }


}
