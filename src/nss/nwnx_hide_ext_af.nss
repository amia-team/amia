#include "nwnx_reveal"


void main()
{
    object oPC = OBJECT_SELF;
    int nCooldown = GetLocalInt(oPC,"HIPSCooldown");
    int nSDLevels = GetLevelByClass(CLASS_TYPE_SHADOWDANCER,oPC);
    int nDam;

    if((nCooldown==0) && (GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT,OBJECT_SELF)==TRUE))
    {
      FloatingTextStringOnCreature("<cò­ÿ>You may use HIPS again in 6 seconds.</c>",oPC,FALSE);
      SetLocalInt(oPC,"HIPSCooldown",1);
      DelayCommand(6.0,DeleteLocalInt(oPC,"HIPSCooldown"));
      DelayCommand(6.0,FloatingTextStringOnCreature("<cò­ÿ>You can HIPS again!</c>",oPC,FALSE));

      if(nSDLevels >= 19)
      {
        nDam = DAMAGE_BONUS_2d10;
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

         if(GetLocalInt(oPC,"EmbracingShadows")==0)
         {
           effect eDam = EffectDamageIncrease(nDam,DAMAGE_TYPE_COLD);
           effect eVis = EffectVisualEffect(VFX_DUR_GLOW_LIGHT_BLUE);
           effect eLink = EffectLinkEffects(eVis,eDam);
           eLink = TagEffect(eLink,"EmbracingShadows");
           ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDam, oPC,12.0);
           SetLocalInt(oPC,"EmbracingShadows",1);
           DelayCommand(6.0,DeleteLocalInt(oPC,"EmbracingShadows"));
         }

      }
    }
}
