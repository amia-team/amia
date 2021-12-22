/*  i_asnobsmist

    --------
    Verbatim
    --------
    Description

    ---------
    Changelog
    ---------

    Date    Name        Reason
    ------------------------------------------------------------------
    050106  Disco       Corrected OnActivate event
    080720  Maverick00053 Added it in as an assassin spell
    ------------------------------------------------------------------


*/

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main( ){

        object oPC = OBJECT_SELF;
        object oTarget = GetSpellTargetObject();
        effect eImpact = EffectVisualEffect(VFX_IMP_DEATH);
        effect eVis = EffectVisualEffect(VFX_DUR_GHOST_SMOKE_2);
        effect eDur = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
        effect eCover = EffectConcealment(20);
        effect eLink = EffectLinkEffects(eDur, eCover);
        eLink = EffectLinkEffects(eLink, eVis);

        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GHOSTLY_VISAGE, FALSE));
        int nDuration = GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC);
        int nMetaMagic = GetMetaMagicFeat();
        int iFail = GetArcaneSpellFailure(oPC);
        int iRoll = d100(1);

        if (iFail < iRoll){
             ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
             ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
        }
        else{
             FloatingTextStringOnCreature("*Arcane Spell Failure*", oPC);
        }

}



