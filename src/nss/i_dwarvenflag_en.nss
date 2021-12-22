// See main file: i_dwarvenflag
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 2015/12/12 BasicHuman       Initial Release.

effect EffectDwarvenFlagBenefitsEffect();

void main()
{
    object oAOECreator = GetAreaOfEffectCreator();
    object oHoldingPC = GetItemPossessor(oAOECreator);
    object oEnteringCreature = GetEnteringObject();

    if(!GetIsFriend(oEnteringCreature, oHoldingPC))
        return;
    // we won't stack effects if two copies of same tag item are used
    string sItemTag = GetTag(oAOECreator);
    effect e = GetFirstEffect(oEnteringCreature);
    while(GetIsEffectValid(e))
    {
        if(GetTag(GetEffectCreator(e)) == sItemTag)
        {
            return;
        }
        e = GetNextEffect(oEnteringCreature);
    }
    SendMessageToPC(oHoldingPC, "Going to apply effects "+GetName(oAOECreator));
    AssignCommand(oAOECreator,
                  ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                      EffectDwarvenFlagBenefitsEffect(),
                                      oEnteringCreature));
}


effect EffectDwarvenFlagBenefitsEffect()
{
    effect eFireResist = EffectDamageResistance(DAMAGE_TYPE_FIRE, 15);
    effect eWillSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_FEAR);
    effect eAttackBonus = EffectAttackIncrease(2, ATTACK_BONUS_MISC);
    effect eDamageIncrease = EffectDamageIncrease(2);
    effect eConcentration = EffectSkillIncrease(SKILL_CONCENTRATION,4);
    effect eDiscipline = EffectSkillIncrease(SKILL_DISCIPLINE,4);

    effect eLinked = EffectLinkEffects(eFireResist, eWillSave);
    eLinked = EffectLinkEffects(eLinked, eAttackBonus);
    eLinked = EffectLinkEffects(eLinked, eDamageIncrease);
    eLinked = EffectLinkEffects(eLinked, eConcentration);
    eLinked = EffectLinkEffects(eLinked, eDiscipline);

    return SupernaturalEffect(eLinked);

}
