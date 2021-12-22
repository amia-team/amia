// Fire Genasi: Fireball Spell-like Ability

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x0_i0_spells"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
//makes sure the effects have the right creator
void ActivateRaceToy( object oPC, location lTarget );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch ( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // vars
            object oPC       = GetItemActivator();
            location lTarget = GetItemActivatedTargetLocation();

            AssignCommand( oPC, ActivateRaceToy( oPC, lTarget ) );

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

void ActivateRaceToy( object oPC, location lTarget ){

    int nCasterLevel    = GetHitDice(oPC);
    effect eVfx     = EffectVisualEffect(VFX_IMP_FLAME_S);
    int nFireDamage = d6(nCasterLevel); // PoS - uncapped damage.

    // Fireball DC = 10 + HD/2 + CHA mod.
    int nDC        = 10 + GetHitDice( oPC )/2 + GetAbilityModifier( ABILITY_CHARISMA, oPC );

    // Fireball origin candy
    float fDelay    = 0.5;

    DelayCommand( fDelay, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_FIREBALL ), lTarget ) );

    // cycle through Fireball range
    object oVictim = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE );

    while ( GetIsObjectValid( oVictim ) ){

        // Non-friendly
        if( !GetIsReactionTypeFriendly( oVictim, oPC ) ) {

            //Fire cast spell at event for the specified target
            SignalEvent(oVictim, EventSpellCastAt(OBJECT_SELF, SPELL_FIREBALL));

            // reflex for 1/2, smite em with the Fireball!
            nFireDamage         = GetReflexAdjustedDamage( nFireDamage, oVictim, nDC, SAVING_THROW_TYPE_FIRE, oPC);

            effect eFireballDmg = EffectDamage( nFireDamage , DAMAGE_TYPE_FIRE);
            eFireballDmg        = EffectLinkEffects( eFireballDmg,  eVfx);

            fDelay += 0.1;

            DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eFireballDmg, oVictim ) );
        }

        oVictim = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    }
}
