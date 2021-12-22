
// Edited: 07/23/19 - Maverick00053. Added in some simple speak scripts and boss mechanics.
#include "ds_ai2_include"

void main()
{
    object oArea = GetArea(OBJECT_SELF);
    object oDamager     = GetLastDamager();
    int nRandom = Random(11);
    int nTalked = GetLocalInt(OBJECT_SELF, "talkedrecently");
    int nAreaLieutentants = GetLocalInt(oArea,"InvasionLieutenants");
    int n75PercentHP = GetLocalInt(OBJECT_SELF,"75%AbilityFired");
    int n50PercentHP = GetLocalInt(OBJECT_SELF,"50%AbilityFired");
    int n25PercentHP = GetLocalInt(OBJECT_SELF,"25%AbilityFired");
    int nInvasionLieutenants = GetLocalInt(oArea,"InvasionLieutenants");
    string sMob = GetResRef(OBJECT_SELF);
    location lAhead = GetAheadLocation(OBJECT_SELF);
    location lBehind = GetBehindLocation(OBJECT_SELF);
    location lLeft  = GetStepLeftLocation(OBJECT_SELF);
    location lRight = GetStepRightLocation(OBJECT_SELF);
    effect eHeal = EffectHeal(1000);
    effect eVisual = EffectVisualEffect(VFX_IMP_HEALING_L);
    effect eLink = EffectLinkEffects(eVisual, eHeal);
    effect eDaze = EffectDazed();
    effect eDeaf = EffectDeaf();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink2 = EffectLinkEffects(eDaze,eDeaf);
    eLink2 = EffectLinkEffects(eLink2,eMind);
    eLink2 = EffectLinkEffects(eLink2,eDur);
    effect eVisual2 = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);


    // Check for the demon boss to make sure its invuln goes down -  invasioncreat004
    if((sMob == "invasioncreat004") && ( nInvasionLieutenants == 100))
    {
       SetPlotFlag(OBJECT_SELF, 0);
    }

    // HP based boss reactions from the troll boss - invasiontrollbs

    if(sMob == "invasiontrollbs")
    {

      if((GetPercentageHPLoss(OBJECT_SELF) <= 50) && (n50PercentHP == 0))
      {
        AssignCommand(OBJECT_SELF, SpeakString("*Yelps out in gibberish and begins waving its arms around as it casted a spell. A barrier shoots up and absorbs all damage for a few seconds as two large trolls are summoned in to help the troll leader*",TALKVOLUME_TALK));
        CreateObject(OBJECT_TYPE_CREATURE, "bigmounttroll", lAhead, FALSE);
        CreateObject(OBJECT_TYPE_CREATURE, "bigmounttroll", lBehind, FALSE);
        SetLocalInt(OBJECT_SELF,"50%AbilityFired",1);
        SetPlotFlag(OBJECT_SELF, 1);
        DelayCommand(6.0,SetPlotFlag(OBJECT_SELF, 0));
      }
      else if((GetPercentageHPLoss(OBJECT_SELF) <= 25) && (n25PercentHP == 0))
      {
        AssignCommand(OBJECT_SELF, SpeakString("*As death nears a second barrier is raised as the leader pulls a potion and quickly drinks it all*",TALKVOLUME_TALK));
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eLink,OBJECT_SELF);
        SetLocalInt(OBJECT_SELF,"25%AbilityFired",1);
        SetPlotFlag(OBJECT_SELF, 1);
        DelayCommand(6.0,SetPlotFlag(OBJECT_SELF, 0));
      }





    }

    // HP based reactions for beastman boss - invasionbeastbs
    if(sMob == "invasionbeastbs")
    {
      if((GetPercentageHPLoss(OBJECT_SELF) <= 75) && (n75PercentHP == 0))
      {
        AssignCommand(OBJECT_SELF, SpeakString("*Lets out a deafening howl and headbutts her attacker!*",TALKVOLUME_TALK));
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisual2,GetLocation(OBJECT_SELF),0.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink2,oDamager,12.0);
        SetLocalInt(OBJECT_SELF,"75%AbilityFired",1);
        SetPlotFlag(OBJECT_SELF, 1);
        DelayCommand(3.0,SetPlotFlag(OBJECT_SELF, 0));
      }
      if((GetPercentageHPLoss(OBJECT_SELF) <= 50) && (n50PercentHP == 0))
      {
        AssignCommand(OBJECT_SELF, SpeakString("*A mighty roar escapes her muzzle, instantly calling to her side her bodyguards*",TALKVOLUME_TALK));
        CreateObject(OBJECT_TYPE_CREATURE, "beastguard", lAhead, FALSE);
        CreateObject(OBJECT_TYPE_CREATURE, "beastguard", lBehind, FALSE);
        CreateObject(OBJECT_TYPE_CREATURE, "beastguard", lLeft, FALSE);
        CreateObject(OBJECT_TYPE_CREATURE, "beastguard", lRight, FALSE);
        SetLocalInt(OBJECT_SELF,"50%AbilityFired",1);
        SetPlotFlag(OBJECT_SELF, 1);
        DelayCommand(3.0,SetPlotFlag(OBJECT_SELF, 0));
      }
      else if((GetPercentageHPLoss(OBJECT_SELF) <= 25) && (n25PercentHP == 0))
      {
        AssignCommand(OBJECT_SELF, SpeakString("*Snarls as she downs a heal potion real fast. Her wounds quickly healing*",TALKVOLUME_TALK));
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eLink,OBJECT_SELF);
        SetLocalInt(OBJECT_SELF,"25%AbilityFired",1);
        SetPlotFlag(OBJECT_SELF, 1);
        DelayCommand(3.0,SetPlotFlag(OBJECT_SELF, 0));
      }





    }

  // invasion boss and lieutentant mobs talking
  if(nTalked == 0)// Make sure they dont constantly spam text
  {


   if(sMob == "invasioncreat004" && (GetPlotFlag(OBJECT_SELF) == 0))    // Demons
   {

      AssignCommand(OBJECT_SELF, SpeakString("(Abyssal) No! My barrier! What have you filthy mortals done!? I will make you pay!",TALKVOLUME_TALK));

   }
   else if(sMob == "invasioncreat004")     // Demons
   {

      AssignCommand(OBJECT_SELF, SpeakString("(Abyssal) Fools! You will never break through my defenses!",TALKVOLUME_TALK));
   }
   else if(sMob == "invasioncreat003")      // Demons
   {

    if(nRandom == 0)
    {
       AssignCommand(OBJECT_SELF, SpeakString("(Abyssal) Cower before your new masters!",TALKVOLUME_TALK));
    }
    else if(nRandom == 1)
    {
       AssignCommand(OBJECT_SELF, SpeakString("(Abyssal) Weak mortals! You do not stand a chance!",TALKVOLUME_TALK));
    }
    else if(nRandom == 2)
    {
       AssignCommand(OBJECT_SELF, SpeakString("*Snarls, growls and hurls curses in abyssal at you*",TALKVOLUME_TALK));
    }
    else if(nRandom == 3)
    {
       AssignCommand(OBJECT_SELF, SpeakString("(Abyssal) Run away little mortals! I like to play catch!",TALKVOLUME_TALK));
    }
    else if(nRandom == 4)
    {
       AssignCommand(OBJECT_SELF, SpeakString("(Abyssal) I plan to saviour the taste of your bones!",TALKVOLUME_TALK));
    }
    else if(nRandom == 5)
    {
       AssignCommand(OBJECT_SELF, SpeakString("(Abyssal) Run while you have the chance!",TALKVOLUME_TALK));
    }
    else if(nRandom == 6)
    {
       AssignCommand(OBJECT_SELF, SpeakString("(Abyssal) I am going to enjoy crushing you!",TALKVOLUME_TALK));
    }
    else if(nRandom == 7)
    {
       AssignCommand(OBJECT_SELF, SpeakString("(Abyssal) Die, die, die!",TALKVOLUME_TALK));
    }
    else if(nRandom == 8)
    {
       AssignCommand(OBJECT_SELF, SpeakString("(Abyssal) It has been eons since I have tasted fresh mortal!",TALKVOLUME_TALK));
    }
    else if(nRandom == 9)
    {
       AssignCommand(OBJECT_SELF, SpeakString("(Abyssal) You are pathetic!",TALKVOLUME_TALK));
    }
    else if(nRandom == 10)
    {
       AssignCommand(OBJECT_SELF, SpeakString("(Abyssal) Mmm. I enjoy the pain. Let me return the favor!",TALKVOLUME_TALK));
    }


    }
    else if((sMob == "ds_yellowfang_4") || (sMob == "ds_yellowfang_3") || (sMob == "ds_yellowfang_6") )  // Goblins
    {


    if(nRandom == 0)
    {
       AssignCommand(OBJECT_SELF, SpeakString("We be takin' everything!",TALKVOLUME_TALK));
    }
    else if(nRandom == 1)
    {
       AssignCommand(OBJECT_SELF, SpeakString("No! You die! Die! Die!",TALKVOLUME_TALK));
    }
    else if(nRandom == 2)
    {
       AssignCommand(OBJECT_SELF, SpeakString("*Snarls, growls and launches itself at you*",TALKVOLUME_TALK));
    }
    else if(nRandom == 3)
    {
       AssignCommand(OBJECT_SELF, SpeakString("Mighty gobs! Destroy pathetic weaklings!",TALKVOLUME_TALK));
    }
    else if(nRandom == 4)
    {
       AssignCommand(OBJECT_SELF, SpeakString("Mes stab back! Stab! Stab! Stab!",TALKVOLUME_TALK));
    }
    else if(nRandom == 5)
    {
       AssignCommand(OBJECT_SELF, SpeakString("Noes! Yous die first!",TALKVOLUME_TALK));
    }
    else if(nRandom == 6)
    {
       AssignCommand(OBJECT_SELF, SpeakString("Mes enjoys crushin' you!",TALKVOLUME_TALK));
    }
    else if(nRandom == 7)
    {
       AssignCommand(OBJECT_SELF, SpeakString("Tell where shinies is and yous maybes live!",TALKVOLUME_TALK));
    }
    else if(nRandom == 8)
    {
       AssignCommand(OBJECT_SELF, SpeakString("Mes take all your shinies!",TALKVOLUME_TALK));
    }
    else if(nRandom == 9)
    {
       AssignCommand(OBJECT_SELF, SpeakString("Yes! Fights! You die quickly!",TALKVOLUME_TALK));
    }
    else if(nRandom == 10)
    {
       AssignCommand(OBJECT_SELF, SpeakString("No! You no stops gob army! You die!",TALKVOLUME_TALK));
    }



    }
    else if((sMob == "chosenofkilma002") || (sMob == "orcboss001"))   // Orcs
    {


    if(nRandom == 0)
    {
       AssignCommand(OBJECT_SELF, SpeakString("Orcs chew on yer bones!",TALKVOLUME_TALK));
    }
    else if(nRandom == 1)
    {
       AssignCommand(OBJECT_SELF, SpeakString("No! You die! Die! Die!",TALKVOLUME_TALK));
    }
    else if(nRandom == 2)
    {
       AssignCommand(OBJECT_SELF, SpeakString("*Snarls, growls and launches itself at you*",TALKVOLUME_TALK));
    }
    else if(nRandom == 3)
    {
       AssignCommand(OBJECT_SELF, SpeakString("Boss orc crush yous!",TALKVOLUME_TALK));
    }
    else if(nRandom == 4)
    {
       AssignCommand(OBJECT_SELF, SpeakString("Smash! Stab! Kill you!",TALKVOLUME_TALK));
    }
    else if(nRandom == 5)
    {
       AssignCommand(OBJECT_SELF, SpeakString("Hah! Just flesh wound, weakling!",TALKVOLUME_TALK));
    }
    else if(nRandom == 6)
    {
       AssignCommand(OBJECT_SELF, SpeakString("Mes enjoys crushin' you!",TALKVOLUME_TALK));
    }
    else if(nRandom == 7)
    {
       AssignCommand(OBJECT_SELF, SpeakString("We take everything!",TALKVOLUME_TALK));
    }
    else if(nRandom == 8)
    {
       AssignCommand(OBJECT_SELF, SpeakString("Give up and cry as we crush you!",TALKVOLUME_TALK));
    }
    else if(nRandom == 9)
    {
       AssignCommand(OBJECT_SELF, SpeakString("Yes! Fight! You die quickly!",TALKVOLUME_TALK));
    }
    else if(nRandom == 10)
    {
       AssignCommand(OBJECT_SELF, SpeakString("No! You won't stop mighty orc! You will die!",TALKVOLUME_TALK));
    }



    }
    else if((sMob == "bigmounttroll"))        // Trolls
    {
       AssignCommand(OBJECT_SELF, SpeakString("*Snarls, growls and yelps out some gibberish*",TALKVOLUME_TALK));
    }
    else if((sMob == "invasionbeastbs") || (sMob == "beastguard"))  // Beastmen
    {

    if(nRandom == 0)
    {
       AssignCommand(OBJECT_SELF, SpeakString("*Lets out a haunting howl before charging*",TALKVOLUME_TALK));
    }
    else if(nRandom == 1)
    {
       AssignCommand(OBJECT_SELF, SpeakString("*Snarls and lashes back at you*",TALKVOLUME_TALK));
    }
    else if(nRandom == 2)
    {
       AssignCommand(OBJECT_SELF, SpeakString("*Snarls, growls and launches itself at you*",TALKVOLUME_TALK));
    }
    else if(nRandom == 3)
    {
       AssignCommand(OBJECT_SELF, SpeakString("*Growls as it turns and lunges forward*",TALKVOLUME_TALK));
    }
    else if(nRandom == 4)
    {
       AssignCommand(OBJECT_SELF, SpeakString("*Snaps its jaws at you as it attacks back*",TALKVOLUME_TALK));
    }
    else if(nRandom == 5)
    {
       AssignCommand(OBJECT_SELF, SpeakString("*Yelps out as you damage it*",TALKVOLUME_TALK));
    }
    else if(nRandom == 6)
    {
       AssignCommand(OBJECT_SELF, SpeakString("*Howls in pain and snaps back at you*",TALKVOLUME_TALK));
    }
    else if(nRandom == 7)
    {
       AssignCommand(OBJECT_SELF, SpeakString("*Lets out a roar as it leaps at you*",TALKVOLUME_TALK));
    }
    else if(nRandom == 8)
    {
       AssignCommand(OBJECT_SELF, SpeakString("*Howls for its pack mates to join it as it charges*",TALKVOLUME_TALK));
    }
    else if(nRandom == 9)
    {
       AssignCommand(OBJECT_SELF, SpeakString("*Snarls something you cannot understand as it attacks*",TALKVOLUME_TALK));
    }
    else if(nRandom == 10)
    {
       AssignCommand(OBJECT_SELF, SpeakString("*Beats its chest with one hand as it roars and leaps at you*",TALKVOLUME_TALK));
    }


    }




    SetLocalInt(OBJECT_SELF, "talkedrecently", 1);
    DelayCommand(60.0,DeleteLocalInt(OBJECT_SELF, "talkedrecently"));
    }


    ExecuteScript("ds_ai2_damaged", OBJECT_SELF);
}
