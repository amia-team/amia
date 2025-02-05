/*

   Maverick's Generic Quest Script


   Changelog:
   2/21/2024 - Lord Jyssev - Added ability to set a required quest with string "questrequired" and will speak the message, "speechquestrequired"

*/

#include "nw_i0_plot"


void FaceNearestPC();

// Launches speech strings with the set delay
void LaunchSpeech(object oNPC);

// Launches the script to add the quest entry to their pckey and any party members nearby
void LaunchQuest(object oPC,object oNPC,string sQuest);


// Marks the quest type 0 as done, does a speech ending the quest, and gives xp/rewards
// default item retrieval quest; eg kill troll, take troll head, return to Bendir guard
void LaunchQuestZeroFinish(object oPC, object oQuestItem, object oNPC, string sQuest);

// Marks the quest type 1 as done, does a speech ending the quest, and gives xp/rewards
// visit multiple areas or talk to multiple NPCs in a specific quest chain order
void LaunchQuestOneFinish(object oPC, object oQuestItem, object oNPC, string sQuest);

// Marks the quest type 2 as done, does a speech ending the quest, and gives xp/rewards
// visit multiple areas or talk to multiple NPCs in any order
void LaunchQuestTwoFinish(object oPC, object oQuestItem, object oNPC, string sQuest);

// Marks the quest type 3 as done, does a speech ending the quest, and gives xp/rewards
// delivery quest with single or multiple deliveries
void LaunchQuestThreeFinish(object oPC, object oQuestItem, object oNPC, string sQuest);

// Checks to make sure that the conditions for quest type 2 are complete
int CheckQuestTwoFinished(object oPC,object oNPC);

// Checks to make sure that the conditions for quest type 2 are complete
int CheckQuestThreeFinished(object oPC,object oNPC);

// Sets the Quest XP with level 30 in consideration
void SetQuestXP(object oPC, int nXPReward);


void main()
{
  object oPC = GetLastSpeaker();
  object oNPC = OBJECT_SELF;
  object oPCKey = GetItemPossessedBy(oPC, "ds_pckey");
  string sQuest = GetLocalString(oNPC, "questname");
  string speechwithquest = GetLocalString(oNPC, "speechwithquest");
  string speechquestdone = GetLocalString(oNPC, "speechquestdone");
  string questitem = GetLocalString(oNPC, "questitem");
  string sClassRestriction = GetLocalString(oNPC, "classrestrictedon");
  string sSkillRestriction = GetLocalString(oNPC, "skillrestrictedon");
  string sRejectionMessage = GetLocalString(oNPC, "rejectionmessage");
  int nBlocker = GetLocalInt(oNPC, "nblocker");
  int nQuest = GetLocalInt(oPCKey,sQuest);
  int nQuestType = GetLocalInt(oNPC, "questtype");
  int nQuestChain = GetLocalInt(oNPC, "questchain");
  int nQuestProgress = GetLocalInt(oPCKey,sQuest+"qp");
  int nClassRestriction = GetLocalInt(oNPC, "classrestricted");
  int nClassRestrictionLvl = GetLocalInt(oNPC, "classrestrictedlevel");
  int nSkill = GetLocalInt(oNPC, "skillrestricted");
  int nSkillPoints = GetLocalInt(oNPC, "skillrestrictedpoints");
  int nSkillPointsBase = GetLocalInt(oNPC, "skillrestrictedpointsbase");
  object oQuestItem = GetItemPossessedBy(oPC, questitem);
  string sRequiredQuest = GetLocalString(oNPC, "questrequired");
  string sSpeechRequiredQuest = GetLocalString(oNPC, "speechquestrequired");

  FaceNearestPC();


  // Speaking blocker, stops people spamming while the quest giver is talking
  if (nBlocker != 1) return;

  // Class checker, if PC doesn't have the required class level, plays the rejection message
  if (sClassRestriction == "on" && (GetLevelByClass(nClassRestriction, oPC) < nClassRestrictionLvl))
  {
    AssignCommand(oNPC, ActionSpeakString(sRejectionMessage));
    return;
  }

  // Skill checker, if PC doesn't have the required skill rank, plays the rejection message
  if (sSkillRestriction == "on" && (GetSkillRank(nSkill,oPC,nSkillPointsBase) < nSkillPoints))
  {
    AssignCommand(oNPC, ActionSpeakString(sRejectionMessage));
    return;
  }

  // Check if this quest requires the completion of another for it
  if (sRequiredQuest != "")
  {
    object oPCKey = GetItemPossessedBy(oPC, "ds_pckey");
    int nRequiredQuest = GetLocalInt(oPCKey,sRequiredQuest);
    if (nRequiredQuest != 2)
    {
      AssignCommand(oNPC, ActionSpeakString(sSpeechRequiredQuest));
      SendMessageToPC(oPC, "You must complete the <c ï¿½ >" + sRequiredQuest + "</c> quest before you may begin this one.");
      return;
    }
  }

  // If the PC doesn't have the quest, launch the opening speech and quest
  if (nQuest == 0)
  {
    LaunchSpeech(oNPC);
    LaunchQuest(oPC,oNPC,sQuest);
    SetLocalInt(oNPC, "nblocker", 1);
    return;
  }

  // If the PC has completed the quest, plays the quest done speech
  if (nQuest == 2)
  {
    AssignCommand(oNPC, ActionSpeakString(speechquestdone));
    return;
  }

  // If the PC has already taken the quest and hasn't completed it yet
  if (nQuest == 1)
  {
    // RETRIEVAL QUEST if the quest type is unspecified or specified as zero
    if (nQuestType == FALSE)
    {
      if (GetIsObjectValid(oQuestItem))
      {
        LaunchQuestZeroFinish(oPC, oQuestItem, oNPC, sQuest);
      }
      else
      {
        AssignCommand(oNPC, ActionSpeakString(speechwithquest));
      }
    }
    if (nQuestType == 1) // Quest 1 is the multi visit people or places quest but in an order
    {
      if (nQuestChain == nQuestProgress)
      {
        LaunchQuestOneFinish(oPC,oQuestItem,oNPC,sQuest);
      }
      else
      {
        AssignCommand(oNPC, ActionSpeakString(speechwithquest));
      }
    }
    else if (nQuestType == 2) // Quest 2 is the multi visit people or places quest but in any order
    {
      if (CheckQuestTwoFinished(oPC,oNPC))
      {
        LaunchQuestTwoFinish(oPC,oQuestItem,oNPC,sQuest);
      }
      else
      {
        AssignCommand(oNPC, ActionSpeakString(speechwithquest));
      }
    }
    else if (nQuestType == 3) // Quest 3 is the delivery questline
    {
      if (CheckQuestThreeFinished(oPC,oNPC))
      {
        LaunchQuestThreeFinish(oPC,oQuestItem,oNPC,sQuest);
      }
      else
      {
        AssignCommand(oNPC, ActionSpeakString(speechwithquest));
      }
    }

  }

}


void LaunchSpeech(object oNPC)
{
  string speech;
  float fDelay = GetLocalFloat(oNPC, "delay");
  float fBlockDelay = 1.0;

  int i;
  for (i = 1;;i++)
  {
    speech = GetLocalString(oNPC, "speech"+IntToString(i));

    if (speech == "") break;

    if (i == 1)
      AssignCommand(oNPC, ActionSpeakString(speech));

    if (i > 1)
    {
      DelayCommand((i - 1) * fDelay, AssignCommand(oNPC, ActionSpeakString(speech)));
      fBlockDelay = (i - 1) * fDelay;
    }

  }

   DelayCommand(fBlockDelay, SetLocalInt(oNPC, "nblocker", 0));

}


void LaunchQuest(object oPC,object oNPC, string sQuest)
{
  int nQuest;
  int nSkill = GetLocalInt(oNPC, "skillrestricted");
  int nSkillPoints = GetLocalInt(oNPC, "skillrestrictedpoints");
  int nSkillPointsBase = GetLocalInt(oNPC, "skillrestrictedpointsbase");
  int nClassRestriction = GetLocalInt(oNPC, "classrestricted");
  int nDeliveryAmount = GetLocalInt(oNPC, "deliveryamount");
  object oPCKey = GetItemPossessedBy(oPC, "ds_pckey");
  string sSkillRestriction = GetLocalString(oNPC, "skillrestrictedon");
  string sClassRestriction = GetLocalString(oNPC, "classrestrictedon");
  string sQuest = GetLocalString(oNPC, "questname");
  string speech;

  SendMessageToPC(oPC, "You received <c ï¿½ >" + sQuest + "</c>");
  SetLocalInt(oPCKey,sQuest,1);

  // Gives them a note with the quest info
  object oNote = CreateItemOnObject("questnote",oPC);

  int i;
  for (i = 1;;i++)
  {
    speech = GetLocalString(oNPC, "speech"+IntToString(i));
    if (speech == "") break;

    if (i == 1)
      SetDescription(oNote, speech);

    if (i > 1)
      SetDescription(oNote, GetDescription(oNote)+" "+speech);
  }

  SetName(oNote,sQuest);

  // Gives items to the PC for the Quest type 3 if present
  if (nDeliveryAmount != 0)
  {
    int i;
    for(i=1;i<=nDeliveryAmount;i++)
    {
      CreateItemOnObject(GetLocalString(oNPC, "deliveryitem"+IntToString(i)),oPC);
    }
  }

  // Get the first PC party member
  object oPartyMember = GetFirstFactionMember(oPC, TRUE);
  // We stop when there are no more valid PC's in the party.
  while (GetIsObjectValid(oPartyMember) == TRUE)
  {
    // Get only nearby party members
    if ((GetDistanceBetween(oPC,oPartyMember) <= 20.0) && (GetArea(oPC) == GetArea(oPartyMember)))
    {
      oPCKey = GetItemPossessedBy(oPartyMember, "ds_pckey");

      if (GetLocalInt(oPCKey,sQuest) == 0)
      {
        // Check to see if there is class restrictions
        if (((GetClassByPosition(1,oPartyMember) == nClassRestriction) || (GetClassByPosition(2,oPartyMember) == nClassRestriction) || (GetClassByPosition(3,oPartyMember) == nClassRestriction)) || (sClassRestriction == ""))
        {
          // Check to see if there is skill restrictions
          if ((GetSkillRank(nSkill,oPartyMember,nSkillPointsBase) >= nSkillPoints) || (sSkillRestriction == ""))
          {
            SendMessageToPC(oPartyMember, "You received <c ï¿½ >" + sQuest + "</c>");
            SetLocalInt(oPCKey,sQuest,1);

            // Quest note
            oNote = CreateItemOnObject("questnote",oPartyMember);

            int i;
            for (i = 1;;i++)
            {
              speech = GetLocalString(oNPC, "speech"+IntToString(i));
              if (speech == "") break;

              if (i == 1)
                SetDescription(oNote, speech);

              if (i > 1)
                SetDescription(oNote, GetDescription(oNote)+" "+speech);
            }

            SetName(oNote,sQuest);

            // Gives items to the PC for the Quest type 3 if present
            if (nDeliveryAmount > 0)
            {
              int e;
              for(e=1;e<=nDeliveryAmount;e++)
              {
              CreateItemOnObject(GetLocalString(oNPC, "deliveryitem"+IntToString(e)),oPartyMember);
              }
            }
          }
        }
      }
    }

    oPartyMember = GetNextFactionMember(oPC, TRUE);
  }
}


void LaunchQuestZeroFinish(object oPC, object oQuestItem, object oNPC, string sQuest)
{
  string speechdone = GetLocalString(oNPC,"speechdone");
  string itemreward = GetLocalString(oNPC,"itemreward");
  int nXPReward = GetLocalInt(oNPC,"xpreward");
  int nTakeQuestItem = GetLocalInt(oNPC,"takeitem");
  int nGold = GetLocalInt(oNPC,"goldreward");

  if (itemreward != "")
  {
    CreateItemOnObject(itemreward,oPC);
  }

  SetQuestXP(oPC,nXPReward);
  GiveGoldToCreature(oPC,nGold);

  object oPCKey = GetItemPossessedBy(oPC, "ds_pckey");
  SendMessageToPC(oPC, "You received "+IntToString(nXPReward)+" experience points completing <c ï¿½ >" + sQuest + "</c>");

  SetLocalInt(oPCKey, sQuest, 2);

  // If the quest item is marked to be destroyed, destroy it
  if (nTakeQuestItem == 1)
  {
    if (GetIsObjectValid(oQuestItem))
    {
      DestroyObject(oQuestItem);
    }
  }

  // Get the first PC party member
  object oPartyMember = GetFirstFactionMember(oPC, TRUE);
  // We stop when there are no more valid PC's in the party.
  while (GetIsObjectValid(oPartyMember) == TRUE)
  {
      // Get only nearby party members
      if ((GetDistanceBetween(oPC,oPartyMember) <= 20.0) && (GetArea(oPC) == GetArea(oPartyMember)))
      {
        oPCKey = GetItemPossessedBy(oPartyMember, "ds_pckey");
        if (GetLocalInt(oPCKey,sQuest) == 1)
        {
          if (itemreward != "")
          {
            CreateItemOnObject(itemreward,oPartyMember);
          }

          SetQuestXP(oPartyMember,nXPReward);
          GiveGoldToCreature(oPartyMember,nGold);
          SendMessageToPC(oPartyMember, "You received "+IntToString(nXPReward)+" experience points completing <c ï¿½ >" + sQuest + "</c>");
          SetLocalInt(oPCKey,sQuest,2);
        }

      }

      oPartyMember = GetNextFactionMember(oPC, TRUE);
  }

  AssignCommand(oNPC, ActionSpeakString(speechdone));
}


void LaunchQuestOneFinish(object oPC, object oQuestItem, object oNPC, string sQuest)
{


    string speechdone = GetLocalString(oNPC, "speechdone");
    string itemreward = GetLocalString(oNPC, "itemreward");
    int nXPReward = GetLocalInt(oNPC, "xpreward");
    int nTakeQuestItem = GetLocalInt(oNPC, "takeitem");
    int nQuestChain = GetLocalInt(oNPC, "questchain");
    int nGold = GetLocalInt(oNPC, "goldreward");
    int nQuestProgress;

    if (itemreward != "")
    {
    CreateItemOnObject(itemreward,oPC);
    }
    SetQuestXP(oPC,nXPReward);
    GiveGoldToCreature(oPC,nGold);

    object oPCKey = GetItemPossessedBy(oPC, "ds_pckey");
    SendMessageToPC(oPC, "You received "+IntToString(nXPReward)+" experience points completing <c ï¿½ >" + sQuest + "</c>");

    SetLocalInt(oPCKey,sQuest,2);


    // Get the first PC party member
    object oPartyMember = GetFirstFactionMember(oPC, TRUE);
    // We stop when there are no more valid PC's in the party.
    while (GetIsObjectValid(oPartyMember) == TRUE)
    {
        // Get only nearby party members
        if ((GetDistanceBetween(oPC,oPartyMember) <= 20.0) && (GetArea(oPC) == GetArea(oPartyMember)))
        {
           oPCKey = GetItemPossessedBy(oPartyMember, "ds_pckey");
           if (GetLocalInt(oPCKey,sQuest) == 1)
           {

            // Check to make sure the PC party member also has the finished requirements
            nQuestProgress = GetLocalInt(oPCKey,sQuest+"qp");
            if (nQuestChain == nQuestProgress)
            {
             if (itemreward != "")
             {
             CreateItemOnObject(itemreward,oPartyMember);
             }
             SetQuestXP(oPartyMember,nXPReward);
             GiveGoldToCreature(oPartyMember,nGold);
             SendMessageToPC(oPartyMember, "You received "+IntToString(nXPReward)+" experience points completing <c ï¿½ >" + sQuest + "</c>");
             SetLocalInt(oPCKey,sQuest,2);
            }


           }

        }

        oPartyMember = GetNextFactionMember(oPC, TRUE);
    }



    AssignCommand(oNPC, ActionSpeakString(speechdone));

}


void LaunchQuestTwoFinish(object oPC, object oQuestItem, object oNPC, string sQuest)
{

    string speechdone = GetLocalString(oNPC, "speechdone");
    string itemreward = GetLocalString(oNPC, "itemreward");
    int nXPReward = GetLocalInt(oNPC, "xpreward");
    int nTakeQuestItem = GetLocalInt(oNPC, "takeitem");
    int nQuestChain = GetLocalInt(oNPC, "questchain");
    int nGold = GetLocalInt(oNPC, "goldreward");
    int nQuestProgress;

    if (itemreward != "")
    {
    CreateItemOnObject(itemreward,oPC);
    }
    SetQuestXP(oPC,nXPReward);
    GiveGoldToCreature(oPC,nGold);

    object oPCKey = GetItemPossessedBy(oPC, "ds_pckey");
    SendMessageToPC(oPC, "You received "+IntToString(nXPReward)+" experience points completing <c ï¿½ >" + sQuest + "</c>");

    SetLocalInt(oPCKey,sQuest,2);


    // Get the first PC party member
    object oPartyMember = GetFirstFactionMember(oPC, TRUE);
    // We stop when there are no more valid PC's in the party.
    while (GetIsObjectValid(oPartyMember) == TRUE)
    {
        // Get only nearby party members
        if ((GetDistanceBetween(oPC,oPartyMember) <= 20.0) && (GetArea(oPC) == GetArea(oPartyMember)))
        {
          oPCKey = GetItemPossessedBy(oPartyMember, "ds_pckey");
          if (GetLocalInt(oPCKey,sQuest) == 1)
          {

            // Check to make sure the PC party member also has the finished requirements
            nQuestProgress = GetLocalInt(oPCKey,sQuest+"qp");
            if (CheckQuestTwoFinished(oPartyMember,oNPC))
            {
              if (itemreward != "")
              {
              CreateItemOnObject(itemreward,oPartyMember);
              }
              SetQuestXP(oPartyMember,nXPReward);
              GiveGoldToCreature(oPartyMember,nGold);
              SendMessageToPC(oPartyMember, "You received "+IntToString(nXPReward)+" experience points completing <c ï¿½ >" + sQuest + "</c>");
              SetLocalInt(oPCKey,sQuest,2);
            }
          }
        }

      oPartyMember = GetNextFactionMember(oPC, TRUE);
    }



    AssignCommand(oNPC, ActionSpeakString(speechdone));

}



void LaunchQuestThreeFinish(object oPC, object oQuestItem, object oNPC, string sQuest)
{

    string speechdone = GetLocalString(oNPC, "speechdone");
    string itemreward = GetLocalString(oNPC, "itemreward");
    int nXPReward = GetLocalInt(oNPC, "xpreward");
    int nTakeQuestItem = GetLocalInt(oNPC, "takeitem");
    int nQuestChain = GetLocalInt(oNPC, "questchain");
    int nGold = GetLocalInt(oNPC, "goldreward");
    int nQuestProgress;

    if (itemreward != "")
    {
    CreateItemOnObject(itemreward,oPC);
    }
    SetQuestXP(oPC,nXPReward);
    GiveGoldToCreature(oPC,nGold);

    object oPCKey = GetItemPossessedBy(oPC, "ds_pckey");
    SendMessageToPC(oPC, "You received "+IntToString(nXPReward)+" experience points completing <c ï¿½ >" + sQuest + "</c>");

    SetLocalInt(oPCKey,sQuest,2);


    // Get the first PC party member
    object oPartyMember = GetFirstFactionMember(oPC, TRUE);
    // We stop when there are no more valid PC's in the party.
    while (GetIsObjectValid(oPartyMember) == TRUE)
    {
        // Get only nearby party members
        if ((GetDistanceBetween(oPC,oPartyMember) <= 20.0) && (GetArea(oPC) == GetArea(oPartyMember)))
        {
          oPCKey = GetItemPossessedBy(oPartyMember, "ds_pckey");

          if (GetLocalInt(oPCKey,sQuest) == 1)
          {

            // Check to make sure the PC party member also has the finished requirements
            nQuestProgress = GetLocalInt(oPCKey,sQuest+"qp");
            if (CheckQuestTwoFinished(oPartyMember,oNPC))
            {
              if (itemreward != "")
              {
              CreateItemOnObject(itemreward,oPartyMember);
              }
              SetQuestXP(oPartyMember,nXPReward);
              GiveGoldToCreature(oPartyMember,nGold);
              SendMessageToPC(oPartyMember, "You received "+IntToString(nXPReward)+" experience points completing <c ï¿½ >" + sQuest + "</c>");
              SetLocalInt(oPCKey,sQuest,2);
            }
          }

        }

        oPartyMember = GetNextFactionMember(oPC, TRUE);
    }



    AssignCommand(oNPC, ActionSpeakString(speechdone));

}

int CheckQuestTwoFinished(object oPC,object oNPC)
{
  object oPCKey = GetItemPossessedBy(oPC, "ds_pckey");
  string sQuest = GetLocalString(oNPC, "questname");
  int nQuestChain = GetLocalInt(oNPC, "questchain");
  int nQuestCounter;

  int i;
  for(i=1;i<=nQuestChain;i++)
  {
    if (GetLocalInt(oPCKey,sQuest+"p"+IntToString(i)) == 1)
    {
     nQuestCounter++;
    }
  }

  if (nQuestCounter==nQuestChain)
  {
    return 1;
  }
  else
  {
    return 0;
  }
}


int CheckQuestThreeFinished(object oPC,object oNPC)
{
  object oPCKey = GetItemPossessedBy(oPC, "ds_pckey");
  string sQuest = GetLocalString(oNPC, "questname");
  int nQuestDelivery = GetLocalInt(oNPC, "deliveryamount");
  int nQuestCounter;

  int i;
  for(i=1;i<=nQuestDelivery;i++)
  {
    if (GetLocalInt(oPCKey,sQuest+"p"+IntToString(i)) == 1)
    {
     nQuestCounter++;
    }
  }

  if (nQuestCounter==nQuestDelivery)
  {
    return 1;
  }
  else
  {
    return 0;
  }
}


void FaceNearestPC()
{
    vector vFace = GetPosition(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN));
    SetFacingPoint(vFace);
}

void SetQuestXP(object oPC, int nXPReward)
{

    // Level 30 XP Blocker
    if (GetHitDice(oPC) == 30)
    {
     SetXP(oPC,GetXP(oPC)+1);
    }
    else
    {
     SetXP(oPC,GetXP(oPC)+nXPReward);
    }

}