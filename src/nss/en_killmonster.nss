// kill mobs

void main()
{
    object oCreature = GetEnteringObject( );
    if ( GetIsPC(oCreature) || GetIsPC(GetMaster(oCreature)) )
        return;

    effect eHarm = EffectVisualEffect( VFX_IMP_HARM );
    effect eDeath = EffectDeath( TRUE, TRUE );
    effect eKillCreature = EffectLinkEffects( eHarm, eDeath );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eKillCreature, oCreature );
}
