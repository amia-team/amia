/*
Editted: Maverick00053 5/30/21
Summoner Setter Widget for PM

*/
#include "x2_inc_switches"
#include "inc_ds_records"

void LaunchConvo( object oPC);

void SetSummons( object oPC, int nNode);

void LaunchConvo( object oPC){
    SetLocalString(oPC,"ds_action","i_pm_animateud");
    AssignCommand(oPC, ActionStartConversation(oPC, "c_pm_animateud", TRUE, FALSE));
}


void main()
{

    object oPC          = GetItemActivator();
    object oWidget      = GetItemActivated();
    int nNode           = GetLocalInt( oPC, "ds_node" );
    string sAction      = GetLocalString( oPC, "ds_action");
    int horse           = GetLocalInt( oWidget, "horse");


    // Checks to see if the script has run once, if it did not it runs though the convo file
    if(sAction != "i_pm_animateud")
    {
       SetLocalInt( oPC, "ds_node", 0 );
       SetLocalString( oPC, "ds_action", "" );
       LaunchConvo(oPC);

    }
    else if(nNode > 0)
    {

      if( 35 >= nNode >= 1)
      {
         SetSummons( oPC, nNode);
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

void SetSummons( object oPC, int nNode)
{

      object oWidget = GetItemPossessedBy(oPC, "pm_animateud");
      SetLocalInt(oWidget,"summonset",nNode);

      SetLocalInt( oPC, "ds_node", 0 );
      SetLocalString( oPC, "ds_action", "" );

}
