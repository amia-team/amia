/*#include "nwnx_lua"*/
#include "td_act_ffile_ex"
//void main (){}
void CreateList(object oPC){

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
    SetFPlusKeyValueTable(GetPCPlayerName(oPC));

    for(n=0;n<10;n++){

        if(nPage+n <= nLen){
            //SetCustomToken(10102+n,GetLuaIndexValue(nPage+n));
            SetCustomToken(10102+n,GetFPlusIndexValue(nPage+n));
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
    SetFPlusKeyValueTable(GetPCPlayerName(oPC));
    int nPage = GetLocalInt( oPC, "list_start");
    int nReal = nPage+nIndex-11;
    if(isVault)
        //RunLua("local name = file.VAULT..[=["+GetPCPlayerName(oPC)+"/"+GetLuaIndexValue(nReal)+"]=];nwscript.file = nwn.GetFileInfo(name);nwscript.file.name = name;");
        //RunFPlus("local name = file.VAULT..[=["+GetPCPlayerName(oPC)+"/"+GetFPlusValue(nReal)+"]=];nwscript.file = nwn.GetFileInfo(name);nwscript.file.name = name;");
        FPlusListVault(GetPCPlayerName(oPC),GetFPlusIndexValue(nReal));
    else
        //RunLua("local name = file.ARCHIVE..[=["+GetPCPlayerName(oPC)+"/"+GetLuaIndexValue(nReal)+"]=];nwscript.file = nwn.GetFileInfo(name);nwscript.file.name = name;");
        //RunFPlus("local name = file.ARCHIVE..[=["+GetPCPlayerName(oPC)+"/"+GetFPlusValue(nReal)+"]=];nwscript.file = nwn.GetFileInfo(name);nwscript.file.name = name;");
        FPlusListArchive(GetPCPlayerName(oPC),GetFPlusIndexValue(nReal));

    SetLocalInt(oPC,"list_current",nReal);
    //SetCustomToken(10112,RunLua("return file.CreateToken([=["+GetLuaIndexValue(nReal)+"]=]);"));
    //SetCustomToken(10112,RunFPlus("return file.CreateToken([=["+GetFPlusIndexValue(nReal)+"]=]);"));
    SetCustomToken(10112,FPlusCreateToken(GetFPlusIndexValue(nReal)));
}

void Archive(object oPC){

    //SetLuaKeyValueTable(GetPCPlayerName(oPC));
    SetFPlusKeyValueTable(GetPCPlayerName(oPC));
    //string file = GetLuaIndexValue(GetLocalInt(oPC,"list_current"));
    string file = GetFPlusIndexValue(GetLocalInt(oPC,"list_current"));

    //if(GetStringLowerCase(file)==RunLua("return nwn.GetBic('"+ObjectToString(oPC)+"'):lower()..'.bic'")){
    if(GetStringLowerCase(file)==RunFPlus("return nwn.GetBic('"+ObjectToString(oPC)+"'):lower()..'.bic'")){
        SendMessageToPC(oPC,"Can't archive the character you're currently playing!");
        return;
    }

    //int ok = StringToInt(RunLua("return file.Archive([=["+file+"]=],[=["+GetPCPlayerName(oPC)+"]=])"));
    //int ok = StringToInt(RunFPlus("return file.Archive([=["+file+"]=],[=["+GetPCPlayerName(oPC)+"]=])"));
    FPlusArchiveFile(GetPCPublicCDKey(oPC),file);
    int ok = FALSE;
    if(ok)
        SendMessageToPC(oPC,"Successfully archived "+file);
    else
        SendMessageToPC(oPC,"Failed to archive file!");
}

void Unarchive(object oPC){

    //SetLuaKeyValueTable(GetPCPlayerName(oPC));
    SetFPlusKeyValueTable(GetPCPlayerName(oPC));
    //string file = GetLuaIndexValue(GetLocalInt(oPC,"list_current"));
    string file = GetFPlusIndexValue(GetLocalInt(oPC,"list_current"));

    //int ok = StringToInt(RunLua("return file.UnArchive([=["+file+"]=],[=["+GetPCPlayerName(oPC)+"]=])"));
    //int ok = StringToInt(RunFPlus("return file.UnArchive([=["+file+"]=],[=["+GetPCPlayerName(oPC)+"]=])"));
    FPlusUnArchiveFile(GetPCPublicCDKey(oPC),file);
    int ok = FALSE;

    if(ok)
        SendMessageToPC(oPC,"Successfully unarchived "+file);
    else
        SendMessageToPC(oPC,"Failed to unarchive "+file);
}

string GetSelected(object oPC){
    //SetLuaKeyValueTable(GetPCPlayerName(oPC));
    SetFPlusKeyValueTable(GetPCPlayerName(oPC));
    //return GetLuaIndexValue(GetLocalInt(oPC,"list_current"));
    return GetFPlusIndexValue(GetLocalInt(oPC,"list_current"));
}

string Rename(object oPC, string sNew){
    string sFile = GetSelected(oPC);
    //return RunLua("return file.Rename([=["+GetPCPlayerName(oPC)+"]=],[=["+sFile+"]=], [=["+sNew+"]=]);");
    return RunFPlus("return file.Rename([=["+GetPCPlayerName(oPC)+"]=],[=["+sFile+"]=], [=["+sNew+"]=]);");
}

void main()
{
    object oPC  = OBJECT_SELF;
    int nNode   = GetLocalInt( oPC, "ds_node");
    int nTree   = GetLocalInt( oPC, "ds_tree");
    int nListLen = 0;

    if(nTree<=0){

        if(nNode == 1){
            SetLocalInt( oPC, "ds_tree",1);
            //nListLen = StringToInt(RunLua("return file.ListVault([=["+GetPCPlayerName(oPC)+"]=],false);"));
            nListLen = StringToInt(RunFPlus("return file.ListVault([=["+GetPCPlayerName(oPC)+"]=],false);"));

            SetLocalInt( oPC, "list_len",nListLen);
            SetLocalInt( oPC, "list_start",1);
            SendMessageToPC(oPC,"You got "+IntToString(nListLen)+" characters in your vault");
            CreateList(oPC);
        }
        else if(nNode == 2){
            SetLocalInt( oPC, "ds_tree",2);
            //nListLen = StringToInt(RunLua("return file.ListVault([=["+GetPCPlayerName(oPC)+"]=],true);"));
            nListLen = StringToInt(RunFPlus("return file.ListVault([=["+GetPCPlayerName(oPC)+"]=],true);"));
            SetLocalInt( oPC, "list_len",nListLen);
            SetLocalInt( oPC, "list_start",1);
            SendMessageToPC(oPC,"You got "+IntToString(nListLen)+" characters in your archive");
            CreateList(oPC);
        }
    }
    else if(nTree==1||nTree==2){

        if(nNode==11){
            CreateList(oPC);
            return;
        }
        else if(nNode==12){
            SetLocalInt( oPC, "ds_tree",0);
        }
        else{
            CreateFileSummary(nNode,oPC,nTree==1);

            if(nTree==1){
                SetLocalInt(oPC,"ds_check_1",FALSE);
                SetLocalInt( oPC, "ds_tree",3);
            }
            else{
                SetLocalInt(oPC,"ds_check_1",TRUE);
                SetLocalInt( oPC, "ds_tree",4);
            }
        }
    }
    else if(nTree==3){

        if(nNode==1){
            Archive(oPC);
        }
        SetLocalInt( oPC, "ds_tree",0);
    }
    else if(nTree==4){

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

        if(nNode==1){
            string sNew = GetLocalString( oPC, "last_chat" );
            SetCustomToken(10114,"Old name: "+GetSelected(oPC)+"\nNew: "+sNew);
            SetLocalInt( oPC, "ds_tree",6);
            return;
        }

        SetLocalInt( oPC, "ds_tree",0);
    }
    else if(nTree==6){
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
