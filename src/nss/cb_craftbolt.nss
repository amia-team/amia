/*
  Made 101/19 by Maverick00053

  Bolt bullet crafting script for Crossbow PRC

*/

#include "x2_inc_switches"
#include "inc_ds_porting"
#include "inc_ds_actions"

void CreateBolt( object oPC, int nNode);
void LaunchConvo( object oPC);

void LaunchConvo( object oPC){
    SetLocalString(oPC,"ds_action","cb_craftbolt");
    AssignCommand(oPC, ActionStartConversation(oPC, "c_craftbolt", TRUE, FALSE));
}

// Checks to see if anything from the convo has been picked yet, if not it will start the convo
// Let the player pick
void main()
{

    object oPC          = OBJECT_SELF;
    int nNode           = GetLocalInt( oPC, "ds_node" );
    string sAction      = GetLocalString( oPC, "ds_action");
    int nClassLevel = GetLevelByClass(51 , oPC);





    // Checks to see if the script has run once, if it did not it runs though the convo file
    if(sAction != "cb_craftbolt")
    {

        // Checks how many class levels they have, unlocking more options

        if(nClassLevel >= 18)
        {
         SetLocalInt(oPC,"ds_check_7",1);
        }

        if(nClassLevel >= 15)
        {
         SetLocalInt(oPC,"ds_check_6",1);
        }

        if(nClassLevel >= 12)
        {
         SetLocalInt(oPC,"ds_check_5",1);
        }

        if(nClassLevel >= 9)
        {
         SetLocalInt(oPC,"ds_check_4",1);
        }

        if(nClassLevel >= 6)
        {
         SetLocalInt(oPC,"ds_check_3",1);
        }

        if(nClassLevel >= 3)
        {
         SetLocalInt(oPC,"ds_check_2",1);
        }

       SetLocalInt( oPC, "ds_node", 0 );
       SetLocalString( oPC, "ds_action", "" );
       LaunchConvo(oPC);
    }
    else if(nNode > 0)
    {


      //Bug checking
      SendMessageToPC(oPC,"FEAT SCRIPT LAUNCHED!");


      if( 7 >= nNode >= 1)
      {

        // Extra check to catch a bug

        if(nClassLevel >= 18)
        {
         SetLocalInt(oPC,"ds_check_7",1);
        }

        if(nClassLevel >= 15)
        {
         SetLocalInt(oPC,"ds_check_6",1);
        }

        if(nClassLevel >= 12)
        {
         SetLocalInt(oPC,"ds_check_5",1);
        }

        if(nClassLevel >= 9)
        {
         SetLocalInt(oPC,"ds_check_4",1);
        }

        if(nClassLevel >= 6)
        {
         SetLocalInt(oPC,"ds_check_3",1);
        }

        if(nClassLevel >= 3)
        {
         SetLocalInt(oPC,"ds_check_2",1);
        }

        CreateBolt( oPC, nNode);
        return;
      }


    }
    else if(nNode == 0) // If the ds_action variable is set, but a choice wasn't made this will refire the convo script so they can make a choice
    {

        // Checks how many class levels they have, unlocking more options

        if(nClassLevel >= 18)
        {
         SetLocalInt(oPC,"ds_check_7",1);
        }

        if(nClassLevel >= 15)
        {
         SetLocalInt(oPC,"ds_check_6",1);
        }

        if(nClassLevel >= 12)
        {
         SetLocalInt(oPC,"ds_check_5",1);
        }

        if(nClassLevel >= 9)
        {
         SetLocalInt(oPC,"ds_check_4",1);
        }

        if(nClassLevel >= 6)
        {
         SetLocalInt(oPC,"ds_check_3",1);
        }

        if(nClassLevel >= 3)
        {
         SetLocalInt(oPC,"ds_check_2",1);
        }

       SetLocalInt( oPC, "ds_node", 0 );
       SetLocalString( oPC, "ds_action", "" );
       LaunchConvo(oPC);
    }


}


//Generates the appropriate bolt based on choice, and takes gold
void CreateBolt( object oPC, int nNode){

    int gold = GetGold(oPC);
    object bolt;

    //Bug checking
    SendMessageToPC(oPC,"CREATEBOLT SCRIPT LAUNCHED!");
    if(nNode == 1)
    {
       if(gold > 500)
       {
         TakeGoldFromCreature(500, oPC, TRUE);
         bolt = CreateItemOnObject("cbbolt1", oPC, 99);
         SetName(bolt, "Fire Bolt");

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
       {
         TakeGoldFromCreature(1000, oPC, TRUE);
         bolt = CreateItemOnObject("cbbolt2", oPC, 99);
         SetName(bolt, "Shock Bolt");
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
       if(gold > 1500)
       {
         TakeGoldFromCreature(1500, oPC, TRUE);
         bolt = CreateItemOnObject("cbbolt3", oPC, 99);
         SetName(bolt, "Magic Bolt");
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
       {
         TakeGoldFromCreature(2000, oPC, TRUE);
         bolt = CreateItemOnObject("cbbolt4", oPC, 99);
         SetName(bolt, "Ice and Fire Bolt");
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
       if(gold > 2500)
       {
         TakeGoldFromCreature(2500, oPC, TRUE);
         bolt = CreateItemOnObject("cbbolt5", oPC, 99);
         SetName(bolt, "Skin Boiler Bolt");
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
       if(gold > 3000)
       {
         TakeGoldFromCreature(3000, oPC, TRUE);
         bolt = CreateItemOnObject("cbbolt6", oPC, 99);
         SetName(bolt, "Blunt Force Bolt");
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
     SetLocalInt(oPC,"ds_check_4",0);
     SetLocalInt(oPC,"ds_check_5",0);
     SetLocalInt(oPC,"ds_check_6",0);
     SetLocalInt(oPC,"ds_check_7",0);
}
