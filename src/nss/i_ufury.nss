/*  DC Item :: Stillborn's Unnatural Fury :: OnUse: Unique Power: Target [Self]

    --------
    Verbatim
    --------
    1 minute 30 second's worth of 20% of attack bonus boost to attack and damage.
    Then simulate a death.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    110206  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

// Includes.
#include "x2_inc_switches"


void main(){

    // Variables.
    int nEvent                  = GetUserDefinedItemEventNumber( );
    int nResult                 = X2_EXECUTE_SCRIPT_END;

    switch(nEvent){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC          = GetItemActivator( );
            int nAttack         = GetBaseAttackBonus( oPC ) + GetAbilityModifier( ABILITY_STRENGTH, oPC );


            // Boost 20% of attack.
            int nBoost          = FloatToInt( IntToFloat( nAttack ) * 0.2 );
            // Boost attack & damage.
            effect eBoost       = EffectLinkEffects(
                ExtraordinaryEffect( EffectAttackIncrease( nBoost ) ),
                ExtraordinaryEffect( EffectDamageIncrease( nBoost, DAMAGE_TYPE_PIERCING ) ) );
            // Knockdown vfx.
            effect eKnock       = ExtraordinaryEffect( EffectKnockdown( ) );

            // Impact visual.
            effect eImpVfx      = EffectVisualEffect( VFX_IMP_NEGATIVE_ENERGY );
            effect eImpVfx2     = EffectVisualEffect( VFX_COM_BLOOD_CRT_RED );
            // Duration visual.
            effect eDurVfx      = ExtraordinaryEffect( EffectVisualEffect( VFX_DUR_AURA_PULSE_RED_BLACK ) );

            // Apply the effects and emote.
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBoost, oPC, 90.0 );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDurVfx, oPC, 90.0 );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eImpVfx, oPC );
            PlayVoiceChat( VOICE_CHAT_BATTLECRY1, oPC );

            // Simulated death in 1 minute, 30 seconds.
            DelayCommand( 90.0, PlayVoiceChat( VOICE_CHAT_DEATH, oPC ) );
            DelayCommand( 90.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eKnock, oPC, 30.0 ) );

            float fDelay = 89.0;
            int nCounter = 0;
            // Lots of blood.
            for( nCounter = 0; nCounter < 30; nCounter++ ){
                fDelay += 1.0;
                DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eImpVfx2, oPC ) );
            }

            break;

        }

        default:
            break;

    }

    SetExecutedScriptReturnValue( nResult );
    return;

}
