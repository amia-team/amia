/* Temple of Set - The Cistern: Area tilemagic

    cs_tilemagic = ice (426), water (401), grass (402), lava fountain (349), lava (350), cavefloor (406), sewer water (461).

*/

// Includes
#include "x2_inc_toollib"

void main( ){

    // Variables
    object oTrigger             = OBJECT_SELF;
    object oPC                  = GetEnteringObject( );
    object oArea                = GetArea( oPC );
    int    nTileVfx             = 401;

    // Resolve Spawned Status
    if( !GetLocalInt( oTrigger, "spawned" ) ){

        // Refresh Spawned Status
        SetLocalInt( oTrigger, "spawned", 1 );

        // Initialize TileMagic
        TLChangeAreaGroundTiles( oArea, nTileVfx, 2, 2 );

        // Refresh Lighting for TileMagic
        DelayCommand( 1.0, RecomputeStaticLighting( oArea ) );

    }

    return;

}
