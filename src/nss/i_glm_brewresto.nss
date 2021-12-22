/* Brew Potion: Restoration - Custom Potion Craft - Kaithan (Bezekira10913)

Takes 1x Hallowseeds and 1x Midwive's Helper from player's inventory and
creates 1x Potion of Restoration in exchange.

Revision History
Date     Name             Description
-------- ---------------- ---------------------------------------------
07/18/12 Glim             Initial Release
07/20/12 Glim             Fix for running out of reagents reaction

*/
#include "amia_include"
#include "x2_inc_switches"

void CreatePotion(object oPC)
{
    object oPotion = CreateItemOnObject("glm_restopot", oPC, 1, "");
}

void ActivateItem()
{
    object oPC = GetItemActivator();
    //Hallowseeds
    object oReagent1 = GetItemPossessedBy(oPC, "ds_j_res_236");
    //Midwive's Helper
    object oReagent2 = GetItemPossessedBy(oPC, "ds_j_res_243");

    effect eVis1 = EffectVisualEffect(VFX_IMP_RESTORATION, FALSE);
    string sEmote1 = "*takes out a small mortar and pestle and starts grinding the Hallowseeds into a fine powder...*";
    string sEmote2 = "*...sprinkles the fine powder into the Midwive's helper, swishing it around a little, intoning a prayer to Sehanine Moonbow*";

    //Both reagents missing
    if (oReagent1 == OBJECT_INVALID && oReagent2 == OBJECT_INVALID)
    {
        SendMessageToPC(oPC, "You've run out of both Hallowseeds and Midwive's Helper!");
        return;
    }

    //No more Hallowseeds
    if (oReagent1 == OBJECT_INVALID)
    {
        SendMessageToPC(oPC, "You've run out of Hallowseeds.");
        return;
    }

    //No more Midwive's Helper
    if (oReagent2 == OBJECT_INVALID)
    {
        SendMessageToPC(oPC, "You've run out of Midwive's Helper.");
        return;
    }

    //Both reagents present
    if (oReagent1 != OBJECT_INVALID && oReagent2 != OBJECT_INVALID)
    {
        //Stir...
        AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 6.0));
        AssignCommand(oPC, SpeakString(sEmote1));
        //Bless!
        DelayCommand(6.0, AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0, 6.0)));
        DelayCommand(6.0, AssignCommand(oPC, SpeakString(sEmote2)));
        //Take Reagents
        DestroyObject(oReagent1, 12.0);
        DestroyObject(oReagent2, 12.0);
        //Give Potion
        DelayCommand(12.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oPC));
        DelayCommand(12.0, SendMessageToPC(oPC, "You successfully create a Potion of Restoration."));
        DelayCommand(12.1, CreatePotion(oPC));
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
