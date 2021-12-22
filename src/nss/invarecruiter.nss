/*
  Made 8/15/19 by Maverick00053

  Invasion Recruiter Script

*/

#include "x2_inc_switches"
#include "inc_ds_porting"
#include "inc_ds_actions"

void AssignFactionFriendly( object oPC, int nNode, object oNPC);
void LaunchConvo( object oPC, object oNPC);

void LaunchConvo( object oPC, object oNPC){
    SetLocalString(oPC,"ds_action","invarecruiter");
    AssignCommand(oNPC, ActionStartConversation(oPC, "c_invarecruiter", TRUE, FALSE));
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
    if(sAction != "invarecruiter")
    {
       SetLocalInt( oPC, "ds_node", 0 );
       SetLocalString( oPC, "ds_action", "" );
       ActionMoveToObject( GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC ), TRUE, 10.0 );
       LaunchConvo(oPC,oNPC);
    }
    else if(nNode > 0)
    {



       if( 4 >= nNode >= 1)
       {
          AssignFactionFriendly( oPC, nNode, oNPC);
          return;
       }

     }
     else if(nNode == 0) // If the ds_action variable is set, but a choice wasn't made this will refire the convo script so they can make a choice
     {


       SetLocalInt( oPC, "ds_node", 0 );
       SetLocalString( oPC, "ds_action", "" );
    }


}


//Assign Faction Friendly
void AssignFactionFriendly( object oPC, int nNode, object oNPC){

    int gold = GetGold(oPC);
    int nFaction = 0;
    object oFaction;
    string sFactionResRef;
    object oArea = GetArea(oPC);

    if(nNode == 1)
    {
       if(gold > 1000)
       {

          oFaction = GetObjectByTag("invasionfaction1");
          TakeGoldFromCreature(1000, oPC, TRUE);

           if(GetReputation(oFaction,oPC) <= 39)
           {
             AdjustReputation(oPC,oFaction,50);
           }



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



          oFaction = GetObjectByTag("invasionfaction2");
          TakeGoldFromCreature(1000, oPC, TRUE);
           if(GetReputation(oFaction,oPC) <= 39)
           {
             AdjustReputation(oPC,oFaction,50);
           }


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
       {



          oFaction = GetObjectByTag("invasionfaction3");
          TakeGoldFromCreature(1000, oPC, TRUE);
           if(GetReputation(oFaction,oPC) <= 39)
           {
             AdjustReputation(oPC,oFaction,50);
           }


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
       if(gold > 1000)
       {



          oFaction = GetObjectByTag("invasionfaction4");
          TakeGoldFromCreature(1000, oPC, TRUE);
           if(GetReputation(oFaction,oPC) <= 39)
           {
             AdjustReputation(oPC,oFaction,50);
           }


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
     SetLocalInt( oNPC, "ds_node", 0 );
     SetLocalString( oNPC, "ds_action", "" );

}
