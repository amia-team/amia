/*  Heartbeat :: Body Of Flame :: As per Book of Vile Darkness

    --------
    Verbatim
    --------
    This script is the heartbeat of the Body of Flame immolation.
    Specifically it'll damage the player 1d6 fire damage if they fail a reflex save.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    071606  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Constants. */
const string IMMOLATED              = "cs_immolated";

void main( ){

    // Variables.
    object oVictim          = OBJECT_SELF;

    // Failed reflex, continue immolation.
    if( ReflexSave( oVictim, 20, SAVING_THROW_TYPE_FIRE ) < 1 ){

        // Immolation visual.
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( 498 ), oVictim, 6.0 );

        // Damage.
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectLinkEffects(
                EffectDamage( d6( ), DAMAGE_TYPE_FIRE ),
                EffectVisualEffect( VFX_IMP_FLAME_S ) ),
            oVictim );

        // Initialize immolation, in 6 seconds time.
        DelayCommand( 6.0, ExecuteScript( "cs_immolation", oVictim ) );

    }
    // Successful reflex, cancel immolation.
    else
        SetLocalInt( oVictim, IMMOLATED, FALSE );

    return;

}
