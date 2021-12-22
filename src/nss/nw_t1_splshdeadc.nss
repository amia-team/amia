//::///////////////////////////////////////////////
//:: Deadly Acid Splash Trap
//:: NW_T1_SplshStrC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Strikes the entering object with a blast of
    cold for 8d8 damage. Reflex save to take
    1/2 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 16th , 2001
//:://////////////////////////////////////////////

// 2008-04-11    Disco    Added PvP system

#include "NW_I0_SPELLS"
#include "inc_ds_traps"

void main()
{
    //Declare major variables
    object oTarget   = GetEnteringObject();

    //----------------------------------------------------------------
    //trap pvp system
    //----------------------------------------------------------------
    int nTrapStatus  = GetTrapStatus( oTarget, OBJECT_SELF );

    if ( nTrapStatus < 0 ){

        return;
    }

    object oOwner    = GetLocalObject( OBJECT_SELF, TRAP_CREATOR );
    //----------------------------------------------------------------

    int nDamage     = d8(8);
    int nDC         = 20;
    int nUpgrade    = GetLocalInt( OBJECT_SELF, TRAP_UPGRADE );

    effect eDam;
    effect eVis     = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eACDec   = EffectACDecrease( 1, AC_DODGE_BONUS );

    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_TRAP);

    if (nUpgrade){

        if (nDamage > 0){

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eACDec, oTarget, RoundsToSeconds(3) );

        }
    }
    eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    //----------------------------------------------------------------
    //trap pvp system
    //----------------------------------------------------------------
    //transfer PvP settings
    TransferPvpMode( oTarget, oOwner, nTrapStatus, nDamage, "acid" );
    //----------------------------------------------------------------
}

