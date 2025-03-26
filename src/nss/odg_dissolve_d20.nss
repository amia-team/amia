void main()
{
    //Gives a creature a d20 chance to partially dissolve when damaged by acid,
    //But gains str and dex. Lasts 1 round, can trigger once every 2 rounds
    object oTarget = OBJECT_SELF;
    int iHP = GetMaxHitPoints(oTarget)/4;
    int iCHP = GetCurrentHitPoints(oTarget);
    int iDiss = GetDamageDealtByType(DAMAGE_TYPE_ACID);
    effect eVis1 = EffectVisualEffect(257);
    effect eVis2 = EffectVisualEffect(315);
    effect eDam = EffectDamage(iHP, DAMAGE_TYPE_MAGICAL);
    effect eSTR = EffectAbilityIncrease(0, 4);
    effect eDEX = EffectAbilityIncrease(1, 4);
    effect eLink1 = EffectLinkEffects(eDam, eVis1);
    effect eLink2 = EffectLinkEffects(eSTR, eDEX);
    string sODCooldown;

    //Will not trigger if this has been activated in past 2 Rounds
    if (GetLocalInt(oTarget, sODCooldown) == 1)
    {
    return;
    }

    //Check for damage type
    if (iDiss >= 0)
    {
        //Chance roll. Can be raised or lowered if needed
        if (d20(1) == 1)
        {
            //This will not trigger under 25% HP so PC can get gold and XP
            if (iHP >= iCHP)
            {
            return;
            }
            else
            {
            SetLocalInt(oTarget, sODCooldown, 1);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink1, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, 6.0);
            DelayCommand(12.0, SetLocalInt(oTarget, sODCooldown, 0));
            }
         }
    }
}

