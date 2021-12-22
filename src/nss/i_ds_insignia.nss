//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: i_ds_insignia
//group: faction stuff
//used as: item activation script
//date: 2008-10-05
//author:disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_ds_porting"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------


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
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            string sItemName = GetName(oItem);
            location lTarget = GetItemActivatedTargetLocation();


            if ( oTarget == oPC ){

                string sKey = GetDescription( oItem, FALSE, FALSE );

                if ( sKey != "" ){

                    ds_take_item( oPC, sKey );
                }

                ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oPC );

                DestroyObject( oItem, 1.0 );

                SetPCKEYValue( oTarget, "bp_2", 0 );
            }
            else if ( GetIsPC( oTarget ) ){

                SendMessageToPC( oTarget, "*"+GetName(oPC)+" flashes "+sItemName+"*" );
                SendMessageToPC( oPC, "*You show "+GetName(oTarget)+" your "+sItemName+"*" );

                AssignCommand( oPC, PlayAnimation( ANIMATION_FIREFORGET_STEAL ) );
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------





