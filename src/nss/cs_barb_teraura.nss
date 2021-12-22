/*  Barbarian Rage :: Terrifying Rage : Fear [OnEnter]

    --------
    Verbatim
    --------
    5. Terrifying Rage feat gives Fear Aura with a Will save DC equal to your Intimidate skill.
        5.1. Failure fears your enemy for 1 round per 2 ranks of Barbarian.
        5.2. This aura only affects creatures up to 1.5 times your Barbarian rank.
        5.2. Creatures above 1.5 times your Barbarian rank are shaken: -2 Attack, Damage and Saves.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    082706  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

void main( ){

    // Variables.
    object oPC          = GetAreaOfEffectCreator( );
    int nPC_Level       = GetHitDice( oPC );
    int nBarbLevel      = GetLevelByClass(CLASS_TYPE_BARBARIAN,oPC);
    int nDC             = nBarbLevel/2 + GetAbilityModifier(ABILITY_CONSTITUTION,oPC)+GetSkillRank( SKILL_INTIMIDATE, oPC, TRUE )/3;
    float fDuration     = RoundsToSeconds( nPC_Level / 2 );     // No limits needed, must be epic to use this anyway.

    object oVictim      = GetEnteringObject( );
    int nVictim_Level   = GetHitDice( oVictim );


    // Gives DC bonuses if feats are invested
    if(GetHasFeat(FEAT_SKILL_FOCUS_INTIMIDATE, oPC)==TRUE)
    {
       nDC = nDC + 1;
    }

    if(GetHasFeat(FEAT_EPIC_SKILL_FOCUS_INTIMIDATE, oPC)==TRUE)
    {
       nDC = nDC + 3;
    }


    // Bug out if the victim isn't a creature OR it's not a foe of the Barbarian.
    if( GetObjectType( oVictim ) != OBJECT_TYPE_CREATURE || !GetIsEnemy( oVictim, oPC ) )
        return;

    // Determine if victim is 1.5 times higher in level than the Barbarian, if so then leave them shaken only, otherwise fear them.
    float fLvlDiff      = IntToFloat( nVictim_Level ) / IntToFloat( nPC_Level );

    if( fLvlDiff > 1.5 && nPC_Level < nVictim_Level )
        ApplyEffectToObject(
            DURATION_TYPE_TEMPORARY,
            SupernaturalEffect( EffectLinkEffects(
                EffectLinkEffects(
                    EffectAttackDecrease( 2 ),
                    EffectLinkEffects( EffectDamageDecrease( 2 ), EffectSavingThrowDecrease( SAVING_THROW_ALL, 2 ) ) ),
                EffectVisualEffect( VFX_IMP_DOOM ) ) ),
            oVictim,
            fDuration );


    // Roll a Will Save, DC equal to Barbarian's Intimidate skill to negate Fear.
    else if( WillSave( oVictim, nDC, SAVING_THROW_TYPE_FEAR, oPC ) == 0 )
        ApplyEffectToObject(
            DURATION_TYPE_TEMPORARY,
            SupernaturalEffect( EffectLinkEffects(
                EffectFrightened( ),
                EffectVisualEffect( VFX_DUR_MIND_AFFECTING_FEAR ) ) ),
            oVictim,
            fDuration );

    return;

}
