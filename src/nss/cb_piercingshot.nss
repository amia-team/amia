/*
  Made 10/1/19 by Maverick00053

   Piercing Shot Feat for Crossbow PRC

*/

#include "nwnx_creature"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    object oItem = GetItemInSlot(4,oPC);
    int nClassLevel = GetLevelByClass(51, oPC);
    int nToggled = GetLocalInt(oPC, "PiercingShotToggled");
    int nDam = nClassLevel;

    // This adjust the damage so it calls the proper damage value. In the code after the damage of 5 it has d roll damage for the next
    // ten slots before returning to 6, 7, 8 etc.
    if(nDam > 5)
    {
      nDam = nDam + 10;
    }


    int nAB = nClassLevel/2;
    int    eLoopSpellID;
    effect eLoop                    = GetFirstEffect(oPC);
    effect eAB = EffectAttackIncrease(nAB);
    effect eDam1 = EffectDamageIncrease(nDam,DAMAGE_TYPE_DIVINE);
    effect eLink = EffectLinkEffects(eAB, eDam1);
    eLink = ExtraordinaryEffect(eLink);

     // Check to make sure the weapon is a crossbow (light or heavy)
   if((GetBaseItemType(oItem)== BASE_ITEM_HEAVYCROSSBOW) ||(GetBaseItemType(oItem)== BASE_ITEM_LIGHTCROSSBOW))
   {
      // Check to see if it is toggled
      if(nToggled == 0)
      {
        SendMessageToPC(oPC,"Piercing Shot Activated!");
        SetLocalInt(oPC, "PiercingShotToggled",1);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
		
		int iSlow = SetMovementRate(oPC, 0.01);
      }
      else
      {

        // Checks for and removes the feat buff
         while(GetIsEffectValid(eLoop))
         {
          eLoopSpellID = GetEffectSpellId(eLoop);

            if ((GetEffectType(eLoop)==EFFECT_TYPE_DAMAGE_INCREASE) && (eLoopSpellID == 950))
            {
                 RemoveEffect(oPC, eLoop);
            }

                eLoop=GetNextEffect(oPC);
         }


        DeleteLocalInt(oPC,"PiercingShotToggled");
        SendMessageToPC(oPC,"Piercing Shot Deactivated!");
		iSlow = SetMovementRate(oPC, 1);

      }


   }
   else
   {
      SendMessageToPC(oPC,"You can only use this feat with a light, or heavy crossbow.");
   }


}
