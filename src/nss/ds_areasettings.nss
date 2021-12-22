//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_areasettings
//group:   area settings
//used as: action script
//date:    apr 04 2007
//author:  disco


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void SetAreaWeather( object oPC, object oArea, int nWeather );
void SetAreaLights1( object oPC, object oArea, int nColour );
void SetAreaLights2( object oPC, object oArea, int nColour );
void SetSourceLights( object oPC, object oArea, int nColour );
void SetFogColour( object oPC, object oArea, int nR, int nG, int nB );
void SetFogDensity( object oPC, object oArea, int nAmount );


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC    = OBJECT_SELF;
    object oArea  = GetArea( OBJECT_SELF );

    int nNode   = GetLocalInt( oPC, "ds_node" );
    int nWtr    = GetLocalInt( oPC, "ds_wtr" );
    int nML1    = GetLocalInt( oPC, "ds_ml1" );
    int nML2    = GetLocalInt( oPC, "ds_ml2" );
    int nSrc    = GetLocalInt( oPC, "ds_src" );
    int nFgR    = GetLocalInt( oPC, "ds_fgr" );
    int nFgG    = GetLocalInt( oPC, "ds_fgg" );
    int nFgB    = GetLocalInt( oPC, "ds_fgb" );
    int nFam    = GetLocalInt( oPC, "ds_fam" );

    //get convo node
    switch ( nNode ) {

        case 0:       break;

        //weather
        case 01:  SetAreaWeather( oPC, oArea, nWtr+1 );  break;
        case 02:  SetAreaWeather( oPC, oArea, nWtr-1 );  break;

        //mainlight1
        case 03:  SetAreaLights1( oPC, oArea, nML1+1 );  break;
        case 04:  SetAreaLights1( oPC, oArea, nML1-1 );  break;

        //mainlight2
        case 05:  SetAreaLights2( oPC, oArea, nML2+1 );  break;
        case 06:  SetAreaLights2( oPC, oArea, nML2-1 );  break;

        //sourcelight
        case 07:  SetSourceLights( oPC, oArea, nSrc+1 ); break;
        case 08:  SetSourceLights( oPC, oArea, nSrc-1 ); break;

        //fog colour
        case 09:  SetFogColour( oPC, oArea, nFgR+16, nFgG, nFgB ); break;
        case 10:  SetFogColour( oPC, oArea, nFgR-16, nFgG, nFgB ); break;
        case 11:  SetFogColour( oPC, oArea, nFgR, nFgG+16, nFgB ); break;
        case 12:  SetFogColour( oPC, oArea, nFgR, nFgG-16, nFgB ); break;
        case 13:  SetFogColour( oPC, oArea, nFgR, nFgG, nFgB+16 ); break;
        case 14:  SetFogColour( oPC, oArea, nFgR, nFgG, nFgB-16 ); break;

        //fog amount
        case 15:  SetFogDensity( oPC, oArea, nFam+10 ); break;
        case 16:  SetFogDensity( oPC, oArea, nFam-10 ); break;

        default:      break;
    }
}

void SetAreaWeather( object oPC, object oArea, int nWeather ){

    if ( nWeather > 4 ){

        nWeather = 0;
    }
    else if ( nWeather < 0 ){

        nWeather = 4;
    }

    SetWeather( oArea, nWeather );

    //feedback
    SendMessageToPC( oPC, "Weather: "+IntToString( nWeather ) );

    //store value
    SetLocalInt( oPC, "ds_wtr", nWeather );

}

void SetAreaLights1( object oPC, object oArea, int nColour ){

    vector vLocation;
    location lTile;
    int i;
    int j;
    float fX;
    float fY;

    if ( nColour > 31 ){

        nColour = 0;
    }
    else if ( nColour < 0 ){

        nColour = 31;
    }

    for ( i=0; i<GetAreaSize( AREA_HEIGHT ); i++ ){

        for ( j=0; j<GetAreaSize( AREA_WIDTH ); j++ ){

            //walk through the area and set lights tile by tile
            fX          = IntToFloat(i);
            fY          = IntToFloat(j);

            //Make a location a tile
            vLocation   = Vector(fX, fY, 0.0);
            lTile       = Location(oArea, vLocation, 0.0);

            //set both types of mainlight colours in one go
            SetTileMainLightColor( lTile, nColour, GetTileMainLight2Color(lTile) );
        }
    }
    //feedback
    SendMessageToPC( oPC, "Mainlight 1: "+IntToString( nColour ) );

    //store value
    SetLocalInt( oPC, "ds_ml1", nColour );

    //reset lighting
    RecomputeStaticLighting(oArea);
}

void SetAreaLights2( object oPC, object oArea, int nColour ){

    vector vLocation;
    location lTile;
    int i;
    int j;
    float fX;
    float fY;

    if ( nColour > 31 ){

        nColour = 0;
    }
    else if ( nColour < 0 ){

        nColour = 31;
    }

    for ( i=0; i<GetAreaSize( AREA_HEIGHT ); i++ ){

        for ( j=0; j<GetAreaSize( AREA_WIDTH ); j++ ){

            //walk through the area and set lights tile by tile
            fX          = IntToFloat(i);
            fY          = IntToFloat(j);

            //Make a location a tile
            vLocation   = Vector(fX, fY, 0.0);
            lTile       = Location(oArea, vLocation, 0.0);

            //set both types of mainlight colours in one go
            SetTileMainLightColor( lTile, GetTileMainLight1Color(lTile), nColour );
        }
    }

    //feedback
    SendMessageToPC( oPC, "Mainlight 2: "+IntToString( nColour ) );

    //store value
    SetLocalInt( oPC, "ds_ml2", nColour );

    //reset lighting
    RecomputeStaticLighting(oArea);
}

void SetSourceLights( object oPC, object oArea, int nColour ){

    vector vLocation;
    location lTile;
    int i;
    int j;
    float fX;
    float fY;

    if ( nColour > 15 ){

        nColour = 0;
    }
    else if ( nColour < 0 ){

        nColour = 15;
    }

    for ( i=0; i<GetAreaSize( AREA_HEIGHT ); i++ ){

        for ( j=0; j<GetAreaSize( AREA_WIDTH ); j++ ){

            //walk through the area and set lights tile by tile
            fX          = IntToFloat(i);
            fY          = IntToFloat(j);

            //Make a location a tile
            vLocation   = Vector(fX, fY, 0.0);
            lTile       = Location(oArea, vLocation, 0.0);

            //set both types of mainlight colours in one go
            SetTileSourceLightColor( lTile, nColour, nColour );
        }
    }

    //feedback
    SendMessageToPC( oPC, "Sourcelight: "+IntToString( nColour ) );

    //store value
    SetLocalInt( oPC, "ds_src", nColour );

    //reset lighting
    RecomputeStaticLighting(oArea);
}

void SetFogColour( object oPC, object oArea, int nR, int nG, int nB ){

    if ( nR > 256 ){

        nR = 0;
    }
    else if ( nR < 0 ){

        nR = 256;
    }

    if ( nG > 256 ){

        nG = 0;
    }
    else if ( nG < 0 ){

        nG = 256;
    }

    if ( nB > 256 ){

        nB = 0;
    }
    else if ( nB < 0 ){

        nB = 256;
    }


    int nFogColour = 256*256*nR+256*nG+nB;

    SetFogColor( FOG_TYPE_ALL, nFogColour, oArea );

    //feedback
    SendMessageToPC( oPC, "Fog Colour Hex: "+IntToString( nR )+" "+IntToString( nG )+" "+IntToString( nB ) );
    //feedback
    SendMessageToPC( oPC, "Fog Colour Int: "+IntToString( nFogColour ) );

    //store value
    SetLocalInt( oPC, "ds_fgr", nR );
    SetLocalInt( oPC, "ds_fgg", nG );
    SetLocalInt( oPC, "ds_fgb", nB );
}

void SetFogDensity( object oPC, object oArea, int nAmount ){

    if ( nAmount > 100 ){

        nAmount = 0;
    }
    else if ( nAmount < 0 ){

        nAmount = 100;
    }

    SetFogAmount( FOG_TYPE_ALL, nAmount, oArea );

    //feedback
    SendMessageToPC( oPC, "Fog Colour: "+IntToString( nAmount ) );

    //store value
    SetLocalInt( oPC, "ds_fam", nAmount );
}

