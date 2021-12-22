//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: i_ds_item_portrt
//group:  dm tools
//used as: item activation script
//date:    apr 22 2008
//author:  disco


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
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            int nBaseItem    = GetBaseItemType( oTarget );
            int nMax;
            int nAppearance  = GetItemAppearance( oTarget, ITEM_APPR_TYPE_SIMPLE_MODEL, 0 );

            if ( nBaseItem == BASE_ITEM_MISCLARGE ){

                nMax = 31;
            }
            else if ( nBaseItem == BASE_ITEM_MISCMEDIUM ){

                nMax = 254;
            }
            // Misc Medium 2
            else if ( nBaseItem == 121 ) {
                nMax = 66;
            }
            else if ( nBaseItem == BASE_ITEM_MISCSMALL ) {
                nMax = 254;
            }
            // Small 2
            else if ( nBaseItem == 119 ) {
                nMax = 254;
            }
            // Small 3
            else if ( nBaseItem == 120 ) {
                nMax = 100;
            }
            else if ( nBaseItem == BASE_ITEM_MISCTHIN ){
                nMax = 101;
            }
            else{

                DeleteLocalInt( oPC, "ds_max" );
                return;
            }

            SetCustomToken( 4601, IntToString( nAppearance ) );
            SetCustomToken( 4602, GetName( oTarget ) );
            SetCustomToken( 4603, IntToString( nMax ) );
            SetLocalInt( oPC, "ds_max", nMax );
            SetLocalString( oPC, "ds_action", "ds_item_portrt" );
            SetLocalObject( oPC, "ds_target", oTarget );

            AssignCommand( oPC, ActionStartConversation( oPC, "ds_item_portrt", TRUE, FALSE ) );

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

