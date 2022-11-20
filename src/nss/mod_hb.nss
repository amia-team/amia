//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: mod_heartbeat
//group: module events
//used as: OnHeartbeat
//date: 2008-06-03
//author: Disco (copied & cleaned from old scripts)

//2010-11-16   disco   added DM counter
//Sept 5th 2021 Maverick Added in DC timer for players as well as cleaned up script

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"
#include "inc_call_time"
#include "inc_dc_api"

int CountDMs();
void AddTimeAndDCs();

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main( ){

    SetCalendar(
        GetCalendarYear(),
        GetCalendarMonth(),
        GetCalendarDay()
    );
    SetTime(
        GetTimeHour(),
        GetTimeMinute(),
        GetTimeSecond(),
        GetTimeMillisecond()
    );

    int nCount = GetLocalInt( OBJECT_SELF, "ds_dm_cnt" );

    if ( nCount < 150 ){

        ++nCount;

        SetLocalInt( OBJECT_SELF, "ds_dm_cnt", nCount );
        return;
    }

    //DMs are recorded every 15 minutes
    SetLocalInt( OBJECT_SELF, "ds_dm_cnt", 0 );

    int nDMs = CountDMs();

    if ( nDMs > 0 ){

        string sModule = IntToString( GetLocalInt( OBJECT_SELF, "Module" ) );
    }
}

int CountDMs(){

    object oPC = GetFirstPC();
    int nReturn;

    while ( GetIsObjectValid( oPC ) == TRUE ){

        if ( GetIsDM( oPC ) ){

            ++nReturn;
        }

        oPC = GetNextPC();
    }

    return nReturn;
}
