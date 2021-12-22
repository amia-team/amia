/*  Blackguard's Deeper Darkness Spell :: Setup Blackguard Duration.

    --------
    Verbatim
    --------
    This spellscript links from bg_spells script
    and will toggle a variable for the Darkness: onEnter spellscript,
    for the Deeper Darkness spell,
    and so it interacts properly for Blackguard PrCs.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    051506  Aleph       Initial release.
    ----------------------------------------------------------------------------

*/

void main( ){

    // Variables.
    object oPC          = OBJECT_SELF;
    int nBGD_rank       = GetLevelByClass( CLASS_TYPE_BLACKGUARD );

    // Set variable.
    SetLocalInt( oPC, "bgdeepdark", TRUE );

    // Hack: Ultravision fix.
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectUltravision( ), oPC, TurnsToSeconds( nBGD_rank ) );

    // Cast the Darkness spell [actually Deeper Darkness].
    ActionCastSpellAtLocation(
        SPELL_DARKNESS, GetItemActivatedTargetLocation( ),METAMAGIC_NONE,
        TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE );

    return;

}
