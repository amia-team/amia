//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  jj_book_choose
//description: This uses sets Epic Mummy Dust to summon what the PC chose
//  when he used The Book of Epic Summoning
//used as: conversation script
//date:    mar 29 2010
//author:  you3507 (James)

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "x2_inc_itemprop"
#include "amia_include"
#include "inc_ds_records"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void main()
{
    object oPC     = GetPCSpeaker();
    int nNode      = GetLocalInt(oPC, "ds_node");
    object oTarget = GetLocalObject(oPC, "jj_epic_bookHolder");
    object oItem   = GetLocalObject(oPC, "jj_epic_book");
    string sDesc   = GetDescription(oItem, TRUE);
    string sType;

    switch (nNode)
    {
      case 1:
        sType = "Undead";
        break;
      case 2:
        sType = "Outsider";
        break;
      case 3:
        sType = "Construct";
        break;
      case 4:
        sType = "Magical Beast";
        break;
      case 5:
        sType = "Elemental";
    }
    SetDescription(oItem,sDesc + "\nSummon Set to: " + sType);

//  Raphel Gray 26/10/2020 - Removing the Removal of the below so that this is reusable.
//  IPRemoveMatchingItemProperties(oItem,ITEM_PROPERTY_CAST_SPELL,-1);
//    SetLocalInt(oItem,"Summon",nNode);
    int DD = GetPCKEYValue( oTarget, "jj_MummyDust_Choice");
    string DDM = IntToString(DD);
    SendMessageToPC(GetFirstPC(), DDM);
    SpeakString(DDM,4);

    SetPCKEYValue( oTarget, "jj_MummyDust_Choice", nNode);
    DeleteLocalObject(oPC, "jj_epic_book");
    DeleteLocalObject(oPC, "jj_epic_bookHolder");
    AR_ExportPlayer(oPC);

}

//-----------------------------------------------------------------------------
// functions
//-----------------------------------------------------------------------------
