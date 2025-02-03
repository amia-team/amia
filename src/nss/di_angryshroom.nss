//Repurposed Gargoyle Script to summon an angry myconid


void main()
{
   object oCreature = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
   if (GetIsObjectValid(oCreature) == TRUE && GetDistanceToObject(oCreature) < 10.)
   {
    effect eBoom = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_NATURE);
    object oShroom = CreateObject(OBJECT_TYPE_CREATURE, "hak_m_005", GetLocation(OBJECT_SELF));
    SpeakString("*Angry rustling*");
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eBoom, oShroom);
    SetPlotFlag(OBJECT_SELF, FALSE);
    DestroyObject(OBJECT_SELF, 0.5);
   }
}
