
// Edited: 07/23/19 - Maverick00053. Added in some simple speak scripts and boss mechanics.
// Edited: 11/1/24 - Mav - Updated to be more generic and tie into updated Invasions 2.0
#include "ds_ai2_include"

void CheckLieutentant(object oCritter);

void BarrierHeal(object oCritter);

void SummonReinforcements(object oCritter);

void UnblockableAttack(object oCritter, object oDamager);

void main()
{
    object oArea = GetArea(OBJECT_SELF);
    object oDamager     = GetLastDamager();
    object lieutentant;
    int nRandom = Random(5);
    int nTalked = GetLocalInt(OBJECT_SELF, "talkedrecently");
    int n75PercentHP = GetLocalInt(OBJECT_SELF,"75%AbilityFired");
    int n75Choice = GetLocalInt(OBJECT_SELF,"75Set");
    int n50PercentHP = GetLocalInt(OBJECT_SELF,"50%AbilityFired");
    int n50Choice = GetLocalInt(OBJECT_SELF,"50Set");
    int n25PercentHP = GetLocalInt(OBJECT_SELF,"25%AbilityFired");
    int n25Choice = GetLocalInt(OBJECT_SELF,"25Set");

    // This enables the invuln mechanics
    if(GetLocalInt(OBJECT_SELF,"abyssalboss")==1)
    {
      lieutentant = GetObjectByTag(GetLocalString(OBJECT_SELF,"lieutenant"));
      if(!GetIsObjectValid(lieutentant))
      {
       SetPlotFlag(OBJECT_SELF,FALSE);
      }
      else
      {
       if(GetLocalInt(OBJECT_SELF, "notifcationrecently")==0)
       {
        AssignCommand(OBJECT_SELF,SpeakString("*The creature seems immune to all damage. Its barrier seems to be reinforced by other notable creatures in the area*",TALKVOLUME_TALK));
        SetLocalInt(OBJECT_SELF, "notifcationrecently", 1);
        DelayCommand(30.0,DeleteLocalInt(OBJECT_SELF, "notifcationrecently"));
       }
      }
    }
    //



    // HP Base Reaction Abilities
    if((GetPercentageHPLoss(OBJECT_SELF) <= 75) && (n75PercentHP == 0) && (n75Choice != 0))
    {
     SetLocalInt(OBJECT_SELF,"75%AbilityFired",1);
     switch(n75Choice)
     {
      case 1: BarrierHeal(OBJECT_SELF); break;
      case 2: SummonReinforcements(OBJECT_SELF); break;
      case 3: UnblockableAttack(OBJECT_SELF, oDamager); break;
     }
    }
    if((GetPercentageHPLoss(OBJECT_SELF) <= 50) && (n50PercentHP == 0) && (n50Choice != 0))
    {
     SetLocalInt(OBJECT_SELF,"50%AbilityFired",1);
     switch(n50Choice)
     {
      case 1: BarrierHeal(OBJECT_SELF); break;
      case 2: SummonReinforcements(OBJECT_SELF); break;
      case 3: UnblockableAttack(OBJECT_SELF, oDamager); break;
     }
    }
    else if((GetPercentageHPLoss(OBJECT_SELF) <= 25) && (n25PercentHP == 0) && (n25Choice != 0))
    {
     SetLocalInt(OBJECT_SELF,"25%AbilityFired",1);
     switch(n25Choice)
     {
      case 1: BarrierHeal(OBJECT_SELF); break;
      case 2: SummonReinforcements(OBJECT_SELF); break;
      case 3: UnblockableAttack(OBJECT_SELF, oDamager); break;
     }
    }


  // invasion boss and lieutentant mobs talking
  if(nTalked == 0)// Make sure they dont constantly spam text
  {
   switch(nRandom)
   {
     case 0: AssignCommand(OBJECT_SELF,SpeakString(GetLocalString(OBJECT_SELF,"talk1"),TALKVOLUME_TALK)); break;
     case 1: AssignCommand(OBJECT_SELF,SpeakString(GetLocalString(OBJECT_SELF,"talk2"),TALKVOLUME_TALK)); break;
     case 2: AssignCommand(OBJECT_SELF,SpeakString(GetLocalString(OBJECT_SELF,"talk3"),TALKVOLUME_TALK)); break;
     case 3: AssignCommand(OBJECT_SELF,SpeakString(GetLocalString(OBJECT_SELF,"talk4"),TALKVOLUME_TALK)); break;
     case 4: AssignCommand(OBJECT_SELF,SpeakString(GetLocalString(OBJECT_SELF,"talk5"),TALKVOLUME_TALK)); break;
   }
   SetLocalInt(OBJECT_SELF, "talkedrecently", 1);
   DelayCommand(30.0,DeleteLocalInt(OBJECT_SELF, "talkedrecently"));
  }

  ExecuteScript("ds_ai2_damaged", OBJECT_SELF);
}

void CheckLieutentant(object oCritter)
{


}

void BarrierHeal(object oCritter)
{
 effect eHeal = EffectHeal(10000);
 effect eVisual = EffectVisualEffect(VFX_IMP_HEALING_L);
 effect eLink = EffectLinkEffects(eVisual, eHeal);

 AssignCommand(oCritter, SpeakString("*A barrier of magic is suddenly raised and their wounds begin to heal rapidly!*",TALKVOLUME_TALK));
 ApplyEffectToObject(DURATION_TYPE_INSTANT,eLink,oCritter);
 SetPlotFlag(oCritter, 1);
 DelayCommand(6.0,SetPlotFlag(oCritter, 0));
}

void SummonReinforcements(object oCritter)
{
 location lAhead = GetAheadLocation(OBJECT_SELF);
 location lBehind = GetBehindLocation(OBJECT_SELF);
 location lLeft  = GetStepLeftLocation(OBJECT_SELF);
 location lRight = GetStepRightLocation(OBJECT_SELF);
 string sBoyguard = GetLocalString(oCritter,"bodyguard");

 AssignCommand(oCritter, SpeakString("*A mighty roar escapes it's muzzle, instantly calling to their side bodyguards. A barrier also temporarily is raised!*",TALKVOLUME_TALK));
 CreateObject(OBJECT_TYPE_CREATURE, sBoyguard, lAhead, FALSE);
 CreateObject(OBJECT_TYPE_CREATURE, sBoyguard, lBehind, FALSE);
 CreateObject(OBJECT_TYPE_CREATURE, sBoyguard, lLeft, FALSE);
 CreateObject(OBJECT_TYPE_CREATURE, sBoyguard, lRight, FALSE);
 SetPlotFlag(oCritter, 1);
 DelayCommand(6.0,SetPlotFlag(oCritter, 0));
}


void UnblockableAttack(object oCritter, object oDamager)
{
 effect eDaze = EffectDazed();
 effect eDeaf = EffectDeaf();
 effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
 effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
 effect eLink2 = EffectLinkEffects(eDaze,eDeaf);
 eLink2 = EffectLinkEffects(eLink2,eMind);
 eLink2 = EffectLinkEffects(eLink2,eDur);
 effect eVisual2 = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);

 AssignCommand(oCritter, SpeakString("*Lets out a deafening howl of pain and headbutts their attacker!*",TALKVOLUME_TALK));
 ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisual2,GetLocation(oCritter),0.0);
 ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink2,oDamager,12.0);
 SetPlotFlag(oCritter, 1);
 DelayCommand(3.0,SetPlotFlag(oCritter, 0));
}
