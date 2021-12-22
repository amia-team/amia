/*
  Made 4/6/19 by Maverick00053

  Sling bullet crafting script for Warslinger class

  Edit: August 15th 2019 - Did a bug fix.
*/

#include "x2_inc_switches"
#include "inc_ds_porting"
#include "inc_ds_actions"

void CreateBullets( object oPC, int nNode);
void LaunchConvo( object oPC);

void LaunchConvo( object oPC){
    SetLocalString(oPC,"ds_action","ws_craftbullet");
    AssignCommand(oPC, ActionStartConversation(oPC, "c_craftbullet", TRUE, FALSE));
}

// Checks to see if anything from the convo has been picked yet, if not it will start the convo
// Let the player pick
void main()
{

    object oPC          = OBJECT_SELF;
    int nNode           = GetLocalInt( oPC, "ds_node" );
    string sAction      = GetLocalString( oPC, "ds_action");
    int wslevel = GetLevelByClass(43 , oPC);





    // Checks to see if the script has run once, if it did not it runs though the convo file
    if(sAction != "ws_craftbullet")
    {

        // Checks how many Warslinger class levels they have, unlocking more options

        if(wslevel == 5)
        {
         SetLocalInt(oPC,"ds_check_3",1);
        }

        if(wslevel >= 3)
        {
         SetLocalInt(oPC,"ds_check_2",1);
        }

        LaunchConvo(oPC);
    }
    else if(nNode > 0)
    {


      //Bug checking
      SendMessageToPC(oPC,"FEAT SCRIPT LAUNCHED!");


      if( 10 >= nNode >= 1)
      {

        // Extra check to catch a bug
        if(wslevel == 5)
        {
         SetLocalInt(oPC,"ds_check_3",1);
        }

        if(wslevel >= 3)
        {
         SetLocalInt(oPC,"ds_check_2",1);
        }


         CreateBullets( oPC, nNode);
         return;
      }


    }
    else if(nNode == 0) // If the ds_action variable is set, but a choice wasn't made this will refire the convo script so they can make a choice
    {
        // Checks how many Warslinger class levels they have, unlocking more options

        if(wslevel == 5)
        {
         SetLocalInt(oPC,"ds_check_3",1);
        }

        if(wslevel >= 3)
        {
         SetLocalInt(oPC,"ds_check_2",1);
        }

        LaunchConvo(oPC);
    }


}


//Generates the appropriate bullets based on choice, and takes gold
void CreateBullets( object oPC, int nNode){

    int gold = GetGold(oPC);
    object bullet;

    //Bug checking
    SendMessageToPC(oPC,"CREATEBULLETS SCRIPT LAUNCHED!");
    if(nNode == 1)
    {
       if(gold > 1000)
       { //2d6 Bludg
         TakeGoldFromCreature(1000, oPC, TRUE);
         bullet = CreateItemOnObject("wsbullet1", oPC, 99);
         SetName(bullet, "Precision Bludgeoning Round");

       }
       else
       {
         FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
         SetLocalInt( oPC, "ds_node", 0 );
         SetLocalString( oPC, "ds_action", "" );
         return;
       }
    }
    else if(nNode == 2)
    {
       if(gold > 1000)
       { //2d6 Slashing
         TakeGoldFromCreature(1000, oPC, TRUE);
         bullet = CreateItemOnObject("wsbullet3", oPC, 99);
         SetName(bullet, "Precision Slashing Round");
       }
       else
       {
         FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
         SetLocalInt( oPC, "ds_node", 0 );
         SetLocalString( oPC, "ds_action", "" );
         return;
       }
    }
    else if(nNode == 3)
    {
       if(gold > 1000)
       {//2d6 Piercing
         TakeGoldFromCreature(1000, oPC, TRUE);
         bullet = CreateItemOnObject("wsbullet2", oPC, 99);
         SetName(bullet, "Precision Piercing Round");
       }
       else
       {
         FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
         SetLocalInt( oPC, "ds_node", 0 );
         SetLocalString( oPC, "ds_action", "" );
         return;
       }
    }
    else if(nNode == 4)
    {
       if(gold > 2000)
       { //2d6 Acid
         TakeGoldFromCreature(2000, oPC, TRUE);
         bullet = CreateItemOnObject("wsbullet4", oPC, 99);
         SetName(bullet, "Precision Acid Round");
       }
       else
       {
         FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
         SetLocalInt( oPC, "ds_node", 0 );
         SetLocalString( oPC, "ds_action", "" );
         return;
       }
    }
    else if(nNode == 5)
    {
       if(gold > 2000)
       { //2d6 Cold
         TakeGoldFromCreature(2000, oPC, TRUE);
         bullet = CreateItemOnObject("wsbullet5", oPC, 99);
         SetName(bullet, "Precision Cold Round");
       }
       else
       {
         FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
         SetLocalInt( oPC, "ds_node", 0 );
         SetLocalString( oPC, "ds_action", "" );
         return;
       }
    }
    else if(nNode == 6)
    {
       if(gold > 2000)
       { //2d6 Electrical
         TakeGoldFromCreature(2000, oPC, TRUE);
         bullet = CreateItemOnObject("wsbullet6", oPC, 99);
         SetName(bullet, "Precision Electrical Round");
       }
       else
       {
         FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
         SetLocalInt( oPC, "ds_node", 0 );
         SetLocalString( oPC, "ds_action", "" );
         return;
       }
    }
    else if(nNode == 7)
    {
       if(gold > 2000)
       { //2d6 Fire
         TakeGoldFromCreature(2000, oPC, TRUE);
         bullet = CreateItemOnObject("wsbullet7", oPC, 99);
         SetName(bullet, "Precision Fire Round");
       }
       else
       {
         FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
         SetLocalInt( oPC, "ds_node", 0 );
         SetLocalString( oPC, "ds_action", "" );
         return;
       }
    }
    else if(nNode == 8)
    {
       if(gold > 3000)
       { //1d6 magical + 3 Vamp Regen
         TakeGoldFromCreature(3000, oPC, TRUE);
         bullet = CreateItemOnObject("wsbullet8", oPC, 99);
         SetName(bullet, "Precision Vampiric Round");
       }
       else
       {
         FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
         SetLocalInt( oPC, "ds_node", 0 );
         SetLocalString( oPC, "ds_action", "" );
         return;
       }
    }
    else if(nNode == 9)
    {
       if(gold > 3000)
       { //On Hit silence + on hit Dispell
         TakeGoldFromCreature(3000, oPC, TRUE);
         bullet = CreateItemOnObject("wsbullet9", oPC, 99);
         SetName(bullet, "Precision Anti-Mage Round");
       }
       else
       {
         FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
         SetLocalInt( oPC, "ds_node", 0 );
         SetLocalString( oPC, "ds_action", "" );
         return;
       }
    }
    else if(nNode == 10)
    {
       if(gold > 3000)
       { //2d6 Magic
         TakeGoldFromCreature(3000, oPC, TRUE);
         bullet = CreateItemOnObject("wsbullet10", oPC, 99);
         SetName(bullet, "Precision Magic Round");
       }
       else
       {
         FloatingTextStringOnCreature( "-You do not possess sufficient gold-", oPC, FALSE );
         SetLocalInt( oPC, "ds_node", 0 );
         SetLocalString( oPC, "ds_action", "" );
         return;
       }
    }

     SetLocalInt( oPC, "ds_node", 0 );
     SetLocalString( oPC, "ds_action", "" );
     SetLocalInt(oPC,"ds_check_1",0);
     SetLocalInt(oPC,"ds_check_2",0);
     SetLocalInt(oPC,"ds_check_3",0);

}
