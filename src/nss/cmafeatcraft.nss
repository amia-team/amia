/*
   Craft Wondrous Item or CMA crafting script tied into the feat itself. This is the script that runs if they choose yes.

*/


const int GOLD_COST = 25000; // Gold Cost

void main()
{
  object oPC = GetPCSpeaker();
  object oTarget = GetLocalObject(oPC,"craftingObject");
  string sResRef = GetLocalString(oTarget,"finalResRef");
  effect eVFX1 = EffectVisualEffect(459); // On workbench VFX
  effect eVFX2 = EffectVisualEffect(74); // On NPC caster
  int nSkillCraftWeapon = GetSkillRank(SKILL_CRAFT_WEAPON,oPC,TRUE);
  int nSkillCraftArmor = GetSkillRank(SKILL_CRAFT_ARMOR,oPC,TRUE);
  int nSkillTotal = nSkillCraftWeapon + nSkillCraftArmor;
  int nGoldReduction = (nSkillTotal/10)*5000;
  int nGold = GetGold(oPC);

   if(nGoldReduction > 25000)     // This caps the bonus reduction you can get to 25k
   {
     nGoldReduction = 25000;
   }

   if(nGold < (GOLD_COST-nGoldReduction))
   {
    SendMessageToPC(oPC,"You do not have enough gold.");
    return;
   }

   if(sResRef=="")
   {
    SendMessageToPC(oPC,"ERROR: Varible not set on item properly. Report to DMs.");
    return;
   }

   AssignCommand(oPC,PlayAnimation(ANIMATION_LOOPING_CONJURE2,1.0,2.0));
   DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX2,oPC));
   DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX1,oPC));

   CreateItemOnObject(sResRef,oPC);
   DestroyObject(oTarget);


}
