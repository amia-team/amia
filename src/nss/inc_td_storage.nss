#include "nwnx_data"
#include "inc_lua"
#include "inc_ds_records"
//void main (){}
//Get the storage key for oPC
string STORE_GetKey(object oPC);

//Spawns sKey's storage into oTarget's inventory
void STORAGE_LoadInventory(string sKey, object oTarget);

//Stores the contents of oTarget's inventory into the repo
//this will destroy all the items that get stored, restore them with SpawnStorageInto
void STORAGE_SaveInventory(string sKey, object oTarget);

//Opens the storage interface for oPC
void STORAGE_OpenStorage(object oPC);

void STORAGE_OpenStorage(object oPC){

    if(GetIsPC(oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC)){

        string sTag = "tds_"+STORE_GetKey(oPC);
        object oStore = GetObjectByTag(sTag);

        if(!GetIsObjectValid(oStore))
            oStore = CreateObject(OBJECT_TYPE_STORE,"td_storage",GetLocation(oPC),FALSE,sTag);

        OpenStore(oStore,oPC,-1,-100);
    }
}

void STORAGE_LoadInventory(string sKey, object oTarget){

    string lua = RunLua("return STORAGE:GetAllFilesInRepo([["+sKey+"]])");
    int nCount = StringToInt(lua);

    if(nCount <= 0){
        return;
    }

    SetLuaKeyValueTable("STORAGE");

    int n;
    string file;
    object oItem;
    for(n=1;n<=nCount;n++){

        file = GetLuaIndexValue(n);
        //oItem = DATA_GetFromFile(file,oTarget,GetLocation(oTarget));
    }
}

void STORAGE_SaveInventory(string sKey, object oTarget){

    string path = RunLua("return STORAGE:EmptyRepo([["+sKey+"]]);");;

    if(path=="")
        return;

    object oItem = GetFirstItemInInventory(oTarget);
    while(GetIsObjectValid(oItem)){

        //DATA_SaveToFile(oItem,path+ObjectToString(oItem));

        oItem = GetNextItemInInventory(oTarget);
    }
}

string STORE_GetKey(object oPC){

    object oItem = GetPCKEY(oPC);

    if(GetIsObjectValid(oItem)){
        return GetName(oItem);
    }
    else if(GetIsDM(oPC) ||GetIsDMPossessed(oPC)){
        return "_DM";
    }
    else
        return "";
}
