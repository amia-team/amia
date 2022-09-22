/*
  Job System Merchant Box Script for mini chests

  - Maverick00053
  - 7.28.22

*/

#include "x2_inc_switches"
#include "inc_ds_records"
#include "x0_i0_campaign"
#include "inc_td_itemprop"

// Launches the Convo Script
void LaunchConvo( object oBox, object oPC);

void MerchantBox( object oBox, object oPC, int nNode);

int SpawnBoxAmount( object oChestWidget, object oBox, object oPC, string sStoredItem, int nAmount);

void main()
{
    object oPC          = GetLastClosedBy();
    object oBox       = OBJECT_SELF;
    object oDoor;

    if(GetLocalString(oBox,"owner") != GetName(oPC))
    {
       return;
    }

    // Second run through the code makes sure the PC is set
    if(!GetIsObjectValid(oPC))
    {
      oPC = OBJECT_SELF;
    }

    int nNode           = GetLocalInt( oPC, "ds_node" );
    string sAction      = GetLocalString( oPC, "ds_action");

    // Checks to see if the script has run once, if it did not it runs though the convo file
    if(sAction != "js_merchantbox_2")
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
         oBox = GetNearestObjectByTag("minimerchantbox",oPC);
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
    SetLocalString(oPC,"ds_action","js_merchantbox_2");
    AssignCommand(oBox, ActionStartConversation(oPC,"c_js_mercminibox", TRUE, FALSE));
}

void MerchantBox( object oBox, object oPC, int nNode)
{

    object oChestWidget = GetLocalObject(oBox,"oChest");
    object oBoxItem;
    int nAmount;
    int nChestSet;
    int nAmountRemoved;
    string sStoredItem;


    if(!GetIsObjectValid(oChestWidget))
    {
      SendMessageToPC(oPC,"CHEST IS BROKEN! DO NOT USE!");
      return;
    }

    nAmount = GetLocalInt(oChestWidget,"storageboxcount");
    sStoredItem = GetLocalString(oChestWidget,"storagebox");

    if(nNode == 1)   // Retrieve 50
    {
      nAmountRemoved = SpawnBoxAmount( oChestWidget, oBox, oPC, sStoredItem, 50);
      SendMessageToPC(oPC, "You have removed "+IntToString(nAmountRemoved)+" resources from your chest!");
    }
    else if(nNode == 2)  // Retrieve 500
    {
      nAmountRemoved = SpawnBoxAmount( oChestWidget, oBox, oPC, sStoredItem, 500);
      SendMessageToPC(oPC, "You have removed "+IntToString(nAmountRemoved)+" resources from your chest!");
    }
    else if(nNode == 3)// Retrieve 1000
    {
      nAmountRemoved = SpawnBoxAmount( oChestWidget, oBox, oPC, sStoredItem, 1000);
      SendMessageToPC(oPC, "You have removed "+IntToString(nAmountRemoved)+" resources from your chest!");
    }
    else if(nNode == 4)// Retrieve all
    {
      nAmountRemoved = SpawnBoxAmount( oChestWidget, oBox, oPC, sStoredItem, nAmount);
      SendMessageToPC(oPC, "You have removed "+IntToString(nAmountRemoved)+" resources from your chest!");
    }
    else if(nNode == 5)// Store items
    {

      if(sStoredItem == "") // Means it isn't set to anything
      {
        oBoxItem = GetFirstItemInInventory(oBox);

        // We search for items in the box - Taking the first item that qualifies
        while(GetIsObjectValid(oBoxItem))
        {
          int nStackSize = GetItemStackSize(oBoxItem);
          if((GetSubString(GetResRef(oBoxItem),0,3) == "js_") && (nChestSet == 0))
          {
            SetLocalString(oChestWidget,"storagebox",GetResRef(oBoxItem));
            SetLocalString(oChestWidget,"storageboxname",GetName(oBoxItem));
            SetLocalInt(oChestWidget,"storageboxcount",nStackSize);
            SetName(oChestWidget,"<c~Îë>"+GetName(oBoxItem)+" Miniature Storage Box"+"</c>");
            SetName(oBox,"<c~Îë>"+GetName(oBoxItem)+" Miniature Storage Box"+"</c>");
            nAmount += nStackSize;
            sStoredItem = GetResRef(oBoxItem);
            nChestSet = 1;
            DestroyObject(oBoxItem);
          }
          else if(GetResRef(oBoxItem) == sStoredItem)
          {
            SetLocalInt(oChestWidget,"storageboxcount",nAmount+nStackSize);
            nAmount += nStackSize;
            DestroyObject(oBoxItem);
          }
          oBoxItem = GetNextItemInInventory(oBox);
       }
      }
      else  // Chest is already set so lets store like items
      {
        oBoxItem = GetFirstItemInInventory(oBox);

        // We search for items in the box - Taking the first idea that qualifies
        while(GetIsObjectValid(oBoxItem))
        {
          int nStackSize = GetItemStackSize(oBoxItem);
          if(GetResRef(oBoxItem) == sStoredItem)
          {
            SetLocalInt(oChestWidget,"storageboxcount",nAmount+nStackSize);
            nAmount += nStackSize;
            DestroyObject(oBoxItem);
          }
          oBoxItem = GetNextItemInInventory(oBox);
       }

      }

    }
    else if(nNode == 6)// Remove chest if empty
    {
       oBoxItem = GetFirstItemInInventory(oBox);
       if(!GetIsObjectValid(oBoxItem))
       {
         DestroyObject(oBox);
         DeleteLocalInt(oPC,"minimercchestout");
       }
       else
       {
         FloatingTextStringOnCreature("Merchant box needs to be empty first",oPC);
       }
    }
    else if(nNode == 7)// Delete Storage Box Completely
    {
       oBoxItem = GetFirstItemInInventory(oBox);

       if(!GetIsObjectValid(oBoxItem))
       {
         SendMessageToPC(oPC, "You have removed "+IntToString(nAmount)+" resources and deleted your chest!");
         DeleteLocalInt(oChestWidget,"storageboxcount");
         DeleteLocalString(oChestWidget,"storagebox");
         SetName(oChestWidget,"<c~Îë>" + "Empty Miniature Storage Chest" + "</c>");
         DeleteLocalInt(oPC,"minimercchestout");
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

int SpawnBoxAmount( object oChestWidget, object oBox, object oPC, string sStoredItem, int nSpawnAmount)
{
    int nNumResources = GetLocalInt(oChestWidget,"storageboxcount");
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
    SetLocalInt(oChestWidget,"storageboxcount",nNumResources-nSpawnAmount);
    return nSpawned;
}
