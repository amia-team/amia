void main()
{
if (GetLocalInt(OBJECT_SELF, "nDoOnce") == 1)
        return;
    SetLocalInt(OBJECT_SELF, "nDoOnce", 1);

effect eTentacle = EffectVisualEffect(VFX_FNF_SUMMONDRAGON);

ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTentacle, OBJECT_SELF);
}
