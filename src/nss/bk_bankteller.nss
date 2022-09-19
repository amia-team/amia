/*
  Bank Teller Script

  - Maverick00053

*/

#include "x2_inc_switches"
#include "inc_ds_records"
#include "x0_i0_campaign"

// Launches the Convo Script
void LaunchConvo( object oNPC, object oPC);

// Launches the Banking Script
void Bank(object oPC, object oNPC, int nNode);

void main()
{
    object oPC          = GetLastSpeaker();
    object oNPC         = OBJECT_SELF;
    object oDoor;
    int nNode           = GetLocalInt( oPC, "ds_node" );
    int nNPCGroup       = GetLocalInt(oNPC, "group");
    int nDoorGroup;
    int nLockedState;
    int nCount = 1;
    string sAction      = GetLocalString( oPC, "ds_action");

    // Check to see if prior chest was closed properly.
    /*string sBankUse = "BANK_MID_USE";
    object oPCKey = GetPCKEY(oPC);
    if (GetLocalInt(oPCKey,sBankUse) == TRUE) {
      AssignCommand(oNPC, ActionSpeakString("My apologies, there was a security issue with your storage. Please come back later. (//Please contact a DM if you see this message)"));
      return;
    } */

    // Runs a loop to make sure the proper door is locked before the NPC will continue
    oDoor = GetNearestObjectByTag("BankDoor");
    nDoorGroup = GetLocalInt(oDoor, "group");

    while(GetIsObjectValid(oDoor))
    {
    if(nDoorGroup == nNPCGroup)
    {
      nLockedState = GetLocked(oDoor);
      if(nLockedState != 1)
      {
      AssignCommand(oNPC, ActionSpeakString("Please lock the door so we may continue..."));
      return;
      }
      else if(nLockedState == 1)
      break;
    }
    nCount++;
    oDoor = GetNearestObjectByTag("BankDoor",OBJECT_SELF,nCount);
    nDoorGroup = GetLocalInt(oDoor, "group");
    }
    //

    // Checks to see if the script has run once, if it did not it runs though the convo file
    if(sAction != "bk_bankteller")
    {
       DeleteLocalInt( oPC, "ds_node");
       DeleteLocalString( oPC, "ds_action");
       LaunchConvo(oNPC,oPC);
    }
    else if(nNode > 0)
    {

      if( 21 >= nNode >= 1)
      {
         // Since the script is going to be launched a second time and moved from the NPC to the PC you need to make sure the NPC is set
         // properly on the second run.
         oNPC = GetNearestObjectByTag("Banker",oPC);
         Bank(oPC,oNPC,nNode);
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
    SetLocalString(oPC,"ds_action","bk_bankteller");
    AssignCommand(oNPC, ActionStartConversation(oPC, "c_bankteller", TRUE, FALSE));
}

void Bank(object oPC, object oNPC, int nNode)
{

   int nNPCGroup       = GetLocalInt(oNPC, "group");
   int nCount = 1;
   int nCount2 = 1;
   int nGoldTaken;
   int nIsBag;
   int nBankChestSub;
   int nBankGroup;
   object oChest = GetWaypointByTag("bankerchest"+IntToString(nNPCGroup));
   object oBankChest;
   object oBankItem;
   location oChestSpawn = GetLocation(oChest);
   string sBankChestName;


    // Will retrieve your banking chest or spawn a brand new one for you
    if(nNode == 1)
    {
      AssignCommand(oNPC, ActionSpeakString("Wonderful. Let us get your storage chest."));

      // Check to make sure a storage chest isnt already out
      oBankChest = GetNearestObjectByTag("BankerChest",oNPC);
      nBankGroup = GetLocalInt(oBankChest, "group");
      while(GetIsObjectValid(oBankChest))
      {
        if(nBankGroup == nNPCGroup)
        {
          AssignCommand(oNPC, ActionSpeakString("There is already a storage unit out."));
          return;
        }
        oBankChest =  GetNearestObjectByTag("BankerChest",oNPC,nCount);
        nBankGroup = GetLocalInt(oBankChest, "group");
        nCount++;
      }

      // 5k Gold per chest summon
      if(GetGold(oPC) >= 5000)
      {
         nGoldTaken = 1;
      }
      else
      {
        AssignCommand(oNPC, ActionSpeakString("You need more gold."));
        return;
      }

      // If no storage chest is out then retrieve it for that PC
      oBankChest = RetrieveCampaignDBObject(oPC,"bankstorage",oChestSpawn);
      SetLocalInt(oBankChest,"group",nNPCGroup);

      // If there is nothing to retrieve it means the PC is a first timer so spawn a brand new chest
      if(!GetIsObjectValid(oBankChest))
      {

         // 25k Gold for a new chest
         if(GetGold(oPC) >= 25000)
         {
            nGoldTaken = 2;
         }
         else
         {
           AssignCommand(oNPC, ActionSpeakString("You need more gold."));
           return;
         }

        oBankChest = CreateObject(OBJECT_TYPE_PLACEABLE,"bankerchestplc",oChestSpawn,FALSE,"BankerChest");
        SetName(oBankChest,GetName(oPC) + "'s Bank Chest");
        SetLocalInt(oBankChest,"group",nNPCGroup);
      }

      // Take the appropriate amount of gold
      if(nGoldTaken == 1)
      {
         TakeGoldFromCreature(5000,oPC);
      }
      else if(nGoldTaken == 2)
      {
         TakeGoldFromCreature(25000,oPC);
      }

      SetLocalInt(oPC,"ds_check_1",1);
      // Sets the direction of the chest on spawn
      AssignCommand(oBankChest, SetFacing(GetLocalFloat(oChest,"direction")));
    }
    else if(nNode == 2) // Will store your banking chest once you are done
    {
      oBankChest = GetNearestObjectByTag("BankerChest",oNPC);

      // Check to make sure their is a chest that is out to store
      if(!GetIsObjectValid(oBankChest))
      {
        AssignCommand(oNPC, ActionSpeakString("You have nothing to store."));
        return;
      }

      oBankItem = GetFirstItemInInventory(oBankChest);

      //  This while loop checks to make sure no container items are inside
      while(GetIsObjectValid(oBankItem))
      {

       if(GetHasInventory(oBankItem) == TRUE)
       {
         AssignCommand(oNPC, ActionSpeakString("Please remove any containers or bags from the storage chest."));
         return;
       }

       nCount2++;
       oBankItem = GetNextItemInInventory(oBankChest);
      }

      // Makes sure not too many items are inside
      if(nCount2 >= 100)
      {
        AssignCommand(oNPC, ActionSpeakString("You have too many items in the storage chest. Please remove items till you have less than a hundred."));
        return;
      }


      //
      sBankChestName = GetName(oBankChest);
      nBankChestSub = FindSubString(sBankChestName,"'s Bank Chest");

      // Check to make sure their the chest is theirs
        if(GetSubString(sBankChestName,0,nBankChestSub) != GetName(oPC))
        {
          AssignCommand(oNPC, ActionSpeakString("This is not your chest."));
          return;
        }

      // Saving chest/PC
      // Make sure the PC isnt polymorphed
      if(GetIsPolymorphed(oPC))
      {
        AssignCommand(oNPC, ActionSpeakString("You must unpolymorph before we can continue."));
        return;
      }
      ExportSingleCharacter(oPC);
      StoreCampaignDBObject(oPC,"bankstorage",oBankChest);
      DeleteLocalInt(oPC,"ds_check_1");

      // Quick loop to clear the player chest after saving of inventory
      object oItem = GetFirstItemInInventory( oBankChest );
      while ( GetIsObjectValid( oItem ) == TRUE ){

        DestroyObject( oItem );

        oItem = GetNextItemInInventory( oBankChest );
      }
      // Delay to make sure the chest has time to be emptied
      DelayCommand(2.0,DestroyObject(oBankChest));
      AssignCommand(oNPC, ActionSpeakString("Very well. Thank you for your business."));



    }
    else if(nNode == 3) // Gives you a 5 round bioware TS
    {

      if(GetGold(oPC) >= 5000)
      {
         TakeGoldFromCreature(5000,oPC);
      }
      else
      {
        AssignCommand(oNPC, ActionSpeakString("You need more gold."));
      }


    }


}
