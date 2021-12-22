/*! \file qst_hasitem.nss
 * \brief Scripted quests check for quest item.
 *
 * Conversation conditional to check if the PC has a quest item.  The item
 * tag is stored as local string on the NPC.
 * \verbatim
 * Revision History
 * Date       Name             Description
 * ---------- ---------------- ---------------------------------------------
 * 12/02/2004 jpavelch         Initial release.
 * 12/14/2004 jpavelch         Using QST_* constants.
 * \endverbatim
 */

#include "quests_inc"
#include "logger"

//! Script entry point.
/*!
 * Retrieves the item tag from the NPC speaking and checks for it in the PCs
 * inventory.  Writes a message to the error log if the item tag could not
 * be found.
 * \par Local Variables
 * \li \a QST_ItemTag [string] On NPC to identify quest item.
 * \return \a TRUE If the item is in the PCs inventory.
 * \return \a FALSE If the item is not in the PCs inventory.
 * \return \a FALSE If an item tag could not be found.
 */
int StartingConditional( )
{
    object oPC = GetPCSpeaker( );
    object oNPC = OBJECT_SELF;

    string sItemTag = GetLocalString( oNPC, QST_ITEM_TAG_VAR );

    if ( sItemTag == "" ) {
        LogError(  "qst_hasitem", "## Script quests: could not find "
                + "item tag on NPC " + GetName(oNPC) + "!" );
        return FALSE;
    }

    object oItem = GetItemPossessedBy( oPC, sItemTag );

    return ( GetIsObjectValid(oItem) );
}
