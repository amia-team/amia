#include "x2_inc_switches"

void ActivateItem()
{
    object oPC = GetItemActivator();
    int goldCost = 10000;
    int stackSize = 10;

    if (GetGold(oPC) < goldCost)
    {
         SendMessageToPC(oPC, "The total gold cost for this is " + IntToString(goldCost) + ". You do not have enough!");
    }
    else
    {
         AssignCommand(oPC, TakeGoldFromCreature(goldCost, oPC, TRUE));
         CreateItemOnObject("impholywater", oPC, stackSize);
         SendMessageToPC(oPC, "You have successfully created " + IntToString(stackSize) + " Improved Holy Water potions.");
    }
}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
