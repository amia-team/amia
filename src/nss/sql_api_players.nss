/* Simple interface to create a space where queries are built given data from a user.
   This ensures:
   1) That there is only a single point of creation for a given query.
   2) That the functions that execute the and parse the results of queries
      are also not responsible for building said queries, reducing points of failure
      and responsibilities for functions overall.
*/

#include "nwnx_sql"

//Define SQL Execution failure as a -1, consistent with C standards.
const int SQL_EXECUTION_FAILED = -1;

// Define tables to constants here to avoid error prone string literals.
const string DREAMCOINS_TABLE = "dreamcoin_records";
const string PLAYERS_TABLE = "players";
const string BANS_TABLE = "bans";
const string DMS_TABLE = "dms";

string SQL_DCS_buildQueryToGetDreamcoins(string cdkey);
string SQL_DCS_buildQueryToCreateAccount(string cdkey);
string SQL_DCS_buildQueryToCheckIfAccountExists(string cdkey);
string SQL_DCS_buildQueryToSetDreamcoins(string cdkey, string amount);

string SQL_Players_buildQueryToGetIsBanned(string cdkey);
string SQL_Players_buildQueryToGetIsDM(string cdkey);
string SQL_Players_buildQueryToCreatePlayerAccount(string cdkey);
string SQL_Players_buildQueryToBanPlayerAccount(string cdkey);
string SQL_Players_buildQueryToUnbanPlayerAccount(string cdkey);
int SQL_SetupPlayerAccount(string cdkey);

string SQL_DCS_buildQueryToGetDreamcoins(string cdkey)
{
    string queryForDreamcoins = "select amount from " + DREAMCOINS_TABLE + " where dreamcoin_records.cd_key = '" + cdkey + "';";
    return queryForDreamcoins;
}

string SQL_DCS_buildQueryToCreateDreamcoinAccount(string cdkey)
{
    string createAccountQuery = "insert into " + DREAMCOINS_TABLE + "(cd_key, amount)" +
                                " values ((select cd_key from " + PLAYERS_TABLE + " where cd_key = '" + cdkey + "'), 0) on conflict do nothing;";
    return createAccountQuery;
}

string SQL_DCS_buildQueryToCheckIfAccountExists(string cdkey)
{
    string queryForAccountExistance = "select exists(select 1 from " + DREAMCOINS_TABLE + " where cd_key='" + cdkey + "');";
    return queryForAccountExistance;
}

string SQL_DCS_buildQueryToSetDreamcoins(string cdkey, string amount)
{
    string setDreamCoinsQuery = "update " + DREAMCOINS_TABLE + " set amount = " + amount + " where cd_key = '" + cdkey + "';";
    return setDreamCoinsQuery;
}

int SQL_SetupPlayerAccount(string cdkey)
{
    NWNX_SQL_PrepareQuery(SQL_Players_buildQueryToCreatePlayerAccount(cdkey));
    int queryResult = NWNX_SQL_ExecutePreparedQuery();

    return queryResult != 0;
}

string SQL_Players_buildQueryToCreatePlayerAccount(string cdkey)
{
    string addAccountQuery = "insert into " + PLAYERS_TABLE + "(cd_key) values ('" + cdkey + "') on conflict do nothing;";
    return addAccountQuery;
}

string SQL_Players_buildQueryToGetIsBanned(string cdkey)
{
    string isAccountBannedQuery = "select exists(select 1 from " + BANS_TABLE + " where cd_key='" + cdkey + "');";
    return isAccountBannedQuery;
}

string SQL_Players_buildQueryToBanPlayerAccount(string cdkey)
{
    string banAccountQuery = "insert into " + BANS_TABLE + "(cd_key) values ('" + cdkey + "') on conflict do nothing;";
    return banAccountQuery;
}

string SQL_Players_buildQueryToUnbanPlayerAccount(string cdkey)
{
    string removeBanQuery = "delete from " + BANS_TABLE + " where cd_key='" + cdkey + "';";
    return removeBanQuery;
}

string SQL_Players_buildQueryToGetIsDM(string cdkey)
{
    string isLoginDmQuery = "select exists(select 1 from " + DMS_TABLE + " where cd_key='" + cdkey + "');";
    return isLoginDmQuery;
}