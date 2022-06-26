
#include "inc_call_time"
#include "amia_include"

void giveXP(object oPC);

void main()
{

   object oPC = GetPCSpeaker();
   object oWidget = GetItemPossessedBy(oPC, "ds_pckey");
   location lJump = GetLocalLocation(oPC,"hunter_start_loc");
   string sWaypoint = GetLocalString(oPC,"Hunter_Waypoint");
   object oWaypoint = GetWaypointByTag(sWaypoint);

   DeleteLocalInt(oWaypoint,"IsOccupied");
   SetLocalInt(oWidget,"PreviousStartTime",GetRunTimeInSeconds());
   DelayCommand( 1.0, AssignCommand( oPC, ClearAllActions() ) );
   DelayCommand( 1.1, AssignCommand( oPC, JumpToLocation(lJump) ) );
   DelayCommand( 1.5, giveXP(oPC));
   DelayCommand( 2.0, AssignCommand(oPC,ActionSpeakString("*<c~Îë>You arrive back from your long hunting session*</c>")));

}

void giveXP(object oPC)
{
   int nPCLevel = GetLevelByPosition(1,oPC) + GetLevelByPosition(2,oPC) + GetLevelByPosition(3,oPC);
   int nXP = GetXP(oPC);
   if(nPCLevel==30)
   {
    SetXP(oPC,nXP+1);
   }
   else
   {
    SetXP(oPC,nXP+1000);
   }
}
