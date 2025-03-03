//::///////////////////////////////////////////////
//:: Generic Combat Conversation Check
//:: NW_D2_gen_check
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Check to see whether the NPC has an initialized
    NPC is using SetSpecialCombatConversationStart
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 7, 2001
//:://////////////////////////////////////////////

#include "NW_I0_GENERIC"

int StartingConditional()
{
    object oSelf = OBJECT_SELF;

    if ( GetSpawnInCondition(NW_FLAG_SPECIAL_COMBAT_CONVERSATION) ) {
        if(  GetIsObjectValid(GetPCSpeaker()) )
            return FALSE;

        int nOnce = GetLocalInt( oSelf, "AR_Once" );
        if ( nOnce == TRUE ) {
            return FALSE;
        } else {
            SetLocalInt( oSelf, "AR_Once", TRUE );
            return TRUE;
        }

    }

    return FALSE;
}

