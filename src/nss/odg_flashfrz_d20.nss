void main()
{
    //Gives a creature a d20 chance of flash freezing, taking HP damage and slow
    //But gaining damage reduction. Will trigger at most once ever 2 rounds
    object oTarget = OBJECT_SELF;
    int iHP = GetMaxHitPoints(oTarget)/4;
    int iCHP = GetCurrentHitPoints(oTarget);
    int iFreeze = GetDamageDealtByType(DAMAGE_TYPE_COLD);
    effect eDam = EffectDamage(iHP, DAMAGE_TYPE_MAGICAL);
    effect eSlow = EffectSlow();
    effect eRed = EffectDamageReduction(10, 5, 0);
    effect eVis1 = EffectVisualEffect(52);
    effect eVis2 = EffectVisualEffect(465);
    effect eLink1 = EffectLinkEffects(eDam, eVis1);
    effect eLink2 = EffectLinkEffects(eSlow, eVis2);
    effect eLink3 = EffectLinkEffects(eLink2, eRed);
    string sODCooldown;

    //Will not trigger if this has been activated in past 2 Rounds
    if (GetLocalInt(oTarget, sODCooldown) == 1)
    {
    return;
    }

    //Check for cold damage
    if (iFreeze >= 0)
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
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink3, oTarget, 6.0);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink1, oTarget);
            DelayCommand(12.0, SetLocalInt(oTarget, sODCooldown, 0));
            }
         }
    }
}

