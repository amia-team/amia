/* Stoneguard
   Level 9 Defender Howl like ability

   - Maverick00053 7/21/2024

*/

// includes
#include "nw_i0_spells"
#include "x2_i0_spells"
#include "x2_inc_spellhook"'

int nTimeRemaining;

int CheckCD(object oPC, string CDName);

void main()
{
   object oPC = OBJECT_SELF;

   if(CheckCD(oPC,"stoneguard")==1)
   {
     SendMessageToPC(oPC,"You can use Stoneguard again in " + IntToString(nTimeRemaining) + " seconds");
     return;
   }

   location lPC = GetLocation(oPC);
   int nDefender = GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER,oPC);
   int nCon = GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
   int nDur = 5 + nCon;
   float fDur = IntToFloat(nDur*6);
   float fCooldown = 180.0 - IntToFloat(nCon*6);
   float fRange = 5.0;

   int nAC = nDefender/5;
   int nSave = 0;
   int nDR;

   if(nDefender < 16)
   {
    nDR = 3 + (nDefender/4);
   }
   else if(nDefender >= 16)
   {
    nDR = 6 + (nDefender/4);
   }

   if(nDefender >= 12)
   {
    nSave=1;
   }

   if(nDefender >= 20)
   {
    fRange=10.0;
   }

   effect eTag = EffectVisualEffect(130);
   eTag = TagEffect(eTag,"stoneguard");
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eTag,oPC,fCooldown);

   effect eVisualAoE = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);
   effect eVisual = EffectVisualEffect(553);
   effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL,nSave);
   effect eAC = EffectACIncrease(nAC, AC_DODGE_BONUS);
   effect eDRSlash = EffectDamageResistance(DAMAGE_TYPE_SLASHING,nDR,0);
   effect eDRBludg = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING,nDR,0);
   effect eDRPierce = EffectDamageResistance(DAMAGE_TYPE_PIERCING,nDR,0);

   effect eLink = EffectLinkEffects(eVisual, eSave);
   eLink = EffectLinkEffects(eLink, eAC);
   eLink = EffectLinkEffects(eLink, eDRSlash);
   eLink = EffectLinkEffects(eLink, eDRBludg);
   eLink = EffectLinkEffects(eLink, eDRPierce);

   ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVisualAoE,lPC);
   DelayCommand(fCooldown,SendMessageToPC(oPC,"You can use Stoneguard again"));

   object oCreatures = GetFirstObjectInShape(SHAPE_SPHERE,fRange,lPC);
   while(GetIsObjectValid(oCreatures))
   {
     if((GetReputation(oPC,oCreatures) >= 90) && (oCreatures != oPC))
     {
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oCreatures,fDur);
     }
     oCreatures = GetNextObjectInShape(SHAPE_SPHERE,fRange,lPC);
   }



}

int CheckCD(object oPC, string CDName)
{
  effect eEffects = GetFirstEffect(oPC);
  int t = 0;
  while(GetIsEffectValid(eEffects))
  {
    if(GetEffectTag(eEffects)==CDName)
    {
      t = 1;
      nTimeRemaining = GetEffectDurationRemaining(eEffects);
      break;
    }

    eEffects = GetNextEffect(oPC);
  }

  return t;
}
