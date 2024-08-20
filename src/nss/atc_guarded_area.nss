// Lord-Jyssev; Guarded Area cooldown OnAreaTransitionClick script.
//              When a guard catches you, it sets a cooldown on the PCKey
//              of the player that must expire before they can access
//              the area with guards again.

#include "amia_include"
#include "nw_i0_tool"

void main()
{
    object oPC      = GetClickingObject();
    object oTarget  = GetTransitionTarget( OBJECT_SELF );
    string sTarget  = GetTag(GetArea(oTarget));
    object oArea    = GetArea( OBJECT_SELF );

    object oPCKey = GetItemPossessedBy(oPC, "ds_pckey");
    int nCurrentTime = GetRunTimeInSeconds();
    int nCooldown = GetLocalInt(oPCKey, sTarget);

    if(nCooldown != 0 && nCurrentTime < nCooldown)
    {
        SendMessageToPC(oPC, "You need to lay low a while before returning.");
    }
    else
    {
        SendMessageToPC(oPC, "Transition Successful");
        if(nCooldown != 0)
        {
            DeleteLocalInt(oPCKey, sTarget);
        }
        ExecuteScript("nw_g0_transition");
    }
}



