/*

   Maverick's Generic Quest NPC Script

*/

#include "nw_i0_plot"

void FaceNearestPC();

void GroupCheck(object oPC, object oNPC, int nQuestType);

void main()
{

   object oNPC = OBJECT_SELF;
   object oPC = GetLastSpeaker();
   object oPCKey = GetItemPossessedBy(oPC,"ds_pckey");
   string sQuest = GetLocalString(oNPC,"questname");
   string sMessage = GetLocalString(oNPC,"message");
   string sDeliveryItem = GetLocalString(oNPC,"deliveryitem");
   int nQuest = GetLocalInt(oPCKey,sQuest);
   int nQuestType = GetLocalInt(oNPC,"questtype");
   int nQuestChainNum = GetLocalInt(oNPC,"questchainnum");
   int nQuestDeliveryNum = GetLocalInt(oNPC,"questdeliverynum");
   int nQuestProgress = GetLocalInt(oPCKey,sQuest+"qp");
   int nQuest2Progress = GetLocalInt(oPCKey,sQuest+"p"+IntToString(nQuestChainNum));
   int nQuest3Progress = GetLocalInt(oPCKey,sQuest+"p"+IntToString(nQuestDeliveryNum));

   FaceNearestPC();

   // We only want this to run if the person has the quest
   if(nQuest == 1)
   {

    if(nQuestType == 1)
    {
     // Make sure it launches only if the order is right.
     if((nQuestChainNum-1) == nQuestProgress)
     {
      AssignCommand(oNPC, ActionSpeakString(sMessage));
      SetLocalInt(oPCKey,sQuest+"qp",nQuestChainNum);
      SendMessageToPC(oPC,"*You completed a portion of: " +sQuest+"*");
      GroupCheck(oPC,oNPC,nQuestType);
     }
    }
    else if(nQuestType == 2)
    {
     // Make sure it launches only if it hasnt been visited yet
     if(nQuest2Progress == 0)
     {
      AssignCommand(oNPC, ActionSpeakString(sMessage));
      SetLocalInt(oPCKey,sQuest+"p"+IntToString(nQuestChainNum),1);
      SendMessageToPC(oPC,"*You completed a portion of: " +sQuest+"*");
      GroupCheck(oPC,oNPC,nQuestType);
     }
    }
    else if(nQuestType == 3)
    {
     // Make sure it launches only if it hasnt been visited yet
     if(nQuest3Progress == 0)
     {

      object oDeliveryItem = GetItemPossessedBy(oPC,sDeliveryItem);
      if(GetIsObjectValid(oDeliveryItem))
      {
       DestroyObject(oDeliveryItem);
       AssignCommand(oNPC, ActionSpeakString(sMessage));
       SetLocalInt(oPCKey,sQuest+"p"+IntToString(nQuestDeliveryNum),1);
       SendMessageToPC(oPC,"*You completed a portion of: " +sQuest+"*");
      }
     }
    }



   }


}


void FaceNearestPC()
{
    vector vFace = GetPosition(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN));
    SetFacingPoint(vFace);
}


void GroupCheck(object oPC, object oNPC, int nQuestType)
{
    object oPCKey;
    string sQuest = GetLocalString(oNPC,"questname");
    int nQuestChainNum = GetLocalInt(oNPC,"questchainnum");
    int nQuestProgress;
    int nQuest2Progress;
    // Get the first PC party member
    object oPartyMember = GetFirstFactionMember(oPC, TRUE);
    // We stop when there are no more valid PC's in the party.
    while(GetIsObjectValid(oPartyMember) == TRUE)
    {
        // Get only nearby party members
        if((GetDistanceBetween(oPC,oPartyMember) <= 10.0) && (GetArea(oPC) == GetArea(oPartyMember)))
        {
           oPCKey = GetItemPossessedBy(oPartyMember,"ds_pckey");
           nQuestProgress = GetLocalInt(oPCKey,sQuest+"qp");
           nQuest2Progress = GetLocalInt(oPCKey,sQuest+"p"+IntToString(nQuestChainNum));

           if( GetLocalInt(oPCKey,sQuest) == 1 )
           {


            if(nQuestType == 1)
            {
             // Make sure it launches only if the order is right.
             if((nQuestChainNum-1) == nQuestProgress)
             {
               SetLocalInt(oPCKey,sQuest+"qp",nQuestChainNum);
               SendMessageToPC(oPartyMember,"*You completed a portion of: " +sQuest+"*");
             }
            }
            else if(nQuestType == 2)
            {
              // Make sure it launches only if it hasnt been visited yet
              if(nQuest2Progress == 0)
              {
                SetLocalInt(oPCKey,sQuest+"p"+IntToString(nQuestChainNum),1);
                SendMessageToPC(oPartyMember,"*You completed a portion of: " +sQuest+"*");
              }
            }



           }

        }

        oPartyMember = GetNextFactionMember(oPC, TRUE);
    }





}
