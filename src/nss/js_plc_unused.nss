/*

   Job System PLC plus Size
   - Maverick00053


*/


#include "x2_inc_switches"
#include "x2_inc_itemprop"
#include "inc_ds_porting"

void main()
{
  object oPC = OBJECT_SELF;
  object oPLC = GetLocalObject(oPC,"pcplc");
  SetUseableFlag(oPLC,0);
}
