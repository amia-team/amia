//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_ds_sign_widget
//group:   dm tools
//used as: activation script
//date:    oct 06 2008
//author:  disco


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
            location lTarget = GetItemActivatedTargetLocation();
            string sTag      = "sign_" + GetPCPublicCDKey( oPC, TRUE );
            object oPLC      = GetObjectByTag( sTag );

            if ( !GetIsObjectValid( oPLC ) ){

                oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_sign_widget", lTarget, TRUE, sTag );

                SetName( oPLC, GetName( oItem ) );

                if ( GetDescription( oItem ) != "Sign Widget" ){

                    SetDescription( oPLC, GetDescription( oItem ) );
                }
            }
            else{

                DestroyObject( oPLC );
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

