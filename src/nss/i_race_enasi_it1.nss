// Earth Genasi: Spell-like Ability: Stoneskin
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "amia_include"

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

            // vars
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

    int nHD         = GetHitDice( oPC );
    float fDuration = NewHoursToSeconds( nHD );

    // 10 hitpoints per level up to max. of 150 - edit by PoS, we now cap at 100.
    int nAmount     =  10 *  nHD;

    if ( nAmount > 100 ){

        nAmount = 100;
    }

    // DR 10/+5
    effect eStoneskin   = EffectLinkEffects( EffectDamageReduction( 10, DAMAGE_POWER_PLUS_FIVE, nAmount), EffectVisualEffect(VFX_DUR_PROT_STONESKIN ) );
    effect eVfx         = EffectVisualEffect( VFX_IMP_SUPER_HEROISM );

    // candy
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVfx, oPC );

    // slap it on
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eStoneskin, oPC, fDuration);
}
