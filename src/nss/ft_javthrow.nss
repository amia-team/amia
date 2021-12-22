/*
Maverick00053
Sep. 1st 2017
"Javelin Throw" or "Heroic Throw" feat

Throws your weapon, forcing a disarm on you, and inflicting damage on the enemy.

*/



void main()
{
   object oPlayer = OBJECT_SELF;
   object oTarget = GetSpellTargetObject();
   object oItem = GetItemInSlot(4,oPlayer);
   int Str = GetAbilityModifier(ABILITY_STRENGTH,oPlayer);
   int iDamage = d8(1) + 2*Str;
   int iCritical = iDamage*2;
   int Hit = TouchAttackRanged(oTarget,FALSE);
   effect eDamage = EffectDamage(iDamage, DAMAGE_TYPE_PIERCING);
   effect eCritDamage = EffectDamage(iCritical, DAMAGE_TYPE_PIERCING);
   effect eImpact =  EffectVisualEffect(VFX_COM_BLOOD_LRG_RED);
   effect eImpact2 = EffectVisualEffect(VFX_DUR_ARROW_IN_CHEST_RIGHT);

   //Check to make sure the target isn't the player itself
   if(oTarget != oPlayer)
   {

   // Check to make sure the cooldown is up
   if(GetLocalInt(oPlayer,"cooldown") == 0)
   {

   // Check to make sure the weapon is a trident (short spear or spear)
   if((GetBaseItemType(oItem)== BASE_ITEM_TRIDENT) ||(GetBaseItemType(oItem)== BASE_ITEM_SHORTSPEAR))
   {

      //Check to see if the spear crit, hit or not
      if(Hit == 2)          // crit
      {
      ApplyEffectToObject(DURATION_TYPE_INSTANT,eCritDamage,oTarget);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,eImpact,oTarget);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,eImpact2,oTarget);
      SpeakString("*Hurls spear forward!*");
      ActionUnequipItem(oItem);
      SetLocalInt(oPlayer,"cooldown",1);
      DelayCommand(6.0,DeleteLocalInt(oPlayer,"cooldown"));
      }
      else if(Hit == 1)        // hit
      {
      ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,eImpact,oTarget);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,eImpact2,oTarget);
      SpeakString("*Hurls spear forward!*");
      ActionUnequipItem(oItem);
      SetLocalInt(oPlayer,"cooldown",1);
      DelayCommand(6.0,DeleteLocalInt(oPlayer,"cooldown"));
      }
      else                     // miss
      {
      SpeakString("*Hurls spear forward and misses!*");
      ActionUnequipItem(oItem);
      SetLocalInt(oPlayer,"cooldown",1);
      DelayCommand(6.0,DeleteLocalInt(oPlayer,"cooldown"));
      }

   }
   else
   {

     SendMessageToPC(oPlayer,"You can not throw this weapon type!");

   }

   }
   else
   {
     SendMessageToPC(oPlayer,"You can not throw another spear just yet!");
   }

  }


}
