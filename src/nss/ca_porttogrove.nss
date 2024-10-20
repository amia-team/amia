/*   Script generated by
Lilac Soul's NWN Script Generator, v. 1.3

For download info, please visit:
http://www.lilacsoul.revility.com    */

//Put this on action taken in the conversation editor
void main()
{

object oPC = GetPCSpeaker();

AssignCommand(oPC, ClearAllActions());

object oTarget;
location lTarget;
oTarget = GetWaypointByTag("a13_treetelehere");

lTarget = GetLocation(oTarget);

//only do the jump if the location is valid.
//though not flawless, we just check if it is in a valid area.
//the script will stop if the location isn't valid - meaning that
//nothing put after the teleport will fire either.
//the current location won't be stored, either

if (!GetIsObjectValid(GetAreaFromLocation(lTarget)))
    return;

DelayCommand(2.0f, AssignCommand(oPC, ActionJumpToLocation(lTarget)));

oTarget = oPC;

//Visual effects can't be applied to waypoints, so if it is a WP
//apply to the WP's location instead

int nInt;
nInt = GetObjectType(oTarget);

if (nInt != OBJECT_TYPE_WAYPOINT) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_NATURES_BALANCE), oTarget);
else ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_NATURES_BALANCE), GetLocation(oTarget));

}

