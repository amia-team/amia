void main()
{
    int vfx = GetLocalInt(OBJECT_SELF, "vfx");
    if (vfx)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(vfx)), OBJECT_SELF);
    SetEventScript(OBJECT_SELF, EVENT_SCRIPT_PLACEABLE_ON_HEARTBEAT, "");
}
