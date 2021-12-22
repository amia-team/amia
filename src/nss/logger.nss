// Logging Functions.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 20050505   jking            Initial Release
// 20051223   kfw              Added prototype definitions so the functions appear in the Filter for quick access

/*  Prototype Definitions  */

// Log a debugging message
//
void LogDebug(string sScript, string sMsg);

// Log an informational message
//
void LogInfo(string sScript, string sMsg);

// Log an informational message and send to all online DMs
//
void LogInfoDM(string sScript, string sMsg);

// Log a warning message - these are send to all DMs online as well.
//
void LogWarn(string sScript, string sMsg);

// Log an error message - these are send to all DMs online as well.
//
void LogError(string sScript, string sMsg);


/*  Function Definitions    */

// Log a debugging message
//
void LogDebug(string sScript, string sMsg)
{
    WriteTimestampedLogEntry("@@ " + sScript + " [DEBUG] " + sMsg);
}

// Log an informational message
//
void LogInfo(string sScript, string sMsg)
{
    WriteTimestampedLogEntry("@@ " + sScript + " [INFO] " + sMsg);
}

// Log an informational message and send to all online DMs
//
void LogInfoDM(string sScript, string sMsg)
{
    string sOutput = "@@ " + sScript + " [INFO] " + sMsg;
    SendMessageToAllDMs(sOutput);
    WriteTimestampedLogEntry(sOutput);
}

// Log a warning message - these are send to all DMs online as well.
//
void LogWarn(string sScript, string sMsg)
{
    string sOutput = "@@ " + sScript + " [WARN] " + sMsg;
    SendMessageToAllDMs(sOutput);
    WriteTimestampedLogEntry(sOutput);
}

// Log an error message - these are send to all DMs online as well.
//
void LogError(string sScript, string sMsg)
{
    string sOutput = "@@ " + sScript + " [ERROR] " + sMsg;
    SendMessageToAllDMs(sOutput);
    WriteTimestampedLogEntry(sOutput);
}


