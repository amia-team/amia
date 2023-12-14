// Edit: Maverick00053, 11/23/2023, nerfed biteback hard.

void ApplyDefenderPassives(object player);
effect CreateDefenderDamageShield(object player);
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

    if(DefenderLevels <= 10) return;
    if(rawConstitution < 20) return;

    effect defenderPassives = CreateDefenderDamageShield(player);
    defenderPassives = EffectLinkEffects(defenderPassives, CreateDefenderAbDamageBonus(player));
    defenderPassives = SupernaturalEffect(defenderPassives);

    effect taggedPassives = TagEffect(defenderPassives, DWD_PASSIVES);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, taggedPassives, player);
}

effect CreateDefenderAbDamageBonus(object player)
{
    int bonus = FloatToInt(ConBonus/4.0f);

    effect attackBonus = SupernaturalEffect(EffectAttackIncrease(bonus));

    return attackBonus;
}

effect CreateDefenderDamageShield(object player)
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
