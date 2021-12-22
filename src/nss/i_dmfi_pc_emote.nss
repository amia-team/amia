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
#include "amia_include"


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
            ds_take_item( oPC, "dmfi_pc_emote");
            ds_create_item( "dmfi_pc_emote2", oPC );
        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

