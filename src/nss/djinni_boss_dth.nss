//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  djinni_boss_death
//group:   ds_ai
//used as: death  - Djinni boss death script
//date:    March 2025
//author:  Mav
//


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_ondeath"
#include "ds_ai2_include"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oCritter         = OBJECT_SELF;
    object oArea            = GetArea(oCritter);
    string AreaName         = GetName(oArea);
    object oKiller          = GetLastKiller();
    object oWP              = GetWaypointByTag("djinni_boss_exit");

    // Reward XP.
    int nXPResult = RewardXPForKill( );

    CreateObject(OBJECT_TYPE_PLACEABLE,"djinni_boss_port",GetLocation(oWP));

}
