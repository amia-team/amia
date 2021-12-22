/*! \file qst_castartquest.nss
 * \brief Scripted quests start quest.
 *
 * Conversation action to begin an NPCs quest.
 * \verbatim
 * Revision History
 * Date       Name             Description
 * ---------- ---------------- ---------------------------------------------
 * 07/04/2004 jpavelch         Initial release.
 * 12/14/2004 jpavelch         Using QST_* constants.
 * \endverbatim
 */

#include "quests_inc"
#include "logger"

//! Script entry point.
/*!
 * Retrieves the quest identifier from the NPC and calls into the
 * quest framework.  Writes a message to the error log if a quest
 * identifier could not be found.
 * \par Local Variables
 * \li \a QuestTag Used on the NPC to store the quest identifier.
 */
void main( )
{
    object oNPC = OBJECT_SELF;
    string sQuestTag = GetLocalString( oNPC, QST_TAG_VAR );
    if ( sQuestTag == "" ) {
        LogError( "qst_castartquest", "## Scripted Quests: Could not find quest "
                                    + " for npc: " + GetName(oNPC) );
        return;
    }

    QST_StartQuest( GetPCSpeaker(), sQuestTag );
}
