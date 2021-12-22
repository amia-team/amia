//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  cs_spec_spawn
//group:   spawning
//used as: OnEnter trigger script
//date:    nov 02 2008
//author:  Kung, updated by disco
// Special VFX spawn, spawns a monster with a fancy entrance


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    // vars
    object oTrigger     = OBJECT_SELF;
    object oPC          = GetEnteringObject();
    string szMonster    = GetLocalString( oTrigger, "monster");
    location lDest      = GetLocation(GetFirstInPersistentObject( oTrigger, OBJECT_TYPE_WAYPOINT));
    effect eCustomVFX   = EffectVisualEffect(GetLocalInt( oTrigger, "monster_vfx"));

    // resolve respawn status
    if ( GetIsBlocked( oTrigger ) > 0 ){

        return;
    }

    SetBlockTime( oTrigger, 15 );

    // spawn the critter
    object oMonster = ds_spawn_critter( oPC, szMonster, lDest );

    // vfx the critter
    DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_INSTANT, eCustomVFX, oMonster, 0.0));

    return;
}
