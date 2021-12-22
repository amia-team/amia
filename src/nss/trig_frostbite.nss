//::///////////////////////////////////////////////
//:: trig_frostbite
//:://////////////////////////////////////////////
/*
  A custom trigger to inflict d4 cold damage and
  give the victim a 5% immunity decrease to cold
  for 3 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: PaladinOfSune
//:: Created On: 24th February 2006
//:://////////////////////////////////////////////


#include "NW_I0_SPELLS"

void main()

{

// Declare major variables.

    object oVictim = GetEnteringObject();

    if( !GetIsPC( oVictim ) )
        return;

    int    nDamage    = d4(1);
    effect eFrostbite = EffectDamageImmunityDecrease(DAMAGE_TYPE_COLD, 5);
    effect eDamage    = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
    effect eVisual    = EffectVisualEffect(VFX_COM_HIT_FROST);


// Apply the effects!

         ApplyEffectToObject(
              DURATION_TYPE_TEMPORARY,
              eFrostbite,
              oVictim,
              RoundsToSeconds(3));

         ApplyEffectToObject(
              DURATION_TYPE_INSTANT,
              eDamage,
              oVictim);

         ApplyEffectToObject(
              DURATION_TYPE_INSTANT,
              eVisual,
              oVictim);


}
