//::///////////////////////////////////////////////
//:: Gated Demon: On Heartbeat
//:: NW_C2_GATED.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script will have people perform default
    animations. For the Gated Balor this script
    will check if the master is protected from
    by Protection from Evil.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////
#include "NW_I0_GENERIC"

void main()
{

    object oMaster = GetMaster(OBJECT_SELF);

    if(!GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL, oMaster) &&
       !GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL, oMaster) &&
       !GetHasSpellEffect(SPELL_HOLY_AURA, oMaster ) ){

        RemoveSummonedAssociate(oMaster, OBJECT_SELF);

        SetIsTemporaryEnemy(oMaster);

        SetLocalObject( OBJECT_SELF, "ds_ai_target", oMaster );
    }
    else {

        SetIsTemporaryFriend(oMaster);
    }


    ExecuteScript( "ds_ai2_heartbeat", OBJECT_SELF );
}
