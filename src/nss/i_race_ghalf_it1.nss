// Ghostwise Halfling SL-Ability: Clairaudience/Clairvoyance
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

    // +10 to Listen & Spot skills for 1 round per level
    effect eSkill_increases = EffectSkillIncrease( SKILL_LISTEN, 10 );
    eSkill_increases        = EffectLinkEffects( eSkill_increases, EffectSkillIncrease( SKILL_SPOT, 10 ) );


    eSkill_increases        = EffectLinkEffects( eSkill_increases, EffectVisualEffect( VFX_DUR_MAGICAL_SIGHT ) );

    // undispellable
    eSkill_increases        = ExtraordinaryEffect( eSkill_increases );

    // slap it on
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSkill_increases, oPC, RoundsToSeconds( GetHitDice( oPC ) ) );
}
