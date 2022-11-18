//-------------------------------------------------------------------------------
// Randomized Chest Spawner
//-------------------------------------------------------------------------------
/*

    Created by Lord-Jyssev 10/14/2022

    This script will spawn a chest at a randomly-selected waypoint within the area that this trigger is placed.
    It pulls all information from the variables set on the "lj_randchestspwn" trigger.
    The Tag and the Resref of the chest-to-spawn must match in order to make sure duplicates don't spawn.
    By default, the script uses the placeable chest lj_randchestspwn, but any chest can be used by setting the "resref" variable.

*/
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

//#include "nw_o2_coninclude"
//#include "nw_i0_generic"
#include "amia_include"
#include "nwnx_object"


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

//Spawns a loot chest and passes in customized variables from the trigger for amount, cooldown, and loot tier. Returns spawned oPLC
object SpawnRandomLootChest( object oPLC, int nBlockTime, string sResref, location lWaypoint, float fFacing );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC          = GetEnteringObject();
    string sResref      = GetLocalString( OBJECT_SELF, "resref" );
    int nSearchDC       = GetLocalInt( OBJECT_SELF, "SearchDC" );
    int nBlockTime      = GetLocalInt( OBJECT_SELF, "BlockTime" );
    int nOncePerReset   = GetLocalInt( OBJECT_SELF, "OncePerReset");
    int nCount          = 1;
    float fFacing;
    object oPLC         = GetNearestObjectByTag( sResref, OBJECT_SELF, 1 );
    location lWaypoint;
    object oWaypoint;

    if ( GetIsBlocked( ) > 0 ){

        //SendMessageToPC( oPC, "You're blocked!" );                                                              ///
        return;
    }
    else if(nOncePerReset == 1 && GetLocalInt( OBJECT_SELF, GetPCPublicCDKey( oPC, TRUE ) ) == 1)
    {
        //SendMessageToPC( oPC, "Only one chest per reset!");
        return;
    }

    //Count the number of valid waypoints and  stop if an existing chest is found
    while(GetNearestObjectByTag( sResref, OBJECT_SELF, nCount) != OBJECT_INVALID)
    {
        //Check to make sure that a placeable chest with the resref isn't already in the area
        if ( GetObjectType( GetNearestObjectByTag( sResref , OBJECT_SELF, nCount) ) == OBJECT_TYPE_PLACEABLE )
        {
            return;
        }
        nCount++;
    }

    //Set the cooldown time from the trigger's variables + 30 seconds just to be safe
    SetBlockTime( OBJECT_SELF, 0, nBlockTime+30 );

    //Get a randomized waypoint and get the location from it for spawning
    oWaypoint    = GetNearestObjectByTag( sResref, OBJECT_SELF, Random(nCount) );
    if(oWaypoint == OBJECT_INVALID)
    {
        SendMessageToPC( oPC, "DEBUG: Can't find a vaild waypoint! Please report to a Dev." );                                  ///
    }
    fFacing      = GetFacing( oWaypoint );
    lWaypoint    = GetLocation( oWaypoint );


    //Check to see if the search DC is set. If so, then we'll require searching
    if ( nSearchDC != 0)
    {
        if ( GetIsPC( oPC ) && GetDetectMode( oPC ) == DETECT_MODE_ACTIVE ) {

            // Use a standard D&D style skill check
            if ( GetIsSkillSuccessfulPrivate( oPC, SKILL_SEARCH, nSearchDC ) )
            {
               // Search successful
               oPLC = SpawnRandomLootChest( oPLC, nBlockTime, sResref, lWaypoint, fFacing );

               effect eHint = EffectVisualEffect( VFX_DUR_PROTECTION_GOOD_MINOR );

               ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eHint, GetLocation( oPLC ), 20.0 );
            }
            else
            {
               return;
            }
        }
        else
        {
            return;
        }
    }
    else
    {
        oPLC = SpawnRandomLootChest( oPLC, nBlockTime, sResref, lWaypoint, fFacing );
    }

    //Set a variable on this trigger saying that the PC has spawned this once
    SetLocalInt( OBJECT_SELF, GetPCPublicCDKey( oPC, TRUE ), 1 );

    //Destroy the chest after nearly the full cooldown duration
    DestroyObject( oPLC, IntToFloat((nBlockTime-(nBlockTime/10))) );
}


object SpawnRandomLootChest( object oPLC, int nBlockTime, string sResref, location lWaypoint, float fFacing )
{
    int nRandomLoot      = GetLocalInt( OBJECT_SELF, "RandomLoot");
    int nFixedLoot       = GetLocalInt( OBJECT_SELF, "FixedLoot");
    int nLootLevel       = GetLocalInt( OBJECT_SELF, "LootLevel");
    int nLockedDC        = GetLocalInt( OBJECT_SELF, "LockedDC");
    float fTimeLimit     = GetLocalFloat( OBJECT_SELF, "TimeLimit");
    int nChestAppearance = GetLocalInt (OBJECT_SELF, "ChestAppearance");
    string sChestName       = GetLocalString (OBJECT_SELF, "ChestName");
    string sChestDescription = GetLocalString (OBJECT_SELF, "ChestDescription");

    oPLC                = CreateObject( OBJECT_TYPE_PLACEABLE, sResref, lWaypoint);
    AssignCommand(oPLC, SetFacing( fFacing + 180.0));

    //Set variables on the chest only if they exist on the trigger
    if (nRandomLoot != 0)       { SetLocalInt(oPLC, "RandomLoot", nRandomLoot); }
    if (nFixedLoot != 0)        { SetLocalInt(oPLC, "FixedLoot", nFixedLoot); }
    if (nLootLevel != 0)        { SetLocalInt(oPLC, "LootLevel", nLootLevel); }
    if (nLockedDC != 0)         { SetLocked( oPLC, 1); SetLockLockDC( oPLC, nLockedDC); }
    if (nChestAppearance != 0)  { NWNX_Object_SetAppearance(oPLC, nChestAppearance); }
    if (sChestName != "")        { SetName(oPLC, sChestName); }
    if (sChestDescription != "") { SetDescription(oPLC, sChestDescription); }

    //If a custom time limit is set, use that; if not, default to the nBlockTime timer
    if (fTimeLimit != 0.0)
    {
        SetLocalFloat(oPLC, "TimeLimit", fTimeLimit);
    }
    else
    {
        fTimeLimit = IntToFloat(nBlockTime+30);
        SetLocalFloat(oPLC, "TimeLimit", fTimeLimit);
    }
    return oPLC;
}
