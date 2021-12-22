//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: i_destroy
//group: quests
//used as: item activation script
//date: 2020-10-19
//author: Jes

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
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

                ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oPC );

                DestroyObject( oItem, 1.0 );
            }
            else if ( GetIsPC( oTarget ) ){

                string sKey = GetDescription( oItem, FALSE, FALSE );

                ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oPC );

                DestroyObject( oItem, 1.0 );
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}
