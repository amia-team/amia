/*
  Mythal Fuser Script - Fuses 4 of a lesser kind of mythal into a higher version
  - Maverick00053

*/

// Launches the Convo Script
void LaunchConvo( object oBench, object oPC);

// Launches the LaunchFuser Function
void LaunchFuser(object oPC, object oBench, int nNode);

#include "x2_inc_switches"
#include "inc_ds_records"
#include "x0_i0_campaign"
#include "inc_td_itemprop"

void main()
{
    object oPC          = GetLastClosedBy();
    object oBench       = OBJECT_SELF;
    object oDoor;

    // Second run through the code makes sure the PC is set
    if(!GetIsObjectValid(oPC))
    {
      oPC = OBJECT_SELF;
    }

    int nNode           = GetLocalInt( oPC, "ds_node" );
    string sAction      = GetLocalString( oPC, "ds_action");

    if(!GetIsObjectValid(GetFirstItemInInventory(oBench)))
    {
      DeleteLocalInt( oPC, "ds_node");
      DeleteLocalString( oPC, "ds_action");
      DeleteLocalString( oPC, "ds_actionnode");
      return;
    }
    // Checks to see if the script has run once, if it did not it runs though the convo file
    if(sAction != "mythalfuser")
    {
       DeleteLocalInt( oPC, "ds_node");
       DeleteLocalString( oPC, "ds_action");
       DeleteLocalString( oPC, "ds_actionnode");
       LaunchConvo(oBench,oPC);
    }
    else if(nNode > 0)
    {

      if( 99 >= nNode >= 1)
      {
         // Since the script is going to be launched a second time and moved from the Bench to the PC you need to make sure the NPC is set
         // properly on the second run.
         oBench = GetNearestObjectByTag("mythalfuser",oPC);
         LaunchFuser(oPC,oBench,nNode);
         DeleteLocalInt( oPC, "ds_node");
         DeleteLocalString( oPC, "ds_action");
         DeleteLocalString( oPC, "ds_actionnode");
         return;
      }




    }
    else if(nNode == 0) // If the ds_action variable is set, but a choice wasn't made this will refire the convo script so they can make a choice
    {
      DeleteLocalInt( oPC, "ds_node");
      DeleteLocalString( oPC, "ds_action");
      DeleteLocalString( oPC, "ds_actionnode");
      LaunchConvo(oBench,oPC);
    }


}

void LaunchConvo( object oBench, object oPC){
    SetLocalString(oPC,"ds_action","mythalfuser");
    AssignCommand(oBench, ActionStartConversation(oPC, "c_mythalfuser", TRUE, FALSE));
}

void LaunchFuser(object oPC, object oBench, int nNode)
{
   object oItemInChest = GetFirstItemInInventory(oBench);
   string sBlueprintR;
   string sBlueprintP;
   object chestItem1;
   object chestItem2;
   object chestItem3;
   object chestItem4;
   int chestItemNum = 1;

   // Figures out their selection
   switch(nNode)
   {
      case 1:  sBlueprintR = "mythal1"; sBlueprintP = "mythal2"; break; // Mythal Reagent, Minor => Lesser
      case 2:  sBlueprintR = "mythal2"; sBlueprintP = "mythal3"; break; // Mythal Reagent, Lesser  => Intermediate
      case 3:  sBlueprintR = "mythal3"; sBlueprintP = "mythal4"; break; // Mythal Reagent, Intermediate  => Greater
   }

   // Gets the items in the chest, saves them if they match the ingredients needed
   while(GetIsObjectValid(oItemInChest))
   {
     if(GetResRef(oItemInChest) == sBlueprintR)
     {
       switch(chestItemNum)
       {
         case 1: chestItem1= oItemInChest; chestItemNum++; break;
         case 2: chestItem2= oItemInChest; chestItemNum++; break;
         case 3: chestItem3= oItemInChest; chestItemNum++; break;
         case 4: chestItem4= oItemInChest; chestItemNum++; break;
       }
     }
     oItemInChest = GetNextItemInInventory(oBench);
   }

  if(chestItemNum < 5)
  {
    SendMessageToPC(oPC, "Not enough material to fuse together.");
  }
  else if(chestItemNum == 5)
  {
    // Destroys the material and makes the product
    DelayCommand(0.1,DestroyObject(chestItem1));
    DelayCommand(0.1,DestroyObject(chestItem2));
    DelayCommand(0.2,DestroyObject(chestItem3));
    DelayCommand(0.2,DestroyObject(chestItem4));
    CreateItemOnObject(sBlueprintP,oBench,1);
    SendMessageToPC(oPC, "Mythal fusion successful!");
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_MYSTICAL_EXPLOSION ), oPC );
  }
  else if(chestItemNum > 5)
  {
    SendMessageToPC(oPC, "ERROR: Item Number > 5. Report to Dev.");
  }


   DeleteLocalInt( oPC, "ds_node");
   DeleteLocalString( oPC, "ds_action");
   DeleteLocalString( oPC, "ds_actionnode");

}
