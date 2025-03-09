//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  djinni_antim_aur
//group:   djinni
//used as: Enter Aura script for djinni
//date:    March 2025
//author:  Maverick

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x0_i0_enemy"
#include "ds_ai2_include"
#include "X0_I0_SPELLS"
#include "inc_td_shifter"
//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------


void ApplyAntiMageEffect(object oTarget);
void RemoveAllSpellEffects(object oTarget);
void RemoveAllSummons(object oTarget);
//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main()
{
    object oCritter = GetAreaOfEffectCreator();
    location lCritter = GetLocation( oCritter );
    object oTarget = GetEnteringObject();

    if(GetIsPC(oTarget))
    {
     ApplyAntiMageEffect(oTarget);
    }
}

void ApplyAntiMageEffect(object oTarget)
{
  effect eFail = EffectSpellFailure(100);
  effect eVis = EffectVisualEffect(VFX_IMP_DISPEL);
  eFail = SupernaturalEffect(eFail);
  eFail = TagEffect(eFail,"djinnifail");
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eFail,oTarget,600.0);
  ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
  RemoveAllSpellEffects(oTarget);
  RemoveAllSummons(oTarget);

}

void RemoveAllSpellEffects(object oTarget)
{
  effect eEffect = GetFirstEffect(oTarget);
  while(GetIsEffectValid(eEffect))
  {

   if(GetEffectSpellId(eEffect)!=-1)
   {
      RemoveEffect(oTarget,eEffect);
   }
   eEffect = GetNextEffect(oTarget);
  }
}

void RemoveAllSummons(object oTarget)
{
  object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED,oTarget);

  object oHenchman = GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oTarget);
  int nCount = 1;

  while(GetIsObjectValid(oHenchman))
  {
    RemoveSummonedAssociate(oTarget,oHenchman);
    nCount++;
    oHenchman = GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oTarget,nCount);
  }


}
