//script: getmerchinvchest
//description: Sets a merchant's inventory to be the chest that is denoted in
// the local variable: assignedMChest
//date: 04/12/2020
//author/ Dark Sorcerer - Modified by Raphel Gray for dynamic merchants
//: DarkSorcerer's Scripts - Merchant OnClose Event (06/15/2018)
// =============================================================================
/*
    Resets the shop's inventory by clearing the current items (including any
    sold items from PCs); then copying over the original store set; lastly it
    clears the temp chest of its inventory.
*/
// destroys all items within oTarget's inventory
void ClearInventory(object oTarget);

// copies all items from oChest back into oSelf's inventory;
// then destroys oChest's inventory.
void TransferItems(object oSelf, object oChest, int iDepleteInv, int iPersistInv);
// copies all items from oSelf to the oChest to persist the inventory.
//
void PersistInv(object oSelf, object oChest, int iDepleteInv, int iPersistInv);

// =============================================================================

void main()
{
    //sDepleteInv is normally 0, this will result in an infinite inventory.
    //depleteInv can be set to 1, this refresh the inventory only once.
    //if depleteInv is 2 or higher this will just return.
    string sDepleteInv = GetLocalString(OBJECT_SELF,sDepleteInv);
    int iDepleteInv = StringToInt(sDepleteInv);
    string assignedMChest = GetLocalString(OBJECT_SELF,assignedMChest);
    object oChest = GetObjectByTag(assignedMChest);
    string sPersistInv = GetLocalString(OBJECT_SELF,sPersistInv);
    int iPersistInv = StringToInt(sPersistInv);
//For Debugging Purposes, remove before release
//string sSrtingtoSpeak = "I am a String";
//SpeakString(sSrtingtoSpeak,1);
string sSrtingtoSpeak = sDepleteInv;
SpeakString(sSrtingtoSpeak,1);
string sSrtingtoSpeak2 = IntToString(iDepleteInv);
SpeakString(sSrtingtoSpeak2,1);
string sSrtingtoSpeak3 = assignedMChest;
SpeakString(sSrtingtoSpeak3,1);
string sSrtingtoSpeak4 = GetTag(oChest);
SpeakString(sSrtingtoSpeak4,1);
string sSrtingtoSpeak5 = sPersistInv;
SpeakString(sSrtingtoSpeak5,1);
string sSrtingtoSpeak6 = IntToString(iPersistInv);
SpeakString(sSrtingtoSpeak6,1);
//
    if(iPersistInv = 1)
    {
        DelayCommand(0.2, PersistInv(OBJECT_SELF, oChest, iDepleteInv, iPersistInv));
    }

    if (iDepleteInv > 2)
    {
        // Clear self inventory first
        ClearInventory(OBJECT_SELF);
        // copy back the original items
        DelayCommand(0.2, TransferItems(OBJECT_SELF, oChest,iDepleteInv,iPersistInv));
    }
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

void TransferItems(object oSelf, object oChest, int iDepleteInv, int iPersistInv)
{
    if (!GetIsObjectValid(oSelf) || !GetIsObjectValid(oChest)) return;

    // transfer original items
    object oItem = GetFirstItemInInventory(oChest);
    while (GetIsObjectValid(oItem))
    {
        object oOriginal = CopyItem(oItem, oSelf);
        if (iDepleteInv = 1)
        {
            SetInfiniteFlag(oOriginal, TRUE);
        }
        oItem = GetNextItemInInventory(oChest);
    }

    if (iDepleteInv = 1)
    {
       iDepleteInv + 1;
       string sDepleteInv = IntToString(iDepleteInv);
       SetLocalString(oSelf,sDepleteInv,sDepleteInv);
    }
   if (iPersistInv = 1)
   {
       ClearInventory(oChest);
   }
}

void PersistInv(object oSelf, object oChest, int iDepleteInv, int iPersistInv)
{
    object oPC = GetLastUsedBy();
    object oArea = GetArea(OBJECT_SELF);
    if (GetArea(oChest) != oArea)
    {
        SendMessageToPC(oPC, "Error::Storage Chest not found - please contact the admin with these details: \n" +
                             "Area: " + GetName(oArea) + "\n" +
                             "Store: " + GetTag(OBJECT_SELF) + "\n" +
                             "Storage Chest: " + GetTag(oChest));
        return;
    }

    // Copy all items to temp chest
    object oItem = GetFirstItemInInventory();
    while (GetIsObjectValid(oItem))
    {
        // Don't copy plot items (anti-cheat)
        if (GetPlotFlag(oItem)) DestroyObject(oItem);

        object oNewItem = CopyItem(oItem, oChest);
        if (GetInfiniteFlag(oItem))
        {
            SetInfiniteFlag(oNewItem, FALSE);
            SetName(oNewItem, GetName(oNewItem) + "(I)");
        }
        oItem = GetNextItemInInventory();
    }
}
