//::///////////////////////////////////////////////
//:: Name: whitescale
//:://////////////////////////////////////////////
/*
    Custom effect for the white dragon scale.
    Gives the user 24 hours worth of 25% Immunity
    to Cold.
*/
//:://////////////////////////////////////////////
//:: Created By: PaladinOfSune
//:: Created On: Dec 03, 05
//:://////////////////////////////////////////////

#include "x2_inc_switches"
#include "amia_include"

void ActivateItem()
{
    object oUser = GetItemActivator      ();

    if (!GetIsPC(oUser))
        return;

    // Define the variables

    effect eVFX1   = EffectVisualEffect(VFX_IMP_PULSE_COLD);
    effect eVFX2   = EffectVisualEffect(VFX_DUR_ICESKIN);
    effect eElec   = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 25);

    effect eBoost  = EffectLinkEffects(
                     eVFX2,
                     eElec);

    // Apply the effect

    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        eVFX1,
                        oUser);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        eBoost,
                        oUser,
                        NewHoursToSeconds(24));
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
