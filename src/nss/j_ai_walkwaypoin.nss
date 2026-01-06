/************************ [Resume Waypoint Walking] ****************************
    Filename: j_ai_walkwaypoin
************************* [Resume Waypoint Walking] ****************************
    Executed On Spawn, and from the end of combat, to resume walking

    Notes:
    Needed my own file as to execute and be sure it exsisted. This means
    the Non-override version will not use 2 different waypoint files most of the
    time.
************************* [History] ********************************************
    1.0 - Added
    1.3 - Changed to SoU waypoints. fired from End of Spawn and heartbeat.
          It also returns to start location if set.
    2.1 - Added in looping.
************************* [Workings] *******************************************
    Might change to SoU waypoints, this, at the moment, will just
    walk normal waypoints.

    GEORG:

    Short rundown on WalkWaypoints

    You can create a set of waypoints with their tag constructed like this:

    WP_[TAG]_XX where [TAG] is the exact, case sensitive tag of the creature
    you want to walk these waypoints and XX the number of the waypoint.

    Numbers must be ascending without a gap and must always contain 2 digits.

    If your creature's tag is MY_Monster, the tags would be
    WP_MY_Monster_01, WP_MY_Monster_02, ...

    You can auto-create a first waypoint in the toolset by rightclicking on a
    creature and selecting the "Create Waypoint" option. You can create
    subsequent waypoints by rightclicking on the ground while the creature is
    still selected and choosing "Create Waypoint".

    If you want to make your creature have a different patrol route at night,
    you can create a different set of WayPoints prefixed with WN_ (i.e.
    WN_MY_Monster_01, WN_MY_Monster_02, ...).

    You can also define so called POST waypoints for creatures that do not have
    a route of waypoints but you want to return to their position after a combat
    (i.e. Guards at a gate). This can be done by creating a single Waypoint with
    the tag POST_[TAG] for day and NIGHT_[TAG] for night posts. Creatures will
    automaticall switch between those posts when day changes to night and vice
    versa.

    Waypoints can be between areas and creatures will move there, if you set a
    global integer variable called X2_SWITCH_CROSSAREA_WALKWAYPOINTS on your
    module to 1.
************************* [Arguments] ******************************************
    Arguments: WAYPOINT_RUN, WAYPOINT_PAUSE are set On Spawn to remember
               the pause/run actions.
************************* [Resume Waypoint Walking] ***************************/

#include "j_inc_debug"
#include "NW_I0_GENERIC"

const string WAYPOINT_RUN   = "WAYPOINT_RUN";
const string WAYPOINT_PAUSE = "WAYPOINT_PAUSE";

const int AI_FLAG_OTHER_RETURN_TO_SPAWN_LOCATION = 0x00020000;
const string AI_OTHER_MASTER = "AI_OTHER_MASTER";

// Internal locals
const string LOCAL_RANDOMNAME_DONE = "RANDOMNAME_DONE";

// Timing
const float PATROL_IDLE_RECHECK = 1.0;
const float PATROL_COMBAT_RETRY = 3.0;

// Forward declaration
int AI_GetSpawnInCondition(int nCondition, string sName, object oTarget = OBJECT_SELF);

// Set Collision Box, Default is off
int collision = GetLocalInt(OBJECT_SELF, "collision");

void main()
{
    object oSelf = OBJECT_SELF;

    // Pause patrol during combat
    if (GetIsInCombat(oSelf))
    {
        DelayCommand(PATROL_COMBAT_RETRY, ExecuteScript("j_ai_walkwaypoin", oSelf));
        return;
    }

    // If still executing actions, do not restart patrol
    if (GetCurrentAction(oSelf) != ACTION_INVALID)
    {
        DelayCommand(PATROL_IDLE_RECHECK, ExecuteScript("j_ai_walkwaypoin", oSelf));
        return;
    }

    // Disable collision unless explicitly enabled
    if (collision != 1)
    {
        ApplyEffectToObject(
            DURATION_TYPE_PERMANENT,
            EffectCutsceneGhost(),
            oSelf
        );
    }

    // Return-to-spawn logic
    if (AI_GetSpawnInCondition(AI_FLAG_OTHER_RETURN_TO_SPAWN_LOCATION, AI_OTHER_MASTER))
    {
        location lReturnPoint = GetLocalLocation(oSelf, "AI_RETURN_TO_POINT");
        object oReturnArea = GetAreaFromLocation(lReturnPoint);

        if (GetIsObjectValid(oReturnArea))
        {
            if ((GetArea(oSelf) == oReturnArea &&
                 GetDistanceBetweenLocations(GetLocation(oSelf), lReturnPoint) > 3.0) ||
                GetArea(oSelf) != oReturnArea)
            {
                DebugActionSpeakByInt(77, GetAreaFromLocation(lReturnPoint));
                ActionForceMoveToLocation(lReturnPoint);

                DelayCommand(2.0, ExecuteScript("j_ai_walkwaypoin", oSelf));
                return;
            }
        }
    }

    // One-time random name assignment
    if (GetLocalInt(oSelf, "random_name") == 1 &&
        GetLocalInt(oSelf, LOCAL_RANDOMNAME_DONE) == 0)
    {
        SetLocalInt(oSelf, LOCAL_RANDOMNAME_DONE, 1);
        AssignCommand(oSelf, ExecuteScript("jes_randomname", oSelf));
    }

    // Start waypoint patrol (always from first waypoint)
    WalkWayPoints(
        GetLocalInt(oSelf, WAYPOINT_RUN),
        GetLocalFloat(oSelf, WAYPOINT_PAUSE)
    );

    // Poll again after patrol completes or is interrupted
    DelayCommand(PATROL_IDLE_RECHECK, ExecuteScript("j_ai_walkwaypoin", oSelf));
}

int AI_GetSpawnInCondition(int nCondition, string sName, object oTarget)
{
    return (GetLocalInt(oTarget, sName) & nCondition);
}

