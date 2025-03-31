void main()
{
    //Creature has a chance of resonating, losing HP, becoming paralyzed for one round
    //Then gaining concealment afterwards. Will trigger once
    object oTarget = OBJECT_SELF;
    object oEnemy = GetLastDamager();
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
    string sODBlock;

    //Will trigger once
    if (GetLocalInt(oTarget, sODBlock) == 1)
    {
    return;
    }

    //Check for sonic damage
    if (FortitudeSave(oTarget, iRes,SAVING_THROW_TYPE_SONIC,oEnemy) == 0 )
    {

        //Will not trigger under 25% to allow PC to gain Gold and XP
        if (iHP >= iCHP)
        {
        return;
        }
        else
        {
        SetLocalInt(oTarget, sODBlock, 1);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBoth, oTarget, 6.0);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink1, oTarget);
        DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget));
        }
    }
}
