//::///////////////////////////////////////////////
//:: Average Acid Blob
//:: NW_T1_AcidAvgC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target is hit with a blob of acid that does
    5d6 Damage and holds the target for 3 rounds.
    Can make a Reflex save to avoid the hold effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 4th, 2001
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

    int nDuration   = 3;
    int nDamage     = d6(5);
    int nDC         = 20;
    effect eDam     = EffectDamage( nDamage, DAMAGE_TYPE_ACID);
    effect eHold    = EffectParalyze();
    effect eVis     = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eDur     = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eLink    = EffectLinkEffects(eHold, eDur);
    effect eACDec   = EffectACDecrease( 1, AC_DODGE_BONUS );
    int nUpgrade    = GetLocalInt( OBJECT_SELF, TRAP_UPGRADE );

    //Make Reflex Save
    if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_TRAP))
    {
        //Apply Hold and Damage
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));

        if (nUpgrade){

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eACDec, oTarget, RoundsToSeconds(nDuration+3) );

        }
    }
    else
    {
        //Apply Damage
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    }

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    //----------------------------------------------------------------
    //trap pvp system
    //----------------------------------------------------------------
    //transfer PvP settings
    TransferPvpMode( oTarget, oOwner, nTrapStatus, nDamage, "acid" );
    //----------------------------------------------------------------
}

