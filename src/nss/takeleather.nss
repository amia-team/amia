//::///////////////////////////////////////////////
//:: FileName takeleather
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 15/01/2005 15:37:22
//:://////////////////////////////////////////////

#include "cs_inc_xp"

void main()
{
    // Give the speaker some gold
    GiveGoldToCreature(GetPCSpeaker(), 334);

    // Give the speaker some XP
    GiveCorrectedXP(GetPCSpeaker(), 334, "Quest", 0 );


    // Remove items from the player's inventory
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "leatherhides");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
