//::///////////////////////////////////////////////
//:: Strong Tangle Trap
//:: NW_T1_TangStrC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Targets within 10ft of the entering character
    are slowed unless they make a reflex save with
    a DC of 30.  Effect lasts for 4 Rounds
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

    int nDuration       = 4;
    int nDC             = 30;
    int nTangleDur      = nDuration/2;
    int nUpgrade        = GetLocalInt( OBJECT_SELF, TRAP_UPGRADE );
    location lTarget    = GetLocation(oTarget);
    effect eSlow        = EffectSlow();
    effect eTangle      = EffectEntangle();
    effect eVis1        = EffectVisualEffect(VFX_IMP_SLOW);
    effect eVis2        = EffectVisualEffect(VFX_DUR_ENTANGLE);
    float fDur;

    //Find first target in the size
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget);
    //Cycle through the objects in the radius
    while (GetIsObjectValid(oTarget))
    {
        if(! MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_TRAP))
        {
            if (nUpgrade){
                fDur = RoundsToSeconds(nTangleDur);
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eTangle, oTarget, fDur );
                DelayCommand( fDur, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds(nDuration) ) );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis2, oTarget, fDur );
            }
            else{

                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds(nDuration));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget);
            }


            //Apply slow effect and slow effect
        }
        //Get next target in the shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget);
    }
}
