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
    object oUser = GetItemActivator();
    object oDevice = GetItemActivated();

    if (!GetIsPC(oUser))
        return;

    //from any ioun stones (including self)
    effect eFirstEffect = GetFirstEffect(oUser);
    while (GetIsEffectValid(eFirstEffect) == TRUE)
    {
        if (GetEffectTag(eFirstEffect) == "ancientdevice")
        {
          FloatingTextStringOnCreature("*Another Ancient Barrier's effects overwritten*",oUser,FALSE);
          RemoveEffect(oUser,eFirstEffect);
        }
        eFirstEffect = GetNextEffect(oUser);
    }

    effect eVFX1   = EffectVisualEffect(VFX_DUR_AURA_PULSE_RED_YELLOW);
    effect eVFX2   = EffectVisualEffect(VFX_DUR_GLOW_RED);
    effect eVFX3   = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
    effect eAC     = EffectACIncrease(1, AC_DODGE_BONUS);
    effect eNega;

    if(GetLocalString(oDevice,"element")=="cold")
    {
     eNega = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 10);
     effect eVFX1   = EffectVisualEffect(VFX_DUR_AURA_PULSE_CYAN_WHITE);
     effect eVFX2   = EffectVisualEffect(VFX_DUR_GLOW_WHITE);
     effect eVFX3   = EffectVisualEffect(VFX_IMP_PULSE_COLD);
    }
    else if(GetLocalString(oDevice,"element")=="electrical")
    {
     eNega = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 10);
     effect eVFX1   = EffectVisualEffect(VFX_DUR_AURA_PULSE_BLUE_WHITE);
     effect eVFX2   = EffectVisualEffect(VFX_DUR_GLOW_BLUE);
     effect eVFX3   = EffectVisualEffect(VFX_IMP_PULSE_WIND);
    }
    else if(GetLocalString(oDevice,"element")=="negative")
    {
     eNega = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 10);
     effect eVFX1   = EffectVisualEffect(VFX_DUR_AURA_PULSE_PURPLE_BLACK);
     effect eVFX2   = EffectVisualEffect(VFX_DUR_GLOW_PURPLE);
     effect eVFX3   = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
    }
    else if(GetLocalString(oDevice,"element")=="acid")
    {
     eNega = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 10);
     effect eVFX1   = EffectVisualEffect(VFX_DUR_AURA_PULSE_GREEN_BLACK);
     effect eVFX2   = EffectVisualEffect(VFX_DUR_GLOW_GREEN);
     effect eVFX3   = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
    }
    else if(GetLocalString(oDevice,"element")=="fire")
    {
     eNega = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 10);
    }
    else
    {
     eNega = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 10);
    }





    effect eBoost  = EffectLinkEffects(eVFX1,eVFX2);
           eBoost  = EffectLinkEffects(eBoost,eAC);
           eBoost  = EffectLinkEffects(eBoost,eNega);
           eBoost  = TagEffect(eBoost,"ancientdevice");

    // Apply the effect

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBoost,oUser,HoursToSeconds(24));

    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX3,oUser);
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
