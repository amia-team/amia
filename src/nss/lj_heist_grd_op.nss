#include "nw_i0_tool"
#include "amia_include"

void CheckDistanceToPC(object oNPC, object oPC);

void main()
{
    // Get the perceiving NPC and the perceived object
    object oNPC = OBJECT_SELF;
    object oPerceived = GetLastPerceived();

    // Ensure the NPC is not dead
    if (GetIsDead(oNPC))
    {
        return;
    }

    // Check to see if the PC has an item that allows them safe passage
    if( GetIsPC(oPerceived) && GetLastPerceptionSeen())
    {

        string sSafeKey = GetLocalString(oNPC, "SafeKey");
        int nItemFound = FALSE;

        if (sSafeKey != "" && HasItem(oPerceived, sSafeKey))
        {
            nItemFound = TRUE;
        }

        if (nItemFound == FALSE)
        {
            // Ensure the perceived object is a PC
            if (GetIsPC(oPerceived) && GetLastPerceptionSeen())
            {
                string sSpottedText = GetLocalString(oNPC, "SpottedText");

                // Set the PC as a temporary enemy if hostile is enabled in thier variables
                if(GetLocalInt(oNPC, "HostileChase") == 1) SetIsTemporaryEnemy(oPerceived, oNPC);

                SpeakString(sSpottedText);

                // Start checking the distance to the PC
                CheckDistanceToPC(oNPC, oPerceived);
            }

        }


    }

    //SendMessageToPC(GetFirstPC(), "PC not seen or is not a PC. Returning to original location.");

    // Get variables from NPC
    location lGuardLoc = GetLocalLocation(oNPC, "Location");
    float fGuardFacing = GetLocalFloat(oNPC, "Facing");

    // Clear NPC actions
    ClearAllActions();

    // Return to original location
    ActionMoveToLocation(lGuardLoc, FALSE);
    ActionDoCommand(SetFacing(fGuardFacing));
}

void CheckDistanceToPC(object oNPC, object oPC)
{
    // Get Speech and Message variables
    string sCaughtText = GetLocalString(oNPC, "CaughtText");
    string sEscapeMessage = GetLocalString(oNPC, "EscapeMessage");
    string sCaughtMessage = GetLocalString(oNPC, "CaughtMessage");

    // Ensure both objects are valid and the NPC is not dead
    if (!GetIsObjectValid(oNPC) || !GetIsObjectValid(oPC) || GetIsDead(oNPC))
    {
        return;
    }

    // Check if the NPC can still perceive the PC
    if (!GetObjectSeen(oPC, oNPC))
    {
        // NPC cannot see the PC anymore, stop the pursuit and return to original location
        SetIsTemporaryFriend(oPC, oNPC);
        SendMessageToPC(oPC, sEscapeMessage);
        return;
    }

    // Check the distance to the PC
    float fDistance = GetDistanceBetween(oNPC, oPC);

    if (fDistance > 2.0)
    {
        // If the distance is greater than 2 meters, move towards the PC
        ClearAllActions();
        ActionMoveToObject(oPC, TRUE, 1.0);

        // Recheck the distance after a short delay
        DelayCommand(0.5, CheckDistanceToPC(oNPC, oPC));
    }
    else
    {
        // If within 2 meters, teleport the PC to the waypoint
        string sCaughtWP = GetLocalString(oNPC, "CaughtWP");
        object oWaypoint = GetObjectByTag(sCaughtWP);

        //Capture current runtime for use as a cooldown, using the area tag as the key
        int nCooldown = GetLocalInt(oNPC, "Cooldown");

        if (nCooldown != 0)
        {
            SetLocalInt(GetItemPossessedBy(oPC, "ds_pckey"), GetTag(GetArea(oNPC)), GetRunTimeInSeconds()+nCooldown);
        }

        if (GetIsObjectValid(oWaypoint))
        {
            SpeakString(sCaughtText);
            DelayCommand(0.25, AssignCommand(oPC, JumpToObject(oWaypoint)));
            AssignCommand( oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 3.0));
            SendMessageToPC(oPC, sCaughtMessage);

            // Reset relationship status & clear NPC actions after teleport
            SetIsTemporaryFriend(oPC, oNPC);
            DelayCommand(0.3, AssignCommand(oNPC, ClearAllActions()));
        }
    }
}

