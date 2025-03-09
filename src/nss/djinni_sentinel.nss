/*
   Djinn sentinel/guard specific walkpoint walk
   - Mav, 2/28/25

*/

#include "j_inc_debug"
#include "NW_I0_GENERIC"

const string WAYPOINT_RUN       = "WAYPOINT_RUN";
const string WAYPOINT_PAUSE     = "WAYPOINT_PAUSE";
const int AI_FLAG_OTHER_RETURN_TO_SPAWN_LOCATION                = 0x00020000;
const string AI_OTHER_MASTER    = "AI_OTHER_MASTER";

// For return  to.
int AI_GetSpawnInCondition(int nCondition, string sName, object oTarget = OBJECT_SELF);

//Set Collision Box, Default is off
int collision = GetLocalInt( OBJECT_SELF, "collision" );

void main()
{

    // Add in aura stuff
    effect eAura = EffectAreaOfEffect(AOE_MOB_SILENCE, "djinni_aura_sent","****", "****");
    eAura = SupernaturalEffect(eAura);
    DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAura, OBJECT_SELF));


    if (collision != 1){
        effect eGhost = EffectCutsceneGhost();
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, OBJECT_SELF);
    }

    // FIRST, if we are meant to move back to the start location, do it.
    if(AI_GetSpawnInCondition(AI_FLAG_OTHER_RETURN_TO_SPAWN_LOCATION, AI_OTHER_MASTER))
    {
        location lReturnPoint = GetLocalLocation(OBJECT_SELF, "AI_RETURN_TO_POINT");
        object oReturnArea = GetAreaFromLocation(lReturnPoint);
        if(GetIsObjectValid(oReturnArea))
        {
            if((GetArea(OBJECT_SELF) == oReturnArea &&
                GetDistanceBetweenLocations(GetLocation(OBJECT_SELF), lReturnPoint) > 3.0) ||
                GetArea(OBJECT_SELF) != oReturnArea)
            {
                // 77: "[Waypoints] Returning to spawn location. [Area] " + GetName(oInput)
                DebugActionSpeakByInt(77, GetAreaFromLocation(lReturnPoint));
                ActionForceMoveToLocation(lReturnPoint);
                return;
            }
        }
    }
    // Use on-spawn run/pauses.
    if(GetLocalInt(OBJECT_SELF, "random_name") == 1){
        AssignCommand(OBJECT_SELF, ExecuteScript("jes_randomname", OBJECT_SELF));
    }
    WalkWayPoints(GetLocalInt(OBJECT_SELF, WAYPOINT_RUN), GetLocalFloat(OBJECT_SELF, WAYPOINT_PAUSE));
}

int AI_GetSpawnInCondition(int nCondition, string sName, object oTarget)
{
    return (GetLocalInt(oTarget, sName) & nCondition);
}
