//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:i_dmfi_pc_emote
//group: dmfi replacements
//used as: item activation script
//date: 2008-10-04
//author: Disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oTarget   = GetItemActivatedTarget();
            location lLocation = GetItemActivatedTargetLocation();
            location lPcLocation = GetLocation( oPC );

            if ( (!(GetIsDM(oPC) || GetIsDMPossessed(oPC)) && GetMaster(oTarget) != oPC && !GetIsPC(oTarget)))
            {
                oTarget = oPC;
            }

            SendMessageToPC( oPC, "dmfi_pc_emote: activated" );

            SetLocalString( oPC, "ds_action", "dmfi_pc_emote" );
            SetLocalObject( oPC, "ds_target", oTarget );
            SetLocalLocation( oPC, "ds_location", lLocation);
            SetLocalInt( oPC, "ds_check_1", GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC)));
            SetLocalInt( oPC, "ds_check_2", GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC)));
            SetLocalInt( oPC, "ds_check_3", GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC)));
            SetLocalInt( oPC, "ds_check_4", GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC)));
            SetLocalInt( oPC, "ds_check_5", GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC)));
            SetLocalInt( oPC, "ds_check_6", (GetIsObjectValid(oTarget) && GetIsPC(oTarget) && oTarget != oPC) && GetDistanceBetweenLocations(lLocation, lPcLocation) < 3.5 && !GetIsPossessedFamiliar(oTarget));
            AssignCommand( oPC, ActionStartConversation( oPC, "dmfi_pc_emote", TRUE, FALSE ) );

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

