//::///////////////////////////////////////////////
//:: Tailoring - Customize Bottom Ring Verification
//:: tlr_custverrng1.nss
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
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC);
    int iCost = BaseCost;


//--bloodsong adding in customizable custon names
    string sName = GetLocalString(OBJECT_SELF, "CUSTOMNAME");
        if (sName == "") { sName = GetName(oItem); }
    string sDesc = GetLocalString(OBJECT_SELF, "CUSTOMDESC");
        if (sDesc == "") { sDesc = GetDescription(oItem); }

    string sOut = "Cost: " + IntToString(iCost) + " gold.\n";
    sOut += "This item will be named "+sName+" and the description will be: "+sDesc+".";

    SetCustomToken(55004, sOut);
    //-- this is called to check if the pc has the money to buy
    SetLocalInt(OBJECT_SELF, "CURRENTPRICE", iCost);

    return TRUE;
}
