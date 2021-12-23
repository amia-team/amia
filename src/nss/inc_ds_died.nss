//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  inc_ds_died
//group:   player death
//used as: lib
//date:    march 8 2008
//author:  disco

// 2008-06-11  Removed ResolveDeathStatus()
// 2008-11-30  Added guard metagaming penalty
// 2011-03-19  Removed gold removal cap on death
// 2013-02-12  Added support for entry area raising/resurrection fix

//-------------------------------------------------------------------------------
// settings
//-------------------------------------------------------------------------------
const int DIED_BLACKOUT         = FALSE;
const int DIED_DURATION         = 5;         //in minutes!
const int DIED_SUBDUAL_MODE     = 1;
const int DIED_DUEL_MODE        = 2;
const int DIED_BRAWL_MODE       = 3;
const int DIED_ARENA_MODE       = 4;

const string DIED_PVP_MODE      = "pvp_mode";
const string DIED_PVP_KILLER    = "pvp_killer";
const string DIED_RESPAWN_TIME  = "pvp_time";
const string DIED_DEAD_MODE     = "pvp_dead_mode";
const string DIED_IS_DEAD       = "is_dead";
const string FREE_RESPAWN       = "FreeRespawn";
const string DIED_PVP_STORAGE   = "ds_pvp_storage";


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"
#include "inc_ds_records"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//Takes the killing object and returns master or trapsetter
//as Killer if needed
object ResolveKiller( object oKiller, object oVictim );

//Deals with PvP settings on death.
//Returns FALSE if no PvP settings are set.
//Make sure to terminate the rest of the script on TRUE
int ResolvePvpModeDeath( object oKiller, object oVictim );

//if no PvP mode is detected we assume this is a non-PvP death
void ResolveNormalDeath( object oKiller, object oVictim );

//Deals with PvP settings on respawning.
//Returns FALSE if no PvP settings are set.
//Make sure to terminate the rest of the script on TRUE
int ResolvePvpRespawn( object oVictim );

//deals with a non-PvP respawn
void ResolveNormalRespawn( object oVictim );

//PvP mode toggle in Rest Menu and PvP Tool
void SetPvpMode( object oVictim );

//use this in raises and respawn scripts
//makes sure no nasty variables are retained
void RemoveDeadStatus( object oVictim );

//stores pvp mode for oPC
void SetPvpStatus( object oPC, int nStatus );

//retrieves pvp mode for oKiller, who can be a PC or a trap.
int GetKillerPvpStatus( object oKiller, object oVictim );

//retrieves pvp mode for oVictim
int GetVictimPvpStatus( object oVictim );

// Checks current stealth mode of the player that has just died.  If stealth
// is active then a Mysterious Blood Stain is created at the location of
// the player.  If the blood stain is a target of a raise/rez spell, the
// player will become the target.
void CreateBloodstain( object oVictim );

//docks XP and Gold
void ApplyRespawnPenalty( object oVictim );

//traces PvP kills
void LogPvpDeath( object oKiller, object oVictim, int nPvpMode );

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

object ResolveKiller( object oKiller, object oVictim ){

    // If the killer was a trap, get the trapsetter instead.
    if ( GetObjectType( oKiller ) == OBJECT_TYPE_CREATURE ){

        // If the killer is a summon, get the master instead.

        if ( GetIsPC( GetMaster( oKiller ) ) ){

            oKiller  = GetMaster( oKiller );
        }
    }
    else {

        oKiller = GetLocalObject( oVictim, DIED_PVP_KILLER );
    }

    return oKiller;
}

int ResolvePvpModeDeath( object oKiller, object oVictim ){

    // Check to see if PvP death mode has already been set (persistence)
    int nPvpMode = GetLocalInt( oVictim, DIED_DEAD_MODE );

    // If nothing is set, continue with normal checks.
    if ( nPvpMode == 0 ){

        nPvpMode = GetKillerPvpStatus( oKiller, oVictim );

        if ( GetLocalInt( GetArea( oVictim ), FREE_RESPAWN ) ){

            //override PvP setting in Arenas
            nPvpMode = DIED_ARENA_MODE;
        }

        if ( !nPvpMode ){

            return FALSE;
        }

        //stop metagaming the guards
        if ( GetIsInsideTrigger( oKiller, "ds_guarded" ) ){

            AssignCommand( oKiller, SpeakString( "*Nearby guards jump on top of you and after a brief fight your broken dead body is all that remains of you.*" ) );
            log_to_exploits( oKiller, "Killed "+GetName( oVictim ), GetName( GetArea( oKiller ) ) );
            DelayCommand( 3.0, KillPC( oKiller ) );
        }


        //retain killer's PvP mode on PC
        SetLocalInt( oVictim, DIED_DEAD_MODE, nPvpMode );

    }

    //PvP modes
    if ( nPvpMode == DIED_SUBDUAL_MODE ||
         ( nPvpMode == DIED_BRAWL_MODE && GetVictimPvpStatus( oVictim ) != DIED_BRAWL_MODE ) ){

        //attacker tries to keep opponent alive
        if ( DIED_BLACKOUT ){

            FadeToBlack( oVictim, FADE_SPEED_FASTEST );
        }

        //relogged character
        if ( GetIsBlocked( oVictim, DIED_RESPAWN_TIME ) < 1 ){

            SetBlockTime( oVictim, DIED_DURATION, 0, DIED_RESPAWN_TIME );
        }

        //vfx
        AssignCommand( oKiller, ActionCastSpellAtObject( 833, oVictim, 1, TRUE, 0, 1, TRUE ) );

        PopUpDeathGUIPanel( oVictim, TRUE, TRUE, 0, "You are unconscious. You have to be raised or wait for 5 minutes to start playing." );

        //feedback
        FloatingTextStringOnCreature( "*knocks down " + GetName( oVictim ) + "*", oKiller, FALSE );
    }
    else if ( nPvpMode == DIED_DUEL_MODE ){

        //attacker tries to kill opponent
        if ( DIED_BLACKOUT ){

            FadeToBlack( oVictim, FADE_SPEED_FASTEST );
        }

        //relogged character
        if ( GetIsBlocked( oVictim, DIED_RESPAWN_TIME ) < 1 ){

            SetBlockTime( oVictim, DIED_DURATION, 0, DIED_RESPAWN_TIME );
        }

        PopUpDeathGUIPanel( oVictim, TRUE, TRUE, 0, "You are dead. You have to be 'raised' or wait for 5 minutes to start playing." );

        //feedback
        FloatingTextStringOnCreature( "*kills " + GetName( oVictim ) + "*", oKiller, FALSE );
    }
    else if ( nPvpMode == DIED_BRAWL_MODE ){

        //brawl mode
        if ( DIED_BLACKOUT ){

            FadeToBlack( oVictim, FADE_SPEED_FASTEST );
        }

        PopUpDeathGUIPanel( oVictim, TRUE, TRUE, 0, "You have been incapacitated. You can respawn at your bindpoint without XP/Gold penalty." );

        //feedback
        FloatingTextStringOnCreature( "*incapacitates " + GetName( oVictim ) + "*", oKiller, FALSE );
    }
    else if ( nPvpMode == DIED_ARENA_MODE ){

        //arena mode
        if ( DIED_BLACKOUT ){

            FadeToBlack( oVictim, FADE_SPEED_FASTEST );
        }

        PopUpDeathGUIPanel( oVictim, TRUE, TRUE, 0, "You have been beaten. You can respawn at this location without XP/Gold penalty." );

        //feedback
        FloatingTextStringOnCreature( "*beats " + GetName( oVictim ) + "*", oKiller, FALSE );
    }
    else{

        return FALSE;
    }

    //logging
    if ( !GetIsDM( oKiller ) && !GetIsDMPossessed( oKiller ) && nPvpMode != DIED_ARENA_MODE ){

        //log death to database
        LogPvpDeath( oKiller, oVictim, nPvpMode );
    }

    return TRUE;
}

void ResolveNormalDeath( object oKiller, object oVictim ){

    // Spawn a blood stain if dead character was stealthed (So other characters can Res them by their bloodstain).
    CreateBloodstain( oVictim );

    //make sure player can't be freely respawned
    DeleteLocalInt( oVictim, DIED_DEAD_MODE );

    //remove previous respawn point
    string sWP = "d_"+GetName( GetPCKEY( oVictim ) );
    object oWP = GetWaypointByTag( sWP );

    if ( GetIsObjectValid( oWP ) ){

        DestroyObject( oWP, 1.0 );
    }

    //create new respawn WP
    CreateObject( OBJECT_TYPE_WAYPOINT, "ds_storage", GetLocation( oVictim ), FALSE, sWP );

    if ( DIED_BLACKOUT ){

        FadeToBlack( oVictim, FADE_SPEED_FASTEST );
    }

    DelayCommand( 6.0, PopUpDeathGUIPanel( oVictim, TRUE, TRUE, 0, "You have died. Respawning will cost you 100 xp/level and 10% of your gold." ) );
}

int ResolvePvpRespawn( object oVictim ){

    int nPvpMode       = GetLocalInt( oVictim, DIED_DEAD_MODE );

    if ( !nPvpMode ){

        return FALSE;
    }

    int nRemainingTime = GetIsBlocked( oVictim, DIED_RESPAWN_TIME );
    string sStatus     = "You are unconsious. ";

    if ( nRemainingTime > 0 ){

        if ( nPvpMode == DIED_DUEL_MODE ){

            sStatus = "You are dead. ";            `
        }
        else if ( nPvpMode == DIED_BRAWL_MODE ){

            sStatus = "You are incapacitated. ";
        }
        else if ( nPvpMode == DIED_ARENA_MODE ){

            sStatus = "You have been beaten. ";
        }

        PopUpDeathGUIPanel( oVictim, TRUE, FALSE, 0, sStatus+"You can respawn in "+IntToString( nRemainingTime )+" seconds without XP/Gold penalty." );
    }
    else{

        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectResurrection( ), oVictim );

        if ( nPvpMode == DIED_BRAWL_MODE || nPvpMode == DIED_ARENA_MODE ){

            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectHeal( GetMaxHitPoints( oVictim ) ), oVictim );
        }
        else if ( nPvpMode == DIED_SUBDUAL_MODE ){

            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectHeal( ( GetMaxHitPoints( oVictim ) / 2 ) ), oVictim );
        }

        if ( nPvpMode == DIED_BRAWL_MODE ){

            object oDest = GetWaypointByTag( GetStartWaypoint( oVictim, TRUE ) );
            AssignCommand( oVictim, JumpToObject( oDest ) );
        }

        RemoveDeadStatus( oVictim );
    }

    ExecuteScript("race_effects", oVictim);
    ExecuteScript("subrace_effects", oVictim);

    return TRUE;
}

void ResolveNormalRespawn( object oVictim ){

    int nRespawnFlag = GetPCKEYValue( oVictim, "HasRespawned" );
    //int nRespawnFlag = 1;
    object oDest     = GetWaypointByTag( "wp_fugue" );

    if ( nRespawnFlag == 0 ) {

        SetPCKEYValue( oVictim, "HasRespawned", 1 );

        if ( GetLocalInt( GetModule(), "Module" ) == 1 ){

            oDest = GetWaypointByTag( "wp_vyper" );
        }
    }
    else {

        ApplyRespawnPenalty( oVictim );
    }

    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectResurrection(), oVictim );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectHeal( GetMaxHitPoints( oVictim ) / 5 ), oVictim );

    RemoveDeadStatus( oVictim );

    AssignCommand( oVictim, JumpToObject( oDest ) );
}

void SetPvpMode( object oVictim ){

    int nNode   = GetLocalInt( oVictim, "ds_node" );

    if ( nNode == 1 ){

        SendMessageToPC( oVictim, "<c � >PvP Mode set to </c><c�� >Subdue</c> <c � >[default]</c>" );
        SetPvpStatus( oVictim, DIED_SUBDUAL_MODE );
    }
    else if ( nNode == 2 ){

        SendMessageToPC( oVictim, "<c � >PvP Mode set to </c><c�� >Duel</c>" );
        SetPvpStatus( oVictim, DIED_DUEL_MODE );
    }
    else if ( nNode == 3 ){


        SendMessageToPC( oVictim, "<c � >PvP Mode set to </c><c�  >Brawl</c>" );
        SetPvpStatus( oVictim, DIED_BRAWL_MODE );
    }
    else{

        SendMessageToPC( oVictim, "<c � >PvP Mode Disabled</c>" );
        SetPvpStatus( oVictim, 0 );
    }
}

void RemoveDeadStatus( object oVictim ){

    if ( DIED_BLACKOUT ){

        FadeFromBlack( oVictim, FADE_SPEED_MEDIUM );
    }

    DeleteLocalInt( oVictim, DIED_RESPAWN_TIME );
    DeleteLocalInt( oVictim, DIED_DEAD_MODE );
    DeleteLocalInt( oVictim, DIED_IS_DEAD );
    DeleteLocalObject( oVictim, DIED_PVP_KILLER );

    DeletePCKEYValue( oVictim, "dead_in" );

    //reset factions
    SetStandardFactionReputation( STANDARD_FACTION_COMMONER, 80, oVictim );
    SetStandardFactionReputation( STANDARD_FACTION_MERCHANT, 80, oVictim );
    SetStandardFactionReputation( STANDARD_FACTION_DEFENDER, 80, oVictim );

    // Reset their rest interval so they can rest immediately
    DeleteLocalInt( oVictim, "AR_LastRestHour" );

    // Remove blood stain, if applicable.
    object oStain = GetLocalObject( oVictim, "Bloodstain" );

    if ( GetIsObjectValid( oStain ) ) {

        DeleteLocalObject( oVictim, "Bloodstain" );
        DestroyObject( oStain );
    }

    //clean unconsc. vfx
    RemoveEffectsBySpell( oVictim, 833 );

    // Re-initialize Racial Traits.
    ApplyAreaAndRaceEffects( oVictim, 1 );
    ExecuteScript("race_effects", oVictim);
    ExecuteScript("subrace_effects", oVictim);
    ExecuteScript("char_templates", oVictim);

    //clean effects & refresh racial traits
    DelayCommand( 0.5, SafeRemoveAllEffects( oVictim ) );

}

void SetPvpStatus( object oPC, int nStatus ){

    //I store the mode under cdkey on this WP.
    //This is the only way to retain it while being polied or reskinned
    object oStorage = GetWaypointByTag( DIED_PVP_STORAGE );

    SetLocalInt( oStorage, GetPCPublicCDKey( oPC, TRUE ), nStatus );
}

int GetKillerPvpStatus( object oKiller, object oVictim ){

    int nStatus;

    //make sure it's a PC
    if (  GetIsPC( oKiller ) ){

        //I store the mode under cdkey on this WP.
        //This is the only way to retain it while being polied or reskinned
        object oStorage = GetWaypointByTag( DIED_PVP_STORAGE );
        nStatus         = GetLocalInt( oStorage, GetPCPublicCDKey( oKiller, TRUE ) );

        if ( !nStatus ) {

            nStatus = 1;
        }
    }
    else if ( GetObjectType( oKiller ) == OBJECT_TYPE_CREATURE ){

        //handy for testing
        nStatus = GetLocalInt( oKiller, DIED_PVP_MODE );
    }
    else{

        //no valid object probably means it's a trap kill
        //or a relog
        nStatus = GetLocalInt( oVictim, DIED_DEAD_MODE );
    }

    return nStatus;
}

//retrieves pvp mode for oVictim
int GetVictimPvpStatus( object oVictim ){

    int nStatus;

    //make sure it's a PC
    if (  GetIsPC( oVictim ) ){

        //I store the mode under cdkey on this WP.
        //This is the only way to retain it while being polied or reskinned
        object oStorage = GetWaypointByTag( DIED_PVP_STORAGE );
        nStatus         = GetLocalInt( oStorage, GetPCPublicCDKey( oVictim, TRUE ) );

        if ( !nStatus ) {

            nStatus = 1;
        }
    }

    return nStatus;
}

void CreateBloodstain( object oVictim ){

    int nStealthMode = GetStealthMode( oVictim );

    if ( nStealthMode == STEALTH_MODE_ACTIVATED ) {

        object oStain = CreateObject( OBJECT_TYPE_PLACEABLE, "mysteriousbloods", GetLocation( oVictim ) );

        SetLocalObject( oStain, "PlayerVictim", oVictim );

        SetLocalObject( oVictim, "Bloodstain", oStain );
    }
}

void ApplyRespawnPenalty( object oVictim ){

    int nLevel   = GetHitDice( oVictim );
    int nPenalty = nLevel * 100;

    float fLevel = IntToFloat( GetHitDice(oVictim) );
    float fFloor = fLevel / 2.0 * (fLevel - 1.0) * 1000.0;
    int nFloorXP = 0;
    int nNewXP   = GetXP( oVictim ) - nPenalty;

    if ( fFloor < 0.0 ){

        nFloorXP = 0;
    }
    else{

        nFloorXP = FloatToInt( fFloor );
    }

    if ( nNewXP < nFloorXP ){

        nNewXP = nFloorXP;
    }

    SetXP( oVictim, nNewXP );

    // 10%, no cap.
    float fGoldToTake = IntToFloat( GetGold( oVictim ) ) * 0.1;
    int nGoldToTake   = FloatToInt( fGoldToTake );

    if ( nGoldToTake > 0 ){

        AssignCommand( oVictim, TakeGoldFromCreature( nGoldToTake, oVictim, TRUE ) );
    }
}

void LogPvpDeath( object oKiller, object oVictim, int nPvpMode ){

    string sKeyKiller = GetName( GetPCKEY( oKiller ) );
    string sTagKiller = GetTag( oKiller );
    string sKeyKilled = GetName( GetPCKEY( oVictim ) );
    string sPvpMode   = IntToString( nPvpMode );
    string sArea      = SQLEncodeSpecialChars( GetName( GetArea( oVictim ) ) );

    string sQuery = "INSERT INTO player_kills VALUES ( NULL, '"+sKeyKiller+"', '"+sTagKiller+"', '"+sKeyKilled+"',"+sPvpMode+", '"+sArea+"', NOW() )";

    //execute query
    SQLExecDirect( sQuery );
}
