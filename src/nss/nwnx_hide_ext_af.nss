#include "nwnx_reveal"

int CheckCD(object oPC, string CDName);

void main()
{
    object oPC = OBJECT_SELF;
    int nCooldown = GetLocalInt(oPC,"HIPSCooldown");
    int nSDLevels = GetLevelByClass(CLASS_TYPE_SHADOWDANCER,oPC);
    int nDam;

    if((GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT,OBJECT_SELF)==TRUE))
    {
      DelayCommand(6.0,FloatingTextStringOnCreature("<cò­ÿ>You can hide in plain sight again.</c>",oPC,FALSE));

      if(nSDLevels >= 19)
      {
        nDam = DAMAGE_BONUS_2d12;
      }
      else if(nSDLevels >= 16)
      {
        nDam = DAMAGE_BONUS_2d8;
      }
      else if(nSDLevels >= 13)
      {
        nDam = DAMAGE_BONUS_1d12;
      }
      else if(nSDLevels >= 10)
      {
        nDam = DAMAGE_BONUS_1d6;
      }

      if(nSDLevels >= 10)
      {

         if(CheckCD(oPC,"EmbracingCold")==0)
         {
           effect eDam = EffectDamageIncrease(nDam,DAMAGE_TYPE_COLD);
           effect eVis = EffectVisualEffect(VFX_DUR_AURA_BLUE_LIGHT);
           effect eLink = EffectLinkEffects(eVis,eDam);
           eLink = TagEffect(eLink,"EmbracingCold");
           ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC,12.0);
         }

      }
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
      break;
    }

    eEffects = GetNextEffect(oPC);
  }

  return t;
}
