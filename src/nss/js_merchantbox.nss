/*
  Job System Merchant Box Script

  - Maverick00053

*/

#include "x2_inc_switches"
#include "inc_ds_records"
#include "x0_i0_campaign"
#include "inc_td_itemprop"

// Launches the Convo Script
void LaunchConvo( object oBox, object oPC);

void MerchantBox( object oBox, object oPC, int nNode);

int SpawnBoxAmount( object oJobJournal, object oBox, object oPC,int nChestNumber, string sStoredItem, int nAmount);

void main()
{
    object oPC          = GetLastClosedBy();
    object oBox       = OBJECT_SELF;
    object oDoor;

    // Second run through the code makes sure the PC is set
    if(!GetIsObjectValid(oPC))
    {
      oPC = OBJECT_SELF;
    }

    int nNode           = GetLocalInt( oPC, "ds_node" );
    string sAction      = GetLocalString( oPC, "ds_action");

    // Checks to see if the script has run once, if it did not it runs though the convo file
    if(sAction != "js_merchantbox")
    {
       DeleteLocalInt( oPC, "ds_node");
       DeleteLocalString( oPC, "ds_action");
       LaunchConvo(oBox,oPC);
    }
    else if(nNode > 0)
    {

      if( 99 >= nNode >= 1)
      {
         // Since the script is going to be launched a second time and moved from the Bench to the PC you need to make sure the NPC is set
         // properly on the second run.
         oBox = GetNearestObjectByTag("merchantbox",oPC);
         MerchantBox(oBox,oPC,nNode);
         DeleteLocalInt( oPC, "ds_node");
         DeleteLocalString( oPC, "ds_action");
         return;
      }




    }
    else if(nNode == 0) // If the ds_action variable is set, but a choice wasn't made this will refire the convo script so they can make a choice
    {
      DeleteLocalInt( oPC, "ds_node");
      DeleteLocalString( oPC, "ds_action");
      LaunchConvo(oBox,oPC);
    }


}

void LaunchConvo( object oBox, object oPC){
    SetLocalString(oPC,"ds_action","js_merchantbox");
    AssignCommand(oBox, ActionStartConversation(oPC,"c_js_merchantbox", TRUE, FALSE));
}

void MerchantBox( object oBox, object oPC, int nNode)
{

   object oInventoryItem = GetFirstItemInInventory(oPC);
   object oJobJournal;
   int nAmount;
   int nChestSet;
   int nChestNumber;
   int nAmountRemoved;
   string sStoredItem;

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

    nChestNumber = GetLocalInt(oBox,"storageboxnumber");
    nAmount = GetLocalInt(oJobJournal,"storagebox"+IntToString(nChestNumber)+"amount");
    sStoredItem = GetLocalString(oJobJournal,"storagebox"+IntToString(nChestNumber));

    if(nNode == 1)   // Retrieve 50
    {
      nAmountRemoved = SpawnBoxAmount( oJobJournal, oBox, oPC, nChestNumber, sStoredItem, 25);
      SendMessageToPC(oPC, "You have removed "+IntToString(nAmountRemoved)+" resources from your chest!");
    }
    else if(nNode == 2)  // Retrieve 500
    {
      nAmountRemoved = SpawnBoxAmount( oJobJournal, oBox, oPC, nChestNumber, sStoredItem, 100);
      SendMessageToPC(oPC, "You have removed "+IntToString(nAmountRemoved)+" resources from your chest!");
    }
    else if(nNode == 3)// Retrieve 1000
    {
      nAmountRemoved = SpawnBoxAmount( oJobJournal, oBox, oPC, nChestNumber, sStoredItem, 250);
      SendMessageToPC(oPC, "You have removed "+IntToString(nAmountRemoved)+" resources from your chest!");
    }
    else if(nNode == 4)// Retrieve all
    {
      nAmountRemoved = SpawnBoxAmount( oJobJournal, oBox, oPC, nChestNumber, sStoredItem, nAmount);
      SendMessageToPC(oPC, "You have removed "+IntToString(nAmountRemoved)+" resources from your chest!");
    }
    else if(nNode == 5)// Store items
    {

      if(sStoredItem == "") // Means it isn't set to anything
      {
        oInventoryItem = GetFirstItemInInventory(oBox);

        // We search for items in the box - Taking the first idea that qualifies
        while(GetIsObjectValid(oInventoryItem))
        {
          int nStackSize = GetItemStackSize(oInventoryItem);
          if((GetSubString(GetResRef(oInventoryItem),0,3) == "js_") && (nChestSet == 0))
          {
            SetLocalString(oJobJournal,"storagebox"+IntToString(nChestNumber),GetResRef(oInventoryItem));
            SetLocalInt(oJobJournal,"storagebox"+IntToString(nChestNumber)+"amount",nStackSize);
            SetLocalString(oJobJournal,"storagename"+IntToString(nChestNumber),GetName(oInventoryItem));
            SetName(oBox,GetName(oInventoryItem)+" Storage Chest");
            nAmount += nStackSize;
            sStoredItem = GetResRef(oInventoryItem);
            nChestSet = 1;
            DestroyObject(oInventoryItem);
          }
          else if(GetResRef(oInventoryItem) == sStoredItem)
          {
            SetLocalInt(oJobJournal,"storagebox"+IntToString(nChestNumber)+"amount",nAmount+nStackSize);
            nAmount += nStackSize;
            DestroyObject(oInventoryItem);
          }
          oInventoryItem = GetNextItemInInventory(oBox);
       }
      }
      else  // Chest is already set so lets store like items
      {
        oInventoryItem = GetFirstItemInInventory(oBox);

        // We search for items in the box - Taking the first idea that qualifies
        while(GetIsObjectValid(oInventoryItem))
        {
          int nStackSize = GetItemStackSize(oInventoryItem);
          if(GetResRef(oInventoryItem) == sStoredItem)
          {
            SetLocalInt(oJobJournal,"storagebox"+IntToString(nChestNumber)+"amount",nAmount+nStackSize);
            nAmount += nStackSize;
            DestroyObject(oInventoryItem);
          }
          oInventoryItem = GetNextItemInInventory(oBox);
       }

      }

    }
    else if(nNode == 6)// Remove chest if empty
    {
       oInventoryItem = GetFirstItemInInventory(oBox);
       if(!GetIsObjectValid(oInventoryItem))
       {
         DestroyObject(oBox);
         DeleteLocalInt(oPC,"merchantchestisout");
       }
       else
       {
         FloatingTextStringOnCreature("Merchant box needs to be empty first",oPC);
       }
    }
    else if(nNode == 7)// Delete Storage Box Completely
    {
       oInventoryItem = GetFirstItemInInventory(oBox);

       if(!GetIsObjectValid(oInventoryItem))
       {
         SpawnBoxAmount( oJobJournal, oBox, oPC, nChestNumber, sStoredItem, nAmount);
         SendMessageToPC(oPC, "You have removed "+IntToString(nAmount)+" resources and deleted your chest!");
         DeleteLocalInt(oJobJournal,"storagebox"+IntToString(nChestNumber)+"amount");
         DeleteLocalString(oJobJournal,"storagebox"+IntToString(nChestNumber));
         DeleteLocalString(oJobJournal,"storagename"+IntToString(nChestNumber));
         DeleteLocalInt(oPC,"merchantchestisout");
         DestroyObject(oBox);
       }
       else
       {
         FloatingTextStringOnCreature("Merchant box needs to be empty first",oPC);
       }

    }

    DeleteLocalInt( oPC, "ds_node");
    DeleteLocalString( oPC, "ds_action");
}

int SpawnBoxAmount( object oJobJournal, object oBox, object oPC, int nChestNumber, string sStoredItem, int nSpawnAmount)
{
    int nNumResources = GetLocalInt(oJobJournal,"storagebox"+IntToString(nChestNumber)+"amount");
    if (nSpawnAmount > nNumResources)
    {
        nSpawnAmount = nNumResources;
    }
    int i;
    int nSpawned = 0;
    for(i=0;i<nSpawnAmount;i++)
    {
        CreateItemOnObject(sStoredItem,oBox);
        nSpawned++;
    }
    SetLocalInt(oJobJournal,"storagebox"+IntToString(nChestNumber)+"amount",nNumResources-nSpawnAmount);
    return nSpawned;
}
