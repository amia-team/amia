/*
    Exit Script for Lich  boss encounter
    - Maverick00053 11/17/20

*/
void GenericQuestFinish( object oPC);

void main()
{
   object oPC = GetLastUsedBy();

   object oHome = GetWaypointByTag("lbossoutside");

   AssignCommand( oPC, ClearAllActions() );
   DelayCommand( 0.1, GenericQuestFinish( oPC ) );
   DelayCommand( 0.2f, AssignCommand( oPC, JumpToObject( oHome ) ) );


}

void GenericQuestFinish( object oPC){

   object oTrigger = OBJECT_SELF;
   object oPCKey = GetItemPossessedBy(oPC,"ds_pckey");
   string sQuest = GetLocalString(oTrigger,"questname");
   string sMessage = GetLocalString(oTrigger,"message");
   int nQuest = GetLocalInt(oPCKey,sQuest);
   int nQuestType = GetLocalInt(oTrigger,"questtype");
   int nQuestChainNum = GetLocalInt(oTrigger,"questchainnum");
   int nQuestProgress = GetLocalInt(oPCKey,sQuest+"qp");
   int nQuest2Progress = GetLocalInt(oPCKey,sQuest+"p"+IntToString(nQuestChainNum));

   // We only want this to run if the person has the quest
   if(nQuest == 1)
   {

    if(nQuestType == 1)
    {
     // Make sure it launches only if the order is right.
     if((nQuestChainNum-1) == nQuestProgress)
     {
      FloatingTextStringOnCreature(sMessage,oPC,FALSE);
      SetLocalInt(oPCKey,sQuest+"qp",nQuestChainNum);
     }
    }
    else if(nQuestType == 2)
    {
     // Make sure it launches only if it hasnt been visited yet
     if(nQuest2Progress == 0)
     {
      FloatingTextStringOnCreature(sMessage,oPC,FALSE);
      SetLocalInt(oPCKey,sQuest+"p"+IntToString(nQuestChainNum),1);
     }
    }



   }


}
