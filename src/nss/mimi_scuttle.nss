#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    object oSpellTarget;
    effect eHaste = EffectHaste();
    //add poison immunity
    effect eImmune = EffectImmunity(2);
    effect eVFX1 = EffectVisualEffect(VFX_IMP_DEATH_WARD);
    effect eVFX2 = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    effect eVis = EffectVisualEffect(VFX_DUR_TENTACLE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eHaste, eDur);
           eLink = EffectLinkEffects(eLink,eImmune);
           eLink = EffectLinkEffects(eLink,eVFX1);
           eLink = EffectLinkEffects(eLink,eVFX2);

    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    int nMetaMagic = GetMetaMagicFeat();
    float fDelay;
    //Determine spell duration as an integer for later conversion to Rounds, Turns or Hours.
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nCount;
    location lSpell = GetSpellTargetLocation();

    //Meta Magic check for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oSpellTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lSpell);
    //Cycle through the targets within the spell shape until an invalid object is captured or the number of
    //targets affected is equal to the caster level.
    while(GetIsObjectValid(oSpellTarget) && nCount != nDuration)
    {
        //Make faction check on the target
        if(GetIsFriend(oSpellTarget))
        {
            if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, oSpellTarget) == TRUE)
            {
                RemoveSpellEffects(SPELL_EXPEDITIOUS_RETREAT, OBJECT_SELF, oSpellTarget);
            }

            if (GetHasSpellEffect(647, oSpellTarget) == TRUE)
            {
                RemoveSpellEffects(647, OBJECT_SELF, oSpellTarget);
            }

            if (GetHasSpellEffect(SPELL_MASS_HASTE, oSpellTarget) == TRUE)
            {
                RemoveSpellEffects(SPELL_MASS_HASTE, OBJECT_SELF, oSpellTarget);
            }

            fDelay = GetRandomDelay(0.0, 1.0);
            //Fire cast spell at event for the specified target
            SignalEvent(oSpellTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_HASTE, FALSE));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oSpellTarget, RoundsToSeconds(nDuration)));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oSpellTarget));
            nCount++;
        }
        //Select the next target within the spell shape.
        oSpellTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lSpell);
    }
}
