/*#include "nwnx_lua"*/
#include "td_act_ffile_ex"
//void main (){}
// LUA was 1 indexed while C# is 0 indexed. Adjustment required
int INDEX_SHIFT = -1;

void CreateList(object oPC, int isVault){

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
    //SetLuaKeyValueTable(GetPCPlayerName(oPC));
    //SetFPlusKeyValueTable(GetPCPlayerName(oPC));

    for(n=0;n<10;n++){

        if(nPage+n <= nLen){
            //SetCustomToken(10102+n,GetLuaIndexValue(nPage+n));
            SetCustomToken(10102+n,GetFPlusIndexValue(oPC, nPage+n+INDEX_SHIFT, isVault));
            SetLocalInt(oPC,"ds_check_"+IntToString(n+1),TRUE);
        }
        else{
            SetLocalInt(oPC,"ds_check_"+IntToString(n+1),FALSE);
            bAllowNext=FALSE;
        }
    }

    SetLocalInt(oPC,"ds_check_11",bAllowNext);
    SetLocalInt( oPC, "list_start",nPage+10);
}

void CreateFileSummary(int nIndex, object oPC, int isVault){

    //SetLuaKeyValueTable(GetPCPlayerName(oPC));
    //SetFPlusKeyValueTable(GetPCPlayerName(oPC));
    int nPage = GetLocalInt( oPC, "list_start");
    int nReal = nPage+nIndex-11;
    // TODO: Redo this code block, find a way to post summary. Not sure what WAS in there.
    /*if(isVault) {
        //RunLua("local name = file.VAULT..[=["+GetPCPlayerName(oPC)+"/"+GetLuaIndexValue(nReal)+"]=];nwscript.file = nwn.GetFileInfo(name);nwscript.file.name = name;");
        //RunFPlus("local name = file.VAULT..[=["+GetPCPlayerName(oPC)+"/"+GetFPlusValue(nReal)+"]=];nwscript.file = nwn.GetFileInfo(name);nwscript.file.name = name;");
        //FPlusListVault(oPC,GetPCPlayerName(oPC),GetFPlusIndexValue(oPC, nReal, isVault));
    } else {
        //RunLua("local name = file.ARCHIVE..[=["+GetPCPlayerName(oPC)+"/"+GetLuaIndexValue(nReal)+"]=];nwscript.file = nwn.GetFileInfo(name);nwscript.file.name = name;");
        //RunFPlus("local name = file.ARCHIVE..[=["+GetPCPlayerName(oPC)+"/"+GetFPlusValue(nReal)+"]=];nwscript.file = nwn.GetFileInfo(name);nwscript.file.name = name;");
        //FPlusListArchive(oPC,GetPCPlayerName(oPC),GetFPlusIndexValue(nReal));
    } */
    //FPlusGetFileDetails(GetFPlusIndexValue(oPC, nReal, isVault));

    SetLocalInt(oPC,"list_current",nReal);
    //SetCustomToken(10112,RunLua("return file.CreateToken([=["+GetLuaIndexValue(nReal)+"]=]);"));
    //SetCustomToken(10112,RunFPlus("return file.CreateToken([=["+GetFPlusIndexValue(nReal)+"]=]);"));
    SetCustomToken(10112,GetFPlusIndexValue(oPC, nReal+INDEX_SHIFT, isVault));
}

void Archive(object oPC){

    //SetLuaKeyValueTable(GetPCPlayerName(oPC));
    //SetFPlusKeyValueTable(GetPCPlayerName(oPC));
    //string file = GetLuaIndexValue(GetLocalInt(oPC,"list_current"));
    string file = GetFPlusIndexValue(oPC, GetLocalInt(oPC,"list_current")+INDEX_SHIFT, TRUE);

    //if(GetStringLowerCase(file)==RunLua("return nwn.GetBic('"+ObjectToString(oPC)+"'):lower()..'.bic'")){

    //SendMessageToPC(oPC,"DEBUG: self-file check: " + GetStringLowerCase(ObjectToString(oPC)) + ", File Selected: " + GetStringLowerCase(file));
    // ObjectToString(oPC) gets a memory address, so it's not workable. Need to find another solution
    /*if(GetStringLowerCase(file)==GetStringLowerCase(ObjectToString(oPC))){
        SendMessageToPC(oPC,"Can't archive the character you're currently playing!");
        return;
    } */

    //int ok = StringToInt(RunLua("return file.Archive([=["+file+"]=],[=["+GetPCPlayerName(oPC)+"]=])"));
    //int ok = StringToInt(RunFPlus("return file.Archive([=["+file+"]=],[=["+GetPCPlayerName(oPC)+"]=])"));
    int ok = FPlusArchiveFile(oPC,GetPCPublicCDKey(oPC),file);
    //int ok = FALSE;
    if(ok) {
        SendMessageToPC(oPC,"Successfully archived "+file);
    } else {
        SendMessageToPC(oPC,"Failed to archive file!");
    }
}

void Unarchive(object oPC){

    //SetLuaKeyValueTable(GetPCPlayerName(oPC));
    //SetFPlusKeyValueTable(GetPCPlayerName(oPC));
    //string file = GetLuaIndexValue(GetLocalInt(oPC,"list_current"));
    string file = GetFPlusIndexValue(oPC, GetLocalInt(oPC,"list_current")+INDEX_SHIFT, FALSE);

    //int ok = StringToInt(RunLua("return file.UnArchive([=["+file+"]=],[=["+GetPCPlayerName(oPC)+"]=])"));
    //int ok = StringToInt(RunFPlus("return file.UnArchive([=["+file+"]=],[=["+GetPCPlayerName(oPC)+"]=])"));
    int ok = FPlusUnArchiveFile(oPC, GetPCPublicCDKey(oPC),file);
    //int ok = FALSE;

    if(ok) {
        SendMessageToPC(oPC,"Successfully unarchived "+file);
    } else {
        SendMessageToPC(oPC,"Failed to unarchive "+file);
    }
}

string GetSelected(object oPC, int isVault){
    //SetLuaKeyValueTable(GetPCPlayerName(oPC));
    //SetFPlusKeyValueTable(GetPCPlayerName(oPC));
    //return GetLuaIndexValue(GetLocalInt(oPC,"list_current"));
    return GetFPlusIndexValue(oPC,GetLocalInt(oPC,"list_current")+INDEX_SHIFT,isVault);
}

int Rename(object oPC, string sNew, int isVault){
    string sFile = GetSelected(oPC, isVault);
    //return RunLua("return file.Rename([=["+GetPCPlayerName(oPC)+"]=],[=["+sFile+"]=], [=["+sNew+"]=]);");
    //return RunFPlus("return file.Rename([=["+GetPCPlayerName(oPC)+"]=],[=["+sFile+"]=], [=["+sNew+"]=]);");
    return FPlusRenameFile(oPC, GetLocalInt(oPC,"list_current")+INDEX_SHIFT, sNew);
}

void main()
{
    object oPC  = OBJECT_SELF;
    int nNode   = GetLocalInt( oPC, "ds_node");
    int nTree   = GetLocalInt( oPC, "ds_tree");
    int nListLen = 0;

	int nDisabled = TRUE;
    if (nDisabled) {
        SendMessageToPC(oPC,"Functionality Temporarily Disabled");
        return;
    }

    if(nTree<=0){
        // Conversation Node Display Vault
        if(nNode == 1){
            SetLocalInt( oPC, "ds_tree",1);
            //nListLen = StringToInt(RunLua("return file.ListVault([=["+GetPCPlayerName(oPC)+"]=],false);"));
            //nListLen = StringToInt(RunFPlus("return file.ListVault([=["+GetPCPlayerName(oPC)+"]=],false);"));
            nListLen = FPlusGetVaultSize(oPC);

            SetLocalInt( oPC, "list_len",nListLen);
            SetLocalInt( oPC, "list_start",1);
            SendMessageToPC(oPC,"You got "+IntToString(nListLen)+" characters in your vault");
            CreateList(oPC, TRUE);
        // Conversation Node Display Archive
        } else if(nNode == 2){
            SetLocalInt( oPC, "ds_tree",2);
            //nListLen = StringToInt(RunLua("return file.ListVault([=["+GetPCPlayerName(oPC)+"]=],true);"));
            //nListLen = StringToInt(RunFPlus("return file.ListVault([=["+GetPCPlayerName(oPC)+"]=],true);"));
            nListLen = FPlusGetArchiveSize(oPC);

            SetLocalInt( oPC, "list_len",nListLen);
            SetLocalInt( oPC, "list_start",1);
            SendMessageToPC(oPC,"You got "+IntToString(nListLen)+" characters in your archive");
            CreateList(oPC, FALSE);
        }
    } else if(nTree==1||nTree==2){
        // Conversation Node Display next page (Continue from above case)
        if(nNode==11){
            if (nTree == 1) {
                CreateList(oPC, TRUE);
            } else {
                CreateList(oPC, FALSE);
            }
            return;
        // Conversation Node Cancel
        } else if(nNode==12){
            SetLocalInt( oPC, "ds_tree",0);
        // Conversation Node Select File
        } else {
            CreateFileSummary(nNode,oPC,nTree==1);
            // File from Vault
            if(nTree==1){
                SetLocalInt(oPC,"ds_check_1",FALSE);
                SetLocalInt( oPC, "ds_tree",3);
            // File from Archive
            } else {
                SetLocalInt(oPC,"ds_check_1",TRUE);
                SetLocalInt( oPC, "ds_tree",4);
            }
        }
    // Conversation Node Archive File
    } else if(nTree==3){

        if(nNode==1){
            Archive(oPC);
        }
        SetLocalInt( oPC, "ds_tree",0);
    // Conversation Node Unarchive File
    } else if(nTree==4){

        if(nNode==1){
            Unarchive(oPC);
        // Unknown Node, need test, comes from ARCHIVE set tree
        } else if(nNode==2){
            SetLocalInt( oPC, "ds_tree",5);
            SetCustomToken(10113,GetSelected(oPC, FALSE));
            return;
        }
        SetLocalInt( oPC, "ds_tree",0);
    }
    else if(nTree==5){

        if(nNode==1){
            string sNew = GetLocalString( oPC, "last_chat" );
            SetCustomToken(10114,"Old name: "+GetSelected(oPC, FALSE)+"\nNew: "+sNew);
            SetLocalInt( oPC, "ds_tree",6);
            return;
        }

        SetLocalInt( oPC, "ds_tree",0);
    }
    else if(nTree==6){
        if(nNode==1){

            string sNew = GetLocalString( oPC, "last_chat" );
            int sOk = Rename(oPC, sNew, FALSE);
            if(!sOk) {
                SendMessageToPC(oPC,"unable to rename file");
            } else {
                SendMessageToPC(oPC,"File was renamed.");
            }
            SetLocalInt( oPC, "ds_tree",0);
            //SendMessageToPC(oPC,"Renaming Feature Disabled");
            return;
        }
        SetLocalInt( oPC, "ds_tree",0);
    }
}