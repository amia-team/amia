//API that allows scripters to get general information about a player account.

#include "sql_api_players"

int GetIsPlayerBanned(string cdkey);
int GetIsInTable(string query);
void BanPlayer(string cdkey);
void UnbanPlayer(string cdkey);

// Queries the database for a specific player's dreamcoin amount.
int GetIsPlayerBanned(string cdkey)
{
    int isBanned = GetIsInTable(SQL_Players_buildQueryToGetIsBanned(cdkey));

    if(isBanned)
    {
        WriteTimestampedLogEntry("User is banned: " + cdkey + ".");
    }

    return isBanned;
}

int GetIsInTable(string query)
{
    int inTable = FALSE;

    NWNX_SQL_PrepareQuery(query);
    NWNX_SQL_ExecutePreparedQuery();

    if(NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        inTable = NWNX_SQL_ReadDataInActiveRow() == "t";
    }

    return inTable;
}

void BanPlayer(string cdkey)
{
    NWNX_SQL_PrepareQuery(SQL_Players_buildQueryToBanPlayerAccount(cdkey));
    NWNX_SQL_ExecutePreparedQuery();
}

void UnbanPlayer(string cdkey)
{
    NWNX_SQL_PrepareQuery(SQL_Players_buildQueryToUnbanPlayerAccount(cdkey));
    NWNX_SQL_ExecutePreparedQuery();
}