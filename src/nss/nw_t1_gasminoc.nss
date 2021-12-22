//::///////////////////////////////////////////////
//:: Gas Trap
//:: NW_T1_GasMinoC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a  5m poison radius gas cloud that
    lasts for 2 rounds and poisons all creatures
    entering the area with Giant Wasp Venom
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 30, 2001
//:://////////////////////////////////////////////

// 2008-04-11    Disco    Added PvP system

#include "inc_ds_traps"

void main()
{
    //----------------------------------------------------------------
    //trap pvp system
    //----------------------------------------------------------------
    object oTarget   = GetEnteringObject();

    int nTrapStatus  = GetTrapStatus( oTarget, OBJECT_SELF );

    if ( nTrapStatus < 0 ){

        return;
    }
    //----------------------------------------------------------------

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGACID, "NW_T1_GasMinoC1", "****", "****");
    location lTarget = GetLocation(GetEnteringObject());
    int nDuration = 2;
    int nUpgrade        = GetLocalInt( OBJECT_SELF, TRAP_UPGRADE );

    if (nUpgrade) nDuration *= 2;

    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

