// ds: this is a stripped copy of the usual spell for class feats
// doing this should allow stacking
// 2010-02-22

#include "amia_include"

void main()
{

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eDex;
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nModify = d4() + 1;

    //Signal spell cast at event to fire on the target.
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 892, FALSE));

    //Create the Ability Bonus effect with the correct modifier
    eDex = EffectAbilityIncrease(ABILITY_DEXTERITY,nModify);
    effect eLink = EffectLinkEffects(eDex, eDur);

    //Apply visual and bonus effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, NewHoursToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
