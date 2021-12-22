//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: i_spawnedcorpse
//group:
//date: 2012-07-09
//author: The1Kobra

//-------------------------------------------------------------------------------
// Includes
//-------------------------------------------------------------------------------

#include "x2_inc_switches"

void create_ground_corpse() {
    object oPC       = GetItemActivator();
    object oItem     = GetItemActivated();
    object oTarget   = GetItemActivatedTarget();
    string sItemName = GetName(oItem);
    location lTarget = GetItemActivatedTargetLocation();
    string oDescription = GetDescription(oItem, FALSE, TRUE);
    // String looks like:
    /*SetDescription(oCorpse, "This is the harvested corpse of a " + name + "\n"
                + "Corpse Information: \n" +
                "Resref: " + TheResRef
    */
    int infoloc = FindSubString(oDescription, "Corpse Information:", 0);
    int resloc = FindSubString(oDescription, "Resref:", infoloc);
    // "Collected Corpse of " = 20
    string resstring = GetSubString(oDescription, resloc, GetStringLength(oDescription) - resloc);
    string resref = GetStringRight(resstring, GetStringLength(resstring) - 8);
    string oName = GetStringRight(sItemName, GetStringLength(sItemName) - 20);

    // Testing Stub.
    //SendMessageToPC(oPC, resref);

    // Check to see if the corpse is already out.
    if (GetLocalInt(oItem, "out") == 1) {
        //object oCorpse = GetObjectByResref(resref, 0);
        string corpseTag = GetLocalString(oItem, "Ctag");
        //SendMessageToPC(oPC, corpseTag);
        //if (corpseTag == "") {
        //     SendMessageToPC(oPC, "Error getting object");
        //}
        object oCorpse = GetNearestObjectByTag(corpseTag, oPC, 0);
        //object oCorpse = GetObjectByTag(corpseTag);
        if (oCorpse == OBJECT_INVALID) {
             SendMessageToPC(oPC, "Error getting object");
        }
        if (GetIsDead(oCorpse)) {
            ExecuteScript("i_spawnedcorpse3", oCorpse);
            DestroyObject(oCorpse, 0.0f);
            SetLocalInt(oItem, "out", 0);
        } else {
            SendMessageToPC(oPC, "Target isn't dead!");
        }
    } else {
        object oCorpse = CreateObject(OBJECT_TYPE_CREATURE, resref, lTarget, FALSE, "");
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCorpse), 0.0);
        DestroyObject(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCorpse), 0.0);

        SetLootable(oCorpse, TRUE);
        ExecuteScript("i_spawnedcorpse2", oCorpse);
        SetLocalInt(oItem, "out", 1);

        SetLocalString(oItem, "Ctag", GetTag(oCorpse));
        //SendMessageToPC(oPC, GetTag(oCorpse));
        //SetLocalString(oCorpse, resref, resref);

    }

}
void main()
{
     int nEvent  = GetUserDefinedItemEventNumber();
    //int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:
            create_ground_corpse();
            break;
    }
}
