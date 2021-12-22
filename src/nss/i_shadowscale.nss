//::///////////////////////////////////////////////
//:: Name: Shadowscale
//:://////////////////////////////////////////////
/*
    Custom effect for the shadow dragon scale.
    Gives the user 24 hours worth of +1 AC bonus,
    Dodge Type + 25% Immunity to Negative.
*/
//:://////////////////////////////////////////////
//:: Created By: PaladinOfSune
//:: Created On: Dec 03, 05
//:://////////////////////////////////////////////

#include "x2_inc_switches"

void ActivateItem()
{
    object oUser = GetItemActivator      ();

    if (!GetIsPC(oUser))
        return;

    // Define the variables

    effect eVFX1   = EffectVisualEffect(VFX_DUR_GHOST_TRANSPARENT);
    effect eVFX2   = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    effect eVFX3   = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
    effect eAC     = EffectACIncrease(1, AC_DODGE_BONUS);
    effect eNega   = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 25);

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
