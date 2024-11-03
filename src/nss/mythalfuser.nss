/*
  Mythal Fuser Script - Fuses 4 of a lesser kind of mythal into a higher version
  - Maverick00053
  Edit: Mav 11/24/2023 - I revamped ALL the code to just be better. I also added in the ratios for higher version mythal fusing.
*/

// Launches the Convo Script
void LaunchConvo( object oBench, object oPC);

// Launches the LaunchFuser Function
void LaunchFuser(object oPC, object oBench, int nNode);

// Destroys the mythals used in crafting
void DestroyMythals(object oFuser, int nRatio);

#include "x2_inc_switches"
#include "inc_ds_records"
#include "x0_i0_campaign"
#include "inc_td_itemprop"

// Global variables for how many mythals of each to get the higher verison. Adjust as needed.
int nMinorToLesser = 4;
int nLesserToInterm = 4;
int nIntermToGreater = 4;
int nGreaterToFlawless = 12;
int nFlawlessToPerfect = 6;
int nPerfectToDivine = 6;
int nSplitMythal = 1;

// Global resref strings for the mythal types
string sMinor = "mythal1";
string sLesser = "mythal2";
string sInterm = "mythal3";
string sGreater = "mythal4";
string sFlawless = "mythal5";
string sPerfect = "mythal6";
string sDivine = "mythal7";

void main()
{
    object oPC          = GetLastClosedBy();
    object oFuser       = OBJECT_SELF;
    object oDoor;

    // Second run through the code makes sure the PC is set
    if(!GetIsObjectValid(oPC))
    {
      oPC = OBJECT_SELF;
    }

    int nNode           = GetLocalInt( oPC, "ds_node" );
    string sAction      = GetLocalString( oPC, "ds_action");

    if(!GetIsObjectValid(GetFirstItemInInventory(oFuser)))
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
       LaunchConvo(oFuser,oPC);
    }
    else if(nNode > 0)
    {

      if( 99 >= nNode >= 1)
      {
         // Since the script is going to be launched a second time and moved from the Bench to the PC you need to make sure the NPC is set
         // properly on the second run.
         oFuser = GetNearestObjectByTag("mythalfuser",oPC);
         LaunchFuser(oPC,oFuser,nNode);
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
      LaunchConvo(oFuser,oPC);
    }


}

void LaunchConvo( object oFuser, object oPC){
    SetLocalString(oPC,"ds_action","mythalfuser");
    AssignCommand(oFuser, ActionStartConversation(oPC, "c_mythalfuser", TRUE, FALSE));
}

void LaunchFuser(object oPC, object oFuser, int nNode)
{
   object oItem = GetFirstItemInInventory(oFuser);
   string sResRefRecipe;
   string sResRefProduct;
   string sResRef;
   int nRatio;
   int nItemCount;
   int nNewCount;
   int m;

   // Figures out their selection
   switch(nNode)
   {
      case 1:  sResRefRecipe = sMinor; sResRefProduct = sLesser; nRatio = nMinorToLesser; nNewCount = 1; break; // Mythal Reagent, Minor => Lesser
      case 2:  sResRefRecipe = sLesser; sResRefProduct = sInterm; nRatio = nLesserToInterm; nNewCount = 1; break; // Mythal Reagent, Lesser  => Intermediate
      case 3:  sResRefRecipe = sInterm; sResRefProduct = sGreater; nRatio = nIntermToGreater; nNewCount = 1; break; // Mythal Reagent, Intermediate  => Greater
      case 4:  sResRefRecipe = sGreater; sResRefProduct = sFlawless; nRatio = nGreaterToFlawless; nNewCount = 1; break; // Mythal Reagent, Greater  => Flawess
      case 5:  sResRefRecipe = sFlawless; sResRefProduct = sPerfect; nRatio = nFlawlessToPerfect; nNewCount = 1; break; // Mythal Reagent, Flawess  => Perfect
      case 6:  sResRefRecipe = sPerfect; sResRefProduct = sDivine; nRatio = nPerfectToDivine; nNewCount = 1; break; // Mythal Reagent, Perfect  => Divine
      case 7:  sResRefRecipe = sDivine; sResRefProduct = sPerfect; nRatio = nSplitMythal; nNewCount = nPerfectToDivine; break; // Mythal Reagent, Divine => Perfect
      case 8:  sResRefRecipe = sPerfect; sResRefProduct = sFlawless; nRatio = nSplitMythal; nNewCount = nFlawlessToPerfect; break; // Mythal Reagent, Perfect => Flawless
      case 9:  sResRefRecipe = sFlawless; sResRefProduct = sGreater; nRatio = nSplitMythal; nNewCount = nGreaterToFlawless; break; // Mythal Reagent, Flawless => Greater
      case 10:  sResRefRecipe = sGreater; sResRefProduct = sInterm; nRatio = nSplitMythal; nNewCount = nIntermToGreater; break; // Mythal Reagent, Greater => Intermediate
      case 11:  sResRefRecipe = sInterm; sResRefProduct = sLesser; nRatio = nSplitMythal; nNewCount = nLesserToInterm; break; // Mythal Reagent, Intermediate => Lesser
      case 12:  sResRefRecipe = sLesser; sResRefProduct = sMinor; nRatio = nSplitMythal; nNewCount = nMinorToLesser; break; // Mythal Reagent, Lesser => Minor
   }

   while ( GetIsObjectValid(oItem) )
   {
     sResRef = GetResRef(oItem);

     if(sResRef==sResRefRecipe)
     {
       nItemCount = nItemCount + 1;
       SetLocalObject(oFuser,"mythalused"+IntToString(nItemCount),oItem);
     }
     oItem = GetNextItemInInventory(oFuser);
   }

   if(nItemCount>=nRatio)
   {
     DestroyMythals(oFuser,nRatio);
     SendMessageToPC(oPC, "Mythal modification successful!");
     m = nNewCount;
     while(m>0){
        CreateItemOnObject(sResRefProduct,oFuser);
        m = m - 1;
     }
     ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_MYSTICAL_EXPLOSION ), oPC );
   }
   else
   {
     SendMessageToPC(oPC, "Not enough material to fuse together");
   }

   DeleteLocalInt( oPC, "ds_node");
   DeleteLocalString( oPC, "ds_action");
   DeleteLocalString( oPC, "ds_actionnode");
}


void DestroyMythals(object oFuser, int nRatio)
{
   int i;
   for ( i=1; i<=nRatio; ++i )
   {
     DestroyObject(GetLocalObject(oFuser,"mythalused"+IntToString(i)));
   }
}
