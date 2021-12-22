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

            AssignCommand( oPC, PlayAnimation( ANIMATION_FIREFORGET_SALUTE ) );

            AssignCommand( oPC, SpeakString( "*eats a plate of "+GetName( oItem )+"*" ) );

            int nTaste = GetLocalInt( oItem, "quality" ) + d4();
            int nHit   = GetLocalInt( oItem, "amount" ) + d4() - GetAbilityModifier( ABILITY_CONSTITUTION, oPC );

            if ( nHit < 1 ){ nHit = 1; }

            SendMessageToPC( oPC, "*RP hints*" );
            SendMessageToPC( oPC, "  Taste (1-10): "+IntToString( nTaste ) );
            SendMessageToPC( oPC, "  Nourishment (1-10): "+IntToString( nHit ) );

            effect eHeal = EffectHeal( d10() );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eHeal, oPC );

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------





