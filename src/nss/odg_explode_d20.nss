void main()
{
    //Gives a creature a d20 chance to explode when damaged by fire, losing HP
    //But gaining a damage shield. Will only trigger up to once every 2 rounds
    object oTarget = OBJECT_SELF;
    int iHP = GetMaxHitPoints(oTarget)/4;
    int iCHP = GetCurrentHitPoints(oTarget);
    int iFuse = GetDamageDealtByType(DAMAGE_TYPE_FIRE);
    effect eFlame = EffectVisualEffect(498);
    effect eDam = EffectDamage(iHP, DAMAGE_TYPE_MAGICAL);
    effect eShield = EffectDamageShield(0, DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
    effect eLink = EffectLinkEffects(eFlame, eShield);
    string sODCooldown;

    //Will not trigger if this has been activated in past 2 Rounds
    if (GetLocalInt(oTarget, sODCooldown) == 1)
    {
    return;
    }

    //Check for damage type
    if (iFuse >= 0)
    {
        //Chance roll. Can be raised or lowered if needed
        if (d20(1) == 20)
        {
            //Will not trigger if target is under 25% HP
            if (iHP >= iCHP)
            {
            return;
            }
            else
            {
            SetLocalInt(oTarget, sODCooldown, 1);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            DelayCommand(12.0, SetLocalInt(oTarget, sODCooldown, 0));
            }
         }
    }
}

