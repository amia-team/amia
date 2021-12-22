/*  Trigger :: OnEnter (Once Only) :: TileMagic :: Create Tile Magic

    --------
    Verbatim
    --------
    This script will fire once per reset and will cover a zone dimension from 0,0,Z origin,
    with a trigger-stored Tile Magic reference.

    Variables that should be stored on the trigger itself.
        Name        Type            Designation
        ---------------------------------------
        cs_x    :   Integer     :   X-dimension
        cs_y    :   Integer     :   Y-dimension
        cs_z    :   Float       :   Z-dimension
        cs_vfx  :   Integer     :   426 (ice) | 401 (water) | 402 (grass) | 349 (lava fountain) | 350 (lava) | 406 (cave floor) | 461 (sewer water).

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    082506  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes. */
#include "x2_inc_toollib"


/* Constants. */
const string AREA_DIMENSION_X   = "cs_x";
const string AREA_DIMENSION_Y   = "cs_y";
const string AREA_DIMENSION_Z   = "cs_z";
const string TILE_MAGIC_REF     = "cs_vfx";


void main( ){

    // Variables
    object oTrigger             = OBJECT_SELF;
    object oArea                = GetArea( oTrigger );
    int nAreaX                  = GetAreaSize( AREA_WIDTH, oArea );
    int nAreaY                  = GetAreaSize( AREA_HEIGHT, oArea );
    float fAreaZ                = GetLocalFloat( oTrigger, AREA_DIMENSION_Z );
    int nTileVfx                = GetLocalInt( oTrigger, TILE_MAGIC_REF );

    // Initialize TileMagic
    TLChangeAreaGroundTiles( oArea, nTileVfx, nAreaX, nAreaY, fAreaZ );

    // Refresh Lighting for TileMagic
    DelayCommand( 1.0, RecomputeStaticLighting( oArea ) );

    DestroyObject( oTrigger, 1.1 );

    return;

}

