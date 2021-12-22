/*  Creature :: OnSpawn :: Suicide

    --------
    Verbatim
    --------
    This script will spawn a dead NPC.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    071306  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

void main( ){

    // Variables.
    object oNPC         = OBJECT_SELF;

    // NPC Corpse.
    AssignCommand( oNPC, SetIsDestroyable( FALSE, FALSE, TRUE ) );
    // Stiff 'em.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDeath( ), oNPC );

    return;

}
