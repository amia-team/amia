// Amia dynamic merchants by Jes (06/08/21)
// =============================================================================

// Copies all items from chest into merchant's inventory;
void TransferItems(object merchant, object chest);
// =============================================================================
void main()
{
    object chest    = GetNearestObjectByTag("storage_" + GetTag(OBJECT_SELF));
    int maxBuy      = GetLocalInt(chest, "maxBuy");
    object merchant = OBJECT_SELF;

    if(GetLocalInt(merchant, "store_opened") != 1){
        //Transfer items to merchant
        TransferItems(merchant, chest);
        //Set variable so this only runs when first opened
        SetLocalInt(merchant, "store_opened", 1);
    }
    //Set maximum purchase price, default is 20,000
    if(GetLocalInt(chest, "maxBuy") != 0){
        SetStoreMaxBuyPrice(merchant, maxBuy);
    }
}

void TransferItems(object merchant, object chest)
{
    if (!GetIsObjectValid(merchant) || !GetIsObjectValid(chest)) return;
    object item = GetFirstItemInInventory(chest);
    //Make sure item is not marked Plot
    SetPlotFlag(item, FALSE);

    while (GetIsObjectValid(item)){
        location shop = GetLocation(merchant);
        json original = ObjectToJson(item, TRUE);
        object newCopy = JsonToObject(original, shop, merchant, TRUE);
        //No infinite flag for once-per-reset items
        if (GetLocalInt(newCopy, "dynamicSingle") == 1){
            DelayCommand(0.1f, SetInfiniteFlag(newCopy, FALSE));
        }
        else {
            //Set infinite flag on item in merchant settings
            DelayCommand(0.1f, SetInfiniteFlag(newCopy, TRUE));
        }
        item = GetNextItemInInventory(chest);
        //Make sure next item is not marked Plot
        SetPlotFlag(item, FALSE);
    }
}
