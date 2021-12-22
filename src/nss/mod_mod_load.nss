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
#include "inc_module_vars"
#include "nwnx_weapon"

#include "inc_lua"
#include "nwnx_events"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------


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
void SetStartTime();


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main( ){
    DelayCommand(300.0,ExecuteScript("dc_timer",GetModule()));
    NWNX_Weapon_SetDevastatingCriticalEventScript("nwnx_ev_dev");

    NWNX_Weapon_SetWeaponFinesseSize(BASE_ITEM_LONGSWORD, CREATURE_SIZE_MEDIUM);
    NWNX_Weapon_SetWeaponFinesseSize(BASE_ITEM_BASTARDSWORD, CREATURE_SIZE_MEDIUM);
    NWNX_Weapon_SetWeaponFinesseSize(BASE_ITEM_KATANA, CREATURE_SIZE_MEDIUM);

    NWNX_Weapon_SetWeaponIsMonkWeapon(BASE_ITEM_QUARTERSTAFF);

    NWNX_Events_SubscribeEvent("NWNX_ON_COMBAT_MODE_ON", "sub_comb_on");
    NWNX_Events_SubscribeEvent("NWNX_ON_COMBAT_MODE_OFF", "sub_comb_off");

    // Variables
    object oModule = GetModule( );
    float resetTime = IntToFloat(GetLocalInt(oModule, "AutoReload"));
    DelayCommand(300.0f, ExecuteScript("amia_reset"));

    if( GetLocalInt( oModule, "server_initialize" ) != 1 ) {
        //start database
        SQLInit( );

        SetStartTime();

        // Sets the maximum amount of henchmen per player to 20.
        SetMaxHenchmen(30);

        //We got 4 times the TMI limit
        //SetTMILimit( GetTMILimit( ) * 4 );

        //Run our lua startscript
        string sLua = NWNX_ReadStringFromINI( "AMIA", "Lua", "0", "./nwnx.ini" );
        if( sLua != "0" )
            PrintString( "Running mod load! " + sLua + ": " + ExecuteLuaString( oModule, "dofile( '"+sLua+"' )" ) );
        else
            PrintString( "Running mod load!" );

        // do not repeat this stuff.
        SetLocalInt ( oModule, "server_initialize", 1 );



    // Rolls to see if any invasions will happen this reset. 1/6 chance so about once a day with the 4 hour reset.
    int nInvasionGoblins = Random(3);
    int nInvasionBeastmen = Random(3);
    int nInvasionOrcs = Random(3);
    int nInvasionTrolls = Random(3);

    // Randomly rolls the time the invasion will occur
    int nInvasionGoblinsTime = Random(43);
    int nInvasionBeastmenTime = Random(43);
    int nInvasionOrcsTime = Random(43);
    int nInvasionTrollsTime = Random(43);

    // For server stability I don't want more than one invasion firing off at the same time interval.
    while((nInvasionGoblinsTime == nInvasionBeastmenTime) || (nInvasionGoblinsTime == nInvasionOrcsTime) || (nInvasionGoblinsTime == nInvasionTrollsTime)
    || (nInvasionBeastmenTime == nInvasionOrcsTime) || (nInvasionBeastmenTime == nInvasionTrollsTime) || (nInvasionOrcsTime == nInvasionTrollsTime))
    {

        if(nInvasionGoblinsTime == nInvasionBeastmenTime)
        {
           nInvasionGoblinsTime = Random(43);
           nInvasionBeastmenTime = Random(43);
        }

        if(nInvasionGoblinsTime == nInvasionOrcsTime)
        {
           nInvasionGoblinsTime = Random(43);
           nInvasionOrcsTime = Random(43);
        }

        if(nInvasionGoblinsTime == nInvasionTrollsTime)
        {
           nInvasionGoblinsTime = Random(43);
           nInvasionTrollsTime = Random(43);
        }

        if(nInvasionBeastmenTime == nInvasionOrcsTime)
        {
           nInvasionBeastmenTime = Random(43);
           nInvasionOrcsTime = Random(43);
        }

        if(nInvasionBeastmenTime == nInvasionTrollsTime)
        {
           nInvasionBeastmenTime = Random(43);
           nInvasionTrollsTime = Random(43);
        }

        if(nInvasionOrcsTime == nInvasionTrollsTime)
        {
           nInvasionOrcsTime = Random(43);
           nInvasionTrollsTime = Random(43);
        }

    }




    if(nInvasionGoblins == 2)
    {
       SetLocalInt(GetModule(),"invasiongobs",1);

          // The invasion command will be launched on a delay based on the random variable.
         if(nInvasionGoblinsTime == 0) // 30 minutes after reset
         {
           SetLocalInt(GetModule(),"invasiongobstime",30);
         }
         else if(nInvasionGoblinsTime == 1) // Every ten minutes going up to 3 hrs and 30 mins
         {
           SetLocalInt(GetModule(),"invasiongobstime",40);
         }
         else if(nInvasionGoblinsTime == 2)
         {
           SetLocalInt(GetModule(),"invasiongobstime",50);
         }
         else if(nInvasionGoblinsTime == 3)
         {
           SetLocalInt(GetModule(),"invasiongobstime",60);
         }
         else if(nInvasionGoblinsTime == 4)
         {
           SetLocalInt(GetModule(),"invasiongobstime",70);
          }
         else if(nInvasionGoblinsTime == 5)
         {
           SetLocalInt(GetModule(),"invasiongobstime",80);
         }
         else if(nInvasionGoblinsTime == 6)
         {
           SetLocalInt(GetModule(),"invasiongobstime",90);
         }
         else if(nInvasionGoblinsTime == 7)
         {
           SetLocalInt(GetModule(),"invasiongobstime",100);
         }
         else if(nInvasionGoblinsTime == 8)
         {
           SetLocalInt(GetModule(),"invasiongobstime",110);
         }
         else if(nInvasionGoblinsTime == 9)
         {
           SetLocalInt(GetModule(),"invasiongobstime",120);
         }
         else if(nInvasionGoblinsTime == 10)
         {
           SetLocalInt(GetModule(),"invasiongobstime",130);
         }
         else if(nInvasionGoblinsTime == 11)
         {
           SetLocalInt(GetModule(),"invasiongobstime",140);
         }
         else if(nInvasionGoblinsTime == 12)
         {
           SetLocalInt(GetModule(),"invasiongobstime",150);
         }
         else if(nInvasionGoblinsTime == 13)
         {
           SetLocalInt(GetModule(),"invasiongobstime",160);
         }
         else if(nInvasionGoblinsTime == 14)
         {
           SetLocalInt(GetModule(),"invasiongobstime",170);
         }
         else if(nInvasionGoblinsTime == 15)
         {
           SetLocalInt(GetModule(),"invasiongobstime",180);
         }
         else if(nInvasionGoblinsTime == 16)
         {
           SetLocalInt(GetModule(),"invasiongobstime",190);
         }
         else if(nInvasionGoblinsTime == 17)
         {
           SetLocalInt(GetModule(),"invasiongobstime",200);
         }
         else if(nInvasionGoblinsTime == 18)
         {
            SetLocalInt(GetModule(),"invasiongobstime",210);
         }
         else if(nInvasionGoblinsTime == 19)
         {
            SetLocalInt(GetModule(),"invasiongobstime",220);
         }
         else if(nInvasionGoblinsTime == 20)
         {
            SetLocalInt(GetModule(),"invasiongobstime",230);
         }
         else if(nInvasionGoblinsTime == 21)
         {
            SetLocalInt(GetModule(),"invasiongobstime",240);
         }
         else if(nInvasionGoblinsTime == 22)
         {
            SetLocalInt(GetModule(),"invasiongobstime",250);
         }
         else if(nInvasionGoblinsTime == 23)
         {
            SetLocalInt(GetModule(),"invasiongobstime",260);
         }
         else if(nInvasionGoblinsTime == 24)
         {
            SetLocalInt(GetModule(),"invasiongobstime",270);
         }
         else if(nInvasionGoblinsTime == 25)
         {
            SetLocalInt(GetModule(),"invasiongobstime",280);
         }
         else if(nInvasionGoblinsTime == 26)
         {
            SetLocalInt(GetModule(),"invasiongobstime",290);
         }
         else if(nInvasionGoblinsTime == 27)
         {
            SetLocalInt(GetModule(),"invasiongobstime",300);// 5 hours
         }
         else if(nInvasionGoblinsTime == 28)
         {
            SetLocalInt(GetModule(),"invasiongobstime",310);
         }
         else if(nInvasionGoblinsTime == 29)
         {
            SetLocalInt(GetModule(),"invasiongobstime",320);
         }
         else if(nInvasionGoblinsTime == 30)
         {
            SetLocalInt(GetModule(),"invasiongobstime",330);
         }
         else if(nInvasionGoblinsTime == 31)
         {
            SetLocalInt(GetModule(),"invasiongobstime",340);
         }
         else if(nInvasionGoblinsTime == 32)
         {
            SetLocalInt(GetModule(),"invasiongobstime",350);
         }
         else if(nInvasionGoblinsTime == 33)
         {
            SetLocalInt(GetModule(),"invasiongobstime",360);
         }
         else if(nInvasionGoblinsTime == 34)
         {
            SetLocalInt(GetModule(),"invasiongobstime",370);
         }
         else if(nInvasionGoblinsTime == 35)
         {
            SetLocalInt(GetModule(),"invasiongobstime",380);
         }
         else if(nInvasionGoblinsTime == 36)
         {
            SetLocalInt(GetModule(),"invasiongobstime",390);
         }
         else if(nInvasionGoblinsTime == 37)
         {
            SetLocalInt(GetModule(),"invasiongobstime",400);
         }
         else if(nInvasionGoblinsTime == 38)
         {
            SetLocalInt(GetModule(),"invasiongobstime",410);
         }
         else if(nInvasionGoblinsTime == 39)
         {
            SetLocalInt(GetModule(),"invasiongobstime",420);// 7 hr
         }
         else if(nInvasionGoblinsTime == 40)
         {
            SetLocalInt(GetModule(),"invasiongobstime",430);
         }
         else if(nInvasionGoblinsTime == 41)
         {
            SetLocalInt(GetModule(),"invasiongobstime",440);
         }
         else if(nInvasionGoblinsTime == 42)
         {
            SetLocalInt(GetModule(),"invasiongobstime",450);  // 7.5 Hr
         }
         //
    }

    if(nInvasionBeastmen == 2)
    {
       SetLocalInt(GetModule(),"invasionbeastmen",1);

          // The invasion command will be launched on a delay based on the random variable.
         if(nInvasionBeastmenTime == 0) // 30 minutes after reset
         {
           SetLocalInt(GetModule(),"invasionbeastmentime",30);
         }
         else if(nInvasionBeastmenTime == 1) // Every ten minutes going up to 3 hrs and 30 mins
         {
           SetLocalInt(GetModule(),"invasionbeastmentime",40);
         }
         else if(nInvasionBeastmenTime == 2)
         {
           SetLocalInt(GetModule(),"invasionbeastmentime",50);
         }
         else if(nInvasionBeastmenTime == 3)
         {
           SetLocalInt(GetModule(),"invasionbeastmentime",60);
         }
         else if(nInvasionBeastmenTime == 4)
         {
           SetLocalInt(GetModule(),"invasionbeastmentime",70);
          }
         else if(nInvasionBeastmenTime == 5)
         {
           SetLocalInt(GetModule(),"invasionbeastmentime",80);
         }
         else if(nInvasionBeastmenTime == 6)
         {
           SetLocalInt(GetModule(),"invasionbeastmentime",90);
         }
         else if(nInvasionBeastmenTime == 7)
         {
           SetLocalInt(GetModule(),"invasionbeastmentime",100);
         }
         else if(nInvasionBeastmenTime == 8)
         {
           SetLocalInt(GetModule(),"invasionbeastmentime",110);
         }
         else if(nInvasionBeastmenTime == 9)
         {
           SetLocalInt(GetModule(),"invasionbeastmentime",120);
         }
         else if(nInvasionBeastmenTime == 10)
         {
           SetLocalInt(GetModule(),"invasionbeastmentime",130);
         }
         else if(nInvasionBeastmenTime == 11)
         {
           SetLocalInt(GetModule(),"invasionbeastmentime",140);
         }
         else if(nInvasionBeastmenTime == 12)
         {
           SetLocalInt(GetModule(),"invasionbeastmentime",150);
         }
         else if(nInvasionBeastmenTime == 13)
         {
           SetLocalInt(GetModule(),"invasionbeastmentime",160);
         }
         else if(nInvasionBeastmenTime == 14)
         {
           SetLocalInt(GetModule(),"invasionbeastmentime",170);
         }
         else if(nInvasionBeastmenTime == 15)
         {
           SetLocalInt(GetModule(),"invasionbeastmentime",180);
         }
         else if(nInvasionBeastmenTime == 16)
         {
           SetLocalInt(GetModule(),"invasionbeastmentime",190);
         }
         else if(nInvasionBeastmenTime == 17)  // 3 hrs and 30 mins after reset
         {
           SetLocalInt(GetModule(),"invasionbeastmentime",200);
         }
         else if(nInvasionBeastmenTime == 18)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",210);
         }
         else if(nInvasionBeastmenTime == 19)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",220);
         }
         else if(nInvasionBeastmenTime == 20)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",230);
         }
         else if(nInvasionBeastmenTime == 21)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",240);
         }
         else if(nInvasionBeastmenTime == 22)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",250);
         }
         else if(nInvasionBeastmenTime == 23)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",260);
         }
         else if(nInvasionBeastmenTime == 24)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",270);
         }
         else if(nInvasionBeastmenTime == 25)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",280);
         }
         else if(nInvasionBeastmenTime == 26)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",290);
         }
         else if(nInvasionBeastmenTime == 27)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",300);// 5 hours
         }
         else if(nInvasionBeastmenTime == 28)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",310);
         }
         else if(nInvasionBeastmenTime == 29)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",320);
         }
         else if(nInvasionBeastmenTime == 30)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",330);
         }
         else if(nInvasionBeastmenTime == 31)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",340);
         }
         else if(nInvasionBeastmenTime == 32)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",350);
         }
         else if(nInvasionBeastmenTime == 33)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",360);
         }
         else if(nInvasionBeastmenTime == 34)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",370);
         }
         else if(nInvasionBeastmenTime == 35)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",380);
         }
         else if(nInvasionBeastmenTime == 36)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",390);
         }
         else if(nInvasionBeastmenTime == 37)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",400);
         }
         else if(nInvasionBeastmenTime == 38)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",410);
         }
         else if(nInvasionBeastmenTime == 39)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",420);// 7 hr
         }
         else if(nInvasionBeastmenTime == 40)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",430);
         }
         else if(nInvasionBeastmenTime == 41)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",440);
         }
         else if(nInvasionBeastmenTime == 42)
         {
            SetLocalInt(GetModule(),"invasionbeastmentime",450);  // 7.5 Hr
         }
         //
    }

    if(nInvasionOrcs == 2)
    {
       SetLocalInt(GetModule(),"invasionorcs",1);

          // The invasion command will be launched on a delay based on the random variable.
         if(nInvasionOrcsTime == 0) // 30 minutes after reset
         {
           SetLocalInt(GetModule(),"invasionorcstime",30);
         }
         else if(nInvasionOrcsTime == 1) // Every ten minutes going up to 3 hrs and 30 mins
         {
           SetLocalInt(GetModule(),"invasionorcstime",40);
         }
         else if(nInvasionOrcsTime == 2)
         {
           SetLocalInt(GetModule(),"invasionorcstime",50);
         }
         else if(nInvasionOrcsTime == 3)
         {
           SetLocalInt(GetModule(),"invasionorcstime",60);
         }
         else if(nInvasionOrcsTime == 4)
         {
           SetLocalInt(GetModule(),"invasionorcstime",70);
          }
         else if(nInvasionOrcsTime == 5)
         {
           SetLocalInt(GetModule(),"invasionorcstime",80);
         }
         else if(nInvasionOrcsTime == 6)
         {
           SetLocalInt(GetModule(),"invasionorcstime",90);
         }
         else if(nInvasionOrcsTime == 7)
         {
           SetLocalInt(GetModule(),"invasionorcstime",100);
         }
         else if(nInvasionOrcsTime == 8)
         {
           SetLocalInt(GetModule(),"invasionorcstime",110);
         }
         else if(nInvasionOrcsTime == 9)
         {
           SetLocalInt(GetModule(),"invasionorcstime",120);
         }
         else if(nInvasionOrcsTime == 10)
         {
           SetLocalInt(GetModule(),"invasionorcstime",130);
         }
         else if(nInvasionOrcsTime == 11)
         {
           SetLocalInt(GetModule(),"invasionorcstime",140);
         }
         else if(nInvasionOrcsTime == 12)
         {
           SetLocalInt(GetModule(),"invasionorcstime",150);
         }
         else if(nInvasionOrcsTime == 13)
         {
           SetLocalInt(GetModule(),"invasionorcstime",160);
         }
         else if(nInvasionOrcsTime == 14)
         {
           SetLocalInt(GetModule(),"invasionorcstime",170);
         }
         else if(nInvasionOrcsTime == 15)
         {
           SetLocalInt(GetModule(),"invasionorcstime",180);
         }
         else if(nInvasionOrcsTime == 16)
         {
           SetLocalInt(GetModule(),"invasionorcstime",190);
         }
         else if(nInvasionOrcsTime == 17)  // 3 hrs and 30 mins after reset
         {
           SetLocalInt(GetModule(),"invasionorcstime",200);
         }
         else if(nInvasionOrcsTime == 18)
         {
            SetLocalInt(GetModule(),"invasionorcstime",210);
         }
         else if(nInvasionOrcsTime == 19)
         {
            SetLocalInt(GetModule(),"invasionorcstime",220);
         }
         else if(nInvasionOrcsTime == 20)
         {
            SetLocalInt(GetModule(),"invasionorcstime",230);
         }
         else if(nInvasionOrcsTime == 21)
         {
            SetLocalInt(GetModule(),"invasionorcstime",240);
         }
         else if(nInvasionOrcsTime == 22)
         {
            SetLocalInt(GetModule(),"invasionorcstime",250);
         }
         else if(nInvasionOrcsTime == 23)
         {
            SetLocalInt(GetModule(),"invasionorcstime",260);
         }
         else if(nInvasionOrcsTime == 24)
         {
            SetLocalInt(GetModule(),"invasionorcstime",270);
         }
         else if(nInvasionOrcsTime == 25)
         {
            SetLocalInt(GetModule(),"invasionorcstime",280);
         }
         else if(nInvasionOrcsTime == 26)
         {
            SetLocalInt(GetModule(),"invasionorcstime",290);
         }
         else if(nInvasionOrcsTime == 27)
         {
            SetLocalInt(GetModule(),"invasionorcstime",300);// 5 hours
         }
         else if(nInvasionOrcsTime == 28)
         {
            SetLocalInt(GetModule(),"invasionorcstime",310);
         }
         else if(nInvasionOrcsTime == 29)
         {
            SetLocalInt(GetModule(),"invasionorcstime",320);
         }
         else if(nInvasionOrcsTime == 30)
         {
            SetLocalInt(GetModule(),"invasionorcstime",330);
         }
         else if(nInvasionOrcsTime == 31)
         {
            SetLocalInt(GetModule(),"invasionorcstime",340);
         }
         else if(nInvasionOrcsTime == 32)
         {
            SetLocalInt(GetModule(),"invasionorcstime",350);
         }
         else if(nInvasionOrcsTime == 33)
         {
            SetLocalInt(GetModule(),"invasionorcstime",360);
         }
         else if(nInvasionOrcsTime == 34)
         {
            SetLocalInt(GetModule(),"invasionorcstime",370);
         }
         else if(nInvasionOrcsTime == 35)
         {
            SetLocalInt(GetModule(),"invasionorcstime",380);
         }
         else if(nInvasionOrcsTime == 36)
         {
            SetLocalInt(GetModule(),"invasionorcstime",390);
         }
         else if(nInvasionOrcsTime == 37)
         {
            SetLocalInt(GetModule(),"invasionorcstime",400);
         }
         else if(nInvasionOrcsTime == 38)
         {
            SetLocalInt(GetModule(),"invasionorcstime",410);
         }
         else if(nInvasionOrcsTime == 39)
         {
            SetLocalInt(GetModule(),"invasionorcstime",420);// 7 hr
         }
         else if(nInvasionOrcsTime == 40)
         {
            SetLocalInt(GetModule(),"invasionorcstime",430);
         }
         else if(nInvasionOrcsTime == 41)
         {
            SetLocalInt(GetModule(),"invasionorcstime",440);
         }
         else if(nInvasionOrcsTime == 42)
         {
            SetLocalInt(GetModule(),"invasionorcstime",450);  // 7.5 Hr
         }
         //
    }

    if(nInvasionTrolls == 2)
    {
       SetLocalInt(GetModule(),"invasiontrolls",1);

          // The invasion command will be launched on a delay based on the random variable.
         if(nInvasionTrollsTime == 0) // 30 minutes after reset
         {
           SetLocalInt(GetModule(),"invasiontrollstime",30);
         }
         else if(nInvasionTrollsTime == 1) // Every ten minutes going up to 3 hrs and 30 mins
         {
           SetLocalInt(GetModule(),"invasiontrollstime",40);
         }
         else if(nInvasionTrollsTime == 2)
         {
           SetLocalInt(GetModule(),"invasiontrollstime",50);
         }
         else if(nInvasionTrollsTime == 3)
         {
           SetLocalInt(GetModule(),"invasiontrollstime",60);
         }
         else if(nInvasionTrollsTime == 4)
         {
           SetLocalInt(GetModule(),"invasiontrollstime",70);
          }
         else if(nInvasionTrollsTime == 5)
         {
           SetLocalInt(GetModule(),"invasiontrollstime",80);
         }
         else if(nInvasionTrollsTime == 6)
         {
           SetLocalInt(GetModule(),"invasiontrollstime",90);
         }
         else if(nInvasionTrollsTime == 7)
         {
           SetLocalInt(GetModule(),"invasiontrollstime",100);
         }
         else if(nInvasionTrollsTime == 8)
         {
           SetLocalInt(GetModule(),"invasiontrollstime",110);
         }
         else if(nInvasionTrollsTime == 9)
         {
           SetLocalInt(GetModule(),"invasiontrollstime",120);
         }
         else if(nInvasionTrollsTime == 10)
         {
           SetLocalInt(GetModule(),"invasiontrollstime",130);
         }
         else if(nInvasionTrollsTime == 11)
         {
           SetLocalInt(GetModule(),"invasiontrollstime",140);
         }
         else if(nInvasionTrollsTime == 12)
         {
           SetLocalInt(GetModule(),"invasiontrollstime",150);
         }
         else if(nInvasionTrollsTime == 13)
         {
           SetLocalInt(GetModule(),"invasiontrollstime",160);
         }
         else if(nInvasionTrollsTime == 14)
         {
           SetLocalInt(GetModule(),"invasiontrollstime",170);
         }
         else if(nInvasionTrollsTime == 15)
         {
           SetLocalInt(GetModule(),"invasiontrollstime",180);
         }
         else if(nInvasionTrollsTime == 16)
         {
           SetLocalInt(GetModule(),"invasiontrollstime",190);
         }
         else if(nInvasionTrollsTime == 17)  // 3 hrs and 30 mins after reset
         {
           SetLocalInt(GetModule(),"invasiontrollstime",200);
         }
         else if(nInvasionTrollsTime == 18)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",210);
         }
         else if(nInvasionTrollsTime == 19)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",220);
         }
         else if(nInvasionTrollsTime == 20)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",230);
         }
         else if(nInvasionTrollsTime == 21)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",240);
         }
         else if(nInvasionTrollsTime == 22)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",250);
         }
         else if(nInvasionTrollsTime == 23)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",260);
         }
         else if(nInvasionTrollsTime == 24)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",270);
         }
         else if(nInvasionTrollsTime == 25)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",280);
         }
         else if(nInvasionTrollsTime == 26)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",290);
         }
         else if(nInvasionTrollsTime == 27)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",300);// 5 hours
         }
         else if(nInvasionTrollsTime == 28)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",310);
         }
         else if(nInvasionTrollsTime == 29)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",320);
         }
         else if(nInvasionTrollsTime == 30)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",330);
         }
         else if(nInvasionTrollsTime == 31)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",340);
         }
         else if(nInvasionTrollsTime == 32)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",350);
         }
         else if(nInvasionTrollsTime == 33)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",360);
         }
         else if(nInvasionTrollsTime == 34)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",370);
         }
         else if(nInvasionTrollsTime == 35)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",380);
         }
         else if(nInvasionTrollsTime == 36)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",390);
         }
         else if(nInvasionTrollsTime == 37)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",400);
         }
         else if(nInvasionTrollsTime == 38)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",410);
         }
         else if(nInvasionTrollsTime == 39)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",420);// 7 hr
         }
         else if(nInvasionTrollsTime == 40)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",430);
         }
         else if(nInvasionTrollsTime == 41)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",440);
         }
         else if(nInvasionTrollsTime == 42)
         {
            SetLocalInt(GetModule(),"invasiontrollstime",450);  // 7.5 Hr
         }
         //
     }


         //DelayCommand(300.0,ExecuteScript("invasion_timer",oModule));

    }


    // Do we need to run all areas and temporarily cycle server for maintenance?
    SetLuaKeyValueTable("time");
    int unixTS = StringToInt(RunLua("local currenttime=os.time(); nwscript = nwscript or {}; nwscript.time=os.date('*t', currenttime); return currenttime;"));
    int iYear = StringToInt(GetLuaKeyValue("year"));
    int iMonth = StringToInt(GetLuaKeyValue("month"));
    int iDay = StringToInt(GetLuaKeyValue("day"));
    int iMaintenanceCycleInDays = 13;

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

         SetCustomToken( 5130, "<c?  >This option will jump you to the other server. Partymembers will not come along.</c>" );
         SetCustomToken( 5131, "<c ? >This option will jump you and your partymembers to this location.</c>" );
    }
    else{

         SetCustomToken( 5131, "<c?  >This option will jump you to the other server. Partymembers will not come along.</c>" );
         SetCustomToken( 5130, "<c ? >This option will jump you and your partymembers to this location.</c>" );
    }

    //store startdate on module
    SetLocalInt( oModule, "starttime", GetRunTime() );
    SetLocalString( oModule, "sessionid", IntToString( GetLocalInt( oModule, "Module" ) )+"_"+IntToString( GetCurrentSecond( TRUE ) ) );
    InitStartTime(GetRunTime());
    //get NoRestore casters
    SetLocalObject( oModule, "ds_areaeffects", GetObjectByTag( "ds_areaeffects" ) );
    SetLocalObject( oModule, "ds_permeffects", GetObjectByTag( "ds_permeffects" ) );

    return;
}


void SetStartTime()
{
    SetLocalInt(GetModule(), LVAR_SERVER_START_TIME, GetRunTime());
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
    SetCustomToken( 5101, "<c?  >" ); // red
    SetCustomToken( 5102, "<c ? >" ); // green
    SetCustomToken( 5103, "<c  ?>" ); // blue
    SetCustomToken( 5104, "<c ??>" ); // cyan
    SetCustomToken( 5105, "<c? ?>" ); // magenta
    SetCustomToken( 5106, "<c?? >" ); // yellow
    SetCustomToken( 5107, "<c   >" ); // black
    SetCustomToken( 5108, "<c?  >" ); // dark red
    SetCustomToken( 5109, "<c ? >" ); // dark green
    SetCustomToken( 5110, "<c  ?>" ); // dark blue
    SetCustomToken( 5111, "<c ??>" ); // dark cyan
    SetCustomToken( 5112, "<c? ?>" ); // dark magenta
    SetCustomToken( 5113, "<c?? >" ); // dark yellow
    SetCustomToken( 5114, "<c???>" ); // grey
    SetCustomToken( 5117, "<c???>" ); // dark grey
    SetCustomToken( 5115, "<c?? >" ); // orange
    SetCustomToken( 5116, "<c?? >" ); // dark orange
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
        //remove any old weather templates
        //--------------------------------------------
        DestroyObject( GetNearestObjectByTag( "tat", oRegionFlag ), 1.0 );

        ++nNth;
        oRegionFlag = GetObjectByTag( sRegionFlag, nNth );
    }
}
