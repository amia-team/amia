//::///////////////////////////////////////////////
//:: Tailoring - Customize Arrow Verification
//:: tlr_custverarrw.nss
//:://////////////////////////////////////////////
/*
   Verifies cost of customization.
*/
//:://////////////////////////////////////////////
//:: Created By: Stacy L. Ropella
//:: from Mandragon's mil_tailor
//:://////////////////////////////////////////////
void main (){}
int StartingConditional()
{
    int BaseCost = 10; //-- change to raise prices
    object oPC = GetPCSpeaker();
    object oItem = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
    int iCost = BaseCost;


//--bloodsong adding in customizable custon names
    string sName = GetLocalString(OBJECT_SELF, "CUSTOMNAME");
        if (sName == "") { sName = GetName(oItem); }
    string sDesc = GetLocalString(OBJECT_SELF, "CUSTOMDESC");
        if (sDesc == "") { sDesc = GetDescription(oItem); }

    string sOut = "Cost: " + IntToString(iCost) + " gold.\n";
    sOut += "\nThis item will be named: <cÄãÿ>'"+sName+"'</c>.\n";
    sOut += "\nThe description will be: <cÄãÿ>'"+sDesc+"'</c>";

    SetCustomToken(9895, sOut);
    //-- this is called to check if the pc has the money to buy
    SetLocalInt(OBJECT_SELF, "CURRENTPRICE", iCost);

    return TRUE;
}
