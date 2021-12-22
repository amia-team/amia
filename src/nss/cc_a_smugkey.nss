//script: cc_a_smugkey
//group: items
//used as: convo action script
//date: 2019-08-23
//author: Jes


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"
#include "inc_ds_records"


//-------------------------------------------------------------------------------

void main()
{

object oPC = GetPCSpeaker();

if (GetGold(oPC) >= 500000)
   {
   AssignCommand(oPC, TakeGoldFromCreature(500000, oPC, TRUE));
   CreateItemOnObject("cc_smugkey", oPC);

   }

else
   {
   AssignCommand(GetObjectByTag("cc_boun"), ActionSpeakString("Ya feckin idiot! I don't give out freebies. Get some gold!"));

   }
}
