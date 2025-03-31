void main()
{
    //Gives a chance to partially dissolve when damaged by acid, but gains stats
    //Will only trigger once
    object oTarget = OBJECT_SELF;
    object oEnemy = GetLastDamager();
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
    string sODBlock;

    //Will only trigger once
     if (GetLocalInt(oTarget, sODBlock) == 1)
     {
     return;
     }

     //Chance roll. Can be raised or lowered if needed
     if (FortitudeSave(oTarget, iDiss, SAVING_THROW_TYPE_ACID, oEnemy) == 0 )
     {
        //This will not trigger under 25% HP so PC can get gold and XP
        if (iHP >= iCHP)
        {
        return;
        }
        else
        {
        SetLocalInt(oTarget, sODBlock, 1);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink1, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget);
        }
     }
}
