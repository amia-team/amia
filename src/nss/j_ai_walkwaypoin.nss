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

const string WAYPOINT_RUN       = "WAYPOINT_RUN";
const string WAYPOINT_PAUSE     = "WAYPOINT_PAUSE";

const int AI_FLAG_OTHER_RETURN_TO_SPAWN_LOCATION = 0x00020000;
const string AI_OTHER_MASTER    = "AI_OTHER_MASTER";

// Patrol control locals
const string LOCAL_PATROL_ACTIVE    = "PATROL_ACTIVE";
const string LOCAL_RANDOMNAME_DONE  = "RANDOMNAME_DONE";
const float  PATROL_RETRY_DELAY     = 3.0;

// Forward declaration
int AI_GetSpawnInCondition(int nCondition, string sName, object oTarget = OBJECT_SELF);

// Set Collision Box, Default is off
int collision = GetLocalInt(OBJECT_SELF, "collision");

void main()
{
    // Prevent duplicate patrol loops
    if (GetLocalInt(OBJECT_SELF, LOCAL_PATROL_ACTIVE) == 1)
    {
        return;
    }

    // Pause patrol during combat
    if (GetIsInCombat(OBJECT_SELF))
    {
        DelayCommand(PATROL_RETRY_DELAY, ExecuteScript("j_ai_walkwaypoin", OBJECT_SELF));
        return;
    }

    // Mark patrol as active
    SetLocalInt(OBJECT_SELF, LOCAL_PATROL_ACTIVE, 1);

    // Disable collision unless explicitly enabled
    if (collision != 1)
    {
        ApplyEffectToObject(
            DURATION_TYPE_PERMANENT,
            EffectCutsceneGhost(),
            OBJECT_SELF
        );
    }

    // Return-to-spawn logic
    if (AI_GetSpawnInCondition(AI_FLAG_OTHER_RETURN_TO_SPAWN_LOCATION, AI_OTHER_MASTER))
    {
        location lReturnPoint = GetLocalLocation(OBJECT_SELF, "AI_RETURN_TO_POINT");
        object oReturnArea = GetAreaFromLocation(lReturnPoint);

        if (GetIsObjectValid(oReturnArea))
        {
            if ((GetArea(OBJECT_SELF) == oReturnArea &&
                 GetDistanceBetweenLocations(GetLocation(OBJECT_SELF), lReturnPoint) > 3.0) ||
                GetArea(OBJECT_SELF) != oReturnArea)
            {
                DebugActionSpeakByInt(77, GetAreaFromLocation(lReturnPoint));
                ActionForceMoveToLocation(lReturnPoint);

                // Allow clean restart after returning
                SetLocalInt(OBJECT_SELF, LOCAL_PATROL_ACTIVE, 0);
                DelayCommand(2.0, ExecuteScript("j_ai_walkwaypoin", OBJECT_SELF));
                return;
            }
        }
    }

    // One-time random name assignment
    if (GetLocalInt(OBJECT_SELF, "random_name") == 1 &&
        GetLocalInt(OBJECT_SELF, LOCAL_RANDOMNAME_DONE) == 0)
    {
        SetLocalInt(OBJECT_SELF, LOCAL_RANDOMNAME_DONE, 1);
        AssignCommand(OBJECT_SELF, ExecuteScript("jes_randomname", OBJECT_SELF));
    }

    // Start waypoint patrol (always from first waypoint)
    WalkWayPoints(
        GetLocalInt(OBJECT_SELF, WAYPOINT_RUN),
        GetLocalFloat(OBJECT_SELF, WAYPOINT_PAUSE)
    );

    // Clear patrol flag and loop
    SetLocalInt(OBJECT_SELF, LOCAL_PATROL_ACTIVE, 0);
    DelayCommand(1.0, ExecuteScript("j_ai_walkwaypoin", OBJECT_SELF));
}

int AI_GetSpawnInCondition(int nCondition, string sName, object oTarget)
{
    return (GetLocalInt(oTarget, sName) & nCondition);
}

