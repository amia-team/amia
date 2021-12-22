void main(){

    vector vSelf = GetPosition( OBJECT_SELF );
    float fX = 1.0 * FloatToInt( vSelf.x / 10.0 );
    float fY = 1.0 * FloatToInt( vSelf.y / 10.0 );
    vector vTile = Vector( fX, fY, 0.0 );
    location lTile = Location( GetArea( OBJECT_SELF ), vTile, 0.0 );



    if ( GetLocalInt( OBJECT_SELF, "flame" ) != 1 ){

        string sColour = GetLocalString( OBJECT_SELF, "color" );

        if ( sColour == "red" ){

            SetTileSourceLightColor( lTile, TILE_SOURCE_LIGHT_COLOR_PALE_RED, TILE_SOURCE_LIGHT_COLOR_PALE_DARK_RED );
        }
        else if ( sColour == "yellow" ){

            SetTileSourceLightColor( lTile, TILE_SOURCE_LIGHT_COLOR_PALE_DARK_YELLOW, TILE_SOURCE_LIGHT_COLOR_PALE_YELLOW );
        }
        else if ( sColour == "green" ){

            SetTileSourceLightColor( lTile, TILE_SOURCE_LIGHT_COLOR_PALE_GREEN, TILE_SOURCE_LIGHT_COLOR_PALE_DARK_GREEN );
        }
        else{

            SetTileSourceLightColor( lTile, ( 1 + Random( 15 ) ), ( 1 + Random( 15 ) ) );
        }

        SetLocalInt( OBJECT_SELF, "flame", 1 );
    }

    RecomputeStaticLighting( GetArea( OBJECT_SELF ) );

}
