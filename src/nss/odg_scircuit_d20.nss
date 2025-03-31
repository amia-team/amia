void main()
{
    //Gives a creature a d20 chance of short circuiting, exploding, going prone for 1 round
    //Then receiving haste and weapon damage for 1 round. Can happen once every 2 rounds
    object oTarget = OBJECT_SELF;
    int iHP = GetMaxHitPoints(oTarget)/4;
    int iCHP = GetCurrentHitPoints(oTarget);
    int iShock = GetDamageDealtByType(DAMAGE_TYPE_ELECTRICAL);
    effect eDam = EffectDamage(iHP, DAMAGE_TYPE_MAGICAL);
    effect eProne = EffectKnockdown();
    effect eHaste = EffectHaste();
    effect eWeap = EffectDamageIncrease(7, 128);
    effect eVis1 = EffectVisualEffect(75);
    effect eVis2 = EffectVisualEffect(65);
    effect eLink1 = EffectLinkEffects(eHaste, eWeap);
    effect eLink2 = EffectLinkEffects(eVis1, eVis2);
    string sODCooldown;

    //Will not trigger if this has been activated in past 2 Rounds
    if (GetLocalInt(oTarget, sODCooldown) == 1)
    {
    return;
    }

    //Check for cold damage
    if (iShock >= 0)
    {
        //Chance roll. Can be raised or lowered if needed
        if (d20(1) == 20)
        {
            //Will not trigger under 25% HP to allow PC to gain XP and Gold
            if (iHP >= iCHP)
            {
            return;
            }
            else
            {
            SetLocalInt(oTarget, sODCooldown, 1);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eProne, oTarget, 6.0);
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget));
            DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget));
            DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oTarget));
            DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink1, oTarget, 6.0));
            DelayCommand(12.0, SetLocalInt(oTarget, sODCooldown, 0));
            }
         }
    }
}

