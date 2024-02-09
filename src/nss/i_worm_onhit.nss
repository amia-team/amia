/*
   Purple Worm On Hit
   ------------
   Will have a chance to deal simulate poison damage on hit

   12/10/21 - Maverick00053
*/

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
    object oWorm = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    effect eNegativeAB = EffectAttackDecrease(2);
    effect eNegativeAC = EffectACDecrease(4);
    effect eVFX = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eLink = EffectLinkEffects(eNegativeAB,eNegativeAC);
    eLink = EffectLinkEffects(eVFX,eLink);
    eLink = TagEffect(eLink,"wormpoison");
    eLink = ExtraordinaryEffect(eLink);
    int nPoisoned;

    int nRandom = Random(20)+11;
    effect eDamage = EffectDamage(nRandom,DAMAGE_TYPE_ACID);

    effect eEffectOn = GetFirstEffect(oTarget);

   if(!GetIsImmune(oTarget,IMMUNITY_TYPE_POISON))
   {

    while(GetIsEffectValid(eEffectOn))
    {
     if(GetEffectTag(eEffectOn)=="wormpoison")
     {
       nPoisoned=1;
       break;
     }
     eEffectOn = GetNextEffect(oTarget);
    }

    if(FortitudeSave(oTarget,44, 2)==0)
    {

      if(nPoisoned==1)
      {
       SendMessageToPC(oTarget,"You are already poisoned but your wounds fester faster!");
       ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);
      }
      else
      {
       SendMessageToPC(oTarget,"You become posioned!");
       ApplyEffectToObject(DURATION_TYPE_PERMANENT,eLink,oTarget);
      }
    }
   }
   else
   {
    SendMessageToPC(oTarget,"You are immune to poison.");
   }

}
