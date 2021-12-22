/*  i_ds_poison_x

--------
Verbatim
--------


---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
08-22-06  Disco       Start of header
------------------------------------------------------------------

*/


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

    object oPC;
    object oItem;
    object oTarget;
    int nPoison    = 56;
    effect ePoison = EffectPoison( nPoison );


    switch (nEvent){

        case X2_ITEM_EVENT_ONHITCAST:

            // item activate variables
            oPC       = OBJECT_SELF;
            oTarget   = GetSpellTargetObject();

            //testing
            SendMessageToPC( oPC, Get2DAString( "poison", "Label", nPoison ) );

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePoison, oTarget, 30.0f );

        break;

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            oPC       = GetItemActivator();

            //testing
            SendMessageToPC( oPC, Get2DAString( "poison", "Label", nPoison ) );

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePoison, oPC, 60.0f );

        break;

    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

