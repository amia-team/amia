//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_give_rages
//description: creates item 'ds_item' on oPC
//used as: convo script
//date:    apr 05 2008
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    // Check item condition
    string sResRef = GetLocalString(OBJECT_SELF, "ds_item");
    if (sResRef != "")
    {
        object oItem = GetItemPossessedBy(oPC, sResRef);
        if (GetIsObjectValid(oItem))
        {
            return TRUE;
        }
    }

    // Check tag condition
    string sTag = GetLocalString(oPC, "ds_tag");
    if (sTag != "")
    {
        return TRUE;
    }

    return FALSE;
}
