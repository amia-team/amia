// Aasimar Light SL-Ability
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
//makes sure the effects have the right creator
void ActivateRaceToy( object oPC );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch ( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            object  oPC     = GetItemActivator();

            AssignCommand( oPC, ActivateRaceToy( oPC ) );

            break;
        }
        default:{
            break;
        }
    }
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void ActivateRaceToy( object oPC ){

    int     nHD         = GetHitDice( oPC );
    effect  eLight      = ExtraordinaryEffect( EffectVisualEffect( VFX_DUR_LIGHT_BLUE_15 ) );   // 15ft. blue light
    float   fDuration   = 10.0 * 60.0 * IntToFloat( nHD );  // 10 minutes per level

    // anim
    AssignCommand( oPC , PlaySound( "sce_positive" ) );

    // slap it on
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY , eLight , oPC , fDuration);
}
