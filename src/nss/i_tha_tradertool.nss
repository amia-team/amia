//This is an item trigger script for Amian Traders Federation and Copper
//Industries appraisal items.

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "amia_include"
#include "x2_inc_switches"

//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------
void ActivateItem()
{
    //variables
    int nValue;
    int nPercentage;
    int nLore;
    int nAppraise;
    string sBroadcast;
    string sResult;
    object oPC = GetItemActivator();
    object oItem = GetItemActivated();
    object oTarget = GetItemActivatedTarget();
    string sItemName = GetName(oItem);

    //check which item is being used
    if (sItemName == "The Pricewatch")
    {
        sBroadcast = "no";
    }
    if (sItemName == "The Copper Catalogue")
    {
        sBroadcast = "no";
    }
    if (sItemName == "The Auction Horn")
    {
        sBroadcast = "yes";
    }

    //gather target info
    if (GetIdentified(oTarget)==TRUE)
    {
        nAppraise = (GetSkillRank(SKILL_APPRAISE,oPC)/5);
        nLore = (GetSkillRank(SKILL_LORE,oPC)/5);

        if (nAppraise+nAppraise>10)
        {
            nValue = GetGoldPieceValue(oTarget);
        }
        else
        {
            nPercentage = (90+nAppraise+nLore)+Random((21-(nAppraise*2)-(nLore*2)));
            nValue = (nPercentage*GetGoldPieceValue(oTarget))/100;
        }

        //send info to player
        if (sBroadcast=="yes")
        {
            AssignCommand(oPC,SpeakString("The starting bid for the fabulous "+GetName(oTarget)+" is "+IntToString(nValue)+" gold pieces."));
        }
        else
        {
            SendMessageToPC(oPC,"This item is worth about "+IntToString(nValue)+" gold pieces.");
        }
    }
    else
    {
        SendMessageToPC(oPC,"You cannot appraise/auction unidentified items.");
    }
}

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
