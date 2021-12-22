/*  Mystra's Grove Theatre Light Dimmer Lever

    --------
    Verbatim
    --------
    This script will operate Mystra's Grove Theatre light dimming.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    050306  kfw         Initial Release.
    ----------------------------------------------------------------------------

*/

void main( ){

    // Variables
    object oLever           = OBJECT_SELF;
    object oArea            = GetArea( oLever );

    int nArea_Height        = GetAreaSize( AREA_HEIGHT, oArea );
    int nArea_Width         = GetAreaSize( AREA_WIDTH, oArea );

    int nSetting            = GetLocalInt( oLever, "spawned" );

    int nLight              = TILE_MAIN_LIGHT_COLOR_BLACK;
    int nLight2             = TILE_SOURCE_LIGHT_COLOR_BLACK;

    // Full lever anim.
    PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE );
    DelayCommand( 0.25, PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE ) );

    // Dimmed, set to Brighter.
    if( nSetting == 0 ){

        // Brighter.
        nLight  = TILE_MAIN_LIGHT_COLOR_DIM_WHITE;
        nLight2 = TILE_SOURCE_LIGHT_COLOR_WHITE;

        // Set the control integer.
        nSetting = 1;

    }
    // Brighter, set to Full Light.
    else if( nSetting == 1 ){

        // Full light.
        nLight = TILE_MAIN_LIGHT_COLOR_PALE_YELLOW;
        nLight2 = TILE_SOURCE_LIGHT_COLOR_PALE_YELLOW;

        // Set the control integer.
        nSetting = 2;

    }

    // Full Light, set to Red.
    else if( nSetting == 2 ){

        // Red light.
        nLight = TILE_MAIN_LIGHT_COLOR_DARK_RED;
        nLight2 = TILE_SOURCE_LIGHT_COLOR_PALE_RED;

        // Set the control integer.
        nSetting = 3;

    }

    // Red, set to Blue.
    else if( nSetting == 3 ){

        // Blue light.
        nLight = TILE_MAIN_LIGHT_COLOR_BLUE;
        nLight2 = TILE_SOURCE_LIGHT_COLOR_PALE_BLUE;

        // Set the control integer.
        nSetting = 4;

    }

    // Blue, set to Dimmed.
    else{

        // Set the control integer.
        nSetting = 0;

    }

    // Set the actual control integer.
    SetLocalInt( oLever, "spawned", nSetting );

    // Apply the light setting to all tiles.
    int nX, nY;
    for( nX = 0; nX < nArea_Height; nX++ ){

        for( nY = 0; nY < nArea_Width; nY++ ){

            // Designate Nth tile.
            location lTileDest = Location( oArea, Vector( IntToFloat( nX ), IntToFloat( nY ) ), 0.0 );

            SetTileMainLightColor(
                                lTileDest,
                                nLight,
                                TILE_MAIN_LIGHT_COLOR_BLACK );

            SetTileSourceLightColor(
                                lTileDest,
                                nLight2,
                                TILE_SOURCE_LIGHT_COLOR_BLACK );

        }

    }

    RecomputeStaticLighting( oArea );

    return;

}
