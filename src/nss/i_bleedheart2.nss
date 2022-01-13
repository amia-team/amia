void main()
{
    object PC    = GetItemActivator();
    object Heart = GetItemActivated();

    AssignCommand(PC,ActionSpeakString("*Consumes what remains of a juicy, bleeding heart.*", TALKVOLUME_TALK));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_BALLISTA), PC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_STRENGTH, d4()), PC, TurnsToSeconds(15));
    DestroyObject(Heart);
}
