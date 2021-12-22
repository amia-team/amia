/*  ds_inc_ambience

--------
Verbatim
--------
Sets the same weather in all of Cordor

---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
10-13-06  Disco       Start of header & script hadn't been updated
------------------------------------------------------------------

*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "amia_include"
#include "x2_inc_itemprop"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
//main wrapper, include in area entry event script
void set_ambience(object oPC,object oArea);

//ambience functions
void amb_ambience(object oPC,object oArea);
void amb_cordor(object oPC,object oArea);
void amb_set_area_lights(object oPC, object oArea, string sType, object oAmbientTemplate); //sets tile lighting
int amb_random_light(object oAmbientTemplate, int nDie, string sType);

//utility functions
void amb_check_waypoints(object oPC, object oArea);
int amb_get_area_size(object oArea, string sDirection);

//bobo functions
void amb_override_template(object oPC, object oArea, string sTemplate);
void amb_delayed_override(object oPC, object oArea, string sTemplate);

//-------------------------------------------------------------------------------
//plugin wrapper. NOTE: oPC should be a PC.
//-------------------------------------------------------------------------------

void set_ambience(object oPC,object oArea){

    //safety measure
    if(!GetIsPC(oPC)){
        return;
    }
    if(GetTag(oArea)=="cordor_exterior"){
        amb_cordor(oPC,oArea);
    }
    else if(GetLocalInt(oArea,"tst_tat_loaded")!=1){
        //load waypoints names on area
        amb_check_waypoints(oPC, oArea);

        //store the size of the area on the area
        SetLocalInt(oArea,"nAreaX",amb_get_area_size(oArea,"x"));
        SetLocalInt(oArea,"nAreaY",amb_get_area_size(oArea,"y"));

        //set ambience
        DelayCommand(0.0,amb_ambience(oPC,oArea));
    }
}

//-------------------------------------------------------------------------------
//ambience functions
//-------------------------------------------------------------------------------

// sets the ambience in the area. Is triggered from the amb_area_enter and bobo_commands scripts
void amb_ambience(object oPC,object oArea){

    //variables
    object oAmbientTemplate;
    string sOverride=GetLocalString(oArea,"tat_override");

    //check whether Bobo spawned a new ambience waypoint in this area
    if(sOverride!="yes"){
        //select the preset waypoint
        oAmbientTemplate=GetNearestObjectByTag(GetLocalString(oArea,"tat"),oPC,1);
    }
    else{
        //select the override waypoint
        oAmbientTemplate=GetNearestObjectByTag("tat_override",oPC,1);
    }

    //set the mainlights and sourcelights
    amb_set_area_lights(oPC, oArea, "mainlight", oAmbientTemplate);

    //set the weather and the fog
    SetWeather(oArea,GetLocalInt(oAmbientTemplate,"weather"));
    SetFogColor(FOG_TYPE_SUN,GetLocalInt(oAmbientTemplate,"fog_day_colour"),oArea);
    SetFogAmount(FOG_TYPE_SUN,GetLocalInt(oAmbientTemplate,"fog_day_amount"),oArea);
    SetFogColor(FOG_TYPE_MOON,GetLocalInt(oAmbientTemplate,"fog_night_colour"),oArea);
    SetFogAmount(FOG_TYPE_MOON,GetLocalInt(oAmbientTemplate,"fog_night_amount"),oArea);

    //without this the lighting effects will not kick in
    RecomputeStaticLighting(oArea);
}

// sets synchronised weather in Cordor
void amb_cordor(object oPC,object oArea){

    //SendMessageToPC(GetFirstPC(),"amb_cordor started");

    //first PC that enters sets the weather in the area and blocks any further tries
    if(GetLocalInt(oArea,"weather_loaded")==1){
        //SendMessageToPC(GetFirstPC(),"Area already set, stop script");
        return;
    }

    //variables
    object oCordorWeatherWP = GetObjectByTag("wp_cordor_weather");
    int nWeatherSet         = GetLocalInt(oCordorWeatherWP,"WeatherSet");
    int nFogAmount          = abs(15-d20());
    int nFogColourDay       = FOG_COLOR_WHITE;
    int nFogColourNight     = FOG_COLOR_BLACK;
    int nWeather            = WEATHER_CLEAR;
    int nDie=d8();

    if(nWeatherSet!=1){

        //SendMessageToPC(GetFirstPC(),"WeatherSet != 1");

        //set the weather and the fog and synchronise
        if(nDie==0 || nDie==1 || nDie==2){
            //37.5% chance on perfectly clear weather
            nFogAmount=0;
            nWeather=WEATHER_CLEAR;
        }
        else if(nDie==3){
            //12.5% chance on darker fog and rain
            nFogColourDay=FOG_COLOR_GREY;
            nFogColourNight=FOG_COLOR_GREY;
            nWeather=WEATHER_RAIN;
            nFogAmount=nFogAmount+20;
        }
        else if (nDie==4){
            //12.5 % chance on using tat template
            //load waypoints names on area
            amb_check_waypoints(oPC, oArea);

            //store the size of the area on the area
            SetLocalInt(oArea,"nAreaX",amb_get_area_size(oArea,"x"));
            SetLocalInt(oArea,"nAreaY",amb_get_area_size(oArea,"y"));

            //set ambience
            SetLocalInt(oCordorWeatherWP,"UseTat",1);
            SetLocalInt(oCordorWeatherWP,"WeatherSet",1);
            DelayCommand(0.0,amb_ambience(oPC,oArea));

            //block any further tries
            SetLocalInt(oArea,"weather_loaded",1);

            //test
            //SendMessageToPC(GetFirstPC(),"Local template used and stored on global template");

            return;
        }

        //load settings onto waypoint for use in the other areas
        SetLocalInt(oCordorWeatherWP,"Weather",nWeather);
        SetLocalInt(oCordorWeatherWP,"FogAmount",nFogAmount);
        SetLocalInt(oCordorWeatherWP,"FogColourDay",nFogColourDay);
        SetLocalInt(oCordorWeatherWP,"FogColourNight",nFogColourNight);
        SetLocalInt(oCordorWeatherWP,"WeatherSet",1);

        //set weather and fog from variable (to dodge lag blocking effects)
        SetWeather(oArea,nWeather);
        SetFogColor(FOG_TYPE_SUN,nFogColourDay,oArea);
        SetFogColor(FOG_TYPE_MOON,nFogColourNight,oArea);
        SetFogAmount(FOG_TYPE_ALL,nFogAmount,oArea);

        //test
        //SendMessageToPC(GetFirstPC(),"Settings created and set on global template");
    }
    else{
        //SendMessageToPC(GetFirstPC(),"WeatherSet == 1");

        //set weather and fog from waypoint
        if(GetLocalInt(oCordorWeatherWP,"UseTat")!=1){
            SetWeather(oArea,GetLocalInt(oCordorWeatherWP,"Weather"));
            SetFogColor(FOG_TYPE_MOON,GetLocalInt(oCordorWeatherWP,"FogColourNight"),oArea);
            SetFogColor(FOG_TYPE_SUN,GetLocalInt(oCordorWeatherWP,"FogColourDay"),oArea);
            SetFogAmount(FOG_TYPE_ALL,GetLocalInt(oCordorWeatherWP,"FogAmount"),oArea);

            //test
            //SendMessageToPC(GetFirstPC(),"Settings loaded from global template");
        }
        else{
            //load waypoints names on area
            amb_check_waypoints(oPC, oArea);

            //store the size of the area on the area
            SetLocalInt(oArea,"nAreaX",amb_get_area_size(oArea,"x"));
            SetLocalInt(oArea,"nAreaY",amb_get_area_size(oArea,"y"));

            //set ambience
            DelayCommand(0.0,amb_ambience(oPC,oArea));

            //test
            //SendMessageToPC(GetFirstPC(),"Settings loaded from local template");
        }
    }

    //block any further tries
    SetLocalInt(oArea,"weather_loaded",1);
}

//set the mainlights or the sourcelights
void amb_set_area_lights(object oPC, object oArea, string sType, object oAmbientTemplate){

    //variables
    vector vLocation;
    location lTile;
    int i;
    int j;
    int nAreaX=GetLocalInt(oArea,"nAreaX");
    int nAreaY=GetLocalInt(oArea,"nAreaY");
    float fX;
    float fY;

    //store the size of the area if it isn't done yet
    if(nAreaX==0 || nAreaY==0){
        //calculate X,Y
        nAreaX=amb_get_area_size(oArea,"x");
        nAreaY=amb_get_area_size(oArea,"y");

        //store in area
        SetLocalInt(oArea,"nAreaX",nAreaX);
        SetLocalInt(oArea,"nAreaY",nAreaY);
    }

    for (i=0; i<nAreaX; i++){
        for (j=0; j<nAreaY; j++){

            //walk through the area and set lights tile by tile
            fX=IntToFloat(i);
            fY=IntToFloat(j);

            //Make a location a tile
            vLocation = Vector(fX, fY, 0.0);
            lTile = Location(oArea, vLocation, 0.0);

            //set the right category of lighting
            if(sType=="mainlight"){
                //set both types of mainlight colours in one go
                SetTileMainLightColor(lTile,amb_random_light(oAmbientTemplate,6,sType),amb_random_light(oAmbientTemplate,6,sType));
            }
            if(sType=="sourcelight"){
                //set both types of sourcelight colours in one go
                //to do: find out whether sourcelight is applied in outside areas.
                SetTileSourceLightColor(lTile, amb_random_light(oAmbientTemplate,3,sType), amb_random_light(oAmbientTemplate,3,sType));
            }
        }
    }
}

//gets a random colour from the ambience waypoint (1 out of 6 for mainlights, 1 out of 3 for sourcelights)
int amb_random_light(object oAmbientTemplate, int nDie, string sType){

    //variables
    int n;

    n=(Random(nDie)+1);
    return GetLocalInt(oAmbientTemplate,sType+IntToString(n));
}

//-------------------------------------------------------------------------------
//utility functions
//-------------------------------------------------------------------------------

//Loops through the waypoints in an area and returns info about available templates
void amb_check_waypoints(object oPC, object oArea){

    //variables
    int n=1;
    int nAmbienceTemplates;
    string sTag;
    object oWaypoint=GetNearestObject(OBJECT_TYPE_WAYPOINT,oPC,n);

    while(oWaypoint!=OBJECT_INVALID){
        sTag=GetTag(oWaypoint);
        if (FindSubString(sTag,"tat_")==0 && sTag!="tat_override"){
            SetLocalString(oArea,"tat",sTag);
            ++nAmbienceTemplates;
        }
        ++n;
        oWaypoint=GetNearestObject(OBJECT_TYPE_WAYPOINT,oPC,n);
    }

    //use while testing areas.
    if(nAmbienceTemplates==0){
        //SendMessageToPC(oPC, "Warning: There is no ambience template in this area.");
    }
    if(nAmbienceTemplates>1){
        //SendMessageToPC(oPC, "Warning: There is more than one ambience template in this area.");
    }
    SetLocalInt(oArea,"tst_tat_loaded",1);
}

//adapted the script from whatshisname
int amb_get_area_size(object oArea, string sDirection){

    //variables
    int nSize;
    int nLight;
    vector vTile;
    location lTile;

    while(nLight!=517){
        if(sDirection=="x"){
            vTile=Vector(IntToFloat(nSize), 0.0);
        }
        else if(sDirection=="y"){
            vTile=Vector(0.0, IntToFloat(nSize));
        }
        lTile=Location(oArea, vTile, 0.0);
        nLight=GetTileMainLight1Color(lTile);
        ++nSize;
    }
    return(nSize-1);    //a while loop always goes 'one too many'
}

//-------------------------------------------------------------------------------
//bobo functions
//-------------------------------------------------------------------------------
void tha_override_template(object oPC, object oArea, string sTemplate){

    //variables
    string sType="tat";

    //destroy the previous override template waypoint and data stored on area
    DestroyObject(GetNearestObjectByTag("tat_override", oPC, 1), 0.0);
    DeleteLocalString(oArea,"tat_override");

    //something fishy was going on...  put a timer onnit
    DelayCommand(1.0,amb_delayed_override(oPC, oArea, sTemplate));

}

void amb_delayed_override(object oPC, object oArea, string sTemplate){

    //variables
    object oTemplate;
    location lTarget;

    //'reset' doesn't spawn a new waypoint and deletes the vars stored in the area
    if (sTemplate!="reset"){
        //store the name of the original template on the area
        sTemplate="tat_"+sTemplate;
        SetLocalString(oArea,"tat_override","yes");

        //this creates an ambient template waypoint
        lTarget = GetLocation(oPC);
        oTemplate=CreateObject(OBJECT_TYPE_WAYPOINT, sTemplate, lTarget, FALSE, "tat_override");

        //report missing blueprint
        if(oTemplate==OBJECT_INVALID){
            SendMessageToPC(oPC, "Error: This blueprint ("+sTemplate+") is not available in the toolset.");
            return;
        }
    }

    //ambience is applied
    amb_ambience(oPC, oArea);
}
