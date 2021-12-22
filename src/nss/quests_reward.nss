/*! \file quests_reward.nss
 * \brief Scripted quests rewards.
 *
 * Rewards a PC for finishing a quest.
 * \verbatim
 * Revision History
 * Date       Name             Description
 * ---------- ---------------- ---------------------------------------------
 * 07/04/2004 jpavelch         Initial release.
 * 12/14/2004 jpavelch         Updated to use new QST_* constants.  Changed
 *                             quest tags.
 * 20050313   jking            Added kobold quest.
 * 20060819   kfw              Temporary patch job for mythals, new Quest System comin!
 * 11-23-2006 disco            Added tracer
 * 20071103        Disco      Now uses databased PCKEY functions

 * \endverbatim
 */

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "quests_inc"


//! Chosen of Mug<something> quest reward.
/*!
 * Removes the Chosen's head from the PCs inventory and destroys it before
 * giving the reward.
 * \par Reward
 * \li \a Good 500 XP
 * \li \a Other 2500 Gold
 * \li \a All Scroll of Raise Dead
 * \param oPC PC that has finished the quest.
 * \param sQuestTag Tag of the quest.
 * \param nState \a QST_STATE_*
 */
void GiveChosenReward( object oPC, string sQuestTag, int nState )
{
//    object oItem = GetItemPossessedBy( oPC, "ChosenofKaltharsHead" );
//    DestroyObject( oItem );

    if ( nState == QST_STATE_GOODY ) {

        GiveCorrectedXP( oPC, 500, "Quest", 0 );
    }
    else {

        GiveGoldToCreature( oPC, 2500 );
        UpdateModuleVariable( "QuestGold", 2500 );
    }

    CreateItemOnObject( "nw_it_spdvscr501", oPC );
}

//! Gustav's quest reward.
/*!
 * \par Reward
 * \li 1000 XP
 * \li Scroll of Raise Dead
 * \li Stoneeater's Ring (33% Chance)
 * \param oPC PC that has finished the quest.
 * \param sQuestTag Tag of the quest.
 * \param nState \a QST_STATE_*
 */
void GiveGustavReward( object oPC, string sQuestTag, int nState ){

    GiveCorrectedXP( oPC, 1000, "Quest", 0 );

    CreateItemOnObject( "nw_it_spdvscr501", oPC );

    if ( d100() <= 33 ) {
        // Stone eater's ring
        CreateItemOnObject( "x2_ring_pet", oPC );
    }
}

//! Horned Rat quest reward.
/*!
 * Removes the Cultist List from the PCs inventory and destroys it before
 * giving the reward.
 * \par Reward
 * \li 700 XP
 * \li Scroll of Raise Dead
 * \li TCS Small Ruby (33% Chance)
 * \param oPC PC that has finished the quest.
 * \param sQuestTag Tag of the quest.
 * \param nState \a QST_STATE_*
 */
void GiveHornedRatReward( object oPC, string sQuestTag, int nState )
{
//    object oList = GetItemPossessedBy( oPC, "CultistList" );
//    DestroyObject( oList );

    GiveCorrectedXP( oPC, 1000, "Quest", 0 );
    CreateItemOnObject( "nw_it_spdvscr501", oPC );

    if ( d100() <= 33 ) {
        // Small ruby
        CreateItemOnObject( "mythal1", oPC );
    }
}

//! Spare a Coin? quest reward.
/*!
 * \par Reward
 * \li \a Good If PC alignment not evil, XP equal to amount of gold given.
 * \li \a Normal If PC alignment not evil, XP equal to amount of gold given.
 * \li \a Evil If PC alignment evil, 5 gold and 50 XP.
 * \param oPC PC that has finished the quest.
 * \param sQuestTag Tag of the quest.
 * \param nState \a QST_STATE_*
 */
void GiveSpareCoinReward( object oPC, string sQuestTag, int nState )
{
    int nGoodEvil = GetAlignmentGoodEvil( oPC );
    switch ( nState ) {
        case QST_STATE_GOODY:
            AssignCommand( oPC, TakeGoldFromCreature(100, oPC, TRUE) );
            if ( nGoodEvil != ALIGNMENT_EVIL ) {
                GiveCorrectedXP( oPC, 100, "Quest", 0 );
            }
            break;

        case QST_STATE_NORMAL:
            AssignCommand( oPC, TakeGoldFromCreature(10, oPC, TRUE) );
            if ( nGoodEvil != ALIGNMENT_EVIL ) {
                GiveCorrectedXP( oPC, 10, "Quest", 0 );
            }
            break;

        case QST_STATE_EVIL:
            GiveGoldToCreature( oPC, 5 );
            if ( nGoodEvil == ALIGNMENT_EVIL ) {
                GiveCorrectedXP( oPC, 50, "Quest", 0 );
            }
            break;
    }
}

//! Turn the Curse quest reward.
/*!
 * Removes the blood vial from the PCs inventory and destroys it before
 * giving the reward.
 * \par Reward
 * \li 1000 Gold
 * \li 500 XP
 * \li Thayvian Razor (33% Chance)
 * \param oPC PC that has finished the quest.
 * \param sQuestTag Tag of the quest.
 * \param nState \a QST_STATE_*
 */
void GiveTurnCurseReward( object oPC, string sQuestTag, int nState )
{
//    object oItem = GetItemPossessedBy( oPC, "bloodvial" );
//    DestroyObject( oItem );

    GiveGoldToCreature( oPC, 1000 );
    UpdateModuleVariable( "QuestGold", 1000 );
    GiveCorrectedXP( oPC, 1000, "Quest", 0 );

    //Its now a 100% chance
    //if ( d100() <= 33 ) {
        // Thayvian Razor
        CreateItemOnObject( "mythal6", oPC );
 //   }
}

//! Farmer/Kobold quest reward.
/*!
 * \par Reward
 * \li 350 XP
 * \li TCS Small Blue Gem
 * \param oPC PC that has finished the quest.
 * \param sQuestTag Tag of the quest.
 * \param nState \a QST_STATE_*
 */
void GiveFarmerKoboldReward( object oPC, string sQuestTag, int nState )
{
    GiveCorrectedXP( oPC, 500, "Quest", 0 );
    CreateItemOnObject( "mythal2", oPC );
}

//! Script entry point.
/*!
 * Gets the quest tag and state from the PC as local variables.
 * \par Local Variables
 * \li AR_QuestTag Used on the PC to identify the quest.  Deleted.
 * \li AR_QuestState Used on the PC to identify the finish state.  Deleted.
 */


void main( )
{
    object oPC = OBJECT_SELF;

    string sQuestTag    = GetLocalString( oPC, QST_TAG_VAR );
    int nState          = GetLocalInt( oPC, QST_STATE_VAR );

    // Ugly hack for now.. I'd like to use the database for all the rewards.
    //
    if ( sQuestTag == QST_CHOSEN_TAG ) {

        GiveChosenReward( oPC, sQuestTag, nState );
    }
    else if ( sQuestTag == QST_GUSTAV_TAG ) {

        GiveGustavReward( oPC, sQuestTag, nState );
    }
    else if ( sQuestTag == QST_HORNEDRAT_TAG ) {

        GiveHornedRatReward( oPC, sQuestTag, nState );
    }
    else if ( sQuestTag == QST_BEGGAR_TAG ) {

        GiveSpareCoinReward( oPC, sQuestTag, nState );
    }
    else if ( sQuestTag == QST_MANOR_TAG  ) {

        GiveTurnCurseReward( oPC, sQuestTag, nState );
    }
    else if ( sQuestTag == QST_FARMER_TAG  ) {

        GiveFarmerKoboldReward( oPC, sQuestTag, nState );
    }

    DeleteLocalString( oPC, QST_TAG_VAR );
    DeleteLocalInt( oPC, QST_STATE_VAR );
}
