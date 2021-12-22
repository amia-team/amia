/* Universal Tilemagic Version 1 : Single Tile

    cs_tilemagic = ice (426), water (401), grass (402), lava fountain (349), lava (350), cavefloor (406), sewer water (461).

*/

// Includes
#include "x2_inc_toollib"

void main( ){

    // Variables
    object oTrigger             = OBJECT_SELF;
    object oPC                  = GetEnteringObject( );
    object oArea                = GetArea( oPC );
    int    nTileVfx             = GetLocalInt( oTrigger, "cs_vfx" );
    string szOrigin             = GetTag( oTrigger );
    object oOrigin              = GetWaypointByTag( szOrigin );

    // Initialize TileMagic
    if( GetIsObjectValid( oOrigin ) && nTileVfx > 0 ){

        // Single tile.
        object oTile = CreateObject(
                                    OBJECT_TYPE_PLACEABLE,
                                    "plc_invisobj",
                                    GetLocation( oOrigin ),
                                    FALSE,
                                    "x2_tmp_tile" );

        // Indestructable
        SetPlotFlag( oTile, TRUE );

        // Tilemagic VFX
        ApplyEffectToObject(
                            DURATION_TYPE_PERMANENT,
                            EffectVisualEffect( nTileVfx ),
                            oTile );

        // Refresh Lighting for TileMagic
        DelayCommand( 1.0, RecomputeStaticLighting( oArea ) );

    }

    // Once-off, self-destruct.
    DestroyObject( oTrigger, 1.1 );

    return;

}
