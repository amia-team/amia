/*
   On used script for blocking rocks or other objects in the dynamic dungeon tool system

 - Maverick00053 11/11/2023
 - Lord-Jyssev 3/15/24: Added function to destroy all blockers at once
*/

#include "dung_inc"

// Launches the Str Check Script
void StrCheck( object oPLC, object oPC);
// Launches the Dex Check Script
void DexCheck( object oPLC, object oPC);
// Launches the Spellcraft Check Script
void SCraftCheck(object oPLC,object oPC);

void main()
{
  object oPC = GetLastUsedBy();
  object oPLC = OBJECT_SELF;
  int nStr = GetLocalInt(oPLC,"str");
  int nSCraft = GetLocalInt(oPLC,"scraft");
  int nDex = GetLocalInt(oPLC,"dex");

  if(nStr == 1)
  {
    StrCheck(oPLC,oPC);
  }
  else if(nDex == 1)
  {
    DexCheck(oPLC,oPC);
  }
  else if(nSCraft == 1)
  {
    SCraftCheck(oPLC,oPC);
  }

}

void StrCheck( object oPLC, object oPC)
{
   int nSkillRank = GetSkillRank(SKILL_DISCIPLINE,oPC);
   int nLevel = GetLocalInt(oPLC,"level");
   int nDC = nLevel + 10 + (nLevel-(nLevel/3));
   int nDiceRoll = Random(20)+1;
   effect eVis = EffectVisualEffect(VFX_COM_CHUNK_STONE_MEDIUM);

   if((nDiceRoll+nSkillRank) >= nDC)
   {
     SendMessageToPC(oPC,"Skill Check (DISCIPLINE): " + IntToString(nSkillRank) + " + " + IntToString(nDiceRoll) + " = " +
     IntToString((nSkillRank+nDiceRoll)) + " Vs " + IntToString(nDC) + " !SUCCESS!");
     AssignCommand(oPLC,ActionSpeakString("*The Boulder was pushed out of the way with pure strength and discipline*"));
     ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVis,GetLocation(oPLC));
     DestroyBlockers(oPLC);
   }
   else if((nDiceRoll+nSkillRank) < nDC)
   {
     SendMessageToPC(oPC,"Skill Check (DISCIPLINE): " + IntToString(nSkillRank) + " + " + IntToString(nDiceRoll) + " = " +
     IntToString((nSkillRank+nDiceRoll)) + " Vs " + IntToString(nDC) + " !FAILURE!");
   }
}


void DexCheck( object oPLC, object oPC)
{
}


void SCraftCheck(object oPLC,object oPC)
{
   int nSkillRank = GetSkillRank(SKILL_SPELLCRAFT,oPC);
   int nLevel = GetLocalInt(oPLC,"level");
   int nDC = nLevel + 10 + (nLevel-(nLevel/3));
   int nDiceRoll = Random(20)+1;
   effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);

   if((nDiceRoll+nSkillRank) >= nDC)
   {
     SendMessageToPC(oPC,"Skill Check (SPELLCRAFT): " + IntToString(nSkillRank) + " + " + IntToString(nDiceRoll) + " = " +
     IntToString((nSkillRank+nDiceRoll)) + " Vs " + IntToString(nDC) + " !SUCCESS!");
     AssignCommand(oPLC,ActionSpeakString("*The Magical Crystal hums and then shatters when magic is concentrated in a certain spot*"));
     ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVis,GetLocation(oPLC));
     DestroyBlockers(oPLC);
   }
   else if((nDiceRoll+nSkillRank) < nDC)
   {
     SendMessageToPC(oPC,"Skill Check (SPELLCRAFT): " + IntToString(nSkillRank) + " + " + IntToString(nDiceRoll) + " = " +
     IntToString((nSkillRank+nDiceRoll)) + " Vs " + IntToString(nDC) + " !FAILURE!");
   }
}
