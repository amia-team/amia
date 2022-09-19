#include "inc_ds_records"

void main()
{
    string sBankUse = "BANK_MID_USE";
    object oPC=GetItemActivatedTarget();
    object oPCKey = GetPCKEY(oPC);
    DeleteLocalInt(oPCKey, sBankUse);
}
