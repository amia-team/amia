// Lord-Jyssev - Simple VFX on spawn applier
//
//
// Applies up to 3 different VFX on the creature on spawn, then goes through to
// the normal on spawn routine. Variables for VFX are ints set on the creature
// and should correspond with a proper visual effects constant.
//
// Variables to set on the creature: nVFX1, nVFX2, nVFX3

void main()
{
    // Initialize Variables
    int nVFX1 = GetLocalInt(OBJECT_SELF, "VFX1");
    int nVFX2 = GetLocalInt(OBJECT_SELF, "VFX2");
    int nVFX3 = GetLocalInt(OBJECT_SELF, "VFX3");

    // candy
    if(nVFX1 != 0)
    {
        effect eVFX1=EffectVisualEffect(nVFX1);
        eVFX1=SupernaturalEffect(eVFX1);
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVFX1, OBJECT_SELF, 0.0);
    }

    if(nVFX2 != 0)
    {
        effect eVFX2=EffectVisualEffect(nVFX2);
        eVFX2=SupernaturalEffect(eVFX2);
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVFX2, OBJECT_SELF, 0.0);
    }

    if(nVFX3 != 0)
    {
        effect eVFX3=EffectVisualEffect(nVFX3);
        eVFX3=SupernaturalEffect(eVFX3);
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVFX3, OBJECT_SELF, 0.0);
    }

    ExecuteScript("ds_ai2_spawn");
}
