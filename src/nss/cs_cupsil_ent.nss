void main( ){

    object oTarget  = GetEnteringObject( );
    object oPC      = GetAreaOfEffectCreator( );

    //Caster already has the benefits of this spell
    if( oTarget == oPC )
        return;

    effect eSpell = EffectSkillIncrease( SKILL_LISTEN, 5 );

    if( GetIsReactionTypeFriendly( oTarget, oPC ) ){

        eSpell = EffectLinkEffects( eSpell, EffectSkillIncrease( SKILL_MOVE_SILENTLY, 5 ) );
        SignalEvent(oTarget, EventSpellCastAt( OBJECT_SELF, 878, FALSE ) );
    }
    //Consider this spell hostile if the target wasnt friendly
    else
        SignalEvent(oTarget, EventSpellCastAt( OBJECT_SELF, 878, TRUE ) );

    //Bloat duration since its stripped on the exit script anyway
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSpell, oTarget, TurnsToSeconds( 30 ) );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_SONIC ), oTarget );

    if( !FortitudeSave( oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oPC ) ){

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectSilence(), oTarget, RoundsToSeconds( d2(1) ) );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_SILENCE ), oTarget );
    }
}
