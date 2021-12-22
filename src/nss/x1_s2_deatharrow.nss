/*  Arcane Archer :: Death Arrow!

    --------
    Verbatim
    --------
    Arcane archer's death arrow feat.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    062307  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

void main( ){

    // Variables.
    object oPC                  = OBJECT_SELF;
    object oTarget              = GetSpellTargetObject( );
    int nINT                    = GetAbilityModifier( ABILITY_INTELLIGENCE );
    int nCHA                    = GetAbilityModifier( ABILITY_CHARISMA );
    int nAbilityMod             = nINT > nCHA ? nINT : nCHA;
    int nDC                     = 10 + GetLevelByClass( CLASS_TYPE_ARCANE_ARCHER ) + nAbilityMod;


    // Failed touch attack.
    if( TouchAttackRanged( oTarget ) == 0 ){
        FloatingTextStringOnCreature( "- Your death arrow misses spectacularly! -", oPC, FALSE );
        return;
    }

    // Target has death immunity.
    if( GetIsImmune( oTarget, IMMUNITY_TYPE_DEATH ) ){
        FloatingTextStringOnCreature( "- Your death arrow seems to have no effect! -", oPC, FALSE );
        return;
    }

    // Failed fortitude save.
    if( FortitudeSave( oTarget, nDC, SAVING_THROW_TYPE_DEATH ) == 0 ){

        // Apply death effects.
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DEATH ), oTarget );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDeath( TRUE ), oTarget );

    }

    return;

}
