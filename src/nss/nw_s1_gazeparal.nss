//::///////////////////////////////////////////////
//:: Gaze: Paralysis
//:: NW_S1_GazeParal
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
#include "x0_i0_spells"
#include "inc_td_shifter"
void main()
{
    // Hack for the Evil Glare spell.
    object oPC         = OBJECT_SELF;
    string sPCKey      = GetName( GetPCKEY( oPC ) );
    if( sPCKey == "QVMCXTPT_20071016202329" )
        return;

    if( GZCanNotUseGazeAttackCheck(OBJECT_SELF))
    {
        return;
    }

    //Declare major variables
    int nHD = GetHitDice(OBJECT_SELF);
    int nDuration = 1 + (nHD / 3);
    int nDC = 10 + (nHD/2);
    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    effect eGaze = EffectParalyze();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVisDur = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);

    effect eLink = EffectLinkEffects(eGaze, eVisDur);
    eLink = EffectLinkEffects(eLink, eDur);
    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if(!GetIsReactionTypeFriendly(oTarget) && oTarget != OBJECT_SELF)
        {
            nDuration = GetScaledDuration(nDuration , oTarget);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_GAZE_PARALYSIS));
            //Determine effect delay
            float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
            {
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    }
}

