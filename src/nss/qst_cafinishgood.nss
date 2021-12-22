/*! \file qst_cafinishgood.nss
 * \brief Scripted quests good finish.
 *
 * Conversation action to reward the PC for finishing a quest in a
 * good fashion.
 * \verbatim
 * Revision History
 * Date       Name             Description
 * ---------- ---------------- ---------------------------------------------
 * 08/04/2004 jpavelch         Initial release.
 * 12/14/2004 jpavelch         Using QST_* constants.
 * 11/01/2006 Disco            merged with qst_take_item to fix exploits
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
void main( ){

    object oPC       = GetPCSpeaker( );
    object oNPC      = OBJECT_SELF;

    string sQuestTag = GetLocalString( oNPC, QST_TAG_VAR );
    string sItemTag  = GetLocalString( oNPC, QST_ITEM_TAG_VAR );

    if ( sQuestTag == "" ) {

        //no quest tag on PC, exit
        return;
    }

    if ( sItemTag == "" ) {

        //no item tag on PC, finish quest without taking item
        QST_FinishQuest( GetPCSpeaker(), sQuestTag, QST_STATE_GOODY );

    }
    else {

        object oItem = GetItemPossessedBy( oPC, sItemTag );

        if ( GetIsObjectValid(oItem) ){

            if ( GetLocalInt( oNPC, "QST_ItemStay" ) != 1 ){

                //take item
                DestroyObject( oItem );
            }

            //finish quest
            QST_FinishQuest( GetPCSpeaker(), sQuestTag, QST_STATE_GOODY );

        }
    }
}
