//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: edk_select
//description: Allows player to select their Epic Dragon Knight variant.
//date: 28/10/2020
//author: Raphel Gray

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
    object oItem   = GetLocalObject(oPC, "edk_choice");
    string sDesc   = GetDescription(oItem, TRUE);
    int currentEDKChoice = GetLocalInt( oItem, "edk_choice");
    if (currentEDKChoice = 0){
      SetLocalString( oItem, "origDesc", sDesc);
    } else {
      string sDesc = GetLocalString( oItem, "origDesc");
    }

    string sType;

    switch (nNode)
    {
      case 1:
        sType = "Brass";
        break;
      case 2:
        sType = "Bronze";
        break;
      case 3:
        sType = "Copper";
        break;
      case 4:
        sType = "Gold";
        break;
      case 5:
        sType = "Silver";
        break;
      case 6:
        sType = "Black";
        break;
      case 7:
        sType = "Blue";
        break;
      case 8:
        sType = "Green";
        break;
      case 9:
        sType = "Red";
        break;
      case 10:
        sType = "White";
        break;
      case 11:
        sType = "Behir";
        break;
      case 12:
        sType = "Earth Drake";
        break;
      case 13:
        sType = "Prismatic";
        break;
      case 14:
        sType = "Shadow";
        break;
      //Should only be accessible if oPC has feat (Epic Spell Focus Necromancy)
      case 15:
        sType = "Undead";
        break;
    }
    SetLocalInt( oItem, "edk_choice", nNode);
    SetDescription(oItem,sDesc + "\n\nEpic Dragon Knight Summon Set to: " + sType);
    DeleteLocalObject(oPC, "edk_choice");
}

//-----------------------------------------------------------------------------
// functions
//-----------------------------------------------------------------------------
