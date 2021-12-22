#include "inc_runtime_api"

struct ModuleLocalVariables
{
    int moduleStartTime;
    int moduleReload;
    int moduleAutoSave;
};

const string LVAR_SERVER_START_TIME = "moduleStartTime";
const string LVAR_START_TIME_INIT = "startTimestampInitialized";
const string LVAR_SERVER_AUTO_RELOAD = "AutoReload";



int GetStartTime();
void InitStartTime(int value);

int GetAutoReload();

void InitStartTime(int value)
{
    // Don't re-initialize start time.
    if(GetLocalInt(GetModule(), LVAR_START_TIME_INIT) == TRUE) return;

     SetLocalInt(GetModule(), LVAR_SERVER_START_TIME, value);
     SetLocalInt(GetModule(), LVAR_START_TIME_INIT, TRUE);
}

int GetStartTime()
{
    return GetLocalInt(GetModule(), LVAR_SERVER_START_TIME);
}

int GetAutoReload()
{
    return GetLocalInt(GetModule( ), LVAR_SERVER_AUTO_RELOAD);
}

