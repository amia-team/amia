#include "inc_td_sysdata"
const string PATH = "G:/External/DM/";
void ChangeValue(object oItem, string key, string value){

    key += ": ";

    string sDesc = GetDescription( oItem, FALSE, TRUE );
    int nDescLen = GetStringLength(sDesc);

    if( FindSubString( sDesc, key ) != -1 ){

        int nLen = GetStringLength(key);
        int nStart = FindSubString( sDesc, key );
        int nEnd =  FindSubString( sDesc, "\n", nStart+nLen );

        string sLeft = GetSubString(sDesc,0,nStart);
        string sRight = GetSubString(sDesc,nEnd,nDescLen-nEnd);
        SetDescription(oItem,sLeft+key+value+sRight);
    }
    else{

        string sNew = sDesc;

        string last = GetSubString(sDesc,nDescLen-1,1);
        if(last != "\n"){
            sNew+="\n";
        }

        sNew += key + value + "\n";

        SetDescription(oItem,sNew);
    }
}

string GetKey( object oKeyItem ){

    string sDesc = GetDescription( oKeyItem, FALSE, TRUE );

    if( FindSubString( sDesc, "KEY: " ) != -1 ){

        int nStart = FindSubString( sDesc, "KEY: " )+5;
        int nEnd =  FindSubString( sDesc, "\n", nStart );
        sDesc = GetSubString( sDesc, nStart, nEnd-nStart );
        return sDesc;
    }

    return "";
}

void DeleteStuff( object oKeyItem ){

    string sKey = GetKey( oKeyItem );
    NWNX_DeleteFile( PATH + sKey );
    SetDescription( oKeyItem, "%", FALSE );
    SetDescription( oKeyItem );
    SetName( oKeyItem );
}

void main()
{
    object oPC      = OBJECT_SELF;
    int nNode       = GetLocalInt( oPC, "ds_node" );
    object oItem    = GetLocalObject( oPC, "ds_target" );

    if(nNode==1){
        ChangeValue(oItem,"HOSTILE","YES");
        SendMessageToPC(oPC,"Creature will spawn in as hostile");
    }
    else if(nNode==2){
        ChangeValue(oItem,"HOSTILE","NO");
        SendMessageToPC(oPC,"Creature will spawn in as friendly");
    }
    else if(nNode==3){
        ChangeValue(oItem,"AI","YES");
        SendMessageToPC(oPC,"Creature will spawn in with AI");
    }
    else if(nNode==4){
        ChangeValue(oItem,"AI","NO");
        SendMessageToPC(oPC,"Creature will spawn in without AI");
    }
    else if(nNode==5){
        DeleteStuff(oItem);
        SendMessageToPC(oPC,"Reference file deleted; widget reset!");
    }
}
