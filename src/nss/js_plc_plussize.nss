/*

   Job System PLC minus Size
   - Maverick00053


*/


#include "x2_inc_switches"
#include "x2_inc_itemprop"
#include "inc_ds_porting"

void main()
{
  object oPC = OBJECT_SELF;
  object oPLC = GetLocalObject(oPC,"pcplc");
  float fSize = GetObjectVisualTransform(oPLC,OBJECT_VISUAL_TRANSFORM_SCALE);
  float fBaseSize = GetLocalFloat(oPLC,"basesize");

  if(fSize < (fBaseSize+.20))
  {
   SetObjectVisualTransform(oPLC,OBJECT_VISUAL_TRANSFORM_SCALE,fSize+.01);
  }
  else
  {
   SendMessageToPC(oPC,"You cannot size up this PLC anymore.");
  }
}

