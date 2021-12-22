//::///////////////////////////////////////////////
//:: Deadly Negative Energy Trap
//:: NW_T1_NegDeadC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does 8d6 negative energy damage and the target
    must make a Fort save or take 1 negative level
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 16, 2001
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

    effect eNegLvl = EffectNegativeLevel(1);
    effect eNeg;
    int nUpgrade    = GetLocalInt( OBJECT_SELF, TRAP_UPGRADE );
    int nStrDmg;
    int nDamage = d6(8);
    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

    // Undead are healed by Negative Energy.
    if ( GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD )
    {
        effect eHeal = EffectHeal(d6(8));
        effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget);
    }
    else
    {
        //Make a saving throw check
        if(!MySavingThrow(SAVING_THROW_FORT, oTarget, 21, SAVING_THROW_TYPE_TRAP))
        {
            if (nUpgrade){
                nStrDmg += 2;
                eNeg = EffectAbilityDecrease(ABILITY_STRENGTH, nStrDmg);
                eNeg = SupernaturalEffect(eNeg);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNeg, oTarget);
            }
            eNegLvl = SupernaturalEffect(eNegLvl);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNegLvl, oTarget);
        }
        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

        //----------------------------------------------------------------
        //trap pvp system
        //----------------------------------------------------------------
        //transfer PvP settings
        TransferPvpMode( oTarget, oOwner, nTrapStatus, nDamage, "negative" );
        //----------------------------------------------------------------
    }
}
