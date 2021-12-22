/*
    Bloodsworn Class Ability
    12/7/21 - Maverick00053

*/

#include "X0_I0_SPELLS"
#include "inc_td_shifter"
#include "x2_inc_spellhook"

void main()
{
   object oPC = OBJECT_SELF;
   int nLevelBlood = GetLevelByClass(56,oPC);
   int nSR = (GetHitDice(oPC) - 8) + nLevelBlood*2;

   if(nSR < 0)
   {
     nSR = 0;
   }

   effect eRegen;
   effect eSaves;
   effect eSpellAbsorb;
   effect eStr;
   effect eDex;
   effect eCon;
   effect eInt;
   effect eCha;
   effect eWis;
   effect eLife;
   effect eLuck;
   effect eShadowHide;
   effect eShadowMS;
   effect eShadowDarkv;
   effect ePercSpot;
   effect ePercList;
   effect ePercSeeInv;
   effect eStabilityDisc;
   effect eMagicDefense;
   effect eVis1 = EffectVisualEffect(SPELL_LESSER_SPELL_MANTLE);
   effect eVis2 = EffectVisualEffect(VFX_DUR_GLOW_WHITE);
   effect eLink = EffectLinkEffects(eVis1,eVis2);


   if(nLevelBlood >= 5)
   {
     eStr = EffectAbilityIncrease(ABILITY_STRENGTH,4);
     eDex = EffectAbilityIncrease(ABILITY_DEXTERITY,4);
     eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,4);
     eInt = EffectAbilityIncrease(ABILITY_INTELLIGENCE,4);
     eCha = EffectAbilityIncrease(ABILITY_CHARISMA,4);
     eWis = EffectAbilityIncrease(ABILITY_WISDOM,4);
     eLife = EffectRegenerate(3,6.0);
     eLuck = EffectSavingThrowIncrease(SAVING_THROW_ALL,4);
   }
   else if(nLevelBlood >= 3)
   {
     eStr = EffectAbilityIncrease(ABILITY_STRENGTH,2);
     eDex = EffectAbilityIncrease(ABILITY_DEXTERITY,2);
     eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,2);
     eInt = EffectAbilityIncrease(ABILITY_INTELLIGENCE,2);
     eCha = EffectAbilityIncrease(ABILITY_CHARISMA,2);
     eWis = EffectAbilityIncrease(ABILITY_WISDOM,2);
     eLife = EffectRegenerate(2,6.0);
     eLuck = EffectSavingThrowIncrease(SAVING_THROW_ALL,2);
   }
   else if(nLevelBlood >= 1)
   {
     eStr = EffectAbilityIncrease(ABILITY_STRENGTH,1);
     eDex = EffectAbilityIncrease(ABILITY_DEXTERITY,1);
     eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,1);
     eInt = EffectAbilityIncrease(ABILITY_INTELLIGENCE,1);
     eCha = EffectAbilityIncrease(ABILITY_CHARISMA,1);
     eWis = EffectAbilityIncrease(ABILITY_WISDOM,1);
     eLife = EffectRegenerate(1,6.0);
     eLuck = EffectSavingThrowIncrease(SAVING_THROW_ALL,1);
   }

     if(GetHasFeat(1263,oPC)) // Str Boon
     {
       eLink = EffectLinkEffects(eLink,eStr);
     }
     if(GetHasFeat(1264,oPC)) // Dex Boon
     {
       eLink = EffectLinkEffects(eLink,eDex);
     }
     if(GetHasFeat(1265,oPC)) // Con Boon
     {
       eLink = EffectLinkEffects(eLink,eCon);
     }
     if(GetHasFeat(1266,oPC)) // Int Boon
     {
       eLink = EffectLinkEffects(eLink,eInt);
     }
     if(GetHasFeat(1267,oPC)) // Cha Boon
     {
       eLink = EffectLinkEffects(eLink,eCha);
     }
     if(GetHasFeat(1268,oPC)) // Wis Boon
     {
       eLink = EffectLinkEffects(eLink,eWis);
     }
     if(GetHasFeat(1269,oPC)) // Life Boon
     {
       eLink = EffectLinkEffects(eLink,eLife);
     }
     if(GetHasFeat(1270,oPC)) // Shadows Boon
     {
       eShadowHide = EffectSkillIncrease(SKILL_HIDE,nLevelBlood*2);
       eShadowMS = EffectSkillIncrease(SKILL_MOVE_SILENTLY,nLevelBlood*2);
       eShadowDarkv = EffectUltravision();
       eLink = EffectLinkEffects(eLink,eShadowHide);
       eLink = EffectLinkEffects(eLink,eShadowMS);
       eLink = EffectLinkEffects(eLink,eShadowDarkv);
     }
     if(GetHasFeat(1271,oPC)) // Perception Boon
     {
       ePercSpot = EffectSkillIncrease(SKILL_SPOT,nLevelBlood*2);
       ePercList = EffectSkillIncrease(SKILL_LISTEN,nLevelBlood*2);
       ePercSeeInv = EffectSeeInvisible();
       eLink = EffectLinkEffects(eLink,ePercSpot);
       eLink = EffectLinkEffects(eLink,ePercList);
       eLink = EffectLinkEffects(eLink,ePercSeeInv);
     }
     if(GetHasFeat(1272,oPC)) // Magic Defense Boon
     {
       eMagicDefense = EffectSpellResistanceIncrease(nSR);
       eLink = EffectLinkEffects(eLink,eMagicDefense);
     }
     if(GetHasFeat(1273,oPC)) // Stability Boon
     {
       eStabilityDisc = EffectSkillIncrease(SKILL_DISCIPLINE,nLevelBlood*2);
       eLink = EffectLinkEffects(eLink,eStabilityDisc);
     }
     if(GetHasFeat(1274,oPC)) // Luck Boon
     {
       eLink = EffectLinkEffects(eLink,eLuck);
     }


   eLink = TagEffect(eLink, "bloodsworn");

   int nLoop = 0;
   effect eLoop = GetFirstEffect(oPC);
   while(GetIsEffectValid(eLoop))
   {
    if(GetEffectTag(eLoop) == "bloodsworn")
    {
      nLoop=1;
      RemoveEffect(oPC,eLoop);
    }
    eLoop = GetNextEffect(oPC);
   }

   if(nLoop != 1)
   {
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
   }


}
