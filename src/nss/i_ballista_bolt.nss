// Reworked the faction ballista arrow
// Author: Maverick00053


void main()
{

     object oItem = GetItemActivated();
     object oPC = GetItemActivator();
     location lWaypoint = GetItemActivatedTargetLocation();

    if(GetIsObjectValid(GetAreaFromLocation(lWaypoint)))
    {

     DestroyObject(oItem, 5.0);
     SetLocalLocation(oPC,"ballista_loc",lWaypoint);
     AssignCommand(oPC, ActionSpeakString("*Bolt loaded, location locked!*"));


    }
    else
    {
        AssignCommand(oPC, ActionSpeakString("*Invalid location!*"));
    }

}
