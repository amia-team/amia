/*! \file qst_whitclothdye.nss
 * \brief Scripted quests white cloth dye.
 *
 * Removes the White Petals from a PC and gives flat white cloth dye
 * in return.
 * \verbatim
 * Revision History
 * Date       Name             Description
 * ---------- ---------------- ---------------------------------------------
 * 05/09/2004 Artos            Initial release.
 * \endverbatim
 */

//! Script entry point.
/*!
 * Created with a script wizard.. *shudders*
 */
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "amia_include"
void main()
{
    // Give the speaker some gold
    GiveGoldToCreature(GetPCSpeaker(), 1000);
    UpdateModuleVariable( "QuestGold", 1000 );

    // Give the speaker some XP
    GiveCorrectedXP(GetPCSpeaker(), 100, "Quest", 0 );


    // Remove items from the player's inventory
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "WhitePetals");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
