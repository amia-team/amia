/*  Arcane Archer :: Seeker Arrow

    --------
    Verbatim
    --------
    Arcane archer's seeker arrow feat.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    062307  kfw         Initial release.
    020609  Terra       Pimped, d8/AA half physical half magical
    ----------------------------------------------------------------------------

*/

int GetAAArrowEnch( object oPC );

void main( ){

    // Variables.
    object oPC                  = OBJECT_SELF;
    object oTarget              = GetSpellTargetObject( );

    int nAA                     = GetLevelByClass( CLASS_TYPE_ARCANE_ARCHER );

    int nDam                    = d3( nAA );

    effect eDamMagic            = EffectDamage( nDam, DAMAGE_TYPE_MAGICAL, GetAAArrowEnch( oPC ) );
    effect eDamPhyic            = EffectDamage( nDam, DAMAGE_TYPE_PIERCING, GetAAArrowEnch( oPC ) );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamMagic, oTarget );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamPhyic, oTarget );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_MAGBLUE ), oTarget );

    return;

}

int GetAAArrowEnch( object oPC ){

    if( GetHasFeat( FEAT_PRESTIGE_ENCHANT_ARROW_20, oPC ) )
        return DAMAGE_POWER_PLUS_TWENTY;

    else if( GetHasFeat( FEAT_PRESTIGE_ENCHANT_ARROW_19, oPC ) )
        return DAMAGE_POWER_PLUS_NINTEEN;

    else if( GetHasFeat( FEAT_PRESTIGE_ENCHANT_ARROW_18, oPC ) )
        return DAMAGE_POWER_PLUS_EIGHTEEN;

    else if( GetHasFeat( FEAT_PRESTIGE_ENCHANT_ARROW_17, oPC ) )
        return DAMAGE_POWER_PLUS_SEVENTEEN;

    else if( GetHasFeat( FEAT_PRESTIGE_ENCHANT_ARROW_16, oPC ) )
        return DAMAGE_POWER_PLUS_SIXTEEN;

    else if( GetHasFeat( FEAT_PRESTIGE_ENCHANT_ARROW_15, oPC ) )
        return DAMAGE_POWER_PLUS_FIFTEEN;

    else if( GetHasFeat( FEAT_PRESTIGE_ENCHANT_ARROW_14, oPC ) )
        return DAMAGE_POWER_PLUS_FOURTEEN;

    else if( GetHasFeat( FEAT_PRESTIGE_ENCHANT_ARROW_13, oPC ) )
        return DAMAGE_POWER_PLUS_THIRTEEN;

    else if( GetHasFeat( FEAT_PRESTIGE_ENCHANT_ARROW_12, oPC ) )
        return DAMAGE_POWER_PLUS_TWELVE;

    else if( GetHasFeat( FEAT_PRESTIGE_ENCHANT_ARROW_11, oPC ) )
        return DAMAGE_POWER_PLUS_ELEVEN;

    else if( GetHasFeat( FEAT_PRESTIGE_ENCHANT_ARROW_10, oPC ) )
        return DAMAGE_POWER_PLUS_TEN;

    else if( GetHasFeat( FEAT_PRESTIGE_ENCHANT_ARROW_9, oPC ) )
        return DAMAGE_POWER_PLUS_NINE;

    else if( GetHasFeat( FEAT_PRESTIGE_ENCHANT_ARROW_8, oPC ) )
        return DAMAGE_POWER_PLUS_EIGHT;

    else if( GetHasFeat( FEAT_PRESTIGE_ENCHANT_ARROW_7, oPC ) )
        return DAMAGE_POWER_PLUS_SEVEN;

    else if( GetHasFeat( FEAT_PRESTIGE_ENCHANT_ARROW_6, oPC ) )
        return DAMAGE_POWER_PLUS_SIX;

    else if( GetHasFeat( FEAT_PRESTIGE_ENCHANT_ARROW_5, oPC ) )
        return DAMAGE_POWER_PLUS_FIVE;

    else if( GetHasFeat( FEAT_PRESTIGE_ENCHANT_ARROW_4, oPC ) )
        return DAMAGE_POWER_PLUS_FOUR;

    else if( GetHasFeat( FEAT_PRESTIGE_ENCHANT_ARROW_3, oPC ) )
        return DAMAGE_POWER_PLUS_THREE;

    else if( GetHasFeat( FEAT_PRESTIGE_ENCHANT_ARROW_2, oPC ) )
        return DAMAGE_POWER_PLUS_TWO;

    else if( GetHasFeat( FEAT_PRESTIGE_ENCHANT_ARROW_1, oPC ) )
        return DAMAGE_POWER_PLUS_ONE;

    else
        return DAMAGE_POWER_NORMAL;
}
