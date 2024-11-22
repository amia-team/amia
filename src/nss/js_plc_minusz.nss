/*

   Job System PLC minus Z

   - Maverick00053


*/


#include "x2_inc_switches"
#include "x2_inc_itemprop"
#include "inc_ds_porting"

void main()
{
  object oPC = OBJECT_SELF;
  object oPLC = GetLocalObject(oPC,"pcplc");
  float fFacing = GetFacing(oPLC);
  location Loc = GetLocation(oPLC);
  vector vPLC = GetPositionFromLocation(Loc);
  float x = vPLC.x;
  float y = vPLC.y;
  float z = vPLC.z;
  vector newVector = Vector(x,y,z-1.0);
  location newLoc = Location(GetArea(oPLC),newVector,fFacing);

  AssignCommand(oPLC, JumpToLocation(newLoc));
}
