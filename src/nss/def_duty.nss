/* Defenders Duty
   Level 11 Defenders Duty ability

   - Maverick00053 7/23/2024

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
   location lPC = GetLocation(oPC);
   object oTarget = GetSpellTargetObject();
   location lTarget = GetLocation(oTarget);

  if((GetReputation(oPC,oTarget) >= 90) && (oPC != oTarget))
  {

   if(CheckCD(oPC,"defendersduty")==1)
   {
     SendMessageToPC(oPC,"You can use Defender's Duty again in " + IntToString(nTimeRemaining) + " seconds");
     return;
   }

   int nDefender = GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER,oPC);
   int nCooldown = (nDefender-11)*6;

   if(nDefender >= 20)
   {
     nCooldown = 10*6;
   }

   float fCooldown = 72.0 - IntToFloat(nCooldown);

   effect eJump = EffectVisualEffect(150);
   effect eTag = EffectVisualEffect(130);
   eTag = TagEffect(eTag,"defendersduty");
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eTag,oPC,fCooldown);
   DelayCommand(fCooldown,SendMessageToPC(oPC,"You can use Defender's Duty again"));


   DelayCommand(.5,AssignCommand(oPC,JumpToLocation(lTarget)));
   DelayCommand(.5,AssignCommand(oTarget,JumpToLocation(lPC)));
   ApplyEffectToObject(DURATION_TYPE_INSTANT,eJump,oPC);
   ApplyEffectToObject(DURATION_TYPE_INSTANT,eJump,oTarget);
  }
  else
  {
    SendMessageToPC(oPC,"You cannot use Defender's Duty on a non ally");
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
