/*
 Bloodsworn Statue Script - 2/27/22 - Maverick00053

 Directs to c_bs_statue dialogue which directs to bs_statue_conv stript
*/

#include "nwnx_creature"

void main()
{

   object oPC = GetLastUsedBy();
   string sText = GetLocalString(OBJECT_SELF,"convo");
   string sResRef = GetLocalString(OBJECT_SELF,"widgetResRef");

   if(GetIsPC(oPC))
   {
      SetCustomToken(9121131,sText);
      SetLocalString(oPC, "bsWidgetResRef", sResRef);
      ActionStartConversation(oPC, "c_bs_statue",TRUE, FALSE);
   }

}
