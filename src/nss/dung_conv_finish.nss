/*
  Dungeon Dynamic Tool set convo system for NPCs and PLCs - END SCRIPT the convo sends you to

  - Maverick00053  11/23/2023

*/

#include "inc_ds_summons"
#include "inc_ds_ondeath"

//Resolves the challenges
void ResolveChallenge(object oPC, string sType, string sWaypoint, int nLevel, int nNode);

// Generates the rewards - Gold/XP/Items
void RewardPC(object oPC, int nLevel, string sType, string sWaypoint);

// Generates XP for the party in an area
void GenerateXPForParty(object oPC, int nLevel);

// Gives us a number of nearby party members
int GetPCPartyNumberNearby(object oPC);

//Clears out all the variables once done
void ClearChecks(object oPC);

void main()
{
    object oPC = OBJECT_SELF;
    string sType = GetLocalString(oPC,"dungtype");
    string sWaypoint = GetLocalString(oPC,"dungwaypoint");
    int nLevel = GetLocalInt(oPC,"dunglevel");
    int nNode = GetLocalInt( oPC, "ds_node");

    if(nNode == 0) return;

    ResolveChallenge(oPC, sType, sWaypoint, nLevel, nNode);
    ClearChecks(oPC);
}


void ResolveChallenge(object oPC, string sType, string sWaypoint, int nLevel, int nNode)
{

    // Checks for nearby party members and reduces the roll as a result
    int nPartyNearbyCount = GetPCPartyNumberNearby(oPC);
    if(nPartyNearbyCount >= 1)
    {
     SendMessageToPC(oPC,IntToString(nPartyNearbyCount) + " party members nearby to assist with task. Reducing DC difficulty by " + IntToString(nPartyNearbyCount*2));
    }
    //

    string sSkill;
    int nDC = nLevel + 10 + (nLevel-(nLevel/3)) - (nPartyNearbyCount*2);
    int nSkillRank1;
    int nSkillRank2;
    int nSkillRank3;
    int nSkillRank4;
    int nDiceRoll = Random(20)+1;
    int nDiceRollTotal;
    object oDungeonObject = GetLocalObject(oPC,"dungobject");

    SetLocalInt(oDungeonObject,"blocker",1);
    DelayCommand(60.0,DeleteLocalInt(oDungeonObject,"blocker"));

    if(sType == "hiddendoornpc")
    {
     nSkillRank1 = GetSkillRank(SKILL_PERSUADE,oPC);
     nSkillRank2 = GetSkillRank(SKILL_BLUFF,oPC);
     nSkillRank3 = GetSkillRank(SKILL_INTIMIDATE,oPC);
     nSkillRank4 = GetSkillRank(SKILL_PICK_POCKET,oPC);

     if(nNode==1)
     {
        sSkill = "PERSUADE";
        nDiceRollTotal = nDiceRoll + nSkillRank1;
        nDC = nDC - 5;

       if(nDiceRollTotal >= nDC)
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank1) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !SUCCESS!");
        RewardPC(oPC, nLevel, sType, sWaypoint);
        AssignCommand(oDungeonObject,ActionSpeakString("Hmm. Fine. It is here... *Reveals the location of the hidden doorway* Let me go get some supplies. *Disappears afterwards*"));
        DelayCommand(0.5,DestroyObject(oDungeonObject));
       }
       else
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank1) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !FAILURE!");
       }

      }
     else if(nNode==2)
     {
        sSkill = "BLUFF";
        nDiceRollTotal = nDiceRoll + nSkillRank2;
        nDC = nDC - 10;

       if(nDiceRollTotal >= nDC)
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank2) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !SUCCESS!");
        RewardPC(oPC, nLevel, sType, sWaypoint);
        AssignCommand(oDungeonObject,ActionSpeakString("I see. I don't want to get in trouble... its right here *Reveals the location of the hidden doorway and disappears shortly after*"));
        DelayCommand(0.5,DestroyObject(oDungeonObject));
       }
       else
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank2) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !FAILURE!");
       }
     }
     else if(nNode==3)
     {
        sSkill = "INTIMIDATE";
        nDiceRollTotal = nDiceRoll + nSkillRank3;

       if(nDiceRollTotal >= nDC)
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank3) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !SUCCESS!");
        RewardPC(oPC, nLevel, sType, sWaypoint);
        AssignCommand(oDungeonObject,ActionSpeakString("Fine! Its just here look! *Reveals the location of the hidden doorway before running off*"));
        DelayCommand(0.5,DestroyObject(oDungeonObject));
       }
       else
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank3) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !FAILURE!");
       }
     }
     else if(nNode==4)   // Pickpocket has a +50 adjustment
     {
        sSkill = "PICKPOCKET";
        nDiceRollTotal = nDiceRoll + nSkillRank4 + 50;

       if((nDiceRollTotal) >= nDC)
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank4) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !SUCCESS!");
        RewardPC(oPC, nLevel, sType, sWaypoint);
        AssignCommand(oDungeonObject,ActionSpeakString("No! I am busy! Shoo! *As they are distracted shooing you off you successfully pick pocket the map, and location off of them. Revealing the door way after they take off*"));
        DelayCommand(0.5,DestroyObject(oDungeonObject));
       }
       else
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank4) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !FAILURE!");
       }
     }

    }
    else if(sType == "talknpc")
    {
     nSkillRank1 = GetSkillRank(SKILL_PERSUADE,oPC);
     nSkillRank2 = GetSkillRank(SKILL_BLUFF,oPC);
     nSkillRank3 = GetSkillRank(SKILL_INTIMIDATE,oPC);
     nSkillRank4 = GetSkillRank(SKILL_PICK_POCKET,oPC);

     if(nNode==1)
     {
        sSkill = "PERSUADE";
        nDiceRollTotal = nDiceRoll + nSkillRank1;
        nDC = nDC - 5;

       if(nDiceRollTotal >= nDC)
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank1) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !SUCCESS!");
        RewardPC(oPC, nLevel, sType, sWaypoint);
        AssignCommand(oDungeonObject,ActionSpeakString("Alright. Here *Hands you a heavy bag* this is your share to keep this spot quiet? *Nods before taking off*"));
        DelayCommand(0.5,DestroyObject(oDungeonObject));
       }
       else
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank1) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !FAILURE!");
       }

     }
     else if(nNode==2)
     {
        sSkill = "BLUFF";
        nDiceRollTotal = nDiceRoll + nSkillRank2;
        nDC = nDC - 10;

       if(nDiceRollTotal >= nDC)
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank2) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !SUCCESS!");
        RewardPC(oPC, nLevel, sType, sWaypoint);
        AssignCommand(oDungeonObject,ActionSpeakString("Oh. I... didn't mean to steal from anyone. Look here. *Hands you a heavy bag and quickly takes off*"));
        DelayCommand(0.5,DestroyObject(oDungeonObject));
       }
       else
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank2) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !FAILURE!");
       }
     }
     else if(nNode==3)
     {
        sSkill = "INTIMIDATE";
        nDiceRollTotal = nDiceRoll + nSkillRank3;

       if(nDiceRollTotal >= nDC)
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank3) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !SUCCESS!");
        RewardPC(oPC, nLevel, sType, sWaypoint);
        AssignCommand(oDungeonObject,ActionSpeakString("By the gods don't hurt me! Here! *Tosses a heavy bag at you and runs off*"));
        DelayCommand(0.5,DestroyObject(oDungeonObject));
       }
       else
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank3) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !FAILURE!");
       }
     }
     else if(nNode==4)    // Pickpocket has a +50 adjustment
     {
        sSkill = "PICKPOCKET";
        nDiceRollTotal = nDiceRoll + nSkillRank4 + 50;

       if(nDiceRollTotal >= nDC)
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank4) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !SUCCESS!");
        RewardPC(oPC, nLevel, sType, sWaypoint);
        AssignCommand(oDungeonObject,ActionSpeakString("I said pike off! *As they grumble and take off you quickly picket pocket them successfully and recover a bag of something*"));
        DelayCommand(0.5,DestroyObject(oDungeonObject));
       }
       else
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank4) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !FAILURE!");
       }
     }
    }
    else if(sType == "injurednpc")
    {
      nSkillRank1 = GetSkillRank(SKILL_HEAL,oPC);
      nDiceRollTotal = nDiceRoll + nSkillRank1;
      sSkill = "HEAL";

     if(nNode==1)
     {
      if(nDiceRollTotal >= nDC)
      {
       SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank1) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !SUCCESS!");
        RewardPC(oPC, nLevel, sType, sWaypoint);
        AssignCommand(oDungeonObject,ActionSpeakString("I won't forget your kindness. This is the least I can do. *Passes over a heavy sack before taking their leave*"));
        DelayCommand(0.5,DestroyObject(oDungeonObject));
      }
      else
      {
       SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank1) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !FAILURE!");
      }
     }

    }
    else if(sType == "lorepuzzle")
    {
      nSkillRank1 = GetSkillRank(SKILL_LORE,oPC);
      nDiceRollTotal = nDiceRoll + nSkillRank1;
      sSkill = "LORE";
        nDC = nDC - 5;

     if(nNode==1)
     {
      if(nDiceRollTotal >= nDC)
      {
       SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank1) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !SUCCESS!");
        RewardPC(oPC, nLevel, sType, sWaypoint);
        AssignCommand(oDungeonObject,ActionSpeakString("*The puzzle clicks and cracks open revealing a small hidden treasure*"));
        DelayCommand(0.5,DestroyObject(oDungeonObject));
      }
      else
      {
       SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank1) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !FAILURE!");
      }
     }

    }
    else if(sType == "spellcraftumdpuzzle")     // Odd one. Its checks if spellcraft or umd is higher first.
    {
     nSkillRank1 = GetSkillRank(SKILL_SPELLCRAFT,oPC);
     nSkillRank2 = GetSkillRank(SKILL_USE_MAGIC_DEVICE,oPC);

     if(nSkillRank1>nSkillRank2)
     {
       sSkill = "SPELLCRAFT";
     }
     else
     {
       sSkill = "USE MAGICAL DEVICE";
       nSkillRank1 = nSkillRank2;
     }

     if(nNode==1)
     {
        nDiceRollTotal = nDiceRoll + nSkillRank1;

       if(nDiceRollTotal >= nDC)
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank1) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !SUCCESS!");
        RewardPC(oPC, nLevel, sType, sWaypoint);
        AssignCommand(oDungeonObject,ActionSpeakString("*The puzzle cracks open as the magic is released revealing a small hidden treasure*"));
        DelayCommand(0.5,DestroyObject(oDungeonObject));
       }
       else
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank1) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !FAILURE!");
       }

      }

    }
    else if(sType == "depressednpc")
    {
     nSkillRank1 = GetSkillRank(SKILL_PERFORM,oPC);
     nSkillRank2 = GetSkillRank(SKILL_PERSUADE,oPC);

     if(nNode==1)
     {
        sSkill = "PERFORM";
        nDiceRollTotal = nDiceRoll + nSkillRank1;

       if(nDiceRollTotal >= nDC)
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank1) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !SUCCESS!");
        RewardPC(oPC, nLevel, sType, sWaypoint);
        AssignCommand(oDungeonObject,ActionSpeakString("You are really quite talented! *Smiles* Thank you. I should get going. I have some friends I need to bury. Take this. *Hands you a bag before taking off*"));
        DelayCommand(0.5,DestroyObject(oDungeonObject));
       }
       else
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank1) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !FAILURE!");
       }

      }
     else if(nNode==2)
     {
        sSkill = "PERSUADE";
        nDiceRollTotal = nDiceRoll + nSkillRank2;
        nDC = nDC - 5;

       if(nDiceRollTotal >= nDC)
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank2) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !SUCCESS!");
        RewardPC(oPC, nLevel, sType, sWaypoint);
        AssignCommand(oDungeonObject,ActionSpeakString("You... are right. I need to survive and get out of here. I can't let my friends death be in vain. Thank you. *Hands you a bundle of stuff before taking off*"));
        DelayCommand(0.5,DestroyObject(oDungeonObject));
       }
       else
       {
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank2) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !FAILURE!");
       }
     }
    }
    else if(sType == "appraisepuzzle")
    {
      nSkillRank1 = GetSkillRank(SKILL_APPRAISE,oPC);
      nDiceRollTotal = nDiceRoll + nSkillRank1;
      sSkill = "APPRAISE";
      nDC = nDC - 10;

     if(nNode==1)
     {
      if(nDiceRollTotal >= nDC)
      {
       SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank1) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !SUCCESS!");
        RewardPC(oPC, nLevel, sType, sWaypoint);
        AssignCommand(oDungeonObject,ActionSpeakString("*The pile of junk before you is in fact something a lot more valuable afterall*"));
        DelayCommand(0.5,DestroyObject(oDungeonObject));
      }
      else
      {
       SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank1) + " + " + IntToString(nDiceRoll) + " = " + IntToString((nDiceRollTotal)) + " Vs " + IntToString(nDC) + " !FAILURE!");
      }
     }

    }
    else if(sType == "summonshrine") // Summoning shrine that attaches a summon to you
    {
     object oWaypoint = GetWaypointByTag(sWaypoint);
     location lWaypoint = GetLocation(oWaypoint);
     int nSpell;

     if(nLevel>17) nSpell=SPELL_SUMMON_CREATURE_IX;
     else if(nLevel>15) nSpell=SPELL_SUMMON_CREATURE_VIII;
     else if(nLevel>13) nSpell=SPELL_SUMMON_CREATURE_VII;
     else if(nLevel>11) nSpell=SPELL_SUMMON_CREATURE_VI;
     else if(nLevel>9) nSpell=SPELL_SUMMON_CREATURE_V;
     else if(nLevel>7) nSpell=SPELL_SUMMON_CREATURE_IV;
     else if(nLevel>5) nSpell=SPELL_SUMMON_CREATURE_III;
     else if(nLevel>3) nSpell=SPELL_SUMMON_CREATURE_II;
     else if(nLevel>=1) nSpell=SPELL_SUMMON_CREATURE_I;

     SetPCKEYValue( oPC, "SummonType", 1); // Forcing elemental summmons only.
     sum_SummonCreature(oPC,nSpell,nLevel,lWaypoint);
     AssignCommand(oDungeonObject,ActionSpeakString("*The magical device shimmers, pulses, and then cracks as energy builds nearby and something is summoned to your aid*"));
     DelayCommand(0.5,DestroyObject(oDungeonObject));
     DelayCommand(0.5,SetPCKEYValue( oPC, "SummonType", 0));
    }
    else if(sType == "buffshrine") // Temporary buff shrine
    {
     int nAttributeScaling;
     if(nLevel>28) nAttributeScaling=12;
     else if(nLevel>25) nAttributeScaling=10;
     else if(nLevel>22) nAttributeScaling=9;
     else if(nLevel>19) nAttributeScaling=8;
     else if(nLevel>16) nAttributeScaling=7;
     else if(nLevel>13) nAttributeScaling=6;
     else if(nLevel>10) nAttributeScaling=5;
     else if(nLevel>7) nAttributeScaling=4;
     else if(nLevel>4) nAttributeScaling=3;
     else if(nLevel>=1) nAttributeScaling=2;
     effect eBuffStr = EffectAbilityIncrease(ABILITY_STRENGTH,nAttributeScaling);
     effect eBuffDex = EffectAbilityIncrease(ABILITY_DEXTERITY,nAttributeScaling);
     effect eBuffCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,nAttributeScaling);
     effect eBuffInt = EffectAbilityIncrease(ABILITY_INTELLIGENCE,nAttributeScaling);
     effect eBuffWis = EffectAbilityIncrease(ABILITY_WISDOM,nAttributeScaling);
     effect eBuffCha = EffectAbilityIncrease(ABILITY_CHARISMA,nAttributeScaling);
     effect eBuffTempHP = EffectTemporaryHitpoints(nLevel*7);
     effect eLink = EffectLinkEffects(eBuffStr,eBuffTempHP);
     effect eVisual = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
     eLink = EffectLinkEffects(eBuffDex,eLink);
     eLink = EffectLinkEffects(eBuffCon,eLink);
     eLink = EffectLinkEffects(eBuffInt,eLink);
     eLink = EffectLinkEffects(eBuffWis,eLink);
     eLink = EffectLinkEffects(eBuffCha,eLink);
     eLink = EffectLinkEffects(eVisual,eLink);

     ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oPC,IntToFloat(nLevel*10+30));
     AssignCommand(oDungeonObject,ActionSpeakString("*The magical device shimmers, pulses, and then cracks as energy builds nearby and a magical energy empowers you*"));
     DelayCommand(0.5,DestroyObject(oDungeonObject));
    }

    ClearChecks(oPC);

}

void RewardPC(object oPC, int nLevel, string sType, string sWaypoint)
{
    object oDungeonObject = GetLocalObject(oPC,"dungobject");
    int nRandom = Random(2)+1;
    int nRandomGold = Random(nLevel)*50 + Random(nLevel)*5 + Random(5);
    int nGold = nLevel*450+nRandomGold;
    int nPCLevel = GetLevelByPosition(1,oPC)+GetLevelByPosition(2,oPC)+GetLevelByPosition(3,oPC);

    if(sType == "hiddendoornpc") // This is a special case where the NPC gives a map that immediately leads to a door way
    {
     object oWaypoint = GetWaypointByTag(sWaypoint);
     object oTemp;
     string sDestinationWP = GetLocalString(oDungeonObject,"destination");
     string sDoorType;
     int nRandomDoor = Random(2) + 1;
     switch(nRandomDoor)
     {
      case 1: sDoorType = "hiddendoor"; break;
      case 2: sDoorType = "hiddendoor2"; break;
     }
     location lWaypoint = GetLocation(oWaypoint);
     oTemp = CreateObject(OBJECT_TYPE_PLACEABLE,sDoorType,lWaypoint);
     SetFacing(GetFacing(oWaypoint));  // Sets the facing the same as the waypoint
     SetLocalString(oTemp,"destination",sDestinationWP);
     SetTag(oTemp,"dungtool");
     SetLocalString(oTemp,"waypoint",sWaypoint);
     SetLocalInt(oTemp,"active",1);


     GenerateXPForParty(oPC,nLevel);


    }
    else
    {
      if(nRandom==1)
      {
        GiveGoldToCreature(oPC,nGold);
      }
      else if(nRandom==2)
      {
         GenerateStandardLoot(oPC,nLevel);
      }


      GenerateXPForParty(oPC,nLevel);

    }

}

void GenerateXPForParty(object oPC, int nLevel)
{
   SetXP(oPC,(GetXP(oPC)+nLevel*75));

   object oPartyMember = GetFirstFactionMember(oPC,TRUE);
   object oArea = GetArea( oPC );
   int nPCLevel;

   while(GetIsObjectValid(oPartyMember)==TRUE)
   {
    if((GetArea(oPartyMember) == oArea) && (oPartyMember != oPC))
    {
     nPCLevel = GetLevelByPosition(1,oPartyMember)+GetLevelByPosition(2,oPartyMember)+GetLevelByPosition(3,oPartyMember);
     if(nPCLevel < 30)
     {
      SetXP(oPartyMember,(GetXP(oPartyMember)+nLevel*25));
     }
    }
    oPartyMember = GetNextFactionMember( oPC, TRUE );
   }
}

int GetPCPartyNumberNearby(object oPC)
{

   object oPartyMember = GetFirstFactionMember(oPC,TRUE);
   object oArea = GetArea( oPC );
   int nCount = 0;

   while(GetIsObjectValid(oPartyMember)==TRUE)
   {
    if(GetArea(oPartyMember) == oArea)
    {
      if(GetDistanceBetween(oPC,oPartyMember) < 15.0)
      {
        if(oPC != oPartyMember)
        {
         if(GetIsPC(oPartyMember))
         {
          nCount++;
         }
        }
      }
    }
    oPartyMember = GetNextFactionMember( oPC, TRUE );
   }

   return nCount;

}

void ClearChecks(object oPC)
{
  DeleteLocalInt( oPC, "ds_check_1");
  DeleteLocalInt( oPC, "ds_check_2");
  DeleteLocalInt( oPC, "ds_check_3");
  DeleteLocalInt( oPC, "ds_check_4");
  DeleteLocalInt( oPC, "ds_check_5");
  DeleteLocalInt( oPC, "ds_check_6");
  DeleteLocalInt( oPC, "ds_check_7");
  DeleteLocalInt( oPC, "ds_check_8");
  DeleteLocalInt( oPC, "ds_check_9");
  DeleteLocalInt( oPC,"IsInteractPLC");
  DeleteLocalString(oPC,"dungtype");
  DeleteLocalString(oPC,"dungwaypoint");
  DeleteLocalInt(oPC,"dunglevel");
}
