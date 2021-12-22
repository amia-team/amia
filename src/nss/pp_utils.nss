//////////////////////////////////////////////////////////////////////////
// Pickpocket Replacement Package
// by James E. King, III (jking@prospeed.net) - MagnumMan
//////////////////////////////////////////////////////////////////////////
//
// ChangeLog
// YYYYMMDD WHO Notes
// -------- --- ----------------------------------------------------------
// 20050528 JEK Initial Release
// 20060520 kfw Optimized Pickpocket skill checking.
// 20071222 disco merged into three files
//////////////////////////////////////////////////////////////////////////

// @@@ Custom Amia Integration
#include "logger"


//////////////////////////////////////////////////////////////////////////
// Configurable Options
//////////////////////////////////////////////////////////////////////////

const float  PP_MIN_DISTANCE     = 2.0f;        // minimum distance to target
const int    PP_LOWEST_LEVEL     = 5;           // lowest level target pick

//////////////////////////////////////////////////////////////////////////
// Debugging Settings
//////////////////////////////////////////////////////////////////////////

const int    PP_DEBUGGING        = 0;           // Extra debug output
const string PP_D20_FIX_VARNAME  = "PP_D20";    // To set the d20 roll (pickpocket skill check: picker)
const string PP_D100_FIX_VARNAME = "PP_D100";   // To set the d100 roll (item pick chance: picker)
const string PP_PIN_FIX_VARNAME  = "PP_PIN";    // To set the inventory ordinal number to grab instead of randomizing it
const int    PP_ALLOW_VS_NPC     = FALSE;       // NPCs don't carry gold, but useful for debugging most of the functionalty

//////////////////////////////////////////////////////////////////////////
// Internal (Do not change unless you know what you're doing!)
//////////////////////////////////////////////////////////////////////////

const string PP_TOOL_RESREF              = "pp_tool";
const string PP_TOOL_TAG                 = "pp_tool";

const int    PP_SKILL_DIFFERENCE         = 50;      // -50 seems to be the limit..


// Logs a standard pickpocket message to the system log (provided
// so you can easily re-route to your own logging facility).
//
void PP_Log(string sFunc, string sMsg)
{
    LogInfoDM(sFunc, sMsg);     // @@@ Custom Amia Integration
}

// Logs a Pickpocket debugging message (provided so you can easily
// re-route to your own logging facility
//
void PP_Debug(string sFunc, string sMsg)
{
    if (PP_DEBUGGING) {
        LogDebug(sFunc, sMsg);  // @@@ Custom Amia Integration
        /*
        // We could call PP_Log, but some people use different logging
        // facilities, so we keep the code duplication so the destination
        // can more easily be changed for Log vs Debug

        WriteTimestampedLogEntry(sFunc + ": " + sMsg);
        SendMessageToAllDMs(sFunc + ": " + sMsg);
        object oPC = GetFirstPC();
        while (GetIsPC(oPC)) {
            SendMessageToPC(oPC, sFunc + ": " + sMsg);
            oPC = GetNextPC();
        } */
    }
}

// Used to enhance debug output
//
string PP_ClassToString(int iClass)
{
    switch (iClass) {
        case CLASS_TYPE_BARD         : return "Bard"        ;
        case CLASS_TYPE_ROGUE        : return "Rogue"       ;
        case CLASS_TYPE_ASSASSIN     : return "Assassin"    ;
        case CLASS_TYPE_SHADOWDANCER : return "Shadowdancer";
        case CLASS_TYPE_HARPER       : return "Harper Scout";
        default                      : break;
    }

    return "none";
}

// [Deprecated]
// Checks to see if the player has at least one level in the allowed
// classes that may pickpocket:
// Bard, Rogue, Assassin, Shadowdancer, Harper Scout
//
// [Modified]
// (kfw): Anyone with a single rank in PickPocket is flagged.
//
int PP_HighestClassLevel(object oPC){

    // Pickpocketer
    if( GetSkillRank( SKILL_PICK_POCKET, oPC, TRUE ) )  return( TRUE );
    // Non-pickpocketer
    else                                                return( FALSE );

}

// Applies a supernatural, permanent -50 skill penalty to the player
// object for purposes of disabling the built-in pickpocket system.
// See pp_adjust for why we farm this out as being owned by the module.
//
void PP_AdjustPC(object oPC)
{
    if( !GetIsPC( oPC ) || GetIsDM( oPC ) )
        return;

    DelayCommand( 6.0, ExecuteScript( "pp_adjust", oPC ) );

    return;

}

// Count the valid items for pickpocketing from someone - if this is zero
// then we take gold.
//
int PP_CountValidItems(object oTarget)
{
    PP_Debug("PP_CountValidItems", "Counting items in inventory of " + GetName(oTarget));

    int    iCount = 0;
    object oObj   = GetFirstItemInInventory(oTarget);

    while (GetIsObjectValid(oObj)) {

        // Plot and undroppable items are ignored
        if (GetPlotFlag(oObj) || !GetDroppableFlag(oObj)) {
            PP_Debug("PP_CountValidItems", GetName(oObj) + " is plot or undroppable, skipped");
            oObj = GetNextItemInInventory(oTarget);
            continue;
        }

        // Items weighing more than 5 pounds are discounted
        int iStackSize = GetNumStackedItems(oObj);
        int iWeight    = GetWeight         (oObj);
        int iIndivWt   = iWeight / iStackSize;
        PP_Debug("PP_CountValidItems", GetName(oObj) + " iStackSize " + IntToString(iStackSize) + ", iWeight " + IntToString(iWeight));
        if (iIndivWt > 50) {
            PP_Debug("PP_CountValidItems", GetName(oObj) + " is too heavy, skipped");
            oObj = GetNextItemInInventory(oTarget);
            continue;
        }

        // You cannot pickpocket a container
        if (GetHasInventory(oObj)) {
            PP_Debug("PP_CountValidItems", GetName(oObj) + " is a container of some sort, skipped");
        } else {
            iCount += iStackSize;
            PP_Debug("PP_CountValidItems", IntToString(iCount) + " = " + GetName(oObj) + " (stack size " + IntToString(iStackSize) + ") valid for picking");
        }

        oObj = GetNextItemInInventory(oTarget);
    }

    PP_Debug("PP_CountValidItems", GetName(oTarget) + " contains " + IntToString(iCount) + " valid pickpocket potential items");
    return iCount;
}

// Given a number within the range of 0..PP_CountValidItems, get the object
// corresponding to that slot number.
//
object PP_PickItem(object oTarget, int iPick, int iCount = 0)
{
    PP_Debug("PP_PickItem", "Picking item #" + IntToString(iPick) + ", iCount = " + IntToString(iCount));

    object oObj = GetFirstItemInInventory(oTarget);

    while (GetIsObjectValid(oObj)) {

        // Plot and undroppable items are ignored
        if (GetPlotFlag(oObj) || !GetDroppableFlag(oObj)) {
            PP_Debug("PP_PickItem", GetName(oObj) + " is plot or undroppable, skipped");
            oObj = GetNextItemInInventory(oTarget);
            continue;
        }

        // Items weighing more than 5 pounds are discounted
        int iStackSize = GetNumStackedItems(oObj);
        int iWeight    = GetWeight         (oObj);
        int iIndivWt   = iWeight / iStackSize;
        PP_Debug("PP_PickItem", GetName(oObj) + " iStackSize " + IntToString(iStackSize) + ", iWeight " + IntToString(iWeight));
        if (iIndivWt > 50) {
            PP_Debug("PP_PickItem", GetName(oObj) + " is too heavy, skipped");
            oObj = GetNextItemInInventory(oTarget);
            continue;
        }

        // You cannot pickpocket a container
        if (GetHasInventory(oObj)) {
            PP_Debug("PP_PickItem", GetName(oObj) + " is a container of some sort, skipped");
        } else {
            iCount += iStackSize;
            if (iCount >= iPick)
                return oObj;            // can return a stack, yes...

            PP_Debug("PP_PickItem", GetName(oObj) + " (counted " + IntToString(iStackSize) + " time(s)");
        }

        oObj = GetNextItemInInventory(oTarget);
    }

    return OBJECT_INVALID;
}

int PP_DistanceDCBonus(object oTarget, object oOther)
{
    float fDist = GetDistanceBetween(oTarget, oOther);
    PP_Debug("PP_DistanceDCBonus", FloatToString(fDist) + " between " + GetName(oTarget) + " and " + GetName(oOther));

    if (fDist > 10.99f)
        return 1;
    if (fDist > 3.99f)
        return 2;
    if (fDist > 0.0f)
        return 5;
    return 0;
}

int InPartyTogether(object oTarget, object oOther)
{
    object oObj = GetFirstFactionMember(oTarget);
    while (GetIsObjectValid(oObj)) {
        if (oObj == oOther)
            return TRUE;
        oObj = GetNextFactionMember(oTarget);
    }
    return FALSE;
}

