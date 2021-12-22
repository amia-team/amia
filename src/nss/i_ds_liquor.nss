//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:
//group:
//used as: item activation script
//date:
//author:


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
            string sItemName = GetName(oItem);

            AssignCommand( oPC, PlayAnimation( ANIMATION_FIREFORGET_DRINK ) );

            AssignCommand( oPC, SpeakString( "*drinks a glass of "+GetName( oItem )+"*" ) );

            int nTaste = GetLocalInt( oItem, "quality" ) + d4();
            int nHit   = GetLocalInt( oItem, "strength" ) + d4() - GetAbilityModifier( ABILITY_CONSTITUTION, oPC );

            if ( nHit < 1 ){ nHit = 1; }

            SendMessageToPC( oPC, "*RP hints*" );
            SendMessageToPC( oPC, "  Taste (1-10): "+IntToString( nTaste ) );
            SendMessageToPC( oPC, "  Alcoholic hit (1-10): "+IntToString( nHit ) );


        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------





