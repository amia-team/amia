//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: i_ds_food
//group:
//used as: activation script
//date:    nov 02 2007
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
            string sItemName = GetName(oItem);

            effect eHeal = EffectHeal( d10() );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eHeal, oPC );

            if ( FindSubString( sItemName, "Food" ) == 0 ){

                PlaySound( "it_materialsoft" );

                AssignCommand( oPC, SpeakString( "*eats*" ) );
            }
            else if ( FindSubString( sItemName, "Beverage" ) == 0 ){

                PlaySound( "it_potion" );

                AssignCommand( oPC, SpeakString( "*drinks*" ) );
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
// functions
//----------------------------





