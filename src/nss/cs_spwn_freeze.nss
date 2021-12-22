/*  Creature :: OnSpawn : Freeze [Self]

    --------
    Verbatim
    --------
    This script will freeze a creature when it spawns.

    ---------
    Changelog
    ---------
    Date            Name        Reason
    ----------------------------------------------------------------------------
    050906          kfw         Initial release.
    2009-11-21      Disco       Timing
    ----------------------------------------------------------------------------

*/



void main( ){

    // Variables.
    object oCreature        = OBJECT_SELF;
    int nVFX                = GetLocalInt( oCreature, "cs_vfx" );
    int nVFX2               = GetLocalInt( oCreature, "cs_vfx2" );

    // apply undispellable petrification to the creature when it spawns in

    // Perma-Stoneskin.
    DelayCommand( 5.0, ApplyEffectToObject(
        DURATION_TYPE_PERMANENT,
        SupernaturalEffect( EffectVisualEffect( VFX_DUR_PROT_STONESKIN ) ),
        oCreature ) );

    // Perma-Freeze.
    DelayCommand( 7.0, ApplyEffectToObject(
        DURATION_TYPE_PERMANENT,
        SupernaturalEffect( EffectVisualEffect( VFX_DUR_FREEZE_ANIMATION ) ),
        oCreature ) );

    // Perma-Glow.
    if( nVFX ){

        DelayCommand( 0.4, ApplyEffectToObject(
            DURATION_TYPE_PERMANENT,
            SupernaturalEffect( EffectVisualEffect( nVFX ) ),
            oCreature ) );
    }

    // Perma-Glow.
    if( nVFX2 ){

        DelayCommand( 0.4, ApplyEffectToObject(
            DURATION_TYPE_PERMANENT,
            SupernaturalEffect( EffectVisualEffect( nVFX2 ) ),
            oCreature ) );
    }

    // Set the creature to the Commoner faction, so it isn't hostile to anything.
    DelayCommand( 0.4, ChangeToStandardFaction( oCreature, STANDARD_FACTION_COMMONER ) );

    // Immortalize the creature, so it can't be slain.
    DelayCommand( 0.5, SetPlotFlag( oCreature, TRUE ) );

    return;

}
