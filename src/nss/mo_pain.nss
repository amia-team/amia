/*
  June 26 2019 - Maverick00053
  Path of Enlightenment PRC, Pain Path
*/
// 2022/09/11 Opustus   Capped damage accumulation with level scaling

void main()
{
   object oPC = OBJECT_SELF;
   int nActivated = GetLocalInt(oPC, "monkprc");
   int nDamage = GetLocalInt(oPC, "monkprcpain");
   int nCap = GetLocalInt(oPC, "monkprcpain_cap");
   effect eDamage = EffectDamage(nDamage,DAMAGE_TYPE_DIVINE);
   effect eLoop = GetFirstEffect(oPC);
   int    eLoopSpellID;

   if(GetIsDead(oPC))
   {

     // Checks for and removes the feat buff
         while(GetIsEffectValid(eLoop))
         {
          eLoopSpellID = GetEffectSpellId(eLoop);

            if ((GetEffectType(eLoop)==EFFECT_TYPE_ATTACK_INCREASE) && (eLoopSpellID == 948))
            {
                 RemoveEffect(oPC, eLoop);
            }

                eLoop=GetNextEffect(oPC);
         }


     DeleteLocalInt(oPC,"monkprc");

     return;
   }
   else if(nActivated == 1)
   {
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oPC);
     SetLocalInt(oPC,"monkprcpain",nDamage+5);

     DelayCommand(6.0,ExecuteScript("mo_pain", oPC));

     if (nDamage == nCap)
     {
      SetLocalInt(oPC,"monkprcpain",nCap);
     }
   }
   else
   {
    DeleteLocalInt(oPC, "monkprcpain");
    DeleteLocalInt(oPC,"monkprc");
    return;
   }



}