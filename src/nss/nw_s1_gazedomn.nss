//::///////////////////////////////////////////////
//:: Gaze: Dominate
//:: NW_S1_GazeDomn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Cone shape that affects all within the AoE if they
    fail a Will Save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 9, 2001
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "inc_td_shifter"

void main()
{
    // Expertise/Improved Expertise disabling for Shifters
    if ( GetActionMode( OBJECT_SELF, ACTION_MODE_EXPERTISE ) )
        SetActionMode( OBJECT_SELF, ACTION_MODE_EXPERTISE, FALSE );
    if ( GetActionMode( OBJECT_SELF, ACTION_MODE_IMPROVED_EXPERTISE ) )
        SetActionMode( OBJECT_SELF, ACTION_MODE_IMPROVED_EXPERTISE, FALSE );


    if( GZCanNotUseGazeAttackCheck(OBJECT_SELF))
    {
        return;
    }


    //Declare major variables
    int nHD ;
    int nDuration;
    int nDC;
    // shifter
    nHD = GetHitDice(OBJECT_SELF);
    nDuration = 1 + (nHD / 3);
    nDC = GetShifterDC( OBJECT_SELF, 10 + (nHD/2) );

    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    effect eGaze = EffectDominated();
    effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVisDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);

    effect eLink = EffectLinkEffects(eDur, eVisDur);

    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if(!GetIsReactionTypeFriendly(oTarget) && oTarget != OBJECT_SELF)
        {
            nDuration = GetScaledDuration(nDuration , oTarget);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_GAZE_DOMINATE));
            //Determine effect delay
            float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            if(GetIsEnemy(oTarget))
            {
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                {
                    eGaze = GetScaledEffect(eGaze, oTarget);
                    eLink = EffectLinkEffects(eLink, eGaze);

                    //Apply the VFX impact and effects
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    }
}

