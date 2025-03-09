//-----------------------------------------------------------------------------
//script:  djinni_antim_ext
//group:   djinni
//used as: Exit Aura script for djinni
//date:    March 2025
//author:  Maverick

void ClearAura(object oPC);

void main()
{
  object oPC = GetExitingObject();
  ClearAura(oPC);
}

void ClearAura(object oPC)
{
  effect eEffect = GetFirstEffect(oPC);
  while(GetIsEffectValid(eEffect))
  {

   if(GetEffectTag(eEffect)=="djinnifail")
   {
      RemoveEffect(oPC,eEffect);
   }
   eEffect = GetNextEffect(oPC);
  }
}
