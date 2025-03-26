void main()
{
    //Creature will explode the first time it fails a fortitude save vs amount of
    //Fire damage. Effect will only trigger once and fire shield remains
    object oTarget = OBJECT_SELF;
    object oEnemy = GetLastDamager();
    int iHP = GetMaxHitPoints(oTarget)/4;
    int iCHP = GetCurrentHitPoints(oTarget);
    int iFuse = GetDamageDealtByType(DAMAGE_TYPE_FIRE);
    effect eFlame = EffectVisualEffect(498);
    effect eDam = EffectDamage(iHP, DAMAGE_TYPE_MAGICAL);
    effect eShield = EffectDamageShield(0, DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
    effect eLink = EffectLinkEffects(eFlame, eShield);
    string sODBlock;

     //This will only trigger once, the burning effect will be permanent
     if (GetLocalInt(oTarget, sODBlock) == 1)
     {
     return;
     }

    //The check to explode is a Fortitude Roll, DC is the amount of Fire damage
    if (FortitudeSave(oTarget, iFuse, SAVING_THROW_TYPE_FIRE, oEnemy) == 0 )
    {
        //Will not trigger if creature is under 25% HP
        if (iHP >= iCHP)
        {
        return;
        }
        else
        {
        SetLocalInt(oTarget, sODBlock, 1);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        }
    }
}

