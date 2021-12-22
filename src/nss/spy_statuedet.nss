void main()
{
    // Player nearby, freeze all animations temporarily.
    if (GetUserDefinedEventNumber() == EVENT_PERCEIVE)
    {
        object oSelf = OBJECT_SELF;
        int nVFX = VFX_DUR_FREEZE_ANIMATION;
        effect eEffect = EffectVisualEffect(nVFX);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oSelf, 5.0);
    }
}
