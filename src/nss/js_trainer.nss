/*
  Job System Trainer Script - Gives a Job Journal and assigns primary/secondary jobs

  - Maverick00053

*/

#include "x2_inc_switches"
#include "inc_ds_records"
#include "x0_i0_campaign"

// Launches the Convo Function
void LaunchConvo( object oNPC, object oPC);

// Launches the AssignJob Function
void AssignJob(object oPC, object oNPC, int nNode);

void main()
{
    object oPC          = GetLastSpeaker();
    object oNPC         = OBJECT_SELF;
    object oDoor;
    int nNode           = GetLocalInt( oPC, "ds_node" );
    string sAction      = GetLocalString( oPC, "ds_action");


    // Checks to see if the script has run once, if it did not it runs though the convo file
    if(sAction != "js_trainer")
    {
       DeleteLocalInt( oPC, "ds_node");
       DeleteLocalString( oPC, "ds_action");
       LaunchConvo(oNPC,oPC);
    }
    else if(nNode > 0)
    {

      if( 2 >= nNode >= 1)
      {
         // Since the script is going to be launched a second time and moved from the NPC to the PC you need to make sure the NPC is set
         // properly on the second run.
         oNPC = GetNearestObjectByTag("jobtrainer",oPC);
         AssignJob(oPC,oNPC,nNode);
         DeleteLocalInt( oPC, "ds_node");
         DeleteLocalString( oPC, "ds_action");
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

void LaunchConvo( object oNPC, object oPC){
    SetLocalString(oPC,"ds_action","js_trainer");
    AssignCommand(oNPC, ActionStartConversation(oPC, "c_js_trainer", TRUE, FALSE));
}


void AssignJob(object oPC, object oNPC, int nNode)
{
    object oInventoryItem = GetFirstItemInInventory(oPC);
    object oJobJournal;
    string sJob = GetLocalString(oNPC,"job");
    string sPrimaryJob;
    string sSecondaryJob;

    // First we search if they already have a journal
    while(GetIsObjectValid(oInventoryItem))
    {
        if(GetResRef(oInventoryItem) == "jobjournal")
        {
          oJobJournal = oInventoryItem;
          break;
        }
      oInventoryItem = GetNextItemInInventory(oPC);
    }

    // If they dont have a journal now is the time to make one for them
    if(!GetIsObjectValid(oJobJournal))
    {
      oJobJournal = CreateItemOnObject("jobjournal",oPC);
    }


    // See if the journal already has jobs set
    sPrimaryJob = GetLocalString(oJobJournal,"primaryjob");
    sSecondaryJob = GetLocalString(oJobJournal,"secondaryjob");

    // A check to make sure they already selecting a job they already have
    if((sPrimaryJob == sJob) || (sSecondaryJob == sJob))
    {
       AssignCommand(oNPC, ActionSpeakString("You already have this job."));
       return;
    }


    if(nNode == 1)    // Primary job
    {

      if(sPrimaryJob == "") // If no primary is set already then set it
      {

         SetLocalString(oJobJournal,"primaryjob",sJob);
         SetDescription(oJobJournal,"Primary Job: "+sJob+" / Secondary Job: "+sSecondaryJob);
      }
      else
      {
         AssignCommand(oNPC, ActionSpeakString("You already have a primary job set."));
         return;
      }

    }
    else if(nNode == 2)    // Secondary job
    {

      if(sSecondaryJob == "") // If no secondary is set already then set it
      {
         SetLocalString(oJobJournal,"secondaryjob",sJob);
         SetDescription(oJobJournal,"Primary Job: "+sPrimaryJob+" / Secondary Job: "+sJob);
      }
      else
      {
         AssignCommand(oNPC, ActionSpeakString("You already have a secondary job set."));
         return;
      }

    }











}
