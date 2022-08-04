//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: i_sp_signet
//used as: item activation script
//date: 2022-08-04
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

                SendMessageToPC( oPC, "You need to use this item on another character in order to show it!" );

                //ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oPC );

                //DestroyObject( oItem, 1.0 );

                //SetPCKEYValue( oTarget, "bp_2", 0 );
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





