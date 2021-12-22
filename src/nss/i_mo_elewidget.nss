
/*
Editted: Maverick00053 June 25 2019
Custom Ele Widget for Monk PRC class

*/
#include "x2_inc_switches"
#include "inc_ds_records"

void LaunchConvo( object oPC){
    SetLocalString(oPC,"ds_action","i_mo_elewidget");
    AssignCommand(oPC, ActionStartConversation(oPC, "c_elewidget", TRUE, FALSE));
}

void main()
{

    object oPC          = GetItemActivator();
    object oWidget      = GetItemActivated();
    int nNode           = GetLocalInt( oPC, "ds_node" );
    string sAction      = GetLocalString( oPC, "ds_action");
    int horse           = GetLocalInt( oWidget, "horse");


    if(sAction != "i_mo_elewidget")
    {
       SetLocalInt( oPC, "ds_node", 0 );
       SetLocalString( oPC, "ds_action", "" );
       LaunchConvo(oPC);
    }
    else if(nNode > 0)
    {

      if(nNode == 1)
      {
        SetLocalInt(oPC,"monkprcelemental",1);
        SetLocalInt( oPC, "ds_node", 0 );
        SetLocalString( oPC, "ds_action", "" );
        SetName(oWidget,"Elemental Choice: Fire");
      }
      else if(nNode == 2)
      {
        SetLocalInt(oPC,"monkprcelemental",2);
        SetLocalInt( oPC, "ds_node", 0 );
        SetLocalString( oPC, "ds_action", "" );
        SetName(oWidget,"Elemental Choice: Electrical");
      }
      else if(nNode == 3)
      {

        SetLocalInt(oPC,"monkprcelemental",3);
        SetLocalInt( oPC, "ds_node", 0 );
        SetLocalString( oPC, "ds_action", "" );
        SetName(oWidget,"Elemental Choice: Cold");
      }



    }





}
