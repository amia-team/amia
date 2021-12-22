/*
  Made 8/15/19 by Maverick00053

  Invasion Merchant Script

  Trades the Trophy Tokens (trophytoken) off the player for items
*/

#include "x2_inc_switches"
#include "inc_ds_porting"
#include "inc_ds_actions"
#include "ds_inc_randstore"

void Trade( object oPC, int nNode, object oNPC);
void LaunchConvo( object oPC, object oNPC);

void LaunchConvo( object oPC, object oNPC)
{
    SetLocalString(oPC,"ds_action","invasionmerchant");
    AssignCommand(oNPC, ActionStartConversation(oPC, "c_invasionmerch", TRUE, FALSE));
}

// Checks to see if anything from the convo has been picked yet, if not it will start the convo
// Let the player pick
void main()
{

    object oPC          = GetLastSpeaker();
    object oNPC         = OBJECT_SELF;
    int nNode           = GetLocalInt( oPC, "ds_node" );
    string sAction      = GetLocalString( oPC, "ds_action");



    // Checks to see if the script has run once, if it did not it runs though the convo file
    if(sAction != "invasionmerchant")
    {
       SetLocalInt( oPC, "ds_node", 0 );
       SetLocalString( oPC, "ds_action", "" );
       ActionMoveToObject( GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC ), TRUE, 10.0 );
       LaunchConvo(oPC,oNPC);
    }
    else if(nNode > 0)
    {



       if( 5 >= nNode >= 1)
       {
          Trade( oPC, nNode, oNPC);
          return;
       }

     }
     else if(nNode == 0) // If the ds_action variable is set, but a choice wasn't made this will refire the convo script so they can make a choice
     {


       SetLocalInt( oPC, "ds_node", 0 );
       SetLocalString( oPC, "ds_action", "" );
    }


}


//Trade for tokens
void Trade( object oPC, int nNode, object oNPC){

    int gold = GetGold(oPC);
    int nTokens = 0;
    int nTokensTaken = 0;
    object oItem;
    object oChest;
    string sItemResRef;
    object oArea = GetArea(oPC);


        // Injects the loot into the chest
        oChest = GetNearestObjectByTag("invasionchest");



        // Checking their bag to make sure they have enough tokens for the choice
         oItem = GetFirstItemInInventory(oPC);

         while(GetIsObjectValid(oItem))
         {
          sItemResRef = GetResRef(oItem);
         if(sItemResRef == "trophytoken")
         {
           nTokens = nTokens + GetNumStackedItems(oItem);
         }

          oItem = GetNextItemInInventory(oPC);

         }


    if(nNode == 1)   // Random Rare
    {
       if(nTokens >= 20)
       {
         oItem = GetFirstItemInInventory(oPC);

         while(nTokensTaken < 20)
         {
          sItemResRef = GetResRef(oItem);
         if(sItemResRef == "trophytoken")
         {
           nTokensTaken = nTokensTaken + GetNumStackedItems(oItem);
           DestroyObject(oItem,0.0);
         }

          oItem = GetNextItemInInventory(oPC);

         }

         InjectIntoChest(oChest, 30, 30, 50);
         SpeakString("Wonderful! Your purchase is waiting in the chest for pick up.");


       }
       else
       {
         FloatingTextStringOnCreature( "-You do not possess sufficient tokens-", oPC, FALSE );
         SetLocalInt( oPC, "ds_node", 0 );
         SetLocalString( oPC, "ds_action", "" );
         return;
       }
    }
    else if(nNode == 2)       // Small Magical Ore
    {
       if(nTokens >= 100)
       {

          oItem = GetFirstItemInInventory(oPC);

         while(nTokensTaken < 100)
         {
          sItemResRef = GetResRef(oItem);
         if(sItemResRef == "trophytoken")
         {
           nTokensTaken = nTokensTaken + GetNumStackedItems(oItem);
           DestroyObject(oItem,0.0);
         }

          oItem = GetNextItemInInventory(oPC);

         }

         CreateItemOnObject("nep_smallmagical", oChest,1);
         SpeakString("Wonderful! Your purchase is waiting in the chest for pick up.");

       }
       else
       {
         FloatingTextStringOnCreature( "-You do not possess sufficient tokens-", oPC, FALSE );
         SetLocalInt( oPC, "ds_node", 0 );
         SetLocalString( oPC, "ds_action", "" );
         return;
       }
    }
    else if(nNode == 3)        // Medium Magical Ore
    {
       if(nTokens >= 100)
       {

         oItem = GetFirstItemInInventory(oPC);

         while(nTokensTaken < 100)
         {
          sItemResRef = GetResRef(oItem);
         if(sItemResRef == "trophytoken")
         {
           nTokensTaken = nTokensTaken + GetNumStackedItems(oItem);
           DestroyObject(oItem,0.0);
         }

          oItem = GetNextItemInInventory(oPC);

         }

         CreateItemOnObject("nep_mediummagic", oChest,1);
         SpeakString("Wonderful! Your purchase is waiting in the chest for pick up.");

       }
       else
       {
         FloatingTextStringOnCreature( "-You do not possess sufficient tokens-", oPC, FALSE );
         SetLocalInt( oPC, "ds_node", 0 );
         SetLocalString( oPC, "ds_action", "" );
         return;
       }
    }
    else if(nNode == 4)             // Large Magical Ore
    {
       if(nTokens >= 100)
       {

         oItem = GetFirstItemInInventory(oPC);

         while(nTokensTaken < 100)
         {
          sItemResRef = GetResRef(oItem);
         if(sItemResRef == "trophytoken")
         {
           nTokensTaken = nTokensTaken + GetNumStackedItems(oItem);
           DestroyObject(oItem,0.0);
         }

          oItem = GetNextItemInInventory(oPC);

         }

         CreateItemOnObject("nep_largemagical", oChest,1);
         SpeakString("Wonderful! Your purchase is waiting in the chest for pick up.");

       }
       else
       {
         FloatingTextStringOnCreature( "-You do not possess sufficient tokens-", oPC, FALSE );
         SetLocalInt( oPC, "ds_node", 0 );
         SetLocalString( oPC, "ds_action", "" );
         return;
       }
    }
    else if(nNode == 5)         // Magical Hemp and Wood
    {
       if(nTokens >= 100)
       {

         oItem = GetFirstItemInInventory(oPC);

         while(nTokensTaken < 100)
         {
          sItemResRef = GetResRef(oItem);
         if(sItemResRef == "trophytoken")
         {
           nTokensTaken = nTokensTaken + GetNumStackedItems(oItem);
           DestroyObject(oItem,0.0);
         }

          oItem = GetNextItemInInventory(oPC);

         }

         CreateItemOnObject("nep_magicalhemp", oChest,1);
         SpeakString("*Your purchase is waiting in the chest for pick up*");

       }
       else
       {
         FloatingTextStringOnCreature( "-You do not possess sufficient tokens-", oPC, FALSE );
         SetLocalInt( oPC, "ds_node", 0 );
         SetLocalString( oPC, "ds_action", "" );
         return;
       }
    }
     SetLocalInt( oPC, "ds_node", 0 );
     SetLocalString( oPC, "ds_action", "" );
     SetLocalInt( oNPC, "ds_node", 0 );
     SetLocalString( oNPC, "ds_action", "" );

}
