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
//::
//:: 24-Sep-2023    Frozen      Removed ice skin to be more universal usable
//::
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
    effect eElec   = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 25);

    // Apply the effect

    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        eVFX1,
                        oUser);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        eElec,
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
