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
    // Deprecated. Using C#

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
