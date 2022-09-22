/*
tha_area_enter

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
Manages connections, area lighting and journal entries

---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
04-29-2006      disco      Start of header
05-14-2006      disco      Added 1.67 GetAreaSize
08-07-2006      kfw        Modified to conform to Amia standards.
20070822        Disco      Added functions for testing
20071118        Disco      Libbed
2008-10-05      disco      removed racial traits stuff
2009-01-30      disco      job system addition
2009-09-04      disco      reformatted, some old junk removed
2013-10-23      Glim       Added application of variable based VFX to PC's OnEnt
2019-07-17      Tarnus     Commented Dynamic area stuff out to make EE module runable without for now
------------------------------------------------
*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "area_constants"
#include "nw_i0_tool"
#include "inc_ds_records"
#include "inc_ds_j_lib"
/*#include "fw_include"*/

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
//ambience functions
void ds_ambience( object oPC, object oArea );
void ds_set_area_lights( object oPC, object oArea, string sType, object oAmbientTemplate ); //sets tile lighting
int ds_random_light( object oAmbientTemplate, int nDie, string sType );

//utility functions
void ds_check_waypoints( object oPC, object oArea );
int ds_check_creatures( object oPC, object oArea );

//VFX Application on PCs
void glm_addflavorVFX( object oPC, object oArea );


//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    int SAVE_LOCATION = TRUE;
    int SAVE_LOCATION_SAFE_ONLY = TRUE;
    string LOGOUT_LOCATION = "LOGOUT_LOCATION";
    string RETURN_NO_SET = "NoCasting";
    string RETURN_SPAWN_CHECK = "day_spawn1";

    //some vars and a break when the entering object is not a pc (a spawn, for example)
    object oArea            = OBJECT_SELF;
    object oPC              = GetEnteringObject( );

    // Applicable to player characters only.
    if( !GetIsPC( oPC ) ){

        return;
    }

    DelayCommand( 1.0, ds_j_SpawnTarget( oPC, oArea ) );
    // Fixes black areas. Temp hack.
    if(GetIsAreaInterior( oArea )) {
        if( GetLocalInt( oArea, "CS_MAP_REVEAL" ) ){
            DelayCommand( 2.0, ExploreAreaForPlayer( oArea, oPC, TRUE ) );
        }
        else {
            DelayCommand( 2.0, ExploreAreaForPlayer( oArea, oPC, FALSE ) );
        }
    }

    //store area visits
    db_onTransition( oPC, oArea );

    if( GetLocalInt( oArea, "tst_tat_loaded" ) != 1 ){

        //load waypoints names on area
        ds_check_waypoints(oPC, oArea);

        //set ambience
        DelayCommand( 0.0, ds_ambience( oPC, oArea ) );
    }

    //we only want to do the following in Forrstakkr (FindSubString==-1 means "not found")
    if( FindSubString( GetTag( oArea ), "tha_" ) == 0 ){

        //explore area if the player purchased the map
        if ( GetLocalInt( oPC, "tha_map" ) == 1 ){

            ExploreAreaForPlayer( oArea, oPC );
        }
    }

    //VFX Application on PCs
    if( GetLocalInt( oArea, "AreaVFX" ) != 0 )
    {
        int nVFXDelay = GetLocalInt( oArea, "VFXDelay" );
        DelayCommand( IntToFloat( nVFXDelay ), glm_addflavorVFX( oPC, oArea ) );
    }

/*    // store last known location on player object
    SetLocalObject(oPC, "last_area", oArea);
    int nAreaType = fw_getAreaType(oArea);
    // if area is dynamic, reset the counter
    if(nAreaType == 2)
    {
        int nTime = GetRunTime();
        SetLocalInt(oArea, "ttl", nTime);
    }    */

    if (SAVE_LOCATION == TRUE) {
        object oPCKey = GetPCKEY(oPC);

        location logloc = GetLocation(oPC);
        int iNoCasting = GetLocalInt(oArea, RETURN_NO_SET);
        if (iNoCasting == FALSE) {
            int hasspawns = FALSE;
            string spawnset = GetLocalString(GetArea(oPC), RETURN_SPAWN_CHECK);
            if (spawnset != "") {
                hasspawns = TRUE;
            }
            if (SAVE_LOCATION_SAFE_ONLY == TRUE && hasspawns == TRUE) {
                hasspawns = TRUE;
            } else {
                SetLocalLocation(oPCKey, LOGOUT_LOCATION, logloc);
            }
        }
    }

}

//-------------------------------------------------------------------------------
//ambience functions
//-------------------------------------------------------------------------------

// sets the ambience in the area. Is triggered from the ds_area_enter and bobo_commands scripts
void ds_ambience( object oPC,object oArea ){

    //variables
    object oAmbientTemplate;
    string sOverride = GetLocalString( oArea, "tat_override" );

    //check whether Bobo spawned a new ambience waypoint in this area
    if ( sOverride != "yes" ){

        //select the preset waypoint
        oAmbientTemplate = GetNearestObjectByTag( GetLocalString(oArea, "tat" ), oPC, 1 );
    }
    else{

        //select the override waypoint
        oAmbientTemplate=GetNearestObjectByTag( "tat_override", oPC, 1 );
    }

    if ( !GetIsObjectValid( oAmbientTemplate ) ) {

        SetWeather( oArea, GetWeather( oArea ) );
        return;
    }

    //set the mainlights and sourcelights
    ds_set_area_lights(oPC, oArea, "mainlight", oAmbientTemplate);

    //set the weather and the fog
    int nWeather    = GetLocalInt( oAmbientTemplate, "weather" );
    int nFogColor   = GetLocalInt( oAmbientTemplate, "fog_day_colour" );
    int nFogAmount  = GetLocalInt( oAmbientTemplate, "fog_day_amount" );
    int nFogColor2  = GetLocalInt( oAmbientTemplate, "fog_night_colour" );
    int nFogAmount2 = GetLocalInt( oAmbientTemplate, "fog_night_amount" );

    if( nWeather != -1 ){

        SetWeather( oArea, nWeather );
    }
    if( nFogColor != -1 ){

        SetFogColor( FOG_TYPE_SUN, nFogColor, oArea );
    }
    if( nFogAmount != -1 ){

        SetFogAmount( FOG_TYPE_SUN, nFogAmount, oArea );
    }
    if( nFogColor2 != -1 ){

        SetFogColor( FOG_TYPE_MOON, nFogColor2, oArea );
    }
    if( nFogAmount2 != -1 ){

        SetFogAmount( FOG_TYPE_MOON, nFogAmount2, oArea );
    }

    //without this the lighting effects will not kick in
    RecomputeStaticLighting(oArea);
}

//set the mainlights or the sourcelights
void ds_set_area_lights( object oPC, object oArea, string sType, object oAmbientTemplate ){

    //variables
    vector vLocation;
    location lTile;
    int i;
    int j;
    int nAreaX = GetAreaSize( AREA_WIDTH, oArea );
    int nAreaY = GetAreaSize( AREA_HEIGHT, oArea );
    float fX;
    float fY;

    for ( i=0; i<nAreaX; i++ ){

        for ( j=0; j<nAreaY; j++ ){

            //walk through the area and set lights tile by tile
            fX = IntToFloat( i );
            fY = IntToFloat( j );

            //Make a location a tile
            vLocation = Vector( fX, fY, 0.0 );
            lTile     = Location( oArea, vLocation, 0.0 );

            //set the right category of lighting
            if ( sType == "mainlight" ){

                //set both types of mainlight colours in one go
                SetTileMainLightColor( lTile, ds_random_light( oAmbientTemplate, 6, sType ), ds_random_light( oAmbientTemplate, 6, sType ) );
            }

            if ( sType == "sourcelight" ){

                //set both types of sourcelight colours in one go
                //to do: find out whether sourcelight is applied in outside areas.
                SetTileSourceLightColor( lTile, ds_random_light( oAmbientTemplate, 3, sType ), ds_random_light( oAmbientTemplate, 3, sType ) );
            }
        }
    }
}

//gets a random colour from the ambience waypoint (1 out of 6 for mainlights, 1 out of 3 for sourcelights)
int ds_random_light( object oAmbientTemplate, int nDie, string sType ){

    //variables
    int n;

    n = ( Random( nDie ) + 1 );
    return GetLocalInt( oAmbientTemplate, sType+IntToString( n ) );
}

//-------------------------------------------------------------------------------
//utility functions
//-------------------------------------------------------------------------------

//Loops through the waypoints in an area and returns info about available templates
void ds_check_waypoints( object oPC, object oArea ){

    //variables
    int n               = 1;
    int nSpawnTemplates;
    int nSpawnpoints;
    int nAmbienceTemplates;
    string sTag;
    object oWaypoint    = GetNearestObject(OBJECT_TYPE_WAYPOINT,oPC,n);

    while ( oWaypoint != OBJECT_INVALID ){

        sTag = GetTag(oWaypoint);

        if ( FindSubString( sTag,"tat_" ) == 0 && sTag != "tat_override" ){

            SetLocalString( oArea, "tat", sTag );
            ++nAmbienceTemplates;
        }

        if ( FindSubString( sTag, "tst_" ) == 0 ){

            ++nSpawnTemplates;
            SetLocalString( oArea, "tst_"+IntToString( nSpawnTemplates ), sTag );
        }

        ++n;

        oWaypoint = GetNearestObject( OBJECT_TYPE_WAYPOINT, oPC, n );
    }

    SetLocalInt( oArea, "tst", nSpawnTemplates );
    SetLocalInt( oArea, "tst_tat_loaded", 1 );
}

//-------------------------------------------------------------------------------
// Added Flavor
//-------------------------------------------------------------------------------

void glm_addflavorVFX( object oPC, object oArea )
{
    int nAffected = GetLocalInt( oPC, "AreaVFXApplied" );

    if( GetArea( oPC ) == oArea && nAffected == FALSE )
    {
        int nAreaVFX = GetLocalInt( oArea, "AreaVFX" );
        effect eVis = SupernaturalEffect( EffectVisualEffect( nAreaVFX ) );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVis, oPC );
        SetLocalInt( oPC, "AreaVFXApplied", 1 );
    }

}