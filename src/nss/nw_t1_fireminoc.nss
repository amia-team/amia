//::///////////////////////////////////////////////
//:: Minor Fire Trap
//:: NW_T1_FireMinoC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does 5d6 damage to all within 5 ft.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 4th, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 27, 2001

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

    location lTarget = GetLocation(oTarget);
    int nDamage;
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eDam;
    int nSaveDC = 18;
    effect eScorch;
    int nUpgrade    = GetLocalInt( OBJECT_SELF, TRAP_UPGRADE );
    int nRaceInt;
    int nConDmg;

    //Get first object in the target area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget);

    //Cycle through the target area until all object have been targeted
    while(GetIsObjectValid(oTarget))
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Roll damage
            nDamage = d6(5);
            nConDmg = 2;
            //Adjust the trap damage based on the feats of the target
            if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nSaveDC, SAVING_THROW_TYPE_TRAP))
            {
                if (GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
                {
                    nDamage /= 2;
                    nConDmg /= 2;
                }
            }
            else if (GetHasFeat(FEAT_EVASION, oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
            {
                nDamage = 0;
                nConDmg = 0;
            }
            else
            {
                nDamage /= 2;
                nConDmg /= 2;
            }
            if (nDamage > 0)
            {
                //Set the damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                //Apply effects to the target.
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                if (nUpgrade){

                    nRaceInt = GetRaceInteger( GetRacialType( oTarget ), GetSubRace( oTarget ) );

                    if ( nRaceInt != RACE_AIR_GENASI ){

                        eScorch = EffectAbilityDecrease( ABILITY_CONSTITUTION, nConDmg );
                        DelayCommand( 0.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eScorch, oTarget ) );

                    }
                }

                //----------------------------------------------------------------
                //trap pvp system
                //----------------------------------------------------------------
                //transfer PvP settings
                TransferPvpMode( oTarget, oOwner, nTrapStatus, nDamage, "fire" );
                //----------------------------------------------------------------
            }
        }
        //Get next target in shape
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget);
    }
}

