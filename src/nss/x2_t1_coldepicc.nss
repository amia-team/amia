//::///////////////////////////////////////////////
//:: Deadly Frost Trap
//:: X2_T1_ColdEpicC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Strikes the entering object with a blast of
    cold for 40d4 damage. Fortitude save to avoid
    being paralyzed for 4 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: June 09, 2003
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

    int nDamage = d4(40);
    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
    effect eParal = EffectParalyze();
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eFreeze = EffectVisualEffect(VFX_DUR_BLUR);
    effect eLink = EffectLinkEffects(eParal, eFreeze);
    effect eBite    = EffectDamageImmunityDecrease( DAMAGE_TYPE_COLD, 10 );
    int nUpgrade    = GetLocalInt( OBJECT_SELF, TRAP_UPGRADE );

    if(!MySavingThrow(SAVING_THROW_FORT,oTarget, 30, SAVING_THROW_TYPE_COLD))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(4));
        if ( nUpgrade ){

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBite, oTarget, RoundsToSeconds(14) );
        }

    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    //----------------------------------------------------------------
    //trap pvp system
    //----------------------------------------------------------------
    //transfer PvP settings
    TransferPvpMode( oTarget, oOwner, nTrapStatus, nDamage, "cold" );
    //----------------------------------------------------------------
}

