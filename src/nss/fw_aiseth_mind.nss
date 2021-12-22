void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject( );
    // var
    int cLvl = GetCasterLevel(oPC);
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = cLvl;
    float baseWillMod = 4.0;
    float baseSkillMod = 2.0;

    //Meta Magic check for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    else if (nMetaMagic = METAMAGIC_EMPOWER)
    {
       baseWillMod = baseWillMod * 1.5;
       baseSkillMod = baseSkillMod * 1.5;
    }
    // set final vars: note*float always rounds down
    int w = FloatToInt(baseWillMod);
    int s = FloatToInt(baseSkillMod);

    // saving throw vs mind
    effect eWillVsMind = EffectSavingThrowIncrease(3,w,1);
    // int skills are increased
    effect eAppraise = EffectSkillIncrease(20,s);
    effect eCraftArmor = EffectSkillIncrease(25,s);
    effect eCraftTrap = EffectSkillIncrease(22,s);
    effect eCraftWeapon = EffectSkillIncrease(26,s);
    effect eDisableTrap = EffectSkillIncrease(2,s);
    effect eLore = EffectSkillIncrease(7,s);
    effect eSearch = EffectSkillIncrease(14,s);
    effect eSpellcraft = EffectSkillIncrease(16,s);
    // cha skills are decreased
    effect eAnimalEmpathy = EffectSkillDecrease(0,s);
    effect eBluff = EffectSkillDecrease(23,s);
    effect eIntimidate = EffectSkillDecrease(24,s);
    effect ePerform = EffectSkillDecrease(11,s);
    effect ePersuade = EffectSkillDecrease(12,s);
    effect eTaunt = EffectSkillDecrease(18,s);
    effect eUMD = EffectSkillDecrease(19,s);

    // vfx
    effect eVFX1 = EffectVisualEffect(141);
    effect eVFX2 = EffectVisualEffect(206);

    // elink
    effect eLink = EffectLinkEffects(eVFX1, eVFX2);
           eLink = EffectLinkEffects(eLink, eWillVsMind);
           eLink = EffectLinkEffects(eLink, eAppraise);
           eLink = EffectLinkEffects(eLink, eCraftArmor);
           eLink = EffectLinkEffects(eLink, eCraftTrap);
           eLink = EffectLinkEffects(eLink, eCraftWeapon);
           eLink = EffectLinkEffects(eLink, eDisableTrap);
           eLink = EffectLinkEffects(eLink, eLore);
           eLink = EffectLinkEffects(eLink, eSearch);
           eLink = EffectLinkEffects(eLink, eSpellcraft);
           eLink = EffectLinkEffects(eLink, eAnimalEmpathy);
           eLink = EffectLinkEffects(eLink, eBluff);
           eLink = EffectLinkEffects(eLink, eIntimidate);
           eLink = EffectLinkEffects(eLink, ePerform);
           eLink = EffectLinkEffects(eLink, ePersuade);
           eLink = EffectLinkEffects(eLink, eTaunt);
           eLink = EffectLinkEffects(eLink, eUMD);

    ApplyEffectToObject(1, eLink, oTarget, TurnsToSeconds(nDuration));
}
