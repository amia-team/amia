#include "inc_sqlite_time"

int GetRunTimeInSeconds();
int GetRunTime(int nMinutes=0, int nSeconds=0);


int GetRunTime(int nMinutes=0, int nSeconds=0)
{
    //get starttime in seconds
    int nTimestamp = GetRunTimeInSeconds();

    if ( !nTimestamp ){

        SendMessageToAllDMs( "WARNING: COULD NOT RETRIEVE SERVER RUNTIME!" );
    }

    return nTimestamp + ( 60 * nMinutes ) + nSeconds;
}

int GetRunTimeInSeconds()
{
    struct SQLite_MillisecondTimeStamp currentRuntime = SQLite_GetMillisecondTimeStamp();

    return currentRuntime.seconds;
}
