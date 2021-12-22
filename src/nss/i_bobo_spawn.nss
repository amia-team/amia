//-------------------------------------------------------------------------------
//COMMENTS: I will make this script universal and integrate it with Bustier's Dyechest
//-------------------------------------------------------------------------------

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"


void main()
{
    int nEvent = GetUserDefinedItemEventNumber();    //Which event triggered this
    object oDM;
    object oBobo;

    //Set the return value for the item event script
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {
        case X2_ITEM_EVENT_ACTIVATE:
            //This code runs when the Unique Power property of the item is used or the item is activated
            oDM=GetItemActivator();

            //makes sure only one instance can be spawned at any time.
            oBobo=GetObjectByTag("bobo_listener");
            if (oBobo!=OBJECT_INVALID){
                DestroyObject(oBobo);
            }
            //these lines spawn the listener and defines the listening pattern
            object oListener = CreateObject(OBJECT_TYPE_CREATURE, "bobo_listener", GetLocation(oDM), TRUE);
            SetLocalObject(oListener, "oActivator", oDM);
            SetLocalString(oListener, "sPassword", "Bobo: **");
            AssignCommand(oListener,ActionForceFollowObject(oDM,1.0));

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}
