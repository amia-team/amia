void main()
{


    effect eFreeze = EffectCutsceneParalyze();

    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eFreeze, OBJECT_SELF );
}
