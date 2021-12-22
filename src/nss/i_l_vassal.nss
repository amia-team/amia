/*
Editted: Maverick00053 April 15 2019
Custom Horse Widget for Rider class

Edit: August 15th 2019 - Did a bug fix.
*/
#include "x2_inc_switches"
#include "inc_ds_records"

void LaunchConvo( object oPC);
void AdjustVassal( object oPC, int nNode);

void LaunchConvo( object oPC){
    SetLocalString(oPC,"ds_action","i_l_vassal");
    AssignCommand(oPC, ActionStartConversation(oPC, "c_vassal", TRUE, FALSE));
}


void main()
{

    object oPC          = GetItemActivator();
    object oWidget      = GetItemActivated();
    int nNode           = GetLocalInt( oPC, "ds_node" );
    string sAction      = GetLocalString( oPC, "ds_action");


    // Checks to see if the script has run once, if it did not it runs though the convo file
    if(sAction != "i_l_vassal")
    {
       SetLocalInt( oPC, "ds_node", 0 );
       SetLocalString( oPC, "ds_action", "" );
       LaunchConvo(oPC);

    }
    else if(nNode > 0)
    {

      if( 35 >= nNode >= 1)
      {
         AdjustVassal( oPC, nNode);
         SetLocalInt( oPC, "ds_node", 0 );
         SetLocalString( oPC, "ds_action", "" );
         return;
      }




    }
    else if(nNode == 0) // If the ds_action variable is set, but a choice wasn't made this will refire the convo script so they can make a choice
    {

       SetLocalInt( oPC, "ds_node", 0 );
       SetLocalString( oPC, "ds_action", "" );
       LaunchConvo(oPC);
    }


}



void AdjustVassal( object oPC, int nNode)
{

      object oWidget = GetItemPossessedBy(oPC, "l_vassal");

      if(nNode == 1)  // 1 Human
      {
        SetLocalInt(oWidget,"vassalRace",1);
      }
      else if(nNode == 2) // 2 Half Orc
      {
        SetLocalInt(oWidget,"vassalRace",2);
      }
      else if(nNode == 3) // 3 Elf
      {
        SetLocalInt(oWidget,"vassalRace",3);
      }
      else if(nNode == 4) // 4 Halfling
      {
        SetLocalInt(oWidget,"vassalRace",4);
      }
      else if(nNode == 5)// 5 Dwarf
      {
        SetLocalInt(oWidget,"vassalRace",5);
      }
      else if(nNode == 6)// 6 Male
      {
        SetLocalInt(oWidget,"vassalFemale",0);
      }
      else if(nNode == 7)// 7 Female
      {
        SetLocalInt(oWidget,"vassalFemale",1);
      }
      else if(nNode == 8)// 8 Name
      {
       string sTalkCustom = GetLocalString(oPC,"setcustomtoken");
       DeleteLocalString(oPC,"setcustomtoken");;
       SetCustomToken(92308831,"");
       DeleteLocalString(oPC,"last_chat");
       SetLocalString(oWidget, "vassalName",sTalkCustom);
      }

      SetLocalInt( oPC, "ds_node", 0 );
      SetLocalString( oPC, "ds_action", "" );
      SetLocalInt( oPC, "ds_check_1", 0 );
      SetLocalInt( oPC, "ds_check_2", 0 );

}
