void main()
{
if (GetLocalInt(OBJECT_SELF, "nDoOnce") == 1)
        return;
    SetLocalInt(OBJECT_SELF, "nDoOnce", 1);

effect eTentacle = EffectVisualEffect(VFX_DUR_TENTACLE);

ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTentacle, OBJECT_SELF);
}
