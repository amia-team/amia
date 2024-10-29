/*
    Redirect for AmiaReforged to createitemonobject

*/
#include "inc_ds_records"
#include "x0_i0_campaign"

void main()
{
   string sItem = GetLocalString(OBJECT_SELF,"createitem");
   CreateItemOnObject(sItem,OBJECT_SELF);
}
