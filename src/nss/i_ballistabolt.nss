// Reworked the faction ballista arrow
// Author: Maverick00053

#include "x2_inc_switches"

void ActivateItem()
{
     object oItem = GetItemActivated();
     object oPC = GetItemActivator();
     location lWaypoint = GetItemActivatedTargetLocation();


            if(GetIsObjectValid(GetAreaFromLocation(lWaypoint)))
            {

               DestroyObject(oItem);
               SetLocalLocation(oPC,"ballista_loc",lWaypoint);
               AssignCommand(oPC, ActionSpeakString("*Bolt loaded, location locked!*"));


             }
             else
             {
               AssignCommand(oPC, ActionSpeakString("*Invalid location!*"));
             }

}




void main( ){
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}

