/*
      June 20th 2019 - Maverick00053
      Combat Bandage Feat for the Combat Medic class.

*/



void main()
{

    object oPC = OBJECT_SELF;
    object oTarget = GetAttemptedSpellTarget();
    int nMedicHeal = GetLocalInt(oTarget, "medicheal");
    int nCoolDown = GetLocalInt(oTarget, "mediccd");
    int nCombatMedicLevels = GetLevelByClass(49, oPC);
    int nWisdomMod = GetAbilityModifier(ABILITY_WISDOM,oPC);
    float fTime = IntToFloat(nCombatMedicLevels*2*6)+1.0;
    float fTime2 = IntToFloat(nCombatMedicLevels*2*6*5);
    float fCoolDown = 20.0;

    effect eRegen;
    effect eSaves;
    effect eTempHp;
    effect eLink;

    if(nWisdomMod >= 5)
    {
       nWisdomMod = 5;
    }
    else if(nWisdomMod <= 0)
    {
       nWisdomMod = 0;
    }

    // Checks to see if the cooldown is active, if not it proceeds
    if(nCoolDown == 0)
    {

    // Rounds = 6 seconds, turns =  60s, hour = 2 turns, 20 rounds - Applying effects of the feat based on Combat Medic Level
    if(nCombatMedicLevels == 5 && nMedicHeal == 0)
    {
        eRegen = EffectRegenerate(nWisdomMod,6.0);
        eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, 3);
        eTempHp = EffectTemporaryHitpoints(nCombatMedicLevels*10);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRegen, oTarget, fTime);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTempHp, oTarget, fTime2);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSaves, oTarget, fTime2);
        SetLocalInt(oTarget, "medicheal", 1);
        DelayCommand(fTime2,DeleteLocalInt(oTarget, "medicheal"));
        // Cool down for the medic ability
        SetLocalInt(oPC, "mediccd", 1);
        DelayCommand(fCoolDown,DeleteLocalInt(oPC, "mediccd"));
    }
    else if(nCombatMedicLevels >= 3  && nMedicHeal == 0)
    {
        eRegen = EffectRegenerate(nWisdomMod,6.0);
        eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRegen, oTarget, fTime);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSaves, oTarget, fTime2);
        SetLocalInt(oTarget, "medicheal", 1);
        DelayCommand(fTime2,DeleteLocalInt(oTarget, "medicheal"));
        // Cool down for the medic ability
        SetLocalInt(oPC, "mediccd", 1);
        DelayCommand(fCoolDown,DeleteLocalInt(oPC, "mediccd"));
    }
    else if(nCombatMedicLevels >= 1  && nMedicHeal == 0)
    {
        eRegen = EffectRegenerate(nWisdomMod,6.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRegen, oTarget, fTime);
        SetLocalInt(oTarget, "medicheal", 1);
        DelayCommand(fTime,DeleteLocalInt(oTarget, "medicheal"));
        // Cool down for the medic ability
        SetLocalInt(oPC, "mediccd", 1);
        DelayCommand(fCoolDown,DeleteLocalInt(oPC, "mediccd"));
    }
    else if(nMedicHeal == 1)
    {
      SendMessageToPC(oPC, "Target is already under the effect of your healing!");
    }


    }
    else if(nCoolDown == 1)
    {
      SendMessageToPC(oPC, "Combat Bandage is still on cooldown!");

    }




}
