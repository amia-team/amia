/*
    Custom Spell (Ranged): 9 Wiz/Sorc (Conjuration)
    Light of Le'Quella
        - 10m radius AoE lasting 10 rounds
        - Deals 1d3 per CL (max 10d3) Fire Damage and 1d6 Positive Damage per
          round on failed Reflex save (evasion applies).
            - On failed save, attempt to apply Combustion effect as per standard
              NWN spell (incluting initial Reflex save).
        - Also, Reflex save made every 3rd round versus 1d4 rounds of Blindness.
        - Spell Resistance does not apply.
*/

#include "x0_i0_spells"

void main()
{
    //get target
    location lTarget = GetSpellTargetLocation( );

    effect eAoE = EffectAreaOfEffect( AOE_PER_CUSTOM_AOE, "****", "spl_lequellahrtb", "****" );
    effect eBall = EffectVisualEffect( 4 );
    effect eArrive = EffectVisualEffect( 87 );
    effect eLight = EffectVisualEffect( VFX_DUR_LIGHT_WHITE_20 );
    effect eGlow = EffectVisualEffect( VFX_DUR_AURA_PULSE_YELLOW_WHITE );

    object oQuella = CreateObject( OBJECT_TYPE_PLACEABLE, "quellalight", lTarget );

    DelayCommand( 0.2, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLight, oQuella, 66.3 ) );
    DelayCommand( 0.3, ApplyEffectToObject( DURATION_TYPE_INSTANT, eArrive, oQuella ) );
    DelayCommand( 0.4, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBall, oQuella, 66.5 ) );
    DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eGlow, oQuella, 66.6 ) );
    DelayCommand( 0.6, SetLocalInt( oQuella, "Counter", 1 ) );
    DelayCommand( 0.7, ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAoE, lTarget, 66.8 ) );

    DelayCommand( 66.8, DestroyObject( oQuella ) );
}
