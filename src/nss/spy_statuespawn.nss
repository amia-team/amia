void main()
{
    ClearAllActions();
    ActionWait(5.0);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_PETRIFY), OBJECT_SELF);
    ActionWait(1.0);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION), OBJECT_SELF);
}
