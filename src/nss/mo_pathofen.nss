/*
  June 24 2019 - Maverick00053
  Path of Enlightenment PRC
*/
// 2022/09/11 Opustus   Capped Pain damage accumulation with level scaling

void Mists(object oPC, int nClassLevel, int nActivated, object oWidget);// Feat 1226
void Elemental(object oPC, int nClassLevel, int nActivated, object oWidget);// Feat 1227
void Life(object oPC, int nClassLevel, int nActivated, object oWidget);// Feat 1228
void Ironskin(object oPC, int nClassLevel, int nActivated, object oWidget);// Feat 1229
void Antimagic(object oPC, int nClassLevel, int nActivated, object oWidget);// Feat 1230
void Pain(object oPC, int nClassLevel, int nActivated, object oWidget);// Feat 1231
void Zen(object oPC, int nClassLevel, int nActivated, object oWidget);// Feat 1241

void main()
{

   object oPC = OBJECT_SELF;
   object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
   object oPrimaryHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
   object oWidget = GetItemPossessedBy(oPC, "ds_pckey");

   int nMist = GetHasFeat(1226,oPC);
   int nElemental = GetHasFeat(1227,oPC);
   int nLife = GetHasFeat(1228,oPC);
   int nIronSkint = GetHasFeat(1229,oPC);
   int nAntiMagic = GetHasFeat(1230,oPC);
   int nPain = GetHasFeat(1231,oPC);
   int nZen = GetHasFeat(1241,oPC);
   int nClassLevel = GetLevelByClass(50, oPC);
   int nActivated = GetLocalInt(oWidget, "monkprc");

   // Check to make sure hands are empty
   if(!GetIsObjectValid(oPrimaryHand) && !GetIsObjectValid(oOffHand))
   {

    // Depending on their feat it dictates what happens
    if(nMist == TRUE)
    {
      Mists(oPC,nClassLevel,nActivated,oWidget);
    }
    else if(nElemental == TRUE)
    {
      Elemental(oPC,nClassLevel,nActivated,oWidget);
    }
    else if(nLife == TRUE)
    {
      Life(oPC,nClassLevel,nActivated,oWidget);
    }
    else if(nIronSkint == TRUE)
    {
      Ironskin(oPC,nClassLevel,nActivated,oWidget);
    }
    else if(nAntiMagic == TRUE)
    {
      Antimagic(oPC,nClassLevel,nActivated,oWidget);
    }
    else if(nPain == TRUE)
    {
      Pain(oPC,nClassLevel,nActivated,oWidget);
    }
    else if(nZen == TRUE)
    {
      Zen(oPC,nClassLevel,nActivated,oWidget);
    }

   }
   else
   {

     SendMessageToPC(oPC,"Hands must be completely empty to enter the Enlightened State and continue to be to remain in it!");

   }




}

void Mists(object oPC, int nClassLevel, int nActivated, object oWidget)               // done
{
   effect eAbBonus =  EffectAttackIncrease(2, ATTACK_BONUS_MISC);
   effect eConceal;
   effect eLoop                    = GetFirstEffect(oPC);
   int    eLoopSpellID;
   // Freedom
   effect eParal = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
   effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
   effect eSlow = EffectImmunity(IMMUNITY_TYPE_SLOW);
   effect eMove = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);
   //
   effect eVisual = EffectVisualEffect(320);
   effect eLink;
   effect eDamage;

   // Freedom
   eLink = EffectLinkEffects(eParal, eEntangle);
   eLink = EffectLinkEffects(eLink, eSlow);
   eLink = EffectLinkEffects(eLink, eMove);

   if(nActivated == 0)  // If the feat is not already activated, activate it
   {

      if(nClassLevel == 5)
   {
      eConceal =  EffectConcealment(50);
      eDamage = EffectDamageIncrease(DAMAGE_BONUS_5,DAMAGE_TYPE_COLD);
      eLink = EffectLinkEffects(eConceal, eLink);
      eLink = EffectLinkEffects(eDamage, eLink);
      eLink = EffectLinkEffects(eAbBonus, eLink);
   }
   else if(nClassLevel == 4)
   {
      eDamage = EffectDamageIncrease(DAMAGE_BONUS_4,DAMAGE_TYPE_COLD);
      eConceal =  EffectConcealment(40);
      eLink = EffectLinkEffects(eConceal, eAbBonus);
      eLink = EffectLinkEffects(eDamage, eLink);
   }
   else if(nClassLevel == 3)
   {
      eDamage = EffectDamageIncrease(DAMAGE_BONUS_3,DAMAGE_TYPE_COLD);
      eConceal =  EffectConcealment(30);
      eLink = EffectLinkEffects(eConceal, eAbBonus);
      eLink = EffectLinkEffects(eDamage, eLink);
   }
   else if(nClassLevel == 2)
   {
      eDamage = EffectDamageIncrease(DAMAGE_BONUS_2,DAMAGE_TYPE_COLD);
      eConceal =  EffectConcealment(20);
      eLink = EffectLinkEffects(eConceal, eAbBonus);
      eLink = EffectLinkEffects(eDamage, eLink);
   }
   else if(nClassLevel == 1)
   {
      eDamage = EffectDamageIncrease(DAMAGE_BONUS_1,DAMAGE_TYPE_COLD);
      eConceal =  EffectConcealment(10);
      eLink = EffectLinkEffects(eConceal, eAbBonus);
      eLink = EffectLinkEffects(eDamage, eLink);
   }
     eLink = EffectLinkEffects(eVisual, eLink);
     eLink = ExtraordinaryEffect(eLink);
     ApplyEffectToObject(DURATION_TYPE_PERMANENT,eLink, oPC);
     SetLocalInt(oWidget,"monkprc",1);

  }
  else //Feat is already active so deactivate it
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


     DeleteLocalInt(oWidget,"monkprc");

   }


}

void Elemental(object oPC, int nClassLevel, int nActivated, object oWidget)   // Done
{
   effect eAbBonus =  EffectAttackIncrease(2, ATTACK_BONUS_MISC);
   effect eEleRes;
   effect eDamage;
   effect eLink;
   effect eVisual;
   effect eLoop                    = GetFirstEffect(oPC);
   int    eLoopSpellID;
   int nElementalChoice = GetLocalInt(oPC, "monkprcelemental"); //1 = fire, 2 elec, 3 = cold
   int nElement;


   if(nElementalChoice <= 1)// fire
   {
      nElement = DAMAGE_TYPE_FIRE;
      eVisual = EffectVisualEffect(505);
   }
   else if(nElementalChoice == 2)// elec
   {
      nElement = DAMAGE_TYPE_ELECTRICAL;
      eVisual = EffectVisualEffect(463);
   }
   else if(nElementalChoice == 3)// cold
   {
      nElement = DAMAGE_TYPE_COLD;
      eVisual = EffectVisualEffect(465);
   }

   if(nActivated == 0)  // If the feat is not already activated, activate it
   {

   if(nClassLevel == 5)
   {
      eEleRes = EffectDamageResistance(nElement,15);
      eDamage = EffectDamageIncrease(DAMAGE_BONUS_12,nElement);
      eLink = EffectLinkEffects(eEleRes, eDamage);
      eLink = EffectLinkEffects(eAbBonus, eLink);
   }
   else if(nClassLevel == 4)
   {
      eEleRes = EffectDamageResistance(nElement,12);
      eDamage = EffectDamageIncrease(DAMAGE_BONUS_10,nElement);
      eLink = EffectLinkEffects(eEleRes, eDamage);
      eLink = EffectLinkEffects(eAbBonus, eLink);
   }
   else if(nClassLevel == 3)
   {
      eEleRes = EffectDamageResistance(nElement,10);
      eDamage = EffectDamageIncrease(DAMAGE_BONUS_8,nElement);
      eLink = EffectLinkEffects(eEleRes, eDamage);
      eLink = EffectLinkEffects(eAbBonus, eLink);
   }
   else if(nClassLevel == 2)
   {
      eEleRes = EffectDamageResistance(nElement,7);
      eDamage = EffectDamageIncrease(DAMAGE_BONUS_6,nElement);
      eLink = EffectLinkEffects(eEleRes, eDamage);
      eLink = EffectLinkEffects(eAbBonus, eLink);
   }
   else if(nClassLevel == 1)
   {
      eEleRes = EffectDamageResistance(nElement,5);
      eDamage = EffectDamageIncrease(DAMAGE_BONUS_4,nElement);
      eLink = EffectLinkEffects(eEleRes, eDamage);
      eLink = EffectLinkEffects(eAbBonus, eLink);
   }
     eLink = EffectLinkEffects(eVisual, eLink);
     eLink = ExtraordinaryEffect(eLink);
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
     SetLocalInt(oWidget,"monkprc",1);

  }
  else //Feat is already active so deactivate it
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


     DeleteLocalInt(oWidget,"monkprc");

   }


}

void Life(object oPC, int nClassLevel, int nActivated, object oWidget)  // Done
{
   effect eAbBonus =  EffectAttackIncrease(2, ATTACK_BONUS_MISC);
   effect eImmunity;
   effect eRegeneration;
   effect eVisual = EffectVisualEffect(13);
   effect eLink;
   effect eLoop                    = GetFirstEffect(oPC);
   int    eLoopSpellID;

   if(nActivated == 0)  // If the feat is not already activated, activate it
   {

   if(nClassLevel == 5)
   {
      eRegeneration = EffectRegenerate(10,6.0);
      eImmunity = EffectImmunity(IMMUNITY_TYPE_DEATH);
      eLink = EffectLinkEffects(eImmunity, eRegeneration);
      eLink = EffectLinkEffects(eAbBonus, eLink);
   }
   else if(nClassLevel == 4)
   {
      eRegeneration = EffectRegenerate(8,6.0);
      eLink = EffectLinkEffects(eAbBonus, eRegeneration);
      eLink = EffectLinkEffects(eAbBonus, eLink);
   }
   else if(nClassLevel == 3)
   {
      eRegeneration = EffectRegenerate(6,6.0);
      eLink = EffectLinkEffects(eAbBonus, eRegeneration);
      eLink = EffectLinkEffects(eAbBonus, eLink);
   }
   else if(nClassLevel == 2)
   {
      eRegeneration = EffectRegenerate(4,6.0);
      eLink = EffectLinkEffects(eAbBonus, eRegeneration);
      eLink = EffectLinkEffects(eAbBonus, eLink);
   }
   else if(nClassLevel == 1)
   {
      eRegeneration = EffectRegenerate(2,6.0);
      eLink = EffectLinkEffects(eAbBonus, eRegeneration);
      eLink = EffectLinkEffects(eAbBonus, eLink);
   }
     eLink = EffectLinkEffects(eVisual, eLink);
     eLink = ExtraordinaryEffect(eLink);
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
     SetLocalInt(oWidget,"monkprc",1);

   }
   else //Feat is already active so deactivate it
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


     DeleteLocalInt(oWidget,"monkprc");

   }



}

void Ironskin(object oPC, int nClassLevel, int nActivated, object oWidget)// Done
{
   int nMonkLevel = GetLevelByClass(CLASS_TYPE_MONK,oPC);
   effect eAbBonus =  EffectAttackIncrease(2, ATTACK_BONUS_MISC);
   effect eMoveDecrease = EffectMovementSpeedDecrease(99);
   effect eDamageResP;
   effect eDamageResS;
   effect eDamageResB;
   effect eVisual = EffectVisualEffect(351);
   effect eLink;
   effect eLoop                    = GetFirstEffect(oPC);
   int    eLoopSpellID;


   if(nActivated == 0)  // If the feat is not already activated, activate it
   {

   if(nClassLevel == 5)
   {
     eDamageResP = EffectDamageResistance(DAMAGE_TYPE_PIERCING,25);
     eDamageResS = EffectDamageResistance(DAMAGE_TYPE_SLASHING,25);
     eDamageResB = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING,25);
     eLink = EffectLinkEffects(eDamageResS,eDamageResP);
     eLink = EffectLinkEffects(eMoveDecrease,eLink);
     eLink = EffectLinkEffects(eDamageResB,eLink);
     eLink = EffectLinkEffects(eAbBonus, eLink);
   }
   else if(nClassLevel == 4)
   {
     eDamageResP = EffectDamageResistance(DAMAGE_TYPE_PIERCING,20);
     eDamageResS = EffectDamageResistance(DAMAGE_TYPE_SLASHING,20);
     eDamageResB = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING,20);
     eLink = EffectLinkEffects(eDamageResS,eDamageResP);
     eLink = EffectLinkEffects(eMoveDecrease,eLink);
     eLink = EffectLinkEffects(eDamageResB,eLink);
     eLink = EffectLinkEffects(eAbBonus, eLink);
   }
   else if(nClassLevel == 3)
   {
     eDamageResP = EffectDamageResistance(DAMAGE_TYPE_PIERCING,15);
     eDamageResS = EffectDamageResistance(DAMAGE_TYPE_SLASHING,15);
     eDamageResB = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING,15);
     eLink = EffectLinkEffects(eDamageResS,eDamageResP);
     eLink = EffectLinkEffects(eMoveDecrease,eLink);
     eLink = EffectLinkEffects(eDamageResB,eLink);
     eLink = EffectLinkEffects(eAbBonus, eLink);
   }
   else if(nClassLevel == 2)
   {
     eDamageResP = EffectDamageResistance(DAMAGE_TYPE_PIERCING,10);
     eDamageResS = EffectDamageResistance(DAMAGE_TYPE_SLASHING,10);
     eDamageResB = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING,10);
     eLink = EffectLinkEffects(eDamageResS,eDamageResP);
     eLink = EffectLinkEffects(eMoveDecrease,eLink);
     eLink = EffectLinkEffects(eDamageResB,eLink);
     eLink = EffectLinkEffects(eAbBonus, eLink);
   }
   else if(nClassLevel == 1)
   {
     eDamageResP = EffectDamageResistance(DAMAGE_TYPE_PIERCING,5);
     eDamageResS = EffectDamageResistance(DAMAGE_TYPE_SLASHING,5);
     eDamageResB = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING,5);
     eLink = EffectLinkEffects(eDamageResS,eDamageResP);
     eLink = EffectLinkEffects(eMoveDecrease,eLink);
     eLink = EffectLinkEffects(eDamageResB,eLink);
     eLink = EffectLinkEffects(eAbBonus, eLink);
   }
     eLink = EffectLinkEffects(eVisual, eLink);
     eLink = ExtraordinaryEffect(eLink);
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
     SetLocalInt(oWidget,"monkprc",1);

   }
   else //Feat is already active so deactivate it
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


     DeleteLocalInt(oWidget,"monkprc");

   }



}

void Antimagic(object oPC, int nClassLevel, int nActivated, object oWidget)            // Done
{
   effect eAbBonus =  EffectAttackIncrease(2, ATTACK_BONUS_MISC);
   effect eSpellRes;
   effect eMagicRes = EffectDamageResistance(DAMAGE_TYPE_MAGICAL,5);
   effect eVisual = EffectVisualEffect(495);
   effect eLink;
   effect eLoop                    = GetFirstEffect(oPC);
   int    eLoopSpellID;
   int nCurrentSR = GetLevelByClass(CLASS_TYPE_MONK,oPC) + 10;

   if(GetHasFeat(FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_1,oPC))
   {
      nCurrentSR = nCurrentSR + 2;
   }
   if(GetHasFeat(FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_2,oPC))
   {
      nCurrentSR = nCurrentSR + 2;
   }
   if(GetHasFeat(FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_3,oPC))
   {
      nCurrentSR = nCurrentSR + 2;
   }
   if(GetHasFeat(FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_4,oPC))
   {
      nCurrentSR = nCurrentSR + 2;
   }
   if(GetHasFeat(FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_5,oPC))
   {
      nCurrentSR = nCurrentSR + 2;
   }
   if(GetHasFeat(FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_6,oPC))
   {
      nCurrentSR = nCurrentSR + 2;
   }
   if(GetHasFeat(FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_7,oPC))
   {
      nCurrentSR = nCurrentSR + 2;
   }
   if(GetHasFeat(FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_8,oPC))
   {
      nCurrentSR = nCurrentSR + 2;
   }
   if(GetHasFeat(FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_9,oPC))
   {
      nCurrentSR = nCurrentSR + 2;
   }
   if(GetHasFeat(FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_10,oPC))
   {
      nCurrentSR = nCurrentSR + 2;
   }

   if(nActivated == 0)  // If the feat is not already activated, activate it
   {


   if(nClassLevel == 5)
   {
     eSpellRes =  EffectSpellResistanceIncrease(11 + nCurrentSR);
     eLink = EffectLinkEffects(eSpellRes, eAbBonus);
     eLink = EffectLinkEffects(eMagicRes, eLink);
   }
   else if(nClassLevel == 4)
   {
     eSpellRes =  EffectSpellResistanceIncrease(8 + nCurrentSR);
     eLink = EffectLinkEffects(eSpellRes, eAbBonus);
   }
   else if(nClassLevel == 3)
   {
     eSpellRes =  EffectSpellResistanceIncrease(7 + nCurrentSR);
     eLink = EffectLinkEffects(eSpellRes, eAbBonus);
   }
   else if(nClassLevel == 2)
   {
     eSpellRes =  EffectSpellResistanceIncrease(4 + nCurrentSR);
     eLink = EffectLinkEffects(eSpellRes, eAbBonus);
   }
   else if(nClassLevel == 1)
   {
     eSpellRes =  EffectSpellResistanceIncrease(3 + nCurrentSR);
     eLink = EffectLinkEffects(eSpellRes, eAbBonus);
   }
     eLink = EffectLinkEffects(eVisual, eLink);
     eLink = ExtraordinaryEffect(eLink);
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
     SetLocalInt(oWidget,"monkprc",1);

   }
   else //Feat is already active so deactivate it
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


     DeleteLocalInt(oWidget,"monkprc");

   }
}


void Pain(object oPC, int nClassLevel, int nActivated, object oWidget)
{
   effect eAbBonus;
   effect eHaste = EffectHaste();
   effect eAc;
   effect eDam;
   effect eDamageResP;
   effect eDamageResS;
   effect eDamageResB;
   effect eVisual = EffectVisualEffect(346);
   effect eLink;
   effect eLoop = GetFirstEffect(oPC);
   int    eLoopSpellID;


   if(nActivated == 0)  // If the feat is not already activated, activate it
   {


   if(nClassLevel == 5)
   {
     eAc = EffectACIncrease(4,AC_SHIELD_ENCHANTMENT_BONUS);
     eDam = EffectDamageIncrease(DAMAGE_BONUS_10,DAMAGE_TYPE_BLUDGEONING);
     eAbBonus = EffectAttackIncrease(4, ATTACK_BONUS_MISC);
     eDamageResP = EffectDamageResistance(DAMAGE_TYPE_PIERCING,10);
     eDamageResS = EffectDamageResistance(DAMAGE_TYPE_SLASHING,10);
     eDamageResB = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING,10);
     eLink = EffectLinkEffects(eDam,eAc);
     eLink = EffectLinkEffects(eAbBonus,eLink);
     eLink = EffectLinkEffects(eDamageResP,eLink);
     eLink = EffectLinkEffects(eDamageResS,eLink);
     eLink = EffectLinkEffects(eDamageResB,eLink);
     eLink = EffectLinkEffects(eHaste,eLink);

     SetLocalInt(oPC, "monkprcpain_cap", 25);

   }
   else if(nClassLevel == 4)
   {
     eAc = EffectACIncrease(3,AC_SHIELD_ENCHANTMENT_BONUS);
     eDam = EffectDamageIncrease(DAMAGE_BONUS_8,DAMAGE_TYPE_BLUDGEONING);
     eAbBonus = EffectAttackIncrease(3, ATTACK_BONUS_MISC);
     eDamageResP = EffectDamageResistance(DAMAGE_TYPE_PIERCING,8);
     eDamageResS = EffectDamageResistance(DAMAGE_TYPE_SLASHING,8);
     eDamageResB = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING,8);
     eLink = EffectLinkEffects(eDam,eAc);
     eLink = EffectLinkEffects(eAbBonus,eLink);
     eLink = EffectLinkEffects(eDamageResP,eLink);
     eLink = EffectLinkEffects(eDamageResS,eLink);
     eLink = EffectLinkEffects(eDamageResB,eLink);

     SetLocalInt(oPC, "monkprcpain_cap", 25);
   }
   else if(nClassLevel == 3)
   {
     eAc = EffectACIncrease(3,AC_SHIELD_ENCHANTMENT_BONUS);
     eDam = EffectDamageIncrease(DAMAGE_BONUS_6,DAMAGE_TYPE_BLUDGEONING);
     eAbBonus = EffectAttackIncrease(3, ATTACK_BONUS_MISC);
     eDamageResP = EffectDamageResistance(DAMAGE_TYPE_PIERCING,6);
     eDamageResS = EffectDamageResistance(DAMAGE_TYPE_SLASHING,6);
     eDamageResB = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING,6);
     eLink = EffectLinkEffects(eDam,eAc);
     eLink = EffectLinkEffects(eAbBonus,eLink);
     eLink = EffectLinkEffects(eDamageResP,eLink);
     eLink = EffectLinkEffects(eDamageResS,eLink);
     eLink = EffectLinkEffects(eDamageResB,eLink);

     SetLocalInt(oPC, "monkprcpain_cap", 20);
   }
   else if(nClassLevel == 2)
   {
     eAc = EffectACIncrease(2,AC_SHIELD_ENCHANTMENT_BONUS);
     eDam = EffectDamageIncrease(DAMAGE_BONUS_6,DAMAGE_TYPE_BLUDGEONING);
     eAbBonus = EffectAttackIncrease(2, ATTACK_BONUS_MISC);
     eDamageResP = EffectDamageResistance(DAMAGE_TYPE_PIERCING,6);
     eDamageResS = EffectDamageResistance(DAMAGE_TYPE_SLASHING,6);
     eDamageResB = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING,6);
     eLink = EffectLinkEffects(eDam,eAc);
     eLink = EffectLinkEffects(eAbBonus,eLink);
     eLink = EffectLinkEffects(eDamageResP,eLink);
     eLink = EffectLinkEffects(eDamageResS,eLink);
     eLink = EffectLinkEffects(eDamageResB,eLink);

     SetLocalInt(oPC, "monkprcpain_cap", 15);
   }
   else if(nClassLevel == 1)
   {
     eAc = EffectACIncrease(2,AC_SHIELD_ENCHANTMENT_BONUS);
     eDam = EffectDamageIncrease(DAMAGE_BONUS_4,DAMAGE_TYPE_BLUDGEONING);
     eAbBonus = EffectAttackIncrease(2, ATTACK_BONUS_MISC);
     eDamageResP = EffectDamageResistance(DAMAGE_TYPE_PIERCING,4);
     eDamageResS = EffectDamageResistance(DAMAGE_TYPE_SLASHING,4);
     eDamageResB = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING,4);
     eLink = EffectLinkEffects(eDam,eAc);
     eLink = EffectLinkEffects(eAbBonus,eLink);
     eLink = EffectLinkEffects(eDamageResP,eLink);
     eLink = EffectLinkEffects(eDamageResS,eLink);
     eLink = EffectLinkEffects(eDamageResB,eLink);

     SetLocalInt(oPC, "monkprcpain_cap", 10);
   }
     eLink = EffectLinkEffects(eVisual, eLink);
     eLink = ExtraordinaryEffect(eLink);
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
     SetLocalInt(oPC,"monkprcpain",5);
     SetLocalInt(oWidget,"monkprc",1);
     ExecuteScript("mo_pain", oPC);


   }
   else //Feat is already active so deactivate it
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


     DeleteLocalInt(oWidget,"monkprc");

   }



}

void Zen(object oPC, int nClassLevel, int nActivated, object oWidget)   // Done
{

   effect eAbBonus;
   effect eDam;
   effect eSaves;
   effect eVisual = EffectVisualEffect(685);
   effect eLink;
   effect eLoop = GetFirstEffect(oPC);
   int nWisdomMod = GetAbilityModifier(ABILITY_WISDOM,oPC);
   int nWisdomDam;
   int    eLoopSpellID;


   //Wisdom Damage Set
   nWisdomDam = nWisdomMod/4;
   if(nClassLevel >= 3)
   {
    nWisdomDam = nWisdomMod/3;
   }
   // Adjusts the value because at 6 damage it jumps up in call value by 10
   if(nWisdomDam >= 6)
   {
     nWisdomDam = nWisdomDam + 10;
   }
   //

   if(nActivated == 0)  // If the feat is not already activated, activate it
   {


   if(nClassLevel == 5)
   {
     eDam = EffectDamageIncrease(nWisdomDam,DAMAGE_TYPE_MAGICAL);
     eAbBonus = EffectAttackIncrease(nWisdomMod/2);
     eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL,2,SAVING_THROW_TYPE_ALL);
     eLink = EffectLinkEffects(eDam,eAbBonus);
     eLink = EffectLinkEffects(eSaves,eLink);
   }
   else if(nClassLevel == 4)
   {
     eDam = EffectDamageIncrease(nWisdomDam,DAMAGE_TYPE_MAGICAL);
     eAbBonus = EffectAttackIncrease(0);
     eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL,2,SAVING_THROW_TYPE_ALL);
     eLink = EffectLinkEffects(eDam,eAbBonus);
     eLink = EffectLinkEffects(eSaves,eLink);

   }
   else if(nClassLevel == 3)
   {
     eDam = EffectDamageIncrease(nWisdomDam,DAMAGE_TYPE_MAGICAL);
     eAbBonus = EffectAttackIncrease(0);
     eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL,1,SAVING_THROW_TYPE_ALL);
     eLink = EffectLinkEffects(eDam,eAbBonus);
     eLink = EffectLinkEffects(eSaves,eLink);

   }
   else if(nClassLevel == 2)
   {
     eDam = EffectDamageIncrease(nWisdomDam,DAMAGE_TYPE_MAGICAL);
     eAbBonus = EffectAttackIncrease(0);
     eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL,1,SAVING_THROW_TYPE_ALL);
     eLink = EffectLinkEffects(eDam,eAbBonus);
     eLink = EffectLinkEffects(eSaves,eLink);
   }
   else if(nClassLevel == 1)
   {
     eDam = EffectDamageIncrease(nWisdomDam,DAMAGE_TYPE_MAGICAL);
     eAbBonus =  EffectAttackIncrease(0);
     eLink = EffectLinkEffects(eDam,eAbBonus);
   }
     eLink = EffectLinkEffects(eVisual, eLink);
     eLink = ExtraordinaryEffect(eLink);
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
     SetLocalInt(oWidget,"monkprc",1);


   }
   else //Feat is already active so deactivate it
   {

    // Checks for and removes the feat buff
         while(GetIsEffectValid(eLoop))
         {
          eLoopSpellID = GetEffectSpellId(eLoop);

            if ((eLoopSpellID == 948))
            {
                 RemoveEffect(oPC, eLoop);
            }

                eLoop=GetNextEffect(oPC);
         }


     DeleteLocalInt(oWidget,"monkprc");

   }


}