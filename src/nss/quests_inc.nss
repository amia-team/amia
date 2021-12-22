/*! \file quests_inc.nss
 * \brief Scripted quests include file.
 *
 * Contains scripted quests framework functions and constants.
 * \verbatim
 * Revision History
 * Date       Name             Description
 * ---------- ---------------- ---------------------------------------------
 * 07/04/2004 jpavelch         Initial release.
 * 20071103        Disco      Now uses databased PCKEY functions
 * \endverbatim
 */

#include "logger"
#include "inc_ds_records"

//
// Constants
//

const int QST_ERROR = -1;            //!< Error encountered while processing quest.
const int QST_NOTSTARTED = 0;        //!< Quest has never been started by PC.
const int QST_STARTED = 1;           //!< Quest started by PC but not finished.
const int QST_MIDWAY_BASE = 20;      //!< Intermediate action accomplished by PC.
const int QST_FINISHED_BASE = 100;   //!< Quest has been finished by PC in normal fasion.
const int QST_FINISHED_NORMAL = 110; //!< Quest has been finished by PC in normal fasion.
const int QST_FINISHED_GOODY = 120;  //!< Quest has been finished by PC in goody fashion.
const int QST_FINISHED_EVIL = 130;   //!< Quest has been finished by PC in evil fashion.

const int QST_STATE_NORMAL = 1;     //!< Quest was finished in normal fashion.
const int QST_STATE_GOODY = 2;      //!< Quest was finished in goody-goody fashion.
const int QST_STATE_EVIL = 3;       //!< Quest was finished in evil fashion.

const string QST_PREFIX = "QST_";         //!< Prefix used to store quest state in journal.
const string QST_TAG_VAR = "QST_Tag";     //!< Name of variable that holds quest tag.
const string QST_STATE_VAR = "QST_State"; //!< Name of variable that holds quest state.
const string QST_ITEM_TAG_VAR = "QST_ItemTag";
const string QST_ITEM_RESREF_VAR = "QST_ItemResRef";

// Until we get this quest framework into some type of consistent persistent
// storage we are going to use contants here to keep things straight.
//
const string QST_CHOSEN_TAG = "ChosenOrc";
const string QST_GUSTAV_TAG = "WifeSpirit";
const string QST_HORNEDRAT_TAG = "MainTemple";
const string QST_BEGGAR_TAG = "BlindBeggar";
const string QST_MANOR_TAG = "ManorBook";
const string QST_FARMER_TAG = "FarmerKobold";

//
// Forward Declarations
//

//! Returns the the PCs status of a particular quest.
/*!
 * Returns \a QST_* based on the status of this quest stored in the PCs
 * travel journal.
 * \param oPC PC to check.
 * \param sQuestTag Tag of the quest.
 * \return \a QST_NOSTARTED If the PC has not started this quest.
 * \return \a QST_STARTED If the PC has started the quest but has not
 *                        finished it.
 * \return \a QST_MIDWAY If the PC has achieved the mid-point of the quest.
 * \return \a QST_FINISHED_GOODY If the PC has finished the quest in a
 *                               \e good fashion.
 * \return \a QST_FINISHED_NORMAL If the PC has finished the quest in
 *                                neither a good nor bad fashion.
 * \return \a QST_FINISHED_EVIL If the PC has finished the quest in an
 *                              \e evil fashion.
 */
int QST_GetStatus( object oPC, string sQuestTag );

//! Signals the start of a quest.
/*!
 * The PCs travel journal is updated with \a QST_STARTED for the quest and
 * her NWN journal is updated.
 * \param oPC PC to be updated.
 * \param sQuestTag Tag of the quest.
 */
void QST_StartQuest( object oPC, string sQuestTag );

//! Signals the mid-point of a quest.
/*!
 * The PCs travel journal is updated with \a QST_MIDWAY for the quest and
 * her NWN journal is updated.
 * \param oPC PC to be updated.
 * \param sQuestTag Tag of the quest.
 */
void QST_MidQuest( object oPC, string sQuestTag );

//! Signals the completion of a quest.
/*!
 * The PCs travel journal is updated with \a QST_FINISHED_* based on how
 * the quest was finished and her NWN journal is updated.
 * \param oPC PC to be updated.
 * \param sQuestTag Tag of the quest.
 * \param nState QST_STATE_*
 */
void QST_FinishQuest( object oPC, string sQuestTag, int nState );

//! NWN Journal initialization.
/*!
 * Initializes the PCs NWN journal with all applicable quests and their
 * associated statuses.  All quest statuses are contained in the PCs travel
 * journal.
 * \param oPC PC to be updated.
 */


//
// Implementation
//

// Returns whether the PC has not started, started, or finished NPCs quest.
//
int QST_GetStatus( object oPC, string sQuestTag ){

    //pc key routines
    return GetPCKEYValue( oPC, QST_PREFIX + sQuestTag );
}


// Signals that the PC has started the NPCs quest.
//
void QST_StartQuest( object oPC, string sQuestTag ){

    SetPCKEYValue( oPC, QST_PREFIX + sQuestTag, QST_STARTED );
    AddJournalQuestEntry( QST_PREFIX + sQuestTag, QST_STARTED, oPC, FALSE );
}

// Signals that the PC has performed the requisite midpoint action of the
// quest.
//
void QST_MidQuest( object oPC, string sQuestTag ){

    SetPCKEYValue( oPC, QST_PREFIX + sQuestTag, QST_MIDWAY_BASE );
    AddJournalQuestEntry( QST_PREFIX + sQuestTag, QST_MIDWAY_BASE, oPC, FALSE );
}

// Signals that the PC has finished the NPCs quest.  nState contains the
// 'finish state', ie goody-goody (no reward) or normal (reward).
//
void QST_FinishQuest(  object oPC, string sQuestTag, int nState ){

    if ( nState == QST_STATE_GOODY ) {

        SetPCKEYValue( oPC, QST_PREFIX + sQuestTag, QST_FINISHED_GOODY );
        AddJournalQuestEntry( QST_PREFIX + sQuestTag, QST_FINISHED_GOODY, oPC, FALSE );
    }
    else if ( nState == QST_STATE_NORMAL ) {

        SetPCKEYValue( oPC, QST_PREFIX + sQuestTag, QST_FINISHED_NORMAL );
        AddJournalQuestEntry( QST_PREFIX + sQuestTag, QST_FINISHED_NORMAL, oPC, FALSE );
    }
    else {

        SetPCKEYValue( oPC, QST_PREFIX + sQuestTag, QST_FINISHED_EVIL );
        AddJournalQuestEntry( QST_PREFIX + sQuestTag, QST_FINISHED_EVIL, oPC, FALSE );
    }

    SetLocalString( oPC, QST_TAG_VAR, sQuestTag );
    SetLocalInt( oPC, QST_STATE_VAR, nState );
    ExecuteScript( "quests_reward", oPC );
}


