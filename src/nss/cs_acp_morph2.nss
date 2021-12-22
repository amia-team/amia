/*  Amia Control Panel [ACP] :: Morph :: Morph Summoned Character

    --------
    Verbatim
    --------
    This script will modify the summoned character's appearance.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    070106  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes. */
#include "cs_inc_leto"
#include "logger"

void main( ){

    // Variables.
    object oVault           = OBJECT_SELF;
    location lOrigin        = GetLocation( GetWaypointByTag( "wp_treasurevault" ) );
    object oPC              = GetNearestObjectToLocation( OBJECT_TYPE_CREATURE, lOrigin );

    string szAppearanceRef  = GetStringLeft( GetMatchedSubstring( 0 ), 30 );

    // Modify the summoned character's appearance.
    SetCreatureAppearanceType(
        oPC,
        StringToInt( szAppearanceRef ) );

    // Character integrity.
    ExportSingleCharacter( oPC );

    // Candy.
    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect( VFX_FNF_LOS_HOLY_10 ),
        oPC );

    return;

}
