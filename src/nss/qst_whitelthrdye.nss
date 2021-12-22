/*! \file qst_whitelthrdye.nss
 * \brief Scripted quests white leather dye.
 *
 * Removes the Nexus Waters from a PC and gives flat white leather dye
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
    GiveGoldToCreature(GetPCSpeaker(), 500);
    UpdateModuleVariable( "QuestGold", 500 );

    // Give the speaker some XP
    GiveCorrectedXP(GetPCSpeaker(), 50, "Quest", 0 );

    // Remove items from the player's inventory
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "NexusWaters");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
