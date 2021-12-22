//::///////////////////////////////////////////////
//:: FileName takeoil
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 15/01/2005 15:46:56
//:://////////////////////////////////////////////

#include "cs_inc_xp"

void main(){

    // Give the speaker some gold
    GiveGoldToCreature(GetPCSpeaker(), 333);

    // Give the speaker some XP
    GiveCorrectedXP(GetPCSpeaker(), 333, "Quest", 0 );


    // Remove items from the player's inventory
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "item008");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
