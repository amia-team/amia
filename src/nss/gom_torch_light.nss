// Created by GearsOfMadness, 1/13/2015.
//
// Activates torches in another area they are not presently in.

void main()
{

 object xArea = GetArea(GetWaypointByTag("TorchAreaWaypoint"));
 // * note that nActive == 1 does  not necessarily mean the placeable is active
 // * that depends on the initial state of the object
 int nActive = GetLocalInt (OBJECT_SELF,"X2_L_PLC_ACTIVATED_STATE");
 // * Play Appropriate Animation
 if (!nActive)
 {
 ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
 }
 else
 {
 ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
 }
 // * Store New State
 SetLocalInt(OBJECT_SELF,"X2_L_PLC_ACTIVATED_STATE",!nActive);


 // Loop all objects in area
 object xObject = GetFirstObjectInArea(xArea);
 while(GetIsObjectValid(xObject))
 {
    // Destroy any objects tagged "DESTROY"
    if(GetTag(xObject) == "TorchOfLight")
    {
        ExecuteScript("x2_plc_used_act", xObject);
    }
    xObject = GetNextObjectInArea(xArea);
 }
}
