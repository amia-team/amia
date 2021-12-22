#include "x2_inc_switches"


void main()
{
    int nEvent = GetUserDefinedItemEventNumber();    //Which event triggered this
    object oPC;
    object oDyebox;

    //Set the return value for the item event script
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {
        case X2_ITEM_EVENT_ACTIVATE:
            //This code runs when the Unique Power property of the item is used or the item is activated
            oPC=GetItemActivator();

            //makes sure only Bustier can spawn the chest and only one instance can be spawned at any time.
            if (GetName(oPC)=="Bustier Cassanova d'Attentourt"){
                oDyebox=GetObjectByTag("bustier_listener");
                if (oDyebox!=OBJECT_INVALID){
                    DestroyObject(oDyebox);
                }
                //these lines spawn the listener (looks like a chest) and defines the listening pattern
                object oListener = CreateObject(OBJECT_TYPE_CREATURE, "bustier_listener", GetLocation(oPC), TRUE);
                SetLocalObject(oListener, "oActivator", oPC);
                SetLocalString(oListener, "sPassword", "Chester, **");
                AssignCommand(oListener,ActionForceFollowObject(oPC,1.0));
            }
        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}
