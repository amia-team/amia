/*! \file qst_caklaatuoops.nss
 * \brief Scripted quests Turn the Curse oops.
 *
 * Conversation action to spawn evil dead on the player because she
 * did not speak the correct words with the Book of the Dead. Spawns
 * a random creature (four to choose) at a pseudo-random waypoint
 * (two to choose).  A somewhat random visual effect is applied when the
 * creature spawns.
 * \verbatim
 * Revision History
 * Date       Name             Description
 * ---------- ---------------- ---------------------------------------------
 * 08/05/2004 jpavelch         Initial release.
 * \endverbatim
 */

#include "quests_inc"
#include "logger"

//! Gets a random spell.
/*!
 * Randomly selects one of eight spells used when the creature
 * spawns.
 * \par Spells Used
 * \li Fireball
 * \li Fire Storm
 * \li Horrid Wilting
 * \li War Cry
 * \li Implosion
 * \li Power Word Kill
 * \li Wail of the Banshee
 * \li Weird
 */
int GetSpawnSpell( )
{
    int nSpell = 0;

    switch ( d8() ) {
        case 1:  nSpell = SPELL_FIREBALL;            break;
        case 2:  nSpell = SPELL_FIRE_STORM;          break;
        case 3:  nSpell = SPELL_HORRID_WILTING;      break;
        case 4:  nSpell = SPELL_WAR_CRY;             break;
        case 5:  nSpell = SPELL_IMPLOSION;           break;
        case 6:  nSpell = SPELL_POWER_WORD_KILL;     break;
        case 7:  nSpell = SPELL_WAIL_OF_THE_BANSHEE; break;
        case 8:  nSpell = SPELL_WEIRD;               break;
    }

    return nSpell;
}

//! Spawns the creature.
/*!
 * This is a separate function because it is detached from the main
 * script (one second delay).
 * \param sResRef ResRef of creature to spawn.
 * \param lWaypoint Location to spawn creature.
 */
void CreateSpawn( string sResRef, location lWaypoint )
{
    CreateObject(
        OBJECT_TYPE_CREATURE,
        sResRef,
        lWaypoint
    );
}

//! Script entry point.
/*!
 * If a valid waypoint cannot be found, writes an error message to
 * the log and exits.
 */
void main( )
{
    object oPC = GetPCSpeaker( );

    string sResRef = "necronom" + IntToString( d4() );

    string sWaypoint = "wp_necrospawn" + IntToString( d2() );
    object oWaypoint = GetWaypointByTag( sWaypoint );
    if ( !GetIsObjectValid(oWaypoint) ) {
        LogError( "qst_caklaatuoops", "## Invalid TurnCurse Waypoint!" );
        return;
    }

    // First cast the nasty spell.
    ActionCastSpellAtLocation(
        GetSpawnSpell(),
        GetLocation(oWaypoint),
        METAMAGIC_ANY,
        TRUE,
        PROJECTILE_PATH_TYPE_DEFAULT,
        TRUE
    );

    DelayCommand( 1.0, CreateSpawn(sResRef, GetLocation(oWaypoint)) );
}
