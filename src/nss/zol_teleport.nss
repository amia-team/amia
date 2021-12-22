// Author: ZoltanTheRed
// Usage:
//       1) Place in the 'onEnter' event of any trigger.
//       2) Right click your trigger in the area viewer.
//       3) Add local variables called:
//             portalEndpoint (String) -> The value of this variable should be the TAG of the intended waypoint destination.
//             portalVfx (int) -> The integer value of the visual effect you wish the portal to render on the target upon entering.
//             portalTextUponEntering (String) -> Leave empty or add text as desired.

void main()
{
    object enteringObject = GetEnteringObject();

    string userDefinedWaypointTag = GetLocalString(OBJECT_SELF, "portalEndpoint");
    object userDefinedWaypoint = GetObjectByTag(userDefinedWaypointTag);

    string userDefinedEnterString = GetLocalString(OBJECT_SELF, "portalTextUponEntering");

    int portalVfx = GetLocalInt(OBJECT_SELF, "portalVfx");
    effect teleportationVfx = EffectVisualEffect(portalVfx);

    DelayCommand(1.0, AssignCommand(enteringObject, ActionJumpToObject(userDefinedWaypoint)));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, teleportationVfx, enteringObject);

    if(userDefinedEnterString != "")
    {
        FloatingTextStringOnCreature(userDefinedEnterString, enteringObject);
    }
}

