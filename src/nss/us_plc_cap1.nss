/*  Electric Castle Capacitor

    --------
    Verbatim
    --------
    This will zap any player who touches a capacitor.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    050406  kfw         Initial Release.
    ----------------------------------------------------------------------------

*/

void main( ){

    // Variables
    object oPC              = GetLastUsedBy( );

    // Zap!
    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectLinkEffects(
                        EffectDamage( 999, DAMAGE_TYPE_ELECTRICAL ),
                        EffectVisualEffect( VFX_FNF_ELECTRIC_EXPLOSION ) ),
        oPC );

    return;

}
