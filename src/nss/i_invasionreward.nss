//::///////////////////////////////////////////////
//:: Name: invasionreward
//:://////////////////////////////////////////////
/*
    Custom effect for the demon invasion reward (Ancient Barrier Device).
    Gives the user 24 hours worth of +1 AC bonus,
    Dodge Type + 25% Immunity to fire.
*/
//:://////////////////////////////////////////////
//:: Created By: Maverick00053
//:: Created On: Aug 01, 19
//:://////////////////////////////////////////////

#include "x2_inc_switches"

void ActivateItem()
{
    object oUser = GetItemActivator      ();

    if (!GetIsPC(oUser))
        return;

    // Define the variables

    effect eVFX1   = EffectVisualEffect(VFX_DUR_AURA_PULSE_RED_ORANGE);
    effect eVFX2   = EffectVisualEffect(VFX_DUR_GLOW_RED);
    effect eVFX3   = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
    effect eAC     = EffectACIncrease(1, AC_DODGE_BONUS);
    effect eNega   = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 10);

    effect eBoost  = EffectLinkEffects(
                     eVFX1,
                     eVFX2);
           eBoost  = EffectLinkEffects(
                     eBoost,
                     eAC);
           eBoost  = EffectLinkEffects(
                     eBoost,
                     eNega);

    // Apply the effect

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        eBoost,
                        oUser,
                        HoursToSeconds(24));

    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        eVFX3,
                        oUser);
}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
