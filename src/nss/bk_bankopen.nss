/*
  Bank Chest Close Script
  - The1Kobra
  Part of a script pair that is supposed to save the chest in question when it's
  closed to prevent duping exploits. Sets a variable on someone's PCkey to
  prevent exploiting.
*/

#include "x2_inc_switches"
#include "inc_ds_records"
#include "x0_i0_campaign"

void main() {
    string sBankUse = "BANK_MID_USE";

    //object oPC = GetNearestObject(OBJECT_TYPE_CREATURE);
    object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
    object oBankChest = OBJECT_SELF;
    object oPCKey = GetPCKEY(oPC);
    SetLocalInt(oPCKey, sBankUse, TRUE);
}
