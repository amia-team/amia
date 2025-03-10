//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ai_death
//group:   ds_ai
//used as: OnDamage
//date:    dec 23 2007
//author:  disco
//
// Edit: 12/9/2023 - Maverick00053 - Added in raidsummoner support for normal bosses


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_ondeath"
#include "ds_ai2_include"

void reset_reputation( object pc );
//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oCritter         = OBJECT_SELF;
    object oKiller          = GetLastKiller();

    DelayCommand(60.0, reset_reputation(oKiller));
    //OnDeath custom ability usage
    string sDE = GetLocalString( oCritter, "DeathEffect" );
    if( sDE != "" )
    {
        SetLocalObject( oCritter, sDE, oKiller );
        ExecuteScript( sDE, oCritter );
    }

    if( GetLastKiller() != OBJECT_SELF && GetLocalInt( oCritter, L_ISDEAD ) != 1 ){

       // Set have died once, stops giving out multiple amounts of XP.
        SetLocalInt( oCritter, L_ISDEAD, 1 );

        // Reward XP.
        int nXPResult = RewardXPForKill( );

        // Generate treasure.
        GenerateLoot( oCritter, nXPResult );
    }

    // If this variable is set on the boss or other critter it will function alongside the raidsummoner plc
    string sRaidSpawner = GetLocalString(oCritter,"raidsummoner");
    if(sRaidSpawner != "")
    {
     // Removes the variable on the raid summoner when the boss "dies" so it can be summoned again
     object oRaidSpawner = GetObjectByTag(sRaidSpawner);
     DeleteLocalInt(oRaidSpawner,"bossOut");
    }
}

void reset_reputation( object pc ){

    SetStandardFactionReputation( STANDARD_FACTION_COMMONER, 50, pc );
    SetStandardFactionReputation( STANDARD_FACTION_DEFENDER, 50, pc );
    SetStandardFactionReputation( STANDARD_FACTION_HOSTILE, 0, pc );
    SetStandardFactionReputation( STANDARD_FACTION_MERCHANT, 50, pc );
}
