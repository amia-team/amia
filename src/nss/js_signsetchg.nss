//::///////////////////////////////////////////////
//:: Customize Sign
//:: js_signsetchg.nss
//:: Copyright (c) 2003 Jake E. Fitch
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Jes
//:: Created On: December 8, 2021
//:://////////////////////////////////////////////
void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetItemPossessedBy(oPC, "js_transign");

    int iCost = 10;

    TakeGoldFromCreature(iCost, oPC, TRUE);

    string sName = GetLocalString(OBJECT_SELF, "CUSTOMNAME");
    if(sName != "")
    {  SetName(oItem, sName);  }

    string sDesc = GetLocalString(OBJECT_SELF, "CUSTOMDESC");
    if(sDesc != "")
    {  SetDescription(oItem, sDesc, TRUE);  }
}
