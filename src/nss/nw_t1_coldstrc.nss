//::///////////////////////////////////////////////
//:: Strong Frost Trap
//:: NW_T1_ColdMinC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Strikes the entering object with a blast of
    cold for 3d4 damage. Fortitude save to avoid
    being paralyzed for 3 rounds.
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
    object oTarget = GetEnteringObject();

    //----------------------------------------------------------------
    //trap pvp system
    //----------------------------------------------------------------
    int nTrapStatus  = GetTrapStatus( oTarget, OBJECT_SELF );

    if ( nTrapStatus < 0 ){

        return;
    }

    object oOwner    = GetLocalObject( OBJECT_SELF, TRAP_CREATOR );
    //----------------------------------------------------------------

    int nDamage     = d4(5);
    effect eDam     = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
    effect eParal   = EffectParalyze();
    effect eVis     = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eFreeze  = EffectVisualEffect(VFX_DUR_BLUR);
    effect eLink    = EffectLinkEffects(eParal, eFreeze);
    effect eBite    = EffectDamageImmunityDecrease( DAMAGE_TYPE_COLD, 10 );
    int nUpgrade    = GetLocalInt( OBJECT_SELF, TRAP_UPGRADE );

    if(!MySavingThrow(SAVING_THROW_FORT,oTarget, 14, SAVING_THROW_TYPE_TRAP))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(3));
        if ( nUpgrade ){

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBite, oTarget, RoundsToSeconds(13) );
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

