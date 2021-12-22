// Plane of Negative Energy Tile Magic. Initialized 'lava' tiles to make it look the part.

/* Includes */
#include "x2_inc_toollib"

void main( ){

    // Variables
    object oTrigger             = OBJECT_SELF;
    object oPC                  = GetEnteringObject( );
    object oArea                = GetArea( oPC );

    // Respawn once only.
    if( GetLocalInt( oTrigger, "spawned" ) )
        return;

    SetLocalInt( oTrigger, "spawned", 1 );

    // Tile-magic the area.
    if( GetIsObjectValid( oArea ) )
        TLChangeAreaGroundTiles( oArea, X2_TL_GROUNDTILE_LAVA, 12, 12 );

    return;

}
