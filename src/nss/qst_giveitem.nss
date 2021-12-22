/*! \file qst_giveitem.nss
 * \brief Scripted quests give quest item.
 *
 * Conversation action give a quest item to a PC.  The item tag is stored
 * as local string on the NPC.
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
 * Retrieves the item resref from the NPC speaking and creates it on the PC.
 * Writes a message to the error log if the item resref could not be found.
 * \par Local Variables
 * \li [string] \a QST_ItemResRef On NPC to identify quest item template.
 */
void main( )
{
    object oPC = GetPCSpeaker( );
    object oNPC = OBJECT_SELF;

    string sItemResRef = GetLocalString( oNPC, QST_ITEM_RESREF_VAR );
    if ( sItemResRef == "" ) {
        LogError( "qst_giveitem", "## Script quests: could not find "
                + "item resref on NPC " + GetName(oNPC) + "!" );
        return;
    }

    CreateItemOnObject( sItemResRef, oPC );
}
