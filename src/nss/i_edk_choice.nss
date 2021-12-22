//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: edk_select
//description: Calling Routine for Epic Dragon Knight variant selection, this
// will open the conversation run the routine to set the variable in the
// database. Called from Epic Dragon Knight Statue item via the edk_choice tag.
//date: 28/10/2020
//author: Raphel Gray

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x2_inc_itemprop"
#include "amia_include"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------


//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void main() {
 //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            string sItemName = GetName( oItem );
            object oToken     = oItem;

            SetLocalObject( oPC, "edk_choice", oToken );
            SetLocalString( oPC, "ds_action", "edk_select" );
            AssignCommand(oPC,ActionWait(1.0));
            if ( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_NECROMANCY, oPC ) == TRUE ){
               AssignCommand(oPC,
                    ActionStartConversation(oPC,"c_edk_choice",TRUE));

            } else {
                AssignCommand(oPC,
                    ActionStartConversation(oPC,"c_edk_choice_noU",TRUE));
            }

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-----------------------------------------------------------------------------
// functions
//-----------------------------------------------------------------------------
