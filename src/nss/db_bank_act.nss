/*
  Bank conversation script. Action file at end of convo options.

  - Jes 2/6/2024

*/

void main()
{
    object pc         = GetPCSpeaker();
    object pcKey      = GetItemPossessedBy(pc, "ds_pckey");
    int upgradeCost   = GetLocalInt(pc, "upgrade_cost");
    int newStorageCap = GetLocalInt(pc, "upgrade_amount");

    SetLocalInt(pcKey, "storage_cap", newStorageCap);
    TakeGoldFromCreature(upgradeCost, pc, TRUE);
    DeleteLocalInt(pc, "ds_check_1");
    DeleteLocalInt(pc, "upgrade_amount");
    DeleteLocalInt(pc, "upgrade_cost");
}
