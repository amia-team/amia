/* Ice Coverns - High Priestess's Shrine: Area tilemagic

    cs_tilemagic = ice (426), water (401), grass (402), lava fountain (349), lava (350), cavefloor (406), sewer water (461).

*/

// Includes
#include "x2_inc_toollib"

void main( ){

    // Variables
    object oTrigger             = OBJECT_SELF;
    object oPC                  = GetEnteringObject( );
    object oArea                = GetArea( oPC );
    int nAreaX                  = GetAreaSize( AREA_WIDTH, oArea );
    int nAreaY                  = GetAreaSize( AREA_HEIGHT, oArea );
    int    nTileVfx             = 426;

    // Initialize TileMagic
    TLChangeAreaGroundTiles( oArea, nTileVfx, nAreaX, nAreaY );

    // Refresh Lighting for TileMagic
    DelayCommand( 1.0, RecomputeStaticLighting( oArea ) );

    DestroyObject( oTrigger, 1.1 );

    return;

}
