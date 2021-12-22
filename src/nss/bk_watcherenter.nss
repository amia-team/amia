
void main()
{
    object oPC = GetEnteringObject();
    effect eVFX = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    effect eBiowareTS = EffectTrueSeeing();
    effect eLink = EffectLinkEffects(eVFX,eBiowareTS);
    eLink = TagEffect(eLink, "watcherts");
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink,oPC);
}
