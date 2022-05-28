/*#include "nwnx_lua"*/
#include "td_act_ffile_ex"
//void main (){}
string FILE_INDEX = "ffile_index";
string FILE_NAME = "ffile_name";

void CreateList(object oPC){
    int CONV_TOKEN_INDEX = 10102;

    int n;

    int nLen = GetLocalInt( oPC, "list_len");

    if(nLen<=0){

        for(n=0;n<10;n++){
            SetLocalInt(oPC,"ds_check_"+IntToString(n+1),FALSE);
        }

        return;
    }

    int nPage = GetLocalInt( oPC, "list_start");
    int bAllowNext = TRUE;
    // T1K: No documentation available for what this function did. May replace entirely?
    // I /think/ it's determining the archive or vault table? No idea.
    //SetLuaKeyValueTable(GetPCPlayerName(oPC));

    // T1K: Loop sets the values for the displayed list.
    for(n=0;n<10;n++){
        if(nPage+n <= nLen){
            // T1K: LUA function is setting custom tokens for making the list.
            // I presume what it's getting are file-names? Need to differentiate
            // Archive and Vault; variable ds_tree is used, 1 for vault, 2 for archive
            //SetCustomToken(10102+n,GetLuaIndexValue(nPage+n));

            string fname = "";
            // Urgh this way of differentiation is terrible. Need to find a better one.
            if (GetLocalInt(oPC,"ds_tree") == 1) {
                fname = FPlusGetVaultFile(GetPCPublicCDKey(oPC),nPage+n);
            } else if (GetLocalInt(oPC, "ds_tree") == 2) {
                fname = FPlusGetArchiveFile(GetPCPublicCDKey(oPC),nPage+n);
            }
            SetCustomToken(CONV_TOKEN_INDEX+n, fname);

            SetLocalInt(oPC,"ds_check_"+IntToString(n+1),TRUE);
        } else{
            SetLocalInt(oPC,"ds_check_"+IntToString(n+1),FALSE);
            bAllowNext=FALSE;
        }
    }

    SetLocalInt(oPC,"ds_check_11",bAllowNext);
    SetLocalInt( oPC, "list_start",nPage+10);
}

// T1K: Figured out what this function is supposed to be doing. It gets the
// needed info when a file in the archive or vault is selected.
void CreateFileSummary(int nIndex, object oPC, int isVault){
    // T1K: Again, no idea what this function is doing >.<
    //SetLuaKeyValueTable(GetPCPlayerName(oPC));

    int nPage = GetLocalInt( oPC, "list_start");
    int nReal = nPage+nIndex-11;

    // T1K: I'll admit, I don't know what's what here. I think it's supposed to
    // display some info on the file but I don't know what it should display.
    string sFname = "";
    string sVault = "vault";
    if(isVault) {
        //RunLua("local name = file.VAULT..[=["+GetPCPlayerName(oPC)+"/"+GetLuaIndexValue(nReal)+"]=];nwscript.file = nwn.GetFileInfo(name);nwscript.file.name = name;");
        //RunFPlus("local name = file.VAULT..[=["+GetPCPlayerName(oPC)+"/"+GetFPlusValue(nReal)+"]=];nwscript.file = nwn.GetFileInfo(name);nwscript.file.name = name;");
        sFname = FPlusGetVaultFile(GetPCPublicCDKey(oPC),nReal);
        sVault = "Vault";
    } else {
        //RunLua("local name = file.ARCHIVE..[=["+GetPCPlayerName(oPC)+"/"+GetLuaIndexValue(nReal)+"]=];nwscript.file = nwn.GetFileInfo(name);nwscript.file.name = name;");
        //RunFPlus("local name = file.ARCHIVE..[=["+GetPCPlayerName(oPC)+"/"+GetFPlusValue(nReal)+"]=];nwscript.file = nwn.GetFileInfo(name);nwscript.file.name = name;");
        sFname = FPlusGetArchiveFile(GetPCPublicCDKey(oPC),nReal);
        sVault = "Archive";
    }

    SetLocalInt(oPC,"list_current",nReal);
    SetLocalString(oPC, FILE_NAME, sFname);
    string sToken = "File Index: " + IntToString(nReal) + ". Current Location: " + sVault + ". File Name: " + sFname;
    // T1K: Sets the prompt for the file in question.
    //SetCustomToken(10112,RunLua("return file.CreateToken([=["+GetLuaIndexValue(nReal)+"]=]);"));
    //SetCustomToken(10112,RunFPlus("return file.CreateToken([=["+GetFPlusIndexValue(nReal)+"]=]);"));
    SetCustomToken(10112,sToken);
}

// T1K: Function sends a file to the archive.
void Archive(object oPC){

    // T1K: Think this prepares the table?
    //SetLuaKeyValueTable(GetPCPlayerName(oPC));

    // T1K: Gets the file in question?
    //string file = GetLuaIndexValue(GetLocalInt(oPC,"list_current"));

    // T1K: Check to see if the file is for the currently played character. (May just integrate this check C# side)
    //if(GetStringLowerCase(file)==RunLua("return nwn.GetBic('"+ObjectToString(oPC)+"'):lower()..'.bic'")){
    //    SendMessageToPC(oPC,"Can't archive the character you're currently playing!");
    //    return;
    //}
    //int nPage =
    int nReal = GetLocalInt(oPC,"list_current");
    string sFname = GetLocalString(oPC, FILE_NAME);
    // T1K: Send that file to the archive
    //int ok = StringToInt(RunLua("return file.Archive([=["+file+"]=],[=["+GetPCPlayerName(oPC)+"]=])"));
    int ok = FPlusArchiveFile(GetPCPublicCDKey(oPC),nReal);
    if(ok) {
        //SendMessageToPC(oPC,"Successfully archived "+file);
        SendMessageToPC(oPC,"Successfully archived "+sFname);
    } else {
        SendMessageToPC(oPC,"Failed to archive file!");
    }
}

// T1K: Function sends a file from the archive to the vault.
void Unarchive(object oPC){

    // T1K: Switch to use indexes not filenames.
    //SetLuaKeyValueTable(GetPCPlayerName(oPC));
    //SetFPlusKeyValueTable(GetPCPlayerName(oPC));
    //string file = GetLuaIndexValue(GetLocalInt(oPC,"list_current"));
    //string file = GetFPlusIndexValue(GetLocalInt(oPC,"list_current"));

    //int ok = StringToInt(RunLua("return file.UnArchive([=["+file+"]=],[=["+GetPCPlayerName(oPC)+"]=])"));
    //int ok = StringToInt(RunFPlus("return file.UnArchive([=["+file+"]=],[=["+GetPCPlayerName(oPC)+"]=])"));

    int nReal = GetLocalInt(oPC,"list_current");
    string sFname = GetLocalString(oPC, FILE_NAME);
    int ok = FPlusUnArchiveFile(GetPCPublicCDKey(oPC),nReal);

    if(ok) {
        //SendMessageToPC(oPC,"Successfully unarchived "+file);
        SendMessageToPC(oPC,"Successfully unarchived "+sFname);
    } else {
        //SendMessageToPC(oPC,"Failed to unarchive "+file);
        SendMessageToPC(oPC,"Failed to unarchive "+sFname);
    }
}

string GetSelected(object oPC){
    // T1K: Cut the LUA/C# call, use a local variable instead. Keep it in house.
    //SetLuaKeyValueTable(GetPCPlayerName(oPC));
    //SetFPlusKeyValueTable(GetPCPlayerName(oPC));
    //return GetLuaIndexValue(GetLocalInt(oPC,"list_current"));
    //return GetFPlusIndexValue(GetLocalInt(oPC,"list_current"));
    return GetLocalString(oPC, FILE_NAME);
}

// T1K: Need to retool this with differences in C#
string Rename(object oPC, string sNew){
    //string sFile = GetSelected(oPC);
    int nReal = GetLocalInt(oPC,"list_current");
    //return RunLua("return file.Rename([=["+GetPCPlayerName(oPC)+"]=],[=["+sFile+"]=], [=["+sNew+"]=]);");
    //return RunFPlus("return file.Rename([=["+GetPCPlayerName(oPC)+"]=],[=["+sFile+"]=], [=["+sNew+"]=]);");
    return FPlusRenameFile(GetPCPublicCDKey(oPC),nReal,sNew);
}

void main()
{
    object oPC  = OBJECT_SELF;
    int nNode   = GetLocalInt( oPC, "ds_node");
    int nTree   = GetLocalInt( oPC, "ds_tree");
    int nListLen = 0;

    // T1K: This value is for when the PC selects vault or archive initially?
    if(nTree<=0){

        if(nNode == 1){
            SetLocalInt( oPC, "ds_tree",1);
            //nListLen = StringToInt(RunLua("return file.ListVault([=["+GetPCPlayerName(oPC)+"]=],false);"));
            nListLen = FPlusGetVaultSize( GetPCPublicCDKey(oPC));

            SetLocalInt( oPC, "list_len",nListLen);
            SetLocalInt( oPC, "list_start",1);
            SendMessageToPC(oPC,"You got "+IntToString(nListLen)+" characters in your vault");
            CreateList(oPC);
        }
        else if(nNode == 2){
            SetLocalInt( oPC, "ds_tree",2);
            //nListLen = StringToInt(RunLua("return file.ListVault([=["+GetPCPlayerName(oPC)+"]=],true);"));
            nListLen = FPlusGetArchiveSize( GetPCPublicCDKey(oPC));

            SetLocalInt( oPC, "list_len",nListLen);
            SetLocalInt( oPC, "list_start",1);
            SendMessageToPC(oPC,"You got "+IntToString(nListLen)+" characters in your archive");
            CreateList(oPC);
        }
    }
    else if(nTree==1||nTree==2){
        // T1K: Condition - Show Vault (1) or Show Archive (2).

        // T1K: Okay, I think /this/ is the 'next' button item in the list?
        if(nNode==11){
            CreateList(oPC);
            return;
        }
        // T1K: I think this is the 'back' button in the convo.
        else if(nNode==12){
            SetLocalInt( oPC, "ds_tree",0);
        }
        // T1K: And this is what happens when a file is selected.
        else{
            CreateFileSummary(nNode,oPC,nTree==1);

            if(nTree==1){
                // Showing Vault
                SetLocalInt(oPC,"ds_check_1",FALSE);
                SetLocalInt( oPC, "ds_tree",3);
            }
            else{
                // Showing Archive
                SetLocalInt(oPC,"ds_check_1",TRUE);
                SetLocalInt( oPC, "ds_tree",4);
            }
        }
    }
    else if(nTree==3){
        // T1K: Move file from vault to archive.
        if(nNode==1){
            Archive(oPC);
        }
        SetLocalInt( oPC, "ds_tree",0);
    }
    else if(nTree==4){
        // T1K: Bring file from archive to vault.
        if(nNode==1){
            Unarchive(oPC);
        }
        else if(nNode==2){
            SetLocalInt( oPC, "ds_tree",5);
            SetCustomToken(10113,GetSelected(oPC));
            return;
        }
        SetLocalInt( oPC, "ds_tree",0);
    }
    else if(nTree==5){
        // This is for Renaming Files, get the file being renamed
        if(nNode==1){
            string sNew = GetLocalString( oPC, "last_chat" );
            SetCustomToken(10114,"Old name: "+GetSelected(oPC)+"\nNew: "+sNew);
            SetLocalInt( oPC, "ds_tree",6);
            return;
        }

        SetLocalInt( oPC, "ds_tree",0);
    }
    else if(nTree==6){
        // Also for Renaming Files, go to set the name
        if(nNode==1){
            string sNew = GetLocalString( oPC, "last_chat" );
            string sOk = Rename(oPC, sNew);
            if(sOk=="")
                SendMessageToPC(oPC,"unable to rename file "+GetSelected(oPC));
            else
                SendMessageToPC(oPC,GetSelected(oPC)+" was ranmed to "+sOk);
            SetLocalInt( oPC, "ds_tree",0);
            return;
        }

        SetLocalInt( oPC, "ds_tree",0);
    }
}
