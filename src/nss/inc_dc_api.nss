/* Very simple script to allow users to get, set, and remove dreamcoins from a
   given user based on cdkey.

   Author: ZoltanTheRed
   Last Edited By: ZoltanTheRed, 01-Jun-2020
*/
#include "sql_api_players"
#include "nwnx_sql"
#include "inc_dc_consts"

// Declare prototypes as a promise to implement functions in a specified manner.
int SetupDreamcoinAccount(string cdkey);
int DreamcoinAccountExists(string cdkey);
int GetDreamCoins(string cdkey);
void SetDreamCoins(string cdkey, int amount);

// Attempts to set up an account for a player that does not have one, yet. Typically called on player's first login.
int SetupDreamcoinAccount(string cdkey)
{
    // If the account already exists, return true; there's nothing to do.
    if(DreamcoinAccountExists(cdkey)){
        return TRUE;
    }

    NWNX_SQL_PrepareQuery(SQL_DCS_buildQueryToCreateDreamcoinAccount(cdkey));
    int queryResult = NWNX_SQL_ExecutePreparedQuery();

    return queryResult != FALSE;
}

// Checks if an account exists for a given cdkey. Returns TRUE if account is found.
int DreamcoinAccountExists(string cdkey)
{
    int accountFound = FALSE;

    NWNX_SQL_PrepareQuery(SQL_DCS_buildQueryToCheckIfAccountExists(cdkey));
    NWNX_SQL_ExecutePreparedQuery();

    if(NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        accountFound = NWNX_SQL_ReadDataInActiveRow() == "t";
    }

    if(accountFound)
    {
        WriteTimestampedLogEntry("Found account for cdkey: " + cdkey + ".");
    }

    return accountFound;
}

// Queries the database for a specific player's dreamcoin amount.
int GetDreamCoins(string cdkey)
{
    // Assume failure and set success later if the query succeeds.
    int dreamcoins = SQL_EXECUTION_FAILED;


    int success = NWNX_SQL_PrepareQuery(SQL_DCS_buildQueryToGetDreamcoins(cdkey));
    NWNX_SQL_ExecutePreparedQuery();

    if(success && NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        dreamcoins = StringToInt(NWNX_SQL_ReadDataInActiveRow());
    }

    return dreamcoins;
}

// Takes a cdkey for an account and then updates the amount of dreamcoins given an int.
void SetDreamCoins(string cdkey, int amount)
{
    // Processed as a string because it costs almost nothing to make the function
    // header more intuitive. Passing raw string literals with numerics can be
    // a confusing business.
    string amountAsAString = IntToString(amount);

    NWNX_SQL_PrepareQuery(SQL_DCS_buildQueryToSetDreamcoins(cdkey, amountAsAString));
    NWNX_SQL_ExecutePreparedQuery();
}

