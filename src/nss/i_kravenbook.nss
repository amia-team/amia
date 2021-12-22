//::///////////////////////////////////////////////
//:: Name: kravenbook
//:://////////////////////////////////////////////
/*
    Custom effect for Kraven's book.
    Gives the user 3 Regeneration in exchange
    for half of their current HP, for two hours.
*/
//:://////////////////////////////////////////////
//:: Created By: PaladinOfSune
//:: Created On: Dec 04, 05
//:://////////////////////////////////////////////

#include "x2_inc_switches"
#include "amia_include"

void ActivateItem()
{
    object oUser = GetItemActivator();

    if (    (!GetIsPC(oUser))                           ||
            (GetLocalInt(
                oUser,
                "cs_kravenbook1")==1)                   )
        return;

    // refresh stacking timer
    SetLocalInt(
        oUser,
        "cs_kravenbook1",
        1);

    DelayCommand(
        NewHoursToSeconds(2),
        SetLocalInt(
            oUser,
            "cs_kravenbook1",
            0));

    // Define the variables

    int nDamage      = GetCurrentHitPoints(oUser) / 2;
    effect eVFX1     = EffectVisualEffect(VFX_IMP_EVIL_HELP);
    effect eVFX2     = EffectVisualEffect(VFX_IMP_DEATH_L);
    effect eRegen    = EffectRegenerate(3, 6.0);
    effect eDmg      = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);

    effect eBoost   = EffectLinkEffects(
                        eVFX1,
                        eVFX2);

    effect eBoost2  = SupernaturalEffect(EffectLinkEffects(
                        eRegen,
                        eDmg));

    // Apply the effect

    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        eBoost,
                        oUser);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        eBoost2,
                        oUser,
                        NewHoursToSeconds(2));
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
