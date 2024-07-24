// Edit: Maverick00053, 11/23/2023, nerfed biteback hard.

void ApplyDefenderPassives(object player);
effect CreateDefenderDamageShield(object player);// DO NOT USE ANYMORE
effect CreateDefenderAbDamageBonus(object player);
void RemoveTaggedEffect(object player, string effectTag);
int HasTaggedEffect(object player, string effectTag);
int  GetEpicDrPoints(object player);
void RemoveDefenderPassives(object player);

int DefenderLevels = 0;
int ConBonus = 0;
const string DWD_PASSIVES = "DWD_PASSIVES";
const string DWD_AB = "dwd_ab";

//void main(){}

void ApplyDefenderPassives(object player)
{
    if(!GetIsPC(player)) return;

    ConBonus = GetAbilityModifier(ABILITY_CONSTITUTION, player);
    DefenderLevels = GetLevelByClass(CLASS_TYPE_DWARVENDEFENDER, player);
    int rawConstitution = GetAbilityScore(player, ABILITY_CONSTITUTION, TRUE);
    effect eStrBonus = EffectAbilityIncrease(ABILITY_STRENGTH,1);
    effect eTempHPBonus = EffectTemporaryHitpoints(10);
    effect eResistBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL,1);
    effect eACBonus = EffectACIncrease(1,AC_DODGE_BONUS);
    effect eLink;

    if(DefenderLevels >= 20)
    {
      eStrBonus = EffectAbilityIncrease(ABILITY_STRENGTH,5);
      eTempHPBonus = EffectTemporaryHitpoints(40);
      eResistBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL,7);
      eACBonus = EffectACIncrease(6,AC_DODGE_BONUS);
    }
    else if(DefenderLevels >= 16)
    {
      eStrBonus = EffectAbilityIncrease(ABILITY_STRENGTH,4);
      eTempHPBonus = EffectTemporaryHitpoints(30);
      eResistBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL,5);
      eACBonus = EffectACIncrease(4,AC_DODGE_BONUS);
    }
    else if(DefenderLevels >= 15)
    {
      eStrBonus = EffectAbilityIncrease(ABILITY_STRENGTH,4);
      eTempHPBonus = EffectTemporaryHitpoints(30);
      eResistBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL,4);
      eACBonus = EffectACIncrease(4,AC_DODGE_BONUS);
    }
    else if(DefenderLevels >= 14)
    {
      eStrBonus = EffectAbilityIncrease(ABILITY_STRENGTH,3);
      eTempHPBonus = EffectTemporaryHitpoints(30);
      eResistBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL,4);
      eACBonus = EffectACIncrease(3,AC_DODGE_BONUS);
    }
    else if(DefenderLevels >= 12)
    {
      eStrBonus = EffectAbilityIncrease(ABILITY_STRENGTH,3);
      eTempHPBonus = EffectTemporaryHitpoints(20);
      eResistBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL,4);
      eACBonus = EffectACIncrease(3,AC_DODGE_BONUS);
    }
    else if(DefenderLevels >= 10)
    {
      eStrBonus = EffectAbilityIncrease(ABILITY_STRENGTH,3);
      eTempHPBonus = EffectTemporaryHitpoints(20);
      eResistBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL,3);
      eACBonus = EffectACIncrease(3,AC_DODGE_BONUS);
    }
    else if(DefenderLevels >= 8)
    {
      eStrBonus = EffectAbilityIncrease(ABILITY_STRENGTH,2);
      eTempHPBonus = EffectTemporaryHitpoints(20);
      eResistBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL,3);
      eACBonus = EffectACIncrease(2,AC_DODGE_BONUS);
    }
    else if(DefenderLevels >= 7)
    {
      eStrBonus = EffectAbilityIncrease(ABILITY_STRENGTH,2);
      eTempHPBonus = EffectTemporaryHitpoints(20);
      eResistBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL,2);
      eACBonus = EffectACIncrease(2,AC_DODGE_BONUS);
    }
    else if(DefenderLevels >= 5)
    {
      eStrBonus = EffectAbilityIncrease(ABILITY_STRENGTH,2);
      eTempHPBonus = EffectTemporaryHitpoints(10);
      eResistBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL,2);
      eACBonus = EffectACIncrease(2,AC_DODGE_BONUS);
    }
    else if(DefenderLevels >= 4)
    {
      eStrBonus = EffectAbilityIncrease(ABILITY_STRENGTH,1);
      eTempHPBonus = EffectTemporaryHitpoints(10);
      eResistBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL,2);
      eACBonus = EffectACIncrease(1,AC_DODGE_BONUS);
    }

    eLink = EffectLinkEffects(eStrBonus,eTempHPBonus);
    eLink = EffectLinkEffects(eLink,eResistBonus);
    eLink = EffectLinkEffects(eLink,eACBonus);

    if((DefenderLevels >= 10) && (rawConstitution > 20))
    {
      eLink = EffectLinkEffects(eLink, CreateDefenderAbDamageBonus(player));
    }

    eLink = SupernaturalEffect(eLink);
    effect taggedPassives = TagEffect(eLink, DWD_PASSIVES);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, taggedPassives, player);
}

effect CreateDefenderAbDamageBonus(object player)
{
    int bonus = FloatToInt(ConBonus/4.0f);

    effect attackBonus = SupernaturalEffect(EffectAttackIncrease(bonus));

    return attackBonus;
}

effect CreateDefenderDamageShield(object player)  // DO NOT USE ANYMORE
{
    int damageShieldAmount = DefenderLevels/5;

    effect damageShield = EffectDamageShield(damageShieldAmount,0, DAMAGE_TYPE_DIVINE);

    damageShield = SupernaturalEffect(damageShield);

    return damageShield;
}

int GetEpicDrPoints(object player)
{
    int bonus = GetHasFeat(FEAT_EPIC_DAMAGE_REDUCTION_3) ? 1 : 0 +
                GetHasFeat(FEAT_EPIC_DAMAGE_REDUCTION_6) ? 1 : 0 +
                GetHasFeat(FEAT_EPIC_DAMAGE_REDUCTION_9) ? 1 : 0;
    return bonus;
}


void RemoveDefenderPassives(object player)
{
    if(HasTaggedEffect(player, DWD_PASSIVES))
        RemoveTaggedEffect(player, DWD_PASSIVES);
}

int HasTaggedEffect(object player, string effectTag)
{
    effect eEffect = GetFirstEffect(player);
    while(GetIsEffectValid(eEffect))
    {
        if(GetEffectTag(eEffect) == effectTag)
        {
            return TRUE;
        }
        eEffect = GetNextEffect(player);
    }
    return FALSE;
}

void RemoveTaggedEffect(object player, string effectTag)
{
    effect eEffect = GetFirstEffect(player);
    while(GetIsEffectValid(eEffect))
    {
        if(GetEffectTag(eEffect) == effectTag)
        {
            RemoveEffect(player, eEffect);
        }
        eEffect = GetNextEffect(player);
    }
}
