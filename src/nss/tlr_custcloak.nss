//::///////////////////////////////////////////////
//:: Tailor - Customize Cloak
//:: tlr_custclk.nss
//:: Copyright (c) 2003 Jake E. Fitch
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Jake E. Fitch (Milambus Mandragon)
//:: Created On: March 8, 2004
//:: Modified By: Jes
//:: Modified On: December 7, 2021
//:: Added independent ability to change names and bios.
//:://////////////////////////////////////////////
void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);

    //-- int iCost = GetGoldPieceValue(oItem) * 2;
    int iCost = 10;

    TakeGoldFromCreature(iCost, oPC, TRUE);

    string sName = GetLocalString(OBJECT_SELF, "CUSTOMNAME");
    if(sName != "")
    {  SetName(oItem, sName);  }

    string sDesc = GetLocalString(OBJECT_SELF, "CUSTOMDESC");
    if(sDesc != "")
    {  SetDescription(oItem, sDesc, TRUE);  }


}
