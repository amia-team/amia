/*
  Bank Chest Close Script
  - The1Kobra
  Supposed to save the chest in question when it's closed to prevent duping
  exploits.
*/

#include "x2_inc_switches"
#include "inc_ds_records"
#include "x0_i0_campaign"

void main() {
    string sBankUse = "BANK_MID_USE";

    //object oPC = GetNearestObject(OBJECT_TYPE_CREATURE);
    object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
    object oBankChest = OBJECT_SELF;

    if(GetIsPolymorphed(oPC)) {
        SendMessageToPC(oPC,"ERROR: Cannot Save while polymorphed, please un-polymorph and try again");
        return;
    }
    ExportSingleCharacter(oPC);
    StoreCampaignDBObject(oPC,"bankstorage",oBankChest);
    SendMessageToPC(oPC,"Storage Chest Contents Saved");

    object oPCKey = GetPCKEY(oPC);
    DeleteLocalInt(oPCKey, sBankUse);
}