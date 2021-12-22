/*! \file qst_takeitem.nss
 * \brief Scripted quests take quest item.
 *
 * Conversation action take a quest item from a PC.  The item tag is stored
 * as local string on the NPC.
 * \verbatim
 * Revision History
 * Date       Name             Description
 * ---------- ---------------- ---------------------------------------------
 * 12/02/2004 jpavelch         Initial release.
 * 12/14/2004 jpavelch         Using QST_* constants.
 * 11/01/2006 Disco            disabled and merged with qst_cafinishnorm to fix exploits

    obsolete

 * \endverbatim
 */

#include "quests_inc"
#include "logger"

//! Script entry point.
/*!
 * Retrieves the item tag from the NPC speaking and removes it from the PCs
 * inventory.  Writes a message to the error log if the item tag could not
 * be found.
 * \par Local Variables
 * \li \a QST_ItemTag [string] On NPC to identify quest item.
 */
void main( )
{


   //will not be used here, but in the XP reward script
   return;

    object oPC = GetPCSpeaker( );
    object oNPC = OBJECT_SELF;

    string sItemTag = GetLocalString( oNPC, QST_ITEM_TAG_VAR );
    if ( sItemTag == "" ) {
        LogError(  "qst_takeitem", "## Script quests: could not find "
                + "item tag on NPC " + GetName(oNPC) + "!" );
        return;
    }

    object oItem = GetItemPossessedBy( oPC, sItemTag );
    if ( GetIsObjectValid(oItem) )
        DestroyObject( oItem );
}
