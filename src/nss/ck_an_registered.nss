//::///////////////////////////////////////////////
//:: FileName ck_an_registered
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Anatida
//:: Created On: 5/18/2014 10:25:52 PM
//:://////////////////////////////////////////////
//:: Starting conditional to report registered PCs from convo
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"

int StartingConditional()
{

    // Inspect local variables
    if((GetLocalInt(OBJECT_SELF, "npc_g_i") < 1))
        return FALSE;

    return TRUE;
}
