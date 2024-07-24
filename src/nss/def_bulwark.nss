/* Living Bulwark
   Level 7 Living Bulwark ability

   - Maverick00053 7/23/2024

*/

// includes
#include "nw_i0_spells"
#include "x2_i0_spells"
#include "x2_inc_spellhook"'

void main()
{
   object oPC = OBJECT_SELF;
   object oTarget = GetSpellTargetObject();
   int nDefender = GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER,oPC);
   int nCon = GetAbilityModifier(ABILITY_CONSTITUTION, oPC);

   effect eVisual = EffectVisualEffect(0);
   eVisual = TagEffect(eVisual,"guarded");

   if((GetReputation(oPC,oTarget) >= 90) && (oPC != oTarget))
   {
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVisual,oTarget,7.0);
    SetLocalObject(oTarget,"guarded",oPC);
    SendMessageToPC(oPC,"You guard " + GetName(oTarget));
   }
   else
   {
     SendMessageToPC(oPC,"You cannot apply Living Bulwark to a non ally");
   }
}

