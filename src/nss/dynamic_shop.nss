//: DarkSorcerer's Scripts - Merchant OnClose Event (06/15/2018)
//: Modified for Amia dynamic merchants by Jes (06/08/21)
// =============================================================================
/*
    Resets the shop's inventory by clearing the current items (including any
    sold items from PCs); then copying over the original store set.
*/
// destroys all items within oTarget's inventory
void ClearInventory(object oTarget);

// copies all items from oChest back into oSelf's inventory;
// then destroys oChest's inventory.
void TransferItems(object oSelf, object oChest);

// =============================================================================


void main()
{
    object oChest = GetNearestObjectByTag("storage_" + GetTag(OBJECT_SELF));

    // Clear self inventory first
    ClearInventory(OBJECT_SELF);

    // copy back the original items
    DelayCommand(0.2, TransferItems(OBJECT_SELF, oChest));
}



//: Functions //////////////////////////////////////////////////////////////////
void ClearInventory(object oTarget)
{
    object oItem = GetFirstItemInInventory(oTarget);
    while (GetIsObjectValid(oItem))
    {
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oTarget);
    }
}

void TransferItems(object oSelf, object oChest)
{
    if (!GetIsObjectValid(oSelf) || !GetIsObjectValid(oChest)) return;

    // transfer original items
    object oItem = GetFirstItemInInventory(oChest);
    while (GetIsObjectValid(oItem))
    {
        object oOriginal = CopyItem(oItem, oSelf);
        if (GetLocalInt(oItem,"dynamic_infinite") == 1)
        {
            SetInfiniteFlag(oOriginal, TRUE);
        }
        if (GetLocalInt(oItem,"mythalblock") == 1)
        {
            SetLocalInt(oOriginal, "mythalblock", 1);
        }


        oItem = GetNextItemInInventory(oChest);
    }

    // clean out temp chest (Do not need for Amia dymamics)
    //ClearInventory(oChest);
}
