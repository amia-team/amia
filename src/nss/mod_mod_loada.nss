//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: mod_mod_load
//group: module events
//used as: OnModuleLoad
//date: 2008-06-03
//author: Disco (copied & cleaned from old scripts)

//2009-02-08  disco  updated with jobs cacher
// 2009/02/23 disco  Updated racial/class/area effects refresher
// 2015/08/19 FW     updated terra's script to support recursion

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "x2_inc_switches"
#include "amia_include"
#include "inc_ds_j_lib"
#include "inc_td_sysdata"
#include "inc_ds_onupdate"
#include "nwnx_dynres"
#include "nwnx_tmi"
#include "inc_lua"
#include "nwnx_areas"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

// Sets the current server time from the last persisted timestamp.
void SetDateFromDB( );

//LOGS START OF SERVER TO EXPLOITS TABLE
void LogStart( object oModule );

//assign random skybox to areas not having one
//also caches area list for later use
void SetSkyBoxes();

//custom colours for convos
void InitialiseColours();

// this function sets weather in all areas that contain an
// object with the tag sRegion. Mind that this needs a list
// of weather data with that tag in the database...
void SetRegionWeather( string sRegion );

//Registers the modulefile to dynres
void RegisterModuleFile( );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main( ){

    // Sets the maximum amount of henchmen per player to 50.
    SetMaxHenchmen(50);




    // Rolls to see if any invasions will happen this reset. 1/6 chance so about once a day with the 4 hour reset.
    int nInvasionGoblins = Random(6);
    int nInvasionKobolds = Random(6);
    int nInvasionOrcs = Random(6);
    int nInvasionTrolls = Random(6);

    // Randomly rolls the time the invasion will occur
    int nInvasionGoblinsTime = Random(18);
    int nInvasionKoboldsTime = Random(18);
    int nInvasionOrcsTime = Random(18);
    int nInvasionTrollsTime = Random(18);




    if(nInvasionGoblins == 5)
    {
       SetLocalInt(GetModule(),"invasiongobs",1);

          // The invasion command will be launched on a delay based on the random variable.
         if(nInvasionGoblinsTime == 0) // 30 minutes after reset
         {
           // DelayCommand(1800.0,);
           SetLocalInt(GetModule(),"invasiongobstime",30);
         }
         else if(nInvasionGoblinsTime == 1) // Every ten minutes going up to 3 hrs and 30 mins
         {
            // DelayCommand(2400.0,);
           SetLocalInt(GetModule(),"invasiongobstime",40);
         }
         else if(nInvasionGoblinsTime == 2)
         {
          // DelayCommand(3000.0,);
           SetLocalInt(GetModule(),"invasiongobstime",50);
         }
         else if(nInvasionGoblinsTime == 3)
         {
           // DelayCommand(3600.0,);
           SetLocalInt(GetModule(),"invasiongobstime",60);
         }
         else if(nInvasionGoblinsTime == 4)
         {
          // DelayCommand(4200.0,);
           SetLocalInt(GetModule(),"invasiongobstime",70);
          }
         else if(nInvasionGoblinsTime == 5)
         {
          // DelayCommand(4800.0,);
           SetLocalInt(GetModule(),"invasiongobstime",80);
         }
         else if(nInvasionGoblinsTime == 6)
         {
          // DelayCommand(5400.0,);
           SetLocalInt(GetModule(),"invasiongobstime",90);
         }
         else if(nInvasionGoblinsTime == 7)
         {
          // DelayCommand(6000.0,);
           SetLocalInt(GetModule(),"invasiongobstime",100);
         }
         else if(nInvasionGoblinsTime == 8)
         {
          // DelayCommand(6600.0,);
           SetLocalInt(GetModule(),"invasiongobstime",110);
         }
         else if(nInvasionGoblinsTime == 9)
         {
           // DelayCommand(7200.0,);
           SetLocalInt(GetModule(),"invasiongobstime",120);
         }
         else if(nInvasionGoblinsTime == 10)
         {
          // DelayCommand(7800.0,);
           SetLocalInt(GetModule(),"invasiongobstime",130);
         }
         else if(nInvasionGoblinsTime == 11)
         {
          // DelayCommand(8400.0,);
           SetLocalInt(GetModule(),"invasiongobstime",140);
         }
         else if(nInvasionGoblinsTime == 12)
         {
          // DelayCommand(9000.0,);
           SetLocalInt(GetModule(),"invasiongobstime",150);
         }
         else if(nInvasionGoblinsTime == 13)
         {
          // DelayCommand(9600.0,);
           SetLocalInt(GetModule(),"invasiongobstime",160);
         }
         else if(nInvasionGoblinsTime == 14)
         {
          // DelayCommand(10200.0,);
           SetLocalInt(GetModule(),"invasiongobstime",170);
         }
         else if(nInvasionGoblinsTime == 15)
         {
           // DelayCommand(10800.0,);
           SetLocalInt(GetModule(),"invasiongobstime",180);
         }
         else if(nInvasionGoblinsTime == 16)
         {
          // DelayCommand(11400.0,);
           SetLocalInt(GetModule(),"invasiongobstime",190);
         }
         else if(nInvasionGoblinsTime == 17)  // 3 hrs and 30 mins after reset
         {
          // DelayCommand(12000.0,);
           SetLocalInt(GetModule(),"invasiongobstime",200);
         }
         //
    }

    if(nInvasionKobolds == 5)
    {
       SetLocalInt(GetModule(),"invasionkobs",1);

          // The invasion command will be launched on a delay based on the random variable.
         if(nInvasionKoboldsTime == 0) // 30 minutes after reset
         {
           // DelayCommand(1800.0,);
           SetLocalInt(GetModule(),"invasionkobstime",30);
         }
         else if(nInvasionKoboldsTime == 1) // Every ten minutes going up to 3 hrs and 30 mins
         {
            // DelayCommand(2400.0,);
           SetLocalInt(GetModule(),"invasionkobstime",40);
         }
         else if(nInvasionKoboldsTime == 2)
         {
          // DelayCommand(3000.0,);
           SetLocalInt(GetModule(),"invasionkobstime",50);
         }
         else if(nInvasionKoboldsTime == 3)
         {
           // DelayCommand(3600.0,);
           SetLocalInt(GetModule(),"invasionkobstime",60);
         }
         else if(nInvasionKoboldsTime == 4)
         {
          // DelayCommand(4200.0,);
           SetLocalInt(GetModule(),"invasionkobstime",70);
          }
         else if(nInvasionKoboldsTime == 5)
         {
          // DelayCommand(4800.0,);
           SetLocalInt(GetModule(),"invasionkobstime",80);
         }
         else if(nInvasionKoboldsTime == 6)
         {
          // DelayCommand(5400.0,);
           SetLocalInt(GetModule(),"invasionkobstime",90);
         }
         else if(nInvasionKoboldsTime == 7)
         {
          // DelayCommand(6000.0,);
           SetLocalInt(GetModule(),"invasionkobstime",100);
         }
         else if(nInvasionKoboldsTime == 8)
         {
          // DelayCommand(6600.0,);
           SetLocalInt(GetModule(),"invasionkobstime",110);
         }
         else if(nInvasionKoboldsTime == 9)
         {
           // DelayCommand(7200.0,);
           SetLocalInt(GetModule(),"invasionkobstime",120);
         }
         else if(nInvasionKoboldsTime == 10)
         {
          // DelayCommand(7800.0,);
           SetLocalInt(GetModule(),"invasionkobstime",130);
         }
         else if(nInvasionKoboldsTime == 11)
         {
          // DelayCommand(8400.0,);
           SetLocalInt(GetModule(),"invasionkobstime",140);
         }
         else if(nInvasionKoboldsTime == 12)
         {
          // DelayCommand(9000.0,);
           SetLocalInt(GetModule(),"invasionkobstime",150);
         }
         else if(nInvasionKoboldsTime == 13)
         {
          // DelayCommand(9600.0,);
           SetLocalInt(GetModule(),"invasionkobstime",160);
         }
         else if(nInvasionKoboldsTime == 14)
         {
          // DelayCommand(10200.0,);
           SetLocalInt(GetModule(),"invasionkobstime",170);
         }
         else if(nInvasionKoboldsTime == 15)
         {
           // DelayCommand(10800.0,);
           SetLocalInt(GetModule(),"invasionkobstime",180);
         }
         else if(nInvasionKoboldsTime == 16)
         {
          // DelayCommand(11400.0,);
           SetLocalInt(GetModule(),"invasionkobstime",190);
         }
         else if(nInvasionKoboldsTime == 17)  // 3 hrs and 30 mins after reset
         {
          // DelayCommand(12000.0,);
           SetLocalInt(GetModule(),"invasionkobstime",200);
         }
         //
    }

    if(nInvasionOrcs == 5)
    {
       SetLocalInt(GetModule(),"invasionorcs",1);

          // The invasion command will be launched on a delay based on the random variable.
         if(nInvasionOrcsTime == 0) // 30 minutes after reset
         {
           // DelayCommand(1800.0,);
           SetLocalInt(GetModule(),"invasionorcstime",30);
         }
         else if(nInvasionOrcsTime == 1) // Every ten minutes going up to 3 hrs and 30 mins
         {
            // DelayCommand(2400.0,);
           SetLocalInt(GetModule(),"invasionorcstime",40);
         }
         else if(nInvasionOrcsTime == 2)
         {
          // DelayCommand(3000.0,);
           SetLocalInt(GetModule(),"invasionorcstime",50);
         }
         else if(nInvasionOrcsTime == 3)
         {
           // DelayCommand(3600.0,);
           SetLocalInt(GetModule(),"invasionorcstime",60);
         }
         else if(nInvasionOrcsTime == 4)
         {
          // DelayCommand(4200.0,);
           SetLocalInt(GetModule(),"invasionorcstime",70);
          }
         else if(nInvasionOrcsTime == 5)
         {
          // DelayCommand(4800.0,);
           SetLocalInt(GetModule(),"invasionorcstime",80);
         }
         else if(nInvasionOrcsTime == 6)
         {
          // DelayCommand(5400.0,);
           SetLocalInt(GetModule(),"invasionorcstime",90);
         }
         else if(nInvasionOrcsTime == 7)
         {
          // DelayCommand(6000.0,);
           SetLocalInt(GetModule(),"invasionorcstime",100);
         }
         else if(nInvasionOrcsTime == 8)
         {
          // DelayCommand(6600.0,);
           SetLocalInt(GetModule(),"invasionorcstime",110);
         }
         else if(nInvasionOrcsTime == 9)
         {
           // DelayCommand(7200.0,);
           SetLocalInt(GetModule(),"invasionorcstime",120);
         }
         else if(nInvasionOrcsTime == 10)
         {
          // DelayCommand(7800.0,);
           SetLocalInt(GetModule(),"invasionorcstime",130);
         }
         else if(nInvasionOrcsTime == 11)
         {
          // DelayCommand(8400.0,);
           SetLocalInt(GetModule(),"invasionorcstime",140);
         }
         else if(nInvasionOrcsTime == 12)
         {
          // DelayCommand(9000.0,);
           SetLocalInt(GetModule(),"invasionorcstime",150);
         }
         else if(nInvasionOrcsTime == 13)
         {
          // DelayCommand(9600.0,);
           SetLocalInt(GetModule(),"invasionorcstime",160);
         }
         else if(nInvasionOrcsTime == 14)
         {
          // DelayCommand(10200.0,);
           SetLocalInt(GetModule(),"invasionorcstime",170);
         }
         else if(nInvasionOrcsTime == 15)
         {
           // DelayCommand(10800.0,);
           SetLocalInt(GetModule(),"invasionorcstime",180);
         }
         else if(nInvasionOrcsTime == 16)
         {
          // DelayCommand(11400.0,);
           SetLocalInt(GetModule(),"invasionorcstime",190);
         }
         else if(nInvasionOrcsTime == 17)  // 3 hrs and 30 mins after reset
         {
          // DelayCommand(12000.0,);
           SetLocalInt(GetModule(),"invasionorcstime",200);
         }
         //
    }

    if(nInvasionTrolls == 5)
    {
       SetLocalInt(GetModule(),"invasiontrolls",1);

          // The invasion command will be launched on a delay based on the random variable.
         if(nInvasionTrollsTime == 0) // 30 minutes after reset
         {
           // DelayCommand(1800.0,);
           SetLocalInt(GetModule(),"invasiontrollstime",30);
         }
         else if(nInvasionTrollsTime == 1) // Every ten minutes going up to 3 hrs and 30 mins
         {
            // DelayCommand(2400.0,);
           SetLocalInt(GetModule(),"invasiontrollstime",40);
         }
         else if(nInvasionTrollsTime == 2)
         {
          // DelayCommand(3000.0,);
           SetLocalInt(GetModule(),"invasiontrollstime",50);
         }
         else if(nInvasionTrollsTime == 3)
         {
           // DelayCommand(3600.0,);
           SetLocalInt(GetModule(),"invasiontrollstime",60);
         }
         else if(nInvasionTrollsTime == 4)
         {
          // DelayCommand(4200.0,);
           SetLocalInt(GetModule(),"invasiontrollstime",70);
          }
         else if(nInvasionTrollsTime == 5)
         {
          // DelayCommand(4800.0,);
           SetLocalInt(GetModule(),"invasiontrollstime",80);
         }
         else if(nInvasionTrollsTime == 6)
         {
          // DelayCommand(5400.0,);
           SetLocalInt(GetModule(),"invasiontrollstime",90);
         }
         else if(nInvasionTrollsTime == 7)
         {
          // DelayCommand(6000.0,);
           SetLocalInt(GetModule(),"invasiontrollstime",100);
         }
         else if(nInvasionTrollsTime == 8)
         {
          // DelayCommand(6600.0,);
           SetLocalInt(GetModule(),"invasiontrollstime",110);
         }
         else if(nInvasionTrollsTime == 9)
         {
           // DelayCommand(7200.0,);
           SetLocalInt(GetModule(),"invasiontrollstime",120);
         }
         else if(nInvasionTrollsTime == 10)
         {
          // DelayCommand(7800.0,);
           SetLocalInt(GetModule(),"invasiontrollstime",130);
         }
         else if(nInvasionTrollsTime == 11)
         {
          // DelayCommand(8400.0,);
           SetLocalInt(GetModule(),"invasiontrollstime",140);
         }
         else if(nInvasionTrollsTime == 12)
         {
          // DelayCommand(9000.0,);
           SetLocalInt(GetModule(),"invasiontrollstime",150);
         }
         else if(nInvasionTrollsTime == 13)
         {
          // DelayCommand(9600.0,);
           SetLocalInt(GetModule(),"invasiontrollstime",160);
         }
         else if(nInvasionTrollsTime == 14)
         {
          // DelayCommand(10200.0,);
           SetLocalInt(GetModule(),"invasiontrollstime",170);
         }
         else if(nInvasionTrollsTime == 15)
         {
           // DelayCommand(10800.0,);
           SetLocalInt(GetModule(),"invasiontrollstime",180);
         }
         else if(nInvasionTrollsTime == 16)
         {
          // DelayCommand(11400.0,);
           SetLocalInt(GetModule(),"invasiontrollstime",190);
         }
         else if(nInvasionTrollsTime == 17)  // 3 hrs and 30 mins after reset
         {
          // DelayCommand(12000.0,);
           SetLocalInt(GetModule(),"invasiontrollstime",200);
         }
         //
         }

    //Kill the script, will call the mod script again when the areas are loaded
    if( GetLocalInt( OBJECT_SELF, "halfdynloaded" ) != 1 )
    {
        //We got 4 times the TMI limit
        SetTMILimit( GetTMILimit( ) * 4 );

        //Run our lua startscript
            string sLua = NWNX_ReadStringFromINI( "AMIA", "Lua", "0", "./nwnx.ini" );
            if( sLua != "0" )
                PrintString( "Running mod load! " + sLua + ": " + ExecuteLuaString( OBJECT_SELF, "dofile( '"+sLua+"' )" ) );
            else
                PrintString( "Running mod load!" );

        //We need to load external areas first, if any
        DelayCommand(0.1, ExecuteScript("fw_halfdynamic", OBJECT_SELF));

        //Done until fw_halfdynamic reports back.
        return;
    }

    //start database
    SQLInit( );

    // Variables
    object oModule          = GetModule( );

    // Setting the switch below will enable a seperate Use Magic Device
    // Skill check for rogues when playing on Hardcore+ difficulty. This
    // only applies to scrolls.
    SetModuleSwitch( MODULE_SWITCH_ENABLE_UMD_SCROLLS, FALSE );

    // Spellcasting: Some people don't like caster's abusing expertise to
    // raise their AC.  Uncommenting this line will drop expertise mode
    // whenever a spell is cast by a player.
    SetModuleSwitch( MODULE_VAR_AI_STOP_EXPERTISE_ABUSE, TRUE );

    // Enable Tag-based scripting support and security ScriptName Prefix
    SetModuleSwitch( MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, TRUE );
    SetUserDefinedItemEventPrefix( "i_" );

    //set convo colour tokens
    InitialiseColours();

    //close previous records
    CloseRecords( oModule );

    //caching
    CacheCache( "ds_pckey_storage" );
    DelayCommand( 0.2, CacheBannedCDKEY() );
    DelayCommand( 0.4, CacheBannedIP() );
    DelayCommand( 0.6, CacheDMs() );
    DelayCommand( 0.8, CacheDates() );
    DelayCommand( 1.0, CacheContraband() );
    DelayCommand( 1.2, CacheBindpoints() );
    DelayCommand( 1.2, CacheUpdates() );
    DelayCommand( 1.4, CachePatrols() );

    //job system
    DelayCommand( 1.6, ds_j_InitialiseSystems( oModule ) );

    //skyboxes
    DelayCommand( 6.0, SetSkyBoxes() );

    //set start record
    DelayCommand( 8.0, UpdateDatabase( oModule ) );

    //rules
    DelayCommand( 9.0, ImportRules() );

    DelayCommand( 10.0, SetRegionWeather( "rua" ) );

    //dynamic file
    DelayCommand( 15.0, RegisterModuleFile( ) );


    SetLuaKeyValueTable("time");
    int unixTS = StringToInt(RunLua("local currenttime=os.time(); nwscript = nwscript or {}; nwscript.time=os.date('*t', currenttime); return currenttime;"));
    int iYear = StringToInt(GetLuaKeyValue("year"));
    int iMonth = StringToInt(GetLuaKeyValue("month"));
    int iDay = StringToInt(GetLuaKeyValue("day"));

    // date floor
    int iYearDiff = iYear - 2015;
    int bYear = 1383;  // 1383 = 2015, 1384 = 2016, . . .
    iYear = bYear + iYearDiff;

    // nwn only accepts up to 28 days
    if(iDay > 28){
        iDay = 28;
    }
    PrintString( "The current system date is: "+IntToString(iYear)+"/"+IntToString(iMonth)+"/"+IntToString(iDay)+"" );
    SetCalendar(iYear,iMonth,iDay);

    //Set the time of the server (using DB)
    string sTimeString = GetPersistentString(oModule, "TIME", "pwdata");
    PrintString( "The current database time is: " + sTimeString );
    StringToInt(RunLua("local test = '"+sTimeString+"'; nwscript=nwscript or {};nwscript.parse = {};for str in test:gmatch('([^_]+)') do table.insert(nwscript.parse,str); end;"));
    SetLuaKeyValueTable("parse");
    // worse case scenario it starts at 0,0,0,0 (valid) because it cant find the database
    int iHour = StringToInt(GetLuaIndexValue(1));
    int iMinute = StringToInt(GetLuaIndexValue(2));
    int iSecond = StringToInt(GetLuaIndexValue(3));
    int iMS = StringToInt(GetLuaIndexValue(4));

    SetTime(iHour,iMinute,iSecond,iMS);

    //tries to counter hangings
    DelayCommand( 300.0, ExecuteScript( "amia_keepalive", oModule ) );

    //read testserver setting from nwnx_ini
    //this fixes servervault path for test kits
    if ( ReadBooleanFromINI( "AMIA", "ServerTesting", FALSE, "./NWNX.ini" ) ){

        SetLocalInt( oModule, "testserver", 1 );

        SetLocalString( oModule, "SisterServer", GetLocalString( oModule, "SisterTestServer" ) );
    }

    if ( GetLocalInt( oModule, "Module" ) == 1 ){

         SetCustomToken( 5130, "<c¦  >This option will jump you to the other server. Partymembers will not come along.</c>" );
         SetCustomToken( 5131, "<c ¦ >This option will jump you and your partymembers to this location.</c>" );
    }
    else{

         SetCustomToken( 5131, "<c¦  >This option will jump you to the other server. Partymembers will not come along.</c>" );
         SetCustomToken( 5130, "<c ¦ >This option will jump you and your partymembers to this location.</c>" );
    }

    //store startdate on module
    SetLocalInt( oModule, "starttime", GetRunTime() );
    SetLocalString( oModule, "sessionid", IntToString( GetLocalInt( oModule, "Module" ) )+"_"+IntToString( GetCurrentSecond( TRUE ) ) );

    //get NoRestore casters
    SetLocalObject( oModule, "ds_areaeffects", GetObjectByTag( "ds_areaeffects" ) );
    SetLocalObject( oModule, "ds_permeffects", GetObjectByTag( "ds_permeffects" ) );

    return;
}



//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------
void SetSkyBoxes(){

    object oAreaMarker;
    object oAreaList = GetCache( "ds_area_storage" );
    object oArea     = GetArea( GetObjectByTag( "is_area", 0 ) );
    float fDelay;
    int i;
    int nAreas;

    while ( GetIsObjectValid( oArea ) ){

        //we don't want double entries due to double waypoints in an area
        if (GetLocalObject( oAreaList, GetResRef( oArea ) ) == OBJECT_INVALID ){

            ++nAreas;

            SetLocalInt( oAreaList, GetResRef( oArea ), nAreas );
            SetLocalString( oAreaList, "a_"+IntToString(nAreas), GetResRef( oArea ) );
            SetLocalObject( oAreaList, GetResRef( oArea ), oArea );

            if ( GetIsAreaInterior( oArea ) == FALSE &&
                 GetIsAreaAboveGround( oArea ) == AREA_ABOVEGROUND &&
                 GetSkyBox( oArea ) == SKYBOX_NONE ){

                fDelay = 1.0 + i/10.0;

                DelayCommand( fDelay, SetSkyBox( d4(), oArea ) );
            }
        }

        oArea = GetArea( GetObjectByTag( "is_area", nAreas ) );
    }

    SetLocalInt( oAreaList, "ds_count", nAreas );
}

void InitialiseColours(){

    SetCustomToken( 5100, "</c>" ); // CLOSE tag
    SetCustomToken( 5101, "<c¦  >" ); // red
    SetCustomToken( 5102, "<c ¦ >" ); // green
    SetCustomToken( 5103, "<c  ¦>" ); // blue
    SetCustomToken( 5104, "<c ¦¦>" ); // cyan
    SetCustomToken( 5105, "<c¦ ¦>" ); // magenta
    SetCustomToken( 5106, "<c¦¦ >" ); // yellow
    SetCustomToken( 5107, "<c   >" ); // black
    SetCustomToken( 5108, "<c?  >" ); // dark red
    SetCustomToken( 5109, "<c ? >" ); // dark green
    SetCustomToken( 5110, "<c  ?>" ); // dark blue
    SetCustomToken( 5111, "<c ??>" ); // dark cyan
    SetCustomToken( 5112, "<c? ?>" ); // dark magenta
    SetCustomToken( 5113, "<c?? >" ); // dark yellow
    SetCustomToken( 5114, "<c???>" ); // grey
    SetCustomToken( 5117, "<c???>" ); // dark grey
    SetCustomToken( 5115, "<c¦? >" ); // orange
    SetCustomToken( 5116, "<c¦? >" ); // dark orange
    SetCustomToken( 5117, "<c+?#>" ); // brown
    SetCustomToken( 5118, "<c-? >" ); // dark brown

}


void SetRegionWeather( string sRegion ){

    if ( sRegion == "" ){

        return;
    }

    //--------------------------------------------
    //variables
    //--------------------------------------------
    object oRegionFlag;
    object oArea;
    location lRegionFlag;
    string sQuery;
    string sWind;
    string sRain;
    string sRegionFlag = "ds_w_"+sRegion;
    int nWeather;
    int nWind;
    int nMinTemp;
    int nSunshine;
    int nRaintime;
    int nFogAmount;
    int nTempDiff;
    int nSkyBox;
    int nNth;
    int nFogDayColor   = 0xEEEEEE; //light grey
    int nFogNightColor = 0xAAAAAA; //darker grey


    //--------------------------------------------
    //check if at least one flag is available
    //--------------------------------------------
    oRegionFlag = GetObjectByTag( sRegionFlag );

    if ( !GetIsObjectValid( oRegionFlag ) ){

        return;
    }

    //--------------------------------------------
    //SQL query
    //--------------------------------------------
    sQuery = "SELECT wind_speed, min_temp, sun_percentage, rain_time, view_distance, max_temp-min_temp FROM `weather` WHERE area='"+sRegion+"' and day=DATE_FORMAT(NOW(), '1%m%d') LIMIT 1";
    SQLExecDirect( sQuery );

    if ( SQLFetch( ) == SQL_SUCCESS ){

        nWind       = StringToInt( SQLGetData( 1 ) ) / 25;
        nMinTemp    = StringToInt( SQLGetData( 2 ) );
        nSunshine   = StringToInt( SQLGetData( 3 ) );
        nRaintime   = StringToInt( SQLGetData( 4 ) );
        nFogAmount  = 80 - StringToInt( SQLGetData( 5 ) );
        nTempDiff   = StringToInt( SQLGetData( 6 ) );
    }
    else{

        return;
    }


    //--------------------------------------------
    //wind
    //--------------------------------------------
    if ( nWind > 4 ){

        sWind = "ds_wind_4";
    }
    else if ( nWind > 0 ){

        sWind = "ds_wind_"+IntToString( nWind );
    }

    //--------------------------------------------
    //rain
    //--------------------------------------------
    if ( d100() < nRaintime ){

        if ( nMinTemp < 0 ){

            nWeather = WEATHER_SNOW;

            nSkyBox = SKYBOX_WINTER_CLEAR;

            nFogDayColor = 0xFFFFFF;

            nFogNightColor = 0xBBBBBB;
        }
        else{

            nWeather = WEATHER_RAIN;

            nSkyBox = SKYBOX_GRASS_STORM;

            if ( nRaintime > 70 ){

                sRain = "ds_rain_3";
            }
            else if ( nRaintime > 30 ){

                sRain = "ds_rain_2";
            }
            else if ( nRaintime > 0 ){

                sRain = "ds_rain_1";
            }
        }
    }
    else{

        nWeather = WEATHER_CLEAR;

        nSkyBox = SKYBOX_GRASS_CLEAR;
    }


    //--------------------------------------------
    //loop through areas
    //--------------------------------------------
    while ( GetIsObjectValid( oRegionFlag ) ){

        oArea       = GetArea( oRegionFlag );
        lRegionFlag = GetLocation( oRegionFlag );

        //--------------------------------------------
        //apply wind
        //--------------------------------------------
        if ( sWind != "" ){

            CreateObject( OBJECT_TYPE_WAYPOINT, sWind, lRegionFlag );
        }

        //--------------------------------------------
        //apply rain/snow
        //--------------------------------------------
        SetWeather( oArea, nWeather );

        if ( nWeather == WEATHER_RAIN ){

            CreateObject( OBJECT_TYPE_WAYPOINT, sRain, lRegionFlag );
        }

        //--------------------------------------------
        //thunder
        //--------------------------------------------
        if ( nTempDiff > 75 && nMinTemp > 0 ){

            CreateObject( OBJECT_TYPE_WAYPOINT, "ds_w_thunder", lRegionFlag );

            nSkyBox = SKYBOX_GRASS_STORM;

            nFogDayColor = 0xDDDDDD;

            nFogNightColor = 0x999999;
        }

        //--------------------------------------------
        //skydome
        //--------------------------------------------
        SetSkyBox( nSkyBox, oArea );

        //--------------------------------------------
        //fog
        //--------------------------------------------
        if ( nFogAmount < 0 ){

            nFogAmount = 0;
        }

        if ( nFogAmount > 25 ){

            //override fog colour
            SetFogColor( FOG_TYPE_SUN, nFogDayColor, oArea );
            SetFogColor( FOG_TYPE_MOON, nFogNightColor, oArea );
        }

        SetFogAmount( FOG_TYPE_ALL, nFogAmount, oArea );

        //--------------------------------------------
        //store some vars on the area, needed for changes within resets
        //--------------------------------------------
        //SetLocalInt( oArea, "ds_w_set", 1 );
        //SetLocalInt( oArea, "ds_w_rain", nRaintime );
        //SetLocalInt( oArea, "ds_w_temp", nMinTemp );

        //--------------------------------------------
        //remove any old weather templates
        //--------------------------------------------
        DestroyObject( GetNearestObjectByTag( "tat", oRegionFlag ), 1.0 );

        ++nNth;
        oRegionFlag = GetObjectByTag( sRegionFlag, nNth );
    }
}
void Cache( string sFile, string sFull ){

    DYNRES_AddFile( sFile, sFull );
    DYNRES_CacheFile( sFile );
}

void RegisterModuleFile( ){

    //Long string, extra buffer
    string sDef = "There was nothing here, pretty sad";
    string sMod = NWNX_ReadStringFromINI( "AMIA", "Mod", sDef, "./NWNX.ini" );
    string sMini = NWNX_ReadStringFromINI( "NWNX", "ModuleName", sDef, "./NWNX.ini" );
    if( sDef == sMod || sDef == sMini )
        return;

    /*Cache( "mod_acq_item.ncs", sMod );
    Cache( "mod_act_item.ncs", sMod );
    Cache( "mod_cli_enter.ncs", sMod );
    Cache( "mod_cli_leave.ncs", sMod );
    Cache( "mod_hb.ncs", sMod );
    Cache( "mod_pla_chat.ncs", sMod );
    Cache( "mod_pla_death.ncs", sMod );
    Cache( "mod_pla_dying.ncs", sMod );
    Cache( "mod_equ_item.ncs", sMod );
    Cache( "mod_pla_levelup.ncs", sMod );
    Cache( "mod_pla_respawn.ncs", sMod );
    Cache( "mod_pla_rest.ncs", sMod );
    Cache( "mod_unequ_item.ncs", sMod );
    Cache( "mod_unacq_item.ncs", sMod );*/

    //This fixes the DM crash
    Cache( "creaturepalcus.itp", sMod );
    Cache( "doorpalcus.itp", sMod );
    Cache( "encounterpalcus.itp", sMod );
    Cache( "itempalcus.itp", sMod );
    Cache( "placeablepalcus.itp", sMod );
    Cache( "soundpalcus.itp", sMod );
    Cache( "storepalcus.itp", sMod );
    Cache( "triggerpalcus.itp", sMod );
    Cache( "waypointpalcus.itp", sMod );

    DYNRES_AddFile( sMini+".mod", sMod );
    WriteTimestampedLogEntry( "Cached palette, module event scripts and modulefile: "+sMod );
}
