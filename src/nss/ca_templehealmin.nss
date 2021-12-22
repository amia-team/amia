void main()
{
  object oPC = GetPCSpeaker();
  int nHeal = GetMaxHitPoints(oPC);
  effect eHeal = EffectHeal(nHeal);
  effect eVisual = EffectVisualEffect(VFX_IMP_HEALING_X);
  ActionPauseConversation();
  ActionCastFakeSpellAtObject(SPELL_HEAL, OBJECT_SELF);
  ApplyEffectToObject(DURATION_TYPE_INSTANT,eHeal,oPC);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oPC);
  ActionResumeConversation();
}

