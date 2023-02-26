/*  Creature :: OnSpawn : Freeze [Self], No StoneSkin

    --------
    Verbatim
    --------
    This script will freeze a creature when it spawns; but no stonekin.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    050906  kfw         Initial release.
    060616  msheeler    updated to account for custom factions
    2023-01-07   Frozen      Made spawned npc not have collision
    ----------------------------------------------------------------------------

*/


/* Constants. */
const string VFX            = "cs_vfx";


void main( ){

    // Variables.
    object oCreature        = OBJECT_SELF;
    int nVFX                = GetLocalInt( oCreature, VFX );
    int nCustFaction        = GetLocalInt( oCreature, "CustFaction" );
    effect eGhost           = EffectCutsceneGhost();

    // apply undispellable petrification to the creature when it spawns in

    // Perma-Freeze.
    DelayCommand (0.5, ApplyEffectToObject(
        DURATION_TYPE_PERMANENT,
        SupernaturalEffect( EffectVisualEffect( VFX_DUR_FREEZE_ANIMATION ) ),
        oCreature ));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, oCreature);

    // Perma-Glow.
    if( nVFX )
        ApplyEffectToObject(
            DURATION_TYPE_PERMANENT,
            SupernaturalEffect( EffectVisualEffect( nVFX ) ),
            oCreature );

    // Set the creature to the Commoner faction, so it isn't hostile to anything.
    // added check to make sure creature doesnt already have a custom cafction
    // Removed because we can not use a custom faction that will not conflict with other critters
    // be sure to set critter to custom faction: statue
    //if ( nCustFaction != 1 ){
    //    DelayCommand( 0.4, ChangeToStandardFaction( oCreature, STANDARD_FACTION_COMMONER ) );
    //    }

    // Immortalize the creature, so it can't be slain.
    DelayCommand( 0.5, SetPlotFlag( oCreature, TRUE ) );

    return;

}
