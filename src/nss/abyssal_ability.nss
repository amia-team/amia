/*
    Abyssal Class Ability
    12/7/21 - Maverick00053

*/

#include "X0_I0_SPELLS"
#include "inc_td_shifter"
#include "x2_inc_spellhook"

// Generating Horns
int GenerateHorns(object oPC);

void main()
{
   object oPC = OBJECT_SELF;
   object oWidget = GetItemPossessedBy(oPC,"ds_pckey");
   object oArea = GetArea(oPC);
   object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
   itemproperty ipWhirl = ItemPropertyBonusFeat(IP_CONST_FEAT_WHIRLWIND);
   itemproperty ipEvasion = ItemPropertyBonusFeat(226);
   itemproperty ipImproEvasion = ItemPropertyBonusFeat(231);
   string sBodyPart = GetLocalString(oWidget, "abyssalBodyPart");
   int nAbyssalLevel = GetLevelByClass(55,oPC);
   int nHornLevel;
   location lTarget = GetSpellTargetLocation();
   effect eFly = EffectDisappearAppear(lTarget);
   effect eSpeed;
   effect eVisSpeed;
   effect eLinkSpeed;
   effect eVisHorn;
   effect eVisHorn2;
   effect eVisHorn3;
   effect eLinkHorns;

   if(nAbyssalLevel >= 3)
   {
    nHornLevel = DAMAGE_BONUS_1d4;
   }

   effect eHornBuff = EffectDamageShield(2*nAbyssalLevel,nHornLevel,DAMAGE_TYPE_ELECTRICAL);
   effect eImmunityS = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING,5);
   effect eImmunityP = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING,5);
   effect eImmunityB = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING,5);
   float fDelay;

   if(GetIsPolymorphed(oPC) == TRUE)
   {
     SendMessageToPC(oPC,"You cannot use this while polymorphed.");
     return;
   }

   if(sBodyPart == "")
   {
     SendMessageToPC(oPC,"Body part variable not set right. Contact DM!");
   }

   if(sBodyPart == "wings") // Flight
   {
    // resolve area flight status
    if(GetLocalInt(oArea,"CS_NO_FLY")==1)
    {
        // warn the player
        FloatingTextStringOnCreature("- You are unable to fly in this area! -",oPC,FALSE);
        return;
    }


     if(GetLocalInt(oPC,"abyssalWings") != 0)
     {
      SendMessageToPC(oPC, "You must wait 2 rounds before activating this ability again!");
      return;
     }

    // The duration of the superman effect is four seconds, for particularly mountainous areas.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eFly,oPC,4.0);
    SetLocalInt(oPC,"abyssalWings",1);
    DelayCommand(16.0,DeleteLocalInt(oPC,"abyssalWings"));

    float fDelayWing;
    if(nAbyssalLevel >= 5)
    {
       object oWingTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
       while(GetIsObjectValid(oWingTarget))
       {
        fDelayWing = GetDistanceToObject(oWingTarget)/20.0;
        if(!GetIsFriend(oWingTarget) && !GetFactionEqual(oWingTarget))
        {
           if(!ReflexSave(oWingTarget, 25))
           {
            int nDamWing = Random(3*nAbyssalLevel)+1;
            effect eDam = EffectDamage(nDamWing, DAMAGE_TYPE_BLUDGEONING);
            DelayCommand(fDelayWing + 4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oWingTarget));
            DelayCommand(fDelayWing + 4.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oWingTarget, 3.0));
            effect eVisDust = EffectVisualEffect(460);
            DelayCommand(fDelayWing + 4.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVisDust,oPC));
           }
        }
         oWingTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
       }
    }
    else if(nAbyssalLevel >= 3)
    {
       object oWingTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
       while(GetIsObjectValid(oWingTarget))
       {
        fDelayWing = GetDistanceToObject(oWingTarget)/20.0;
        if(!GetIsFriend(oWingTarget) && !GetFactionEqual(oWingTarget) && (GetCreatureSize(oWingTarget) != CREATURE_SIZE_HUGE))
        {
           if(!ReflexSave(oWingTarget, 25))
           {
            int nDamWing = Random(3*nAbyssalLevel)+1;
            effect eDam = EffectDamage(nDamWing, DAMAGE_TYPE_BLUDGEONING);
            DelayCommand(fDelayWing + 4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oWingTarget));
            effect eVisDust = EffectVisualEffect(460);
            DelayCommand(fDelayWing + 4.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVisDust,oPC));
           }
        }
         oWingTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
       }
    }
   }
   else if(sBodyPart == "tail")  // Whirlwind KD attack
   {
     if(GetLocalInt(oPC,"abyssalTail") == 0)
     {
       IPSafeAddItemProperty(oItem, ipWhirl, 7.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, FALSE);
       ActionUseFeat(FEAT_WHIRLWIND_ATTACK,oPC);   // Check x2_s2_whirl for more details
       SetLocalInt(oPC,"abyssalTail",1);
       DelayCommand(18.0,DeleteLocalInt(oPC,"abyssalTail"));
      }
     else
     {
      SendMessageToPC(oPC, "You must wait 2 rounds before activating this ability again!");
     }
   }
   else if(sBodyPart == "horns") // Buff
   {
     if(GetLocalInt(oPC,"abyssalHorn") == 0)
     {

      if(GetPCKEYValue(oPC,"abyssalHornsFinal") == 0)
      {
       int nFinalHorns = GenerateHorns(oPC);
       eVisHorn = EffectVisualEffect(nFinalHorns);
       SetPCKEYValue(oPC,"abyssalHornsFinal",nFinalHorns);
      }
      else
      {
       eVisHorn = EffectVisualEffect(GetPCKEYValue(oPC,"abyssalHornsFinal"));
      }

      eVisHorn = UnyieldingEffect(eVisHorn);
      eVisHorn2 = EffectVisualEffect(1038);
      eVisHorn3 = EffectVisualEffect(1041);
      eLinkHorns =EffectLinkEffects(eVisHorn2, eHornBuff);
      if(nAbyssalLevel == 5)
      {
        eLinkHorns =EffectLinkEffects(eLinkHorns, eImmunityS);
        eLinkHorns =EffectLinkEffects(eLinkHorns, eImmunityP);
        eLinkHorns =EffectLinkEffects(eLinkHorns, eImmunityB);
      }
      eLinkHorns =EffectLinkEffects(eLinkHorns, eVisHorn3);
      FloatingTextStringOnCreature("*Large powerful horns manifest on your head as power swells around you*",oPC);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVisHorn, oPC);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkHorns, oPC, 48.0);
      SetLocalInt(oPC,"abyssalHorn",1);
      DelayCommand(60.0,DeleteLocalInt(oPC,"abyssalHorn"));
      }
     else
     {
      SendMessageToPC(oPC, "You must wait 10 rounds before activating this ability again!");
     }

   }
   else if(sBodyPart == "legs")// Movement Speed Buff
   {
     if(GetLocalInt(oPC,"abyssalSpeed") == 0)
     {
      int nSpeed = 125;

      if(nAbyssalLevel >= 5)
      {
         nSpeed = 150;
         IPSafeAddItemProperty(oItem, ipImproEvasion, 48.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, FALSE);
      }
      else if(nAbyssalLevel >= 3)
      {
         nSpeed = 150;
         IPSafeAddItemProperty(oItem, ipEvasion, 48.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, FALSE);
      }
      eSpeed = EffectMovementSpeedIncrease(nSpeed);
      eVisSpeed = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
      eLinkSpeed = EffectLinkEffects(eSpeed, eVisSpeed);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkSpeed, oPC, 48.0);
      SetLocalInt(oPC,"abyssalSpeed",1);
      FloatingTextStringOnCreature("*You begin to sprint with your powerful demonic legs*",oPC);
      DelayCommand(60.0,DeleteLocalInt(oPC,"abyssalSpeed"));


     }
     else
     {
      SendMessageToPC(oPC, "You must wait 10 rounds before activating this ability again!");
     }
   }
}

int GenerateHorns(object oPC)
{

      int nRace = GetAppearanceType(oPC);
      int nGender = GetGender(oPC);
      int nFinalHorns = 0;
      int nHorns = Random(6)+1;

      // nHorns
      if(nGender == 0)  // Male
      {
        if((nRace == 4) || (nRace == 6)) // Human + Half Elf
        {
          switch(nHorns)
          {
            case 1: nFinalHorns =717 ; break;
            case 2: nFinalHorns =718; break;
            case 3: nFinalHorns =719; break;
            case 4: nFinalHorns =720; break;
            case 5: nFinalHorns =722; break;
            case 6: nFinalHorns =723; break;
          }
        }
        else if(nRace == 1) // Elf
        {
          switch(nHorns)
          {
            case 1: nFinalHorns =773; break;
            case 2: nFinalHorns =774; break;
            case 3: nFinalHorns =775; break;
            case 4: nFinalHorns =776; break;
            case 5: nFinalHorns =778; break;
            case 6: nFinalHorns =779; break;
          }
        }
        else if(nRace == 0) // Dwarf
        {
          switch(nHorns)
          {
            case 1: nFinalHorns =830; break;
            case 2: nFinalHorns =831; break;
            case 3: nFinalHorns =832; break;
            case 4: nFinalHorns =833; break;
            case 5: nFinalHorns =835; break;
            case 6: nFinalHorns =836; break;
          }
        }
        else if(nRace == 3) // Halfling
        {
          switch(nHorns)
          {
            case 1: nFinalHorns =886; break;
            case 2: nFinalHorns =887; break;
            case 3: nFinalHorns =888; break;
            case 4: nFinalHorns =889; break;
            case 5: nFinalHorns =891; break;
            case 6: nFinalHorns =892; break;
          }
        }
        else if(nRace == 2) // Gnome
        {
          switch(nHorns)
          {
            case 1: nFinalHorns =942; break;
            case 2: nFinalHorns =943; break;
            case 3: nFinalHorns =944; break;
            case 4: nFinalHorns =945; break;
            case 5: nFinalHorns =947; break;
            case 6: nFinalHorns =948; break;
          }
        }
        else if(nRace == 5) // Half Orc
        {
          switch(nHorns)
          {
            case 1: nFinalHorns =998; break;
            case 2: nFinalHorns =999; break;
            case 3: nFinalHorns =1000; break;
            case 4: nFinalHorns =1001; break;
            case 5: nFinalHorns =1003; break;
            case 6: nFinalHorns =1004; break;
          }
        }

      }
      else if(nGender == 1)// Female
      {
        if((nRace == 4) || (nRace == 6)) // Human + Half Elf
        {
          switch(nHorns)
          {
            case 1: nFinalHorns =745; break;
            case 2: nFinalHorns =746; break;
            case 3: nFinalHorns =747; break;
            case 4: nFinalHorns =748; break;
            case 5: nFinalHorns =750; break;
            case 6: nFinalHorns =751; break;
          }

        }
        else if(nRace == 1) // Elf
        {
          switch(nHorns)
          {
            case 1: nFinalHorns =802; break;
            case 2: nFinalHorns =803; break;
            case 3: nFinalHorns =804; break;
            case 4: nFinalHorns =805; break;
            case 5: nFinalHorns =807; break;
            case 6: nFinalHorns =808; break;
          }

        }
        else if(nRace == 0) // Dwarf
        {
          switch(nHorns)
          {
            case 1: nFinalHorns =858; break;
            case 2: nFinalHorns =859; break;
            case 3: nFinalHorns =860; break;
            case 4: nFinalHorns =861; break;
            case 5: nFinalHorns =863; break;
            case 6: nFinalHorns =864; break;
          }

        }
        else if(nRace == 3) // Halfling
        {
          switch(nHorns)
          {
            case 1: nFinalHorns =914; break;
            case 2: nFinalHorns =915; break;
            case 3: nFinalHorns =916; break;
            case 4: nFinalHorns =917; break;
            case 5: nFinalHorns =919; break;
            case 6: nFinalHorns =920; break;
          }

        }
        else if(nRace == 2) // Gnome
        {
          switch(nHorns)
          {
            case 1: nFinalHorns =970; break;
            case 2: nFinalHorns =971; break;
            case 3: nFinalHorns =972; break;
            case 4: nFinalHorns =973; break;
            case 5: nFinalHorns =975; break;
            case 6: nFinalHorns =976; break;
          }

        }
        else if(nRace == 5) // Half Orc
        {
          switch(nHorns)
          {
            case 1: nFinalHorns =1026; break;
            case 2: nFinalHorns =1027; break;
            case 3: nFinalHorns =1028; break;
            case 4: nFinalHorns =1029; break;
            case 5: nFinalHorns =1031; break;
            case 6: nFinalHorns =1032; break;
          }

        }

      }

  return nFinalHorns;

}
