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
    string retval = GetLocalString(oPC,CRET_STRING);
    DeleteLocalString(oPC,CRET_STRING);
    return retval;
}
string FPlusGetVaultFile(object oPC, int index) {
    string cdkey = GetPCPublicCDKey(oPC);
    SetScriptParam(CARG_1, cdkey);
    SetScriptParam(CARG_2, IntToString(index));
    ExecuteScript("td_act_ffile_gvf");
    string retval = GetLocalString(oPC,CRET_STRING);
    DeleteLocalString(oPC,CRET_STRING);
    return retval;
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
    int retval = GetLocalInt(oPC, CRET_INT);
    DeleteLocalInt(oPC,CRET_INT);
    return retval;
}
// Get Vault Size
int FPlusGetVaultSize(object oPC) {
    SetScriptParam(CARG_1, GetPCPublicCDKey(oPC));
    ExecuteScript("td_act_ffile_gvs");
    int retval = GetLocalInt(oPC, CRET_INT);
    DeleteLocalInt(oPC,CRET_INT);
    return retval;
}

// Archive File
int FPlusArchiveFile(object oPC, string cdkey, string fname) {
    ExecuteScript("td_act_ffile_gpb");
    string bic = GetLocalString(oPC,CRET_STRING);
    SendMessageToPC(oPC, "ffile_ex DEBUG bic: " + bic);
    SetScriptParam(CARG_1, cdkey);
    SetScriptParam(CARG_2, fname);
    SetScriptParam(CARG_3, bic);
    ExecuteScript("td_act_ffile_af");
    int retval = GetLocalInt(oPC, CRET_INT);
    DeleteLocalInt(oPC,CRET_INT);
    return retval;
}
// Un Archive File
int FPlusUnArchiveFile(object oPC, string cdkey, string fname) {
    SetScriptParam(CARG_1, cdkey);
    SetScriptParam(CARG_2, fname);
    ExecuteScript("td_act_ffile_uaf");
    int retval = GetLocalInt(oPC, CRET_INT);
    DeleteLocalInt(oPC,CRET_INT);
    return retval;
}
// Rename File
int FPlusRenameFile(object oPC, int index, string sNew) {
    string cdkey = GetPCPublicCDKey(oPC);
    SetScriptParam(CARG_1, cdkey);
    SetScriptParam(CARG_2, IntToString(index));
    SetScriptParam(CARG_3, sNew);
    ExecuteScript("td_act_ffile_rnf");
    int retval = GetLocalInt(oPC, CRET_INT);
    DeleteLocalInt(oPC,CRET_INT);
    return retval;
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