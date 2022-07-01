// Empty for .net
// Number of functions connected to C# scripts
// Sets local variables to try and pass variables to the C# layer, then
// Executes the blank scripts, which are hooked to a .NET layer.

// Placeholder functions for now.

string CARG_1 = "csharp_arg_1";
string CARG_2 = "csharp_arg_2";
string CARG_3 = "csharp_arg_3";
string CRET_STRING = "csharp_return_string";
string CRET_INT = "csharp_return_int";


//void SetFPlusKeyValueTable(string sname) {}

string FPlusGetArchiveFile(object oPC, int index) {
    string cdkey = GetPCPublicCDKey(oPC);
    SetScriptParam(CARG_1, cdkey);
    SetScriptParam(CARG_2, IntToString(index));
    ExecuteScript("td_act_ffile_gaf");
    return GetLocalString(oPC,CRET_STRING);
}
string FPlusGetVaultFile(object oPC, int index) {
    string cdkey = GetPCPublicCDKey(oPC);
    SetScriptParam(CARG_1, cdkey);
    SetScriptParam(CARG_2, IntToString(index));
    ExecuteScript("td_act_ffile_gvf");
    return GetLocalString(oPC,CRET_STRING);
}
// Get File at index:
string GetFPlusIndexValue(object oPC, int iindex, int isVault) {
    string sFilename = "";
    if (isVault == TRUE) {
        sFilename = FPlusGetVaultFile(oPC, iindex);
    } else {
        sFilename = FPlusGetArchiveFile(oPC, iindex);
    }
    return sFilename;
}
// Get Archive Size
int FPlusGetArchiveSize(object oPC) {
    SetScriptParam(CARG_1, GetPCPublicCDKey(oPC));
    ExecuteScript("td_act_ffile_gas");
    return GetLocalInt(oPC, CRET_INT);
}
// Get Vault Size
int FPlusGetVaultSize(object oPC) {
    SetScriptParam(CARG_1, GetPCPublicCDKey(oPC));
    ExecuteScript("td_act_ffile_gvs");
    return GetLocalInt(oPC, CRET_INT);
}

// Archive File
int FPlusArchiveFile(object oPC, string cdkey, string fname) {
    SetScriptParam(CARG_1, cdkey);
    SetScriptParam(CARG_2, fname);
    ExecuteScript("td_act_ffile_af");
    return GetLocalInt(oPC, CRET_INT);
}
// Un Archive File
int FPlusUnArchiveFile(object oPC, string cdkey, string fname) {
    SetScriptParam(CARG_1, cdkey);
    SetScriptParam(CARG_2, fname);
    ExecuteScript("td_act_ffile_uaf");
    return GetLocalInt(oPC, CRET_INT);
}
// Rename File
int FPlusRenameFile(object oPC, string sFile, string sNew) {
    SetScriptParam(CARG_1, sFile);
    SetScriptParam(CARG_2, sNew);
    ExecuteScript("td_act_ffile_rnf");
    return GetLocalInt(oPC, CRET_INT);
}
/*
// Get Archive Files
void FPlusListArchive(string sName, string sIndex) {
    SetScriptParam(CARG_1, sName);
    SetScriptParam(CARG_2, sIndex);
    ExecuteScript("td_act_ffile_gaf");
}

// Get Vault Files
void FPlusListVault(string sName, string sIndex) {
    SetScriptParam(CARG_1, sName);
    SetScriptParam(CARG_2, sIndex);
    ExecuteScript("td_act_ffile_gvf");
}
  */
/*
string FPlusCreateToken(string sname) {
    return "";
}
int FPlusOnCurrentCharacter(string sname, string cdkey) {
    return 0;
} */