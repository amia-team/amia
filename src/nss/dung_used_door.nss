/*
   On used script for hidden doors in the dynamic dungeon tool system

 - Maverick00053 11/11/2023
*/

#include "ds_ai2_include"

// Generates a location slightly behind target
location GetBehindLocationTiny(object oTarget);

void main()
{
  object oPC = GetLastUsedBy();
  object oDoor = OBJECT_SELF;
  string sWaypoint = GetLocalString(oDoor,"destination");
  object oWaypoint = GetWaypointByTag(sWaypoint);
  int nDoorActive = GetLocalInt(oDoor,"active");
  int nReturnDoor = GetLocalInt(oDoor,"returndoor");
  string sReturnLocation = GetLocalString(oDoor,"waypoint");
  string sReturnPCLoc = GetLocalString(oPC,"dungeonreturnpoint");
  object oReturnWaypoint = GetWaypointByTag(sReturnPCLoc);
  location lLocation = GetBehindLocationTiny(oReturnWaypoint);

  if(nReturnDoor==0)
  {
   if((GetIsOpen(oDoor) == FALSE) && (GetLocked(oDoor) == FALSE))
   {
    PlayAnimation(  ANIMATION_PLACEABLE_OPEN );
    DelayCommand( 12.0, PlayAnimation(  ANIMATION_PLACEABLE_CLOSE ) );
   }
   else if((nDoorActive == TRUE) && (GetIsOpen(oDoor) == TRUE) && (GetLocked(oDoor) == FALSE))
   {
    AssignCommand(oPC,ActionJumpToLocation(GetLocation(oWaypoint)));
    SetLocalString(oPC,"dungeonreturnpoint",sReturnLocation);
   }
  }
  else if(nReturnDoor==1)
  {
   if((GetIsOpen(oDoor) == FALSE) && (GetLocked(oDoor) == FALSE))
   {
    PlayAnimation(  ANIMATION_PLACEABLE_OPEN );
    DelayCommand( 12.0, PlayAnimation(  ANIMATION_PLACEABLE_CLOSE ) );
   }
   else if((GetIsOpen(oDoor) == TRUE) && (GetLocked(oDoor) == FALSE))
   {
    AssignCommand(oPC,ActionJumpToLocation(lLocation));
   }
  }

}

location GetBehindLocationTiny(object oTarget)
{
    float fDir = GetFacing(oTarget);
    float fAngleOpposite = GetOppositeDirection(fDir);
    return GenerateNewLocation(oTarget,
                               DISTANCE_TINY,
                               fAngleOpposite,
                               fDir);
}
