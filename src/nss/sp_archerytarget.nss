void main()
{
    object oSelf = OBJECT_SELF;
    effect eFreeze = EffectCutsceneParalyze( );
    eFreeze = SupernaturalEffect( eFreeze );

    ApplyEffectToObject(
        DURATION_TYPE_PERMANENT,
        eFreeze,
        oSelf
    );
}
