/*! \file qst_caklaatu.nss
 * \brief Scripted quests Turn the Curse midpoint.
 *
 * Conversation action to advance the player to the midpoint of the
 * Turn the Curse quest.  The PC is given 500 XP and the blood vial.
 * \verbatim
 * Revision History
 * Date       Name             Description
 * ---------- ---------------- ---------------------------------------------
 * 08/05/2004 jpavelch         Initial release.
 * \endverbatim
 */

#include "quests_inc"


//! Script entry point.
/*!
 * The quest identifier is hard-coded here as \p TurnCurse.
 */
void main( )
{
    object oPC = GetPCSpeaker( );
    string sQuestTag = QST_MANOR_TAG;

    GiveCorrectedXP( oPC, 500, "Quest", 0 );
    CreateItemOnObject( "bloodvial", oPC );

    QST_MidQuest( oPC, sQuestTag );
}
