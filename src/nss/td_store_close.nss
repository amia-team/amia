#include "inc_td_storage"

void main()
{
    string key = GetLocalString(OBJECT_SELF,"key");

    if(key!="")
        STORAGE_SaveInventory(key,OBJECT_SELF);
}
