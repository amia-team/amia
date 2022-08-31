/*
---------------------------------------------------------------------------------
NAME: js_joblogreset

Description: This script allows a player to safely reset their Job Log without
             losing any important variables. It operates on a one month cooldown.

LOG:
    Lord-Jyssev 8/23/2022: created
----------------------------------------------------------------------------------
*/

#include "inc_call_time"
#include "amia_include"
#include "x2_inc_switches"
#include "inc_ds_records"
#include "x0_i0_campaign"

void LaunchConvo( object oNPC, object oPC );//Launches the dialogue and sets the ds_action variable to call this script

void ResetJob( object oPC, object oNPC, object oWidget, object oJobJournal, int nNode, string sPrimaryJob, string sSecondaryJob ); //resets primary, secondary, or both

void DS_CHECK_SET( object oPC, object oJobJournal, string sPrimaryJob, string sSecondaryJob, int nCooldownTime); // Runs a check and sets the ds_check variables on PC for the dialogue

void DS_CLEAR_ALL(object oPC); // Function to clear all saved variables

void DS_CLEAR_CHECK(object oPC); // Function to clear all saved variables for ds_check

void main()
{
    object oPC                      = GetLastSpeaker();
    object oNPC                     = OBJECT_SELF;
    object oWidget                  = GetItemPossessedBy(oPC, "ds_pckey");
    object oJobJournal;
    object oInventoryItem           = GetFirstItemInInventory(oPC);
    string sPrimaryJob;
    string sSecondaryJob;
    int nJobResetCooldown           = GetLocalInt( oWidget, "JobResetCooldown");
    int nCurrentTime                = GetRunTimeInSeconds();
    int nCooldownTime               = ( nCurrentTime - nJobResetCooldown );
    int nTimer                      = (2629800 - nCooldownTime);
    int nNode                       = GetLocalInt( oPC, "ds_node" );

    string sAction                  = GetLocalString( oPC, "ds_action");

    //Set custom token for the dialogue to tell how long of a cooldown remains
    if(nTimer <= 2629800 && nTimer > 86400)
    {
        SetCustomToken(66667, ""+IntToString(nTimer/86400)+" days");
    }
    else if(nTimer <= 86400 && nTimer > 3600)
    {
        SetCustomToken(66667, ""+IntToString(nTimer/3600)+" hours");
    }
    else if(nTimer <= 3600)
    {
        SetCustomToken(66667, ""+IntToString(nTimer/60)+" minutes");
    }
    else
    {
       SetCustomToken(66667, ""+IntToString(nCooldownTime)+" seconds");
    }



    while(GetIsObjectValid(oInventoryItem))
    {
        if(GetResRef(oInventoryItem) == "jobjournal")
        {
          oJobJournal = oInventoryItem;
          break;
        }
      oInventoryItem = GetNextItemInInventory(oPC);
    }

    sPrimaryJob     = GetLocalString( oJobJournal,"primaryjob");
    sSecondaryJob   = GetLocalString( oJobJournal,"secondaryjob");

    DS_CHECK_SET(oPC,oJobJournal, sPrimaryJob, sSecondaryJob, nCooldownTime);


    // Checks to see if the script has run once, if it did not it runs though the convo file
    if(sAction != "js_joblogreset")
    {
       DeleteLocalInt( oPC, "ds_node");
       DeleteLocalString( oPC, "ds_action");
       LaunchConvo(oNPC,oPC);
    }
    else if(nNode > 0)
    {
      if( 3 >= nNode >= 1)
      {
         // Since the script is going to be launched a second time and moved from the NPC to the PC you need to make sure the NPC is set
         // properly on the second run.
         oNPC = GetNearestObjectByTag("js_joblogreset",oPC);
         ResetJob( oPC, oNPC, oWidget, oJobJournal, nNode, sPrimaryJob, sSecondaryJob );
         DS_CLEAR_ALL(oPC);
         return;
      }
    }
    else if(nNode == 0) // If the ds_action variable is set, but a choice wasn't made this will refire the convo script so they can make a choice
    {
      DeleteLocalInt( oPC, "ds_node");
      DeleteLocalString( oPC, "ds_action");
      LaunchConvo(oNPC,oPC);
    }

}

void DS_CHECK_SET( object oPC, object oJobJournal, string sPrimaryJob, string sSecondaryJob, int nCooldownTime)
{
    DS_CLEAR_CHECK(oPC);


    if(nCooldownTime < 2629800) // Make sure that the cooldown isn't below 1 month (2629800 seconds)
    {
        SetLocalInt(oPC,"ds_check_1",1);
    }
    else if(!GetIsObjectValid(oJobJournal)) // Make sure the PC has a job journal and that its variables aren't already reset
    {
        SetLocalInt(oPC,"ds_check_2",1);
    }
    else if(sSecondaryJob == "" && sPrimaryJob == "")
    {
        SetLocalInt(oPC,"ds_check_2",1);
    }
    else
    {
        DS_CLEAR_CHECK(oPC);
    }

    if(sPrimaryJob != "")
    {
        SetLocalInt(oPC,"ds_check_3",1);
    }

    if(sSecondaryJob != "")
    {
        SetLocalInt(oPC,"ds_check_4",1);
    }

}

void LaunchConvo( object oNPC, object oPC )
{
    SetLocalString( oPC,"ds_action","js_joblogreset" );
    AssignCommand( oNPC, ActionStartConversation( oPC, "c_js_joblogreset", TRUE, FALSE ));
}

void ResetJob( object oPC, object oNPC, object oWidget, object oJobJournal, int nNode, string sPrimaryJob, string sSecondaryJob )
{
    string sNameDetails = "To rename a Job System item: drop the item, stand next to it, type /s f_jsname [name]";
    string sBioDetails1 = "To make a new bio, do the same thing then type /s f_jsbio N [bio]";
    string sBioDetails2 = "/s f_jsbio N makes a new bio";
    string sBioDetails3 = "/s f_jsbio A adds to the end";
    string sBioDetails4 = "/s f_jsbio B puts a line break in it";

    if(nNode == 1)    // Primary job
    {

      DeleteLocalString( oJobJournal, "primaryjob");
      SetDescription( oJobJournal, "Primary Job:  / Secondary Job: "+sSecondaryJob+"\n \n"+sNameDetails+"\n"+sBioDetails1+"\n \n"+sBioDetails2+"\n"+sBioDetails3+"\n"+sBioDetails4);
      SetLocalInt(oWidget,"JobResetCooldown",GetRunTimeInSeconds());
      AssignCommand(oNPC, ActionSpeakString("Your primary job has been reset!", 0));

    }
    else if(nNode == 2)    // Secondary job
    {

      DeleteLocalString(oJobJournal,"secondaryjob");
      SetDescription(oJobJournal,"Primary Job: "+sPrimaryJob+" / Secondary Job: \n \n"+sNameDetails+"\n"+sBioDetails1+"\n \n"+sBioDetails2+"\n"+sBioDetails3+"\n"+sBioDetails4);
      SetLocalInt(oWidget,"JobResetCooldown",GetRunTimeInSeconds());
      AssignCommand(oNPC, ActionSpeakString("Your secondary job has been reset!", 0));

    }
    else if(nNode == 3)    // Both jobs (note, this is not hooked up to a dialogue)
    {

      DeleteLocalString( oJobJournal, "primaryjob");
      DeleteLocalString(oJobJournal,"secondaryjob");
      SetDescription(oJobJournal,"Primary Job:  / Secondary Job: \n \n"+sNameDetails+"\n"+sBioDetails1+"\n \n"+sBioDetails2+"\n"+sBioDetails3+"\n"+sBioDetails4);
      SetLocalInt(oWidget,"JobResetCooldown",GetRunTimeInSeconds());
      AssignCommand(oNPC, ActionSpeakString("Both of your jobs have been reset!", 0));

    }

}

void DS_CLEAR_ALL(object oPC)
{

   SetLocalInt( oPC, "ds_node", 0 );
   SetLocalString( oPC, "ds_action", "" );
   DeleteLocalInt(oPC,"ds_check_1");
   DeleteLocalInt(oPC,"ds_check_2");
   DeleteLocalInt(oPC,"ds_check_3");
   DeleteLocalInt(oPC,"ds_check_4");

}

void DS_CLEAR_CHECK(object oPC)
{

   DeleteLocalInt(oPC,"ds_check_1");
   DeleteLocalInt(oPC,"ds_check_2");
   DeleteLocalInt(oPC,"ds_check_3");
   DeleteLocalInt(oPC,"ds_check_4");

}
