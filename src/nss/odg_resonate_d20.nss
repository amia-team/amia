void main()
{
    //Gives a creature a d20 chance of resonating, becoming paralyzed for 1 round
    //then gaining concealment for one round after. Can trigger once every 2 rounds
    object oTarget = OBJECT_SELF;
    int iHP = GetMaxHitPoints(oTarget)/4;
    int iCHP = GetCurrentHitPoints(oTarget);
    int iRes = GetDamageDealtByType(DAMAGE_TYPE_SONIC);
    effect eDam = EffectDamage(iHP, DAMAGE_TYPE_MAGICAL);
    effect ePara = EffectCutsceneParalyze();
    effect eSwirl = EffectVisualEffect(82);
    effect eBoth = EffectLinkEffects(ePara, eSwirl);
    effect eCon = EffectConcealment(50);
    effect eVis1 = EffectVisualEffect(183);
    effect eVis2 = EffectVisualEffect(6);
    effect eLink1 = EffectLinkEffects(eDam, eVis1);
    effect eLink2 = EffectLinkEffects(eCon, eVis2);
    string sODCooldown;

    //Will not trigger if this has been activated in past 2 Rounds
    if (GetLocalInt(oTarget, sODCooldown) == 1)
    {
    return;
    }

    //Check for sonic damage
    if (iRes >= 0)
    {
        //Chance roll. Can be raised or lowered if needed
        if (d20(1) == 20)
        {
            //Will not trigger under 25% to allow PC to gain Gold and XP
            if (iHP >= iCHP)
            {
            return;
            }
            else
            {
            SetLocalInt(oTarget, sODCooldown, 1);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBoth, oTarget, 6.0);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink1, oTarget);
            DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, 6.0));
            DelayCommand(12.0, SetLocalInt(oTarget, sODCooldown, 0));
            }
         }
    }
}
