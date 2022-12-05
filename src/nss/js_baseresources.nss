/*
  Job System Base Resource Script - This is the on use script for all the base resource nodes

  - Maverick00053

  - Edited: Lord-Jyssev - 8/5/22 Include cooldown counter for resource nodes
            Lord-Jyssev - 12/1/22 Included logic to allow single-use crops/animals to be placed in-world
            Lord-Jyssev - 12/5/22 Added ability to have any number of resource variables attached to an object (previously was 3 max)

*/


#include "x2_inc_switches"
#include "inc_ds_records"
#include "x0_i0_campaign"
#include "inc_call_time"
#include "amia_include"
#include "nwnx_object"


const int RESOURCE_XP    = 100;

void RefreshingNode(object oPC, string sResource, object oResourceNode, int nRank); // Refreshing Nodes

void SingleUseNode(object oPC, string sResource, object oResourceNode, int nRank); // Single Use Nodes, like livestock

void main()
{
    object oResourceNode = OBJECT_SELF;
    object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC,OBJECT_SELF);
    object oInventoryItem = GetFirstItemInInventory(oPC);
    object oJobJournal;
    int nBlocker = GetLocalInt(oResourceNode, "blocker");
    int nSingleUse = GetLocalInt(oResourceNode, "SingleUse");
    int nRank;
    int nRand;
    int nPreviousTime = GetLocalInt(oResourceNode,"PreviousHarvestTime");
    int nCurrentTime = GetRunTimeInSeconds();
    int nCooldownTime = (nCurrentTime - nPreviousTime);
    float fRefresh;
    string sResource = GetLocalString(oResourceNode, "resource");
    string sResource2 = GetLocalString(oResourceNode, "resource2");
    string sJob = GetLocalString(oResourceNode, "job");
    string sPrimaryJob;
    string sSecondaryJob;

    if(GetLocalFloat(oResourceNode,"refreshrate") > 0.0)
    {
      fRefresh = GetLocalFloat(oResourceNode,"refreshrate");
    }
    else if(GetLocalFloat(oResourceNode,"traprate") > 0.0)
    {
      fRefresh = GetLocalFloat(oResourceNode,"traprate");
    }
    else if(GetLocalFloat(oResourceNode,"growrate") > 0.0)
    {
      fRefresh = GetLocalFloat(oResourceNode,"growrate");
    }

    // A simple check to see if the blocker for harvesting is up or not on the resource node
    if(nBlocker == 1)
    {
      SendMessageToPC(oPC,"*Cannot harvest this resource for " + IntToString(FloatToInt(fRefresh)-nCooldownTime) + " seconds*");
      return;
    }

    // We search for their journal
    while(GetIsObjectValid(oInventoryItem))
    {
        if(GetResRef(oInventoryItem) == "jobjournal")
        {
          oJobJournal = oInventoryItem;
          break;
        }
      oInventoryItem = GetNextItemInInventory(oPC);
    }


    // Getting a rank for the job. If its their primary they get a 2, secondary a 1, and not at all a 0
    if(!GetIsObjectValid(oJobJournal))
    {
      nRank = 0;
    }
    else
    {
      // Get their primary and secondary jobs
      sPrimaryJob = GetLocalString(oJobJournal,"primaryjob");
      sSecondaryJob = GetLocalString(oJobJournal,"secondaryjob");

      // Rank how good they are at the job
      if((GetSubString(sJob,0,GetStringLength(sPrimaryJob)) == sPrimaryJob) && (sPrimaryJob != ""))
      {
        nRank = 2;
      }
      else if((GetSubString(sJob,0,GetStringLength(sSecondaryJob)) == sSecondaryJob)  && (sSecondaryJob != ""))
      {
        nRank = 1;
      }
      else
      {
        nRank = 0;
      }

    }

     //If more than one resource set, run a loop to determine number of resources and randomly select one
     int nVariableCount = NWNX_Object_GetLocalVariableCount(oResourceNode);

     if((sResource2 != ""))// 2nd Resource not blank
     {
         int nResourceCount;
         int i = 0;
         for(i; i < nVariableCount; i++)
         {
            if( GetSubString( NWNX_Object_GetLocalVariable( oResourceNode, i ).key, 0, 8 ) == "resource" )
            {
                nResourceCount++;
            }
         }
         nRand = Random(nResourceCount)+1;

         if(nRand > 1)
         {
            sResource = GetLocalString(oResourceNode, ("resource"+IntToString(nRand)));
         }
     }
     //

    // Launches the appropriate resource node script
    if( nSingleUse == 1) //nSingleUse is set by the job journal where appropriate (Farm crops, Rancher animals, Hunter traps)
    {
        SingleUseNode(oPC,sResource,oResourceNode,nRank);
    }
    else
    {
        RefreshingNode(oPC,sResource,oResourceNode,nRank);
    }

    /*
    if((sJob == "Miner") || (sJob == "Alchemist") || (sJob == "Artist") || (sJob == "Hunter") || (sJob == "Physician") ||
    (sJob == "Scoundrel") || (sJob == "Tailor") || (sJob == "FarmerTree"))
    {

        RefreshingNode(oPC,sResource,oResourceNode,nRank);

    }
    else if((sJob == "Farmer") || (sJob == "Rancher") || (sJob == "HunterTrap"))
    {
        SingleUseNode(oPC,sResource,oResourceNode,nRank);
    }
    */

}

void RefreshingNode(object oPC, string sResource, object oResourceNode, int nRank)
{
  int nRandom = Random(100)+1;
  float fRefresh = GetLocalFloat(oResourceNode,"refreshrate");
  string sSuccessOrFailure;
  int nPCLevel = GetHitDice(oPC);
  int nXP = RESOURCE_XP;

  // Level 30 XP blocker
  if(nPCLevel == 30)
  {
    nXP = 1;
  }

  if(nRank == 2)
  {
    SendMessageToPC(oPC,"100% SUCCESS! RESOURCE HARVESTED!");
    GiveExactXP(oPC,nXP);
    CreateItemOnObject(sResource,oPC);
  }
  else if(nRank == 1)
  {
    if(nRandom <= 80)
    {
     sSuccessOrFailure = "SUCCESS";
     GiveExactXP(oPC,nXP);
     CreateItemOnObject(sResource,oPC);
    }
    else
    {
     sSuccessOrFailure = "FAILURE";
     GiveExactXP(oPC,nXP/2);
    }
    SendMessageToPC(oPC,"Rolled "+IntToString(nRandom)+" vs 80 or less. "+sSuccessOrFailure);

  }
  else
  {

    if(nRandom <= 60)
    {
     sSuccessOrFailure = "SUCCESS";
     CreateItemOnObject(sResource,oPC);
    }
    else
    {
     sSuccessOrFailure = "FAILURE";
    }
    SendMessageToPC(oPC,"Rolled "+IntToString(nRandom)+" vs 60 or less. "+sSuccessOrFailure);
  }

   SetLocalInt(oResourceNode,"blocker",1);
   DelayCommand(fRefresh,DeleteLocalInt(oResourceNode,"blocker"));
   SetLocalInt(oResourceNode,"PreviousHarvestTime",GetRunTimeInSeconds());
   DelayCommand(fRefresh,DeleteLocalInt(oResourceNode,"PreviousHarvestTime"));

}





void SingleUseNode(object oPC, string sResource, object oResourceNode, int nRank)
{

  int nRandom = Random(100)+1;
  int nPCNameLength = GetStringLength(GetName(oPC));
  string sSuccessOrFailure;
  string sResourceNodeName = GetName(oResourceNode);
  int nPCLevel = GetClassByPosition(1,oPC) + GetClassByPosition(2,oPC) + GetClassByPosition(3,oPC);
  int nXP = RESOURCE_XP;

  // Level 30 XP blocker
  if(nPCLevel == 30)
  {
    nXP = 1;
  }


  // Check to make sure only the owner is harvesting the resource
  if(GetSubString(sResourceNodeName,0,nPCNameLength) != GetName(oPC))
  {
    SendMessageToPC(oPC,"*This is not your resource to harvest!*");
    return;
  }


  if(nRank == 2)
  {
    SendMessageToPC(oPC,"100% SUCCESS! RESOURCE HARVESTED!");
    GiveExactXP(oPC,nXP);
    CreateItemOnObject(sResource,oPC);
    SetLocalInt(oResourceNode,"blocker",1);
    DestroyObject(oResourceNode,0.2);
  }
  else if(nRank == 1)
  {
    if(nRandom <= 80)
    {
     sSuccessOrFailure = "SUCCESS";
     GiveExactXP(oPC,nXP);
     CreateItemOnObject(sResource,oPC);
     SetLocalInt(oResourceNode,"blocker",1);
     DestroyObject(oResourceNode,0.2);
    }
    else
    {
     sSuccessOrFailure = "FAILURE";
     GiveExactXP(oPC,nXP/2);
     SetLocalInt(oResourceNode,"blocker",1);
     DestroyObject(oResourceNode,0.2);
    }
    SendMessageToPC(oPC,"Rolled "+IntToString(nRandom)+" vs 80 or less. "+sSuccessOrFailure);

  }
  else
  {

    if(nRandom <= 60)
    {
     sSuccessOrFailure = "SUCCESS";
     CreateItemOnObject(sResource,oPC);
     SetLocalInt(oResourceNode,"blocker",1);
     DestroyObject(oResourceNode,0.2);
    }
    else
    {
     sSuccessOrFailure = "FAILURE";
     SetLocalInt(oResourceNode,"blocker",1);
     DestroyObject(oResourceNode,0.2);
    }
    SendMessageToPC(oPC,"Rolled "+IntToString(nRandom)+" vs 60 or less. "+sSuccessOrFailure);
  }

  // Tracks and removes crop/animal/trap counters as they are consumed
  if(GetLocalString(oResourceNode,"job") == "Farmer")
  {
    SetLocalInt(oPC,"crops",GetLocalInt(oPC,"crops")-1);
  }
  else if(GetLocalString(oResourceNode,"job") == "Rancher")
  {
    SetLocalInt(oPC,"animals",GetLocalInt(oPC,"animals")-1);
  }
  else if(GetLocalString(oResourceNode,"job") == "HunterTrap")
  {
    SetLocalInt(oPC,"traps",GetLocalInt(oPC,"traps")-1);
  }


}
