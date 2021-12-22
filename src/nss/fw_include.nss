/*
---------------------------------------------------------------------------------
NAME: fw_include
Description: This is a library of functions that essentially manage the dynamic area system.
LOG:
    Faded Wings [01/13/2015 - Removed Lua dependency]
----------------------------------------------------------------------------------
*/
//void main (){}
#include "inc_lua"
#include "nwnx_areas"
#include "amia_include"

const float fAreaLoadDelay = 2.0;
const int dungeonResetTimer = 1200;

// This function calculates the number of players in an area, and if the destroy flag has been set, then tries to delete it.
void fw_removeIdleArea(object oArea);

// This function creates the area and then attempts to go there.
void fw_goToInstance(object oPC, object oTransition);

// This runs after people leave areas.
void fw_instanceLeave(object oArea);

// This will create an area for a short period of time, so people have a chance to go there.
void fw_spawnInstance(object callingObject);

// This will attempt to delete an area if a player never uses a spawned area
void fw_tryLoadCheck(object oArea, int nRun);

// Waits until an opportune moment to destroy the area
void fw_queueAreaDestroy(object oArea);

// This command is the gateway that all functions use to send a player to an area
void fw_sendPlayerToArea(object oPC, object oTarget, object oArea);

// Returns the string of the resref from a full unique tag
string fw_getAreaResRef(object oTransition)
{
    return GetLocalString(oTransition, "destination_rr");
}

// Get the type of area to be : [ 0 = keep forever |  1 = destroy on leave ||  2 = keep 20 minutes ]
int fw_getInstanceType(object oTransition)
{
    return GetLocalInt(oTransition, "destination_type");
}

// Get the type of an existing area : [ 0 = keep forever |  1 = destroy on leave ||  2 = keep 20 minutes ]
int fw_getAreaType(object oArea)
{
    // this is called after a successful transition, allowing it to be deleted.
    SetLocalInt(oArea, "transition", 0);
    return GetLocalInt(oArea, "area_type");
}

void fw_queueAreaDestroy(object oArea)
{
    //server is shutting down, don't destroy
    if(!GetLocalInt(GetModule(), "ds_closing") && !GetLocalInt(oArea, "transition"))
    {
        if(!AREAS_DestroyArea(oArea)){

            //its already dead
            if(!GetIsObjectValid(oArea))
                return;

            object oPC = GetFirstPC();
            while (GetIsObjectValid(oPC))
            {
                //Someone is in the area, cancel destruction
                if(GetArea(oPC)==oArea)
                    return;

                oPC = GetNextPC();
            }

            //Someone is in trans, stall
            DelayCommand(IntToFloat(GetLocalInt(oArea, "faildestroy")+1), fw_queueAreaDestroy(oArea));

            //increment fail
            SetLocalInt(oArea, "faildestroy", GetLocalInt(oArea, "faildestroy")+1);
        }
    }
}

void fw_sendPlayerToArea(object oPC, object oTarget, object oArea)
{
    // make sure the area stays alive until they're done loading
    SetLocalInt(oArea, "transition", 1);
    DelayCommand(fAreaLoadDelay, AssignCommand(oPC, JumpToObject(oTarget)));
}

void fw_removeIdleArea(object oArea)
{
    //Deprecated.
}

void fw_goToInstance(object oPC, object oTransition)
{
    string sResRef = fw_getAreaResRef(oTransition);

    // is sResRef not valid? Check the player for target to spawn in the case of rental houses
    if(sResRef == "")
    {
        sResRef = GetLocalString(oPC, "fw_last_rr");
    }

    if(sResRef == "") return;

    int nAreaType = fw_getInstanceType(oTransition);

    // Make sure the area doesn't already exist.. if so, skip this
    int nAreas = StringToInt(RunLua("return #nwn.GetAreasByResRef('"+sResRef+"')"));

    if(nAreas > 0) {
        object oTarget = GetTransitionTarget(oTransition);
        object oArea = GetArea(oTarget);
        fw_sendPlayerToArea(oPC, oTarget, oArea);
        return;
    }

    // Area doesn't exist ...
    object oArea = AREAS_CreateArea(sResRef);
    SetLocalInt(oArea, "area_type", nAreaType);

    object oTarget = GetTransitionTarget(oTransition);
    fw_sendPlayerToArea(oPC, oTarget, oArea);
}

void fw_instanceLeave(object oArea)
{
    int nAreaType = fw_getAreaType(oArea);
    switch(nAreaType)
    {
        case 0:
            break;
        case 1:
            DelayCommand(5.0, fw_removeIdleArea(oArea));
            break;
        case 2:
            int nTime = GetRunTime();
            SetLocalInt(oArea, "ttl", nTime);
            DelayCommand(IntToFloat(dungeonResetTimer), fw_removeIdleArea(oArea));
            break;
    }
    return;
}

void fw_spawnInstance(object callingObject)
{
    string sResRef = GetLocalString(callingObject, "destination_rr");
    // if sAreaName is empty, we don't need to do anything with this anyways.
    if(sResRef == "")
    {
        return;
    }
    int nAreaType = GetLocalInt(callingObject, "destination_type");

    // Make sure the area doesn't already exist.. if so, skip this
    int nAreas = StringToInt(RunLua("return #nwn.GetAreasByResRef('"+sResRef+"')"));
    if(nAreas > 0) return;

    // Area doesn't exist ... create it.. but don't go there. Let the calling script complete the transaction
    object oArea = AREAS_CreateArea(sResRef);
    SetLocalInt(oArea, "area_type", nAreaType);
    // Destroy the area regardless of the tag if nobody is there within 60 seconds.
    fw_tryLoadCheck(oArea, 1);
}

void fw_tryLoadCheck( object oArea, int nRun ) {
    // Run this 60 times (5 min), every 5.0 seconds before giving up.
    int numArea = AREAS_GetPlayers(oArea);

    if(nRun < 61)
    {
        if(numArea > 0)
        {
            // done setting up the area, player is inside.
            return;
        }
        else
        {
            nRun = nRun + 1;
            DelayCommand(5.0, fw_tryLoadCheck( oArea, nRun ));
        }
    }
    else
    {
        //how is this person not loaded? did they crash?
        fw_queueAreaDestroy(oArea);
    }
}
