//::///////////////////////////////////////////////
//:: FileName flatblackdye
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/01/2005 01:40:11
//:://////////////////////////////////////////////
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "amia_include"

void main()
{
    // Give the speaker some gold
    GiveGoldToCreature(GetPCSpeaker(), 500);

    // Give the speaker some XP
    GiveCorrectedXP(GetPCSpeaker(), 50, "Quest", 0 );



    // Remove items from the player's inventory
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "ObsidianOre");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
