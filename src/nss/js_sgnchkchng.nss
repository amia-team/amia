//::///////////////////////////////////////////////
//:: Customize Sign Verification
//:: js_sgnchkchng.nss
//:://////////////////////////////////////////////
/*
   Verifies cost of customization.
*/
//:://////////////////////////////////////////////
//:: Created By: Jes
//:://////////////////////////////////////////////
void main (){}
int StartingConditional()
{
    int BaseCost = 10; //-- change to raise prices
    object oPC = GetPCSpeaker();
    int iCost = BaseCost;
    object oItem = GetItemPossessedBy(oPC,"js_transign");


//--bloodsong adding in customizable custon names
    string sName = GetLocalString(oItem, "CUSTOMNAME");
    string sDesc = GetLocalString(oItem, "CUSTOMDESC");

    string sOut = "Cost: " + IntToString(iCost) + " gold.\n";
    sOut += "\nThis item will be named: <cÄãÿ>'"+sName+"'</c>.\n";
    sOut += "\nThe description will be: <cÄãÿ>'"+sDesc+"'</c>";

    SetCustomToken(9800, sOut);
    //-- this is called to check if the pc has the money to buy
    SetLocalInt(oItem, "CURRENTPRICE", iCost);

    return TRUE;
}
