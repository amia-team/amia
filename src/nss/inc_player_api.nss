//API that allows scripters to get general information about a player account.

#include "sql_api_players"

int GetIsPlayerBanned(string cdkey);

// Queries the database for a specific player's dreamcoin amount.
int GetIsPlayerBanned(string cdkey)
{
    int isBanned = FALSE;

    NWNX_SQL_PrepareQuery(SQL_Players_buildQueryToGetIsBanned(cdkey));
    NWNX_SQL_ExecutePreparedQuery();

    if(NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        isBanned = NWNX_SQL_ReadDataInActiveRow() == "t";
    }

    if(isBanned)
    {
        WriteTimestampedLogEntry("User is banned: " + cdkey + ".");
    }

    return isBanned;
}