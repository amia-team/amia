//script:  chk_corcit
//date:    May 23 2019
//author:  Angelis
//-----------------------------------------------------------------------------

/*
2019-05-23   Angelis   Wrote Script.
*/

#include "nw_i0_tool"
void main()
{
   object oPC = GetLastSpeaker();

   if(HasItem(oPC, "cor_citizenship") == FALSE)
   {
      object oTarget = GetLastSpeaker();
      string sItemTemplate1 = "cor_citizenship";
      int nStackSize = 1; // Create 1 item;
      CreateItemOnObject(sItemTemplate1, oTarget, nStackSize);
   }
   else
   {
      SendMessageToPC(oPC, "You're already a citizen of Southport, silly.");
   }
}
