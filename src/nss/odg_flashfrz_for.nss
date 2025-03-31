void main()
{
    //Creature will flash freeze on failed fort roll, taking HP damage and being slowed
    //But gaining damage reduction. Will trigger once
    object oTarget = OBJECT_SELF;
    object oEnemy = GetLastDamager();
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
    string sODBlock;

    //This effect will only trigger once
    if (GetLocalInt(oTarget, sODBlock) == 1)
    {
    return;
    }

    //Fortitude Roll made against the amount of cold damage
    if (FortitudeSave(oTarget, iFreeze, SAVING_THROW_TYPE_COLD, oEnemy) == 0 )
    {

        //Will not trigger if creature under 25% HP
        if (iHP >= iCHP)
        {
        return;
        }
        else
        {
        SetLocalInt(oTarget, sODBlock, 1);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink3, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink1, oTarget);
        }
    }
}

