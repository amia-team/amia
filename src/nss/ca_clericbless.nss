// Conversation action for Salandran Clerics.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/02/2005 bbillington      Initial Release
// 20050502   jking            Refactored

void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetPCSpeaker();

    AssignCommand(oCaster,
                  ActionCastFakeSpellAtObject(SPELL_HOLY_AURA, oTarget,
                                              PROJECTILE_PATH_TYPE_DEFAULT));

    effect eVF1 = EffectVisualEffect(VFX_IMP_GOOD_HELP);
    effect eVF2 = EffectVisualEffect(VFX_IMP_HOLY_AID );

    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 1);
    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 1);
    effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, 1);
    effect eInt = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 1);
    effect eWis = EffectAbilityIncrease(ABILITY_WISDOM, 1);
    effect eCha = EffectAbilityIncrease(ABILITY_CHARISMA, 1);

    effect eSR  = EffectSpellResistanceIncrease(12);
    effect eHL  = EffectHeal(d8(4));

    ApplyEffectToObject(DURATION_TYPE_INSTANT  , eVF1, oTarget                   );
    ApplyEffectToObject(DURATION_TYPE_INSTANT  , eVF2, oTarget                   );
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStr, oTarget, TurnsToSeconds(5));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDex, oTarget, TurnsToSeconds(5));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCon, oTarget, TurnsToSeconds(5));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInt, oTarget, TurnsToSeconds(5));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWis, oTarget, TurnsToSeconds(5));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCha, oTarget, TurnsToSeconds(5));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSR , oTarget, TurnsToSeconds(5));
    ApplyEffectToObject(DURATION_TYPE_INSTANT  , eHL , oTarget                   );
}

