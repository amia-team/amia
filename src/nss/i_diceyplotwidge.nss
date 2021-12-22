/*
*  Script by: ZoltanTheRed
*  Last Updated: 09-29-2017
*
 */

void main(){

    object oTarget = GetItemActivatedTarget();

    effect eNegateUniversal = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
    effect eVFXFlies = EffectVisualEffect(480, FALSE);
    effect eVFXBrown = EffectVisualEffect(VFX_DUR_AURA_BROWN, FALSE);

    effect eLinkVFX = EffectLinkEffects(eVFXFlies, eVFXBrown);
    effect eLinkAllEffects = EffectLinkEffects(eLinkVFX, eNegateUniversal);

    effect eDecreaseSaves = SupernaturalEffect(eLinkAllEffects);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDecreaseSaves, oTarget);
}
