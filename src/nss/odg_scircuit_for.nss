void main()
{
    //Creature will explode and fall prone the first time it fails a fortitude save vs amount of
    //Electrical damage, gaining haste and weapon damage afterwards. Will trigger once
    object oTarget = OBJECT_SELF;
    object oEnemy = GetLastDamager();
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
    string sODBlock;

     //This will only trigger once, the burning effect will be permanent
    if (GetLocalInt(oTarget, sODBlock) == 1)
    {
    return;
    }

    //Fortitude check made against incoming electrical damage
    if (FortitudeSave(oTarget, iShock,SAVING_THROW_TYPE_ELECTRICITY,oEnemy) == 0 )
    {
        //Will not trigger under 25% to allow PC to gain gold and XP
        if (iHP >= iCHP)
        {
        return;
        }
        else
        {
        SetLocalInt(oTarget, sODBlock, 1);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eProne, oTarget, 6.0);
        DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget));
        DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget));
        DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oTarget));
        DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink1, oTarget, 6.0));
        }
    }
}

