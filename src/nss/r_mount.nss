/*
Editted: Maverick00053 April 15 2019
Custom Ride Feat for Calvary class

// 2023/05/13   Opustus     Fixed light crossbow not working with Cav

*/

void ChangeSkins(object oPC); // Handles the skin changing aspect

#include "x2_inc_switches"
#include "inc_ds_porting"
#include "inc_ds_actions"

void main()
{
   object oPC = OBJECT_SELF;
   object oWidget = GetItemPossessedBy(oPC, "r_mountwidget");
   object oPrimaryHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
   object oHorseBC = GetLocalObject(oPC,"ds_horse");
   int nPrimaryType = GetBaseItemType(oPrimaryHand);
   int classLevel = GetLevelByClass(45);
   int mounted = GetLocalInt(oWidget,"mounted");
   int nPheno = GetLocalInt(oWidget,"pheno");
   int nTail = GetLocalInt(oWidget,"tail");
   int horse = GetLocalInt(oWidget,"horse");
   int tail = GetCreatureTailType(oPC);
   int pheno = GetPhenoType(oPC);
   int pcRideSkill = GetSkillRank(SKILL_RIDE,oPC,TRUE);
   int pcRideAC;
   int pcTumbleSkill = GetSkillRank(SKILL_TUMBLE,oPC,TRUE);
   int pcTumbleAC;
   int pcTotalAC;
   int eLoopSpellID;
   effect eLoop;
   effect eArmor;
   effect eHp;
   effect eSpeed;
   effect eDam;
   effect eAB;
   effect eLink;

   // Remove the BC mount if it is out
   if(GetIsObjectValid(oHorseBC))
   {
     DestroyObject(oHorseBC,0.5);
   }

   if(!GetIsPolymorphed(oPC))
   {

    //Cav bow additions - do not let them equip a bow and mount unless they have the mounted archery feat and it is a shortbow or light crossbow.
    if((mounted != 1) && ((nPrimaryType == BASE_ITEM_LONGBOW) || (nPrimaryType == BASE_ITEM_SLING) || (nPrimaryType == BASE_ITEM_THROWINGAXE) || (nPrimaryType == BASE_ITEM_DART) || (nPrimaryType == BASE_ITEM_SHURIKEN) || (nPrimaryType == BASE_ITEM_HEAVYCROSSBOW)))
    {
       SendMessageToPC( oPC, "You cannot use that weapon while mounted!");
       ActionUnequipItem(oPrimaryHand);

    }
    else if((mounted != 1) && (GetHasFeat(FEAT_MOUNTED_ARCHERY, oPC) != TRUE))
    {
      if ((nPrimaryType == BASE_ITEM_SHORTBOW) || (nPrimaryType == BASE_ITEM_LIGHTCROSSBOW) || (nPrimaryType == BASE_ITEM_SLING))
      {
         SendMessageToPC( oPC, "You cannot use that weapon while mounted without proper training!");
         ActionUnequipItem(oPrimaryHand);
      }
    }

   // Set speed bonus and temp hp bonus
   if(classLevel == 1)
   {
      eHp = EffectTemporaryHitpoints(40);
      eSpeed = EffectMovementSpeedIncrease(10);
   }
   else if(classLevel == 2)
   {
      eHp = EffectTemporaryHitpoints(80);
      eSpeed = EffectMovementSpeedIncrease(10);
   }
   else if(classLevel == 3)
   {
      eHp = EffectTemporaryHitpoints(120);
      eSpeed = EffectMovementSpeedIncrease(20);
      eDam = EffectDamageIncrease(DAMAGE_BONUS_1,DAMAGE_TYPE_BLUDGEONING);
      eAB = EffectAttackIncrease(1,ATTACK_BONUS_MISC);
   }
   else if(classLevel == 4)
   {
      eHp = EffectTemporaryHitpoints(160);
      eSpeed = EffectMovementSpeedIncrease(20);
   }
   else if(classLevel == 5)
   {
      eHp = EffectTemporaryHitpoints(200);
      eSpeed = EffectMovementSpeedIncrease(30);
      eDam = EffectDamageIncrease(DAMAGE_BONUS_2,DAMAGE_TYPE_BLUDGEONING);
      eAB = EffectAttackIncrease(2,ATTACK_BONUS_MISC);
   }

   // Set armor bonus based on ride skill
   if(pcRideSkill >= 30)
   {
      pcRideAC=6;
   }
   else if(pcRideSkill >= 25)
   {
      pcRideAC=5;
   }
   else if(pcRideSkill >= 20)
   {
      pcRideAC=4;
   }
   else if(pcRideSkill >= 15)
   {
      pcRideAC=3;
   }
   else if(pcRideSkill >= 10)
   {
      pcRideAC=2;
   }
   else if(pcRideSkill >= 5)
   {
      pcRideAC=1;
   }

   // Set armor negative based on tumble skill
   if(pcTumbleSkill >= 30)
   {
      pcTumbleAC=6;
   }
   else if(pcTumbleSkill >= 25)
   {
      pcTumbleAC=5;
   }
   else if(pcTumbleSkill >= 20)
   {
      pcTumbleAC=4;
   }
   else if(pcTumbleSkill >= 15)
   {
      pcTumbleAC=3;
   }
   else if(pcTumbleSkill >= 10)
   {
      pcTumbleAC=2;
   }
   else if(pcTumbleSkill >= 5)
   {
      pcTumbleAC=1;
   }

   // If the PC has a tail that isnt a horse, it will save it to readd it after dismounting
   if((tail != 16) || (tail != 18) || (tail != 19) || (tail != 21) || (tail != 22) || (tail != 29) || (tail != 31) ||
   (tail != 32) || (tail != 34) || (tail != 35) || (tail != 42) || (tail != 44) || (tail != 45) || (tail != 47) ||
   (tail != 48) || (tail != 55) || (tail != 57) || (tail != 58) || (tail != 60) || (tail != 61) || (tail != GetLocalInt(oWidget,"custom1"))
   || (tail != GetLocalInt(oWidget,"custom2")) || (tail != GetLocalInt(oWidget,"custom3")) || (tail != GetLocalInt(oWidget,"custom4"))
   || (tail != GetLocalInt(oWidget,"custom5")) || (tail != GetLocalInt(oWidget,"custom6")) || (tail != GetLocalInt(oWidget,"custom7"))
   || (tail != GetLocalInt(oWidget,"custom8")) || (tail != GetLocalInt(oWidget,"custom9")) || (tail != GetLocalInt(oWidget,"custom10")))
   {
    SetLocalInt(oWidget,"tail",tail);
   }

   // First check to see if they are mounted, if they are dismount them
   if(mounted == 1)
   {

     if(GetLocalInt(oWidget,"appearance") != 0)// The goblin spider/wolf mounts work differently
     {
       SetCreatureAppearanceType(oPC,GetLocalInt(oWidget,"appearance"));
       SetLocalInt(oWidget,"appearance",0);
       DeleteLocalInt(oWidget,"mounted");
     }
     else
     {
       SetPhenoType(nPheno,oPC);
       SetCreatureTailType(nTail,oPC);
       DeleteLocalInt(oWidget,"pheno");
       DeleteLocalInt(oWidget,"mounted");
       DeleteLocalInt(oWidget,"tail");
       // Remove new adjustable skins
       ChangeSkins(oPC);
       //
     }

     // Mounted bonuses being removed
     //

      eLoop = GetFirstEffect(oPC);
      while(GetIsEffectValid(eLoop))
         {
          eLoopSpellID = GetEffectSpellId(eLoop);

            if ((eLoopSpellID == 945) || (GetEffectTag(eLoop) == "caveffects"))
            {
                 RemoveEffect(oPC, eLoop);
            }

                eLoop=GetNextEffect(oPC);
         }


     //

   }
   else // If they arent mounted, then mount them
   {
     if(GetHasFeat(1220,oPC)== TRUE)
     {
       // A check to make sure it defaults to the basic horse or worg for goblin
       if(horse == 0)
       {
          horse = 16;
          if(GetRacialType(oPC) == 38)
          {
            horse = 308;
          }
       }

       if((horse == 308) || (horse == 309))// The goblin spider/worg mounts work differently
       {
         SetLocalInt(oWidget,"appearance",GetAppearanceType(oPC));
         SetCreatureAppearanceType(oPC,horse);
         SetLocalInt(oWidget,"mounted",1);
       }
       else
       {
         if(pheno == 2) // If using the fat/large pheno set that specific mounted pheno
         {
           SetPhenoType(5,oPC);
         }
         else // Otherwise set normal mounted pheno
         {
           SetPhenoType(3,oPC);
         }
         SetCreatureTailType(horse,oPC);
         SetLocalInt(oWidget,"pheno",pheno);
         SetLocalInt(oWidget,"mounted",1);
         // New adjustable skins
         ChangeSkins(oPC);
         //
       }

      // Adds mounted bonus
      if(pcTumbleAC > pcRideAC)
      {
         pcTotalAC = pcTumbleAC - pcRideAC;
         eArmor = EffectACDecrease(pcTotalAC, AC_DODGE_BONUS);
         eLink = EffectLinkEffects(eSpeed, eArmor);
         eLink = EffectLinkEffects(eDam, eLink);
         eLink = EffectLinkEffects(eAB, eLink);
         eLink = ExtraordinaryEffect(eLink);
         eLink = TagEffect(eLink, "caveffects");
         eHp = TagEffect(eHp, "caveffects");
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHp, oPC);
      }
      else if(pcTumbleAC == pcRideAC)
      {
         pcTotalAC == 0;
         eLink = EffectLinkEffects(eDam, eSpeed);
         eLink = EffectLinkEffects(eAB, eLink);
         eLink = ExtraordinaryEffect(eLink);
         eLink = TagEffect(eLink, "caveffects");
         eHp = TagEffect(eHp, "caveffects");
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHp, oPC);
      }
      else if(pcTumbleAC < pcRideAC)
      {
         pcTotalAC = pcRideAC - pcTumbleAC;
         eArmor = EffectACIncrease(pcTotalAC, AC_DODGE_BONUS);
         eLink = EffectLinkEffects(eSpeed, eArmor);
         eLink = EffectLinkEffects(eDam, eLink);
         eLink = EffectLinkEffects(eAB, eLink);
         eLink = ExtraordinaryEffect(eLink);
         eLink = TagEffect(eLink, "caveffects");
         eHp = TagEffect(eHp, "caveffects");
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
         ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHp, oPC);
      }



     }
   }




 }
 else
 {
   SendMessageToPC(oPC, "You cannot mount while polymorphed!");
 }
}

void ChangeSkins(object oPC)
{
  int nAppearance = GetAppearanceType(oPC);
  int nGender = GetGender(oPC);   // Male 0, Female 1

  if(nGender == 1)  // If female
  {
    switch(nAppearance)
    {
      case 0: SetCreatureAppearanceType(oPC,482); break;  // Dwarf
      case 1: SetCreatureAppearanceType(oPC,484); break;  // Elf
      case 2: SetCreatureAppearanceType(oPC,486); break;  // Gnome
      case 3: SetCreatureAppearanceType(oPC,488); break;  // Halfling
      case 4: SetCreatureAppearanceType(oPC,490); break;  // Half elf
      case 5: SetCreatureAppearanceType(oPC,492); break;  // Half orc
      case 6: SetCreatureAppearanceType(oPC,494); break;  // Human
      case 482: SetCreatureAppearanceType(oPC,0); break;
      case 484: SetCreatureAppearanceType(oPC,1); break;
      case 486: SetCreatureAppearanceType(oPC,2); break;
      case 488: SetCreatureAppearanceType(oPC,3); break;
      case 490: SetCreatureAppearanceType(oPC,4); break;
      case 492: SetCreatureAppearanceType(oPC,5); break;
      case 494: SetCreatureAppearanceType(oPC,6); break;
    }
  }
  else // Male and others
  {
    switch(nAppearance)
    {
      case 0: SetCreatureAppearanceType(oPC,483); break;  // Dwarf
      case 1: SetCreatureAppearanceType(oPC,485); break;  // Elf
      case 2: SetCreatureAppearanceType(oPC,487); break;  // Gnome
      case 3: SetCreatureAppearanceType(oPC,489); break;  // Halfling
      case 4: SetCreatureAppearanceType(oPC,491); break;  // Half elf
      case 5: SetCreatureAppearanceType(oPC,493); break;  // Half orc
      case 6: SetCreatureAppearanceType(oPC,495); break;  // Human
      case 483: SetCreatureAppearanceType(oPC,0); break;
      case 485: SetCreatureAppearanceType(oPC,1); break;
      case 487: SetCreatureAppearanceType(oPC,2); break;
      case 489: SetCreatureAppearanceType(oPC,3); break;
      case 491: SetCreatureAppearanceType(oPC,4); break;
      case 493: SetCreatureAppearanceType(oPC,5); break;
      case 495: SetCreatureAppearanceType(oPC,6); break;
    }
  }

}
