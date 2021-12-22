#include "inc_td_storage"

void main()
{
    object oPC = GetLastOpenedBy();
    string key = STORE_GetKey(oPC);

    if(key=="")
    {
        SendMessageToPC(oPC, "!! INVALID KEY THINGS YOU PUT INTO THE STORE WILL BE DESTROYED !!");
        FloatingTextStringOnCreature("!! INVALID KEY THINGS YOU PUT INTO THE STORE WILL BE DESTROYED !!", oPC, FALSE);
        return;
    }

    if(!GetIsObjectValid(GetFirstItemInInventory()))
    {
        SetLocalString(OBJECT_SELF,"key",key);
        STORAGE_LoadInventory(key,OBJECT_SELF);
    }
}
