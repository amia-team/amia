/*
   On used script for hidden door objects in the dynamic dungeon tool system

 - Maverick00053 11/11/2023
*/

void SkillCheck( object oObject, object oPC, string sWaypoint, int nSkill, string sSkill, int nAdjustment);

void main()
{
  object oPC = GetLastUsedBy();
  object oObject = OBJECT_SELF;
  string sType = GetLocalString(oObject,"type");
  string sWaypoint = GetLocalString(oObject,"waypoint");

  if(GetLocalInt(oObject,"blocker")==1)
  {
   SendMessageToPC(oPC,"You must wait a full 60 seconds before trying again.");
   return;
  }


  if(sType == "dungdoorspellcra")
  {
    SkillCheck(oObject, oPC, sWaypoint, SKILL_SPELLCRAFT, "SPELLCRAFT",0);
  }
  else if(sType == "dungdoorsearch")
  {
    SkillCheck( oObject, oPC, sWaypoint, SKILL_SEARCH, "SEARCH",0);
  }
  else if(sType == "dungdoorlore")
  {
    SkillCheck( oObject, oPC, sWaypoint, SKILL_LORE, "LORE",-5);
  }
}

void SkillCheck( object oObject, object oPC, string sWaypoint, int nSkill, string sSkill, int nAdjustment)
{
   int combat = GetIsInCombat(oPC);
   int nSkillRank = GetSkillRank(nSkill,oPC);
   int nLevel = GetLocalInt(oObject,"level");
   int nDC = nLevel + 10 + (nLevel-(nLevel/3)+nAdjustment);
   int nDiceRoll = Random(20)+1;
   int nPCLevel;
   object oWaypoint = GetWaypointByTag(sWaypoint);
   object oTemp;
   string sDoorType;
   string sDestinationWP = GetLocalString(oObject,"destination");
   location lWaypoint = GetLocation(oWaypoint);

   int nRandomDoor = Random(2) + 1;
   switch(nRandomDoor)
   {
     case 1: sDoorType = "hiddendoor"; break;
     case 2: sDoorType = "hiddendoor2"; break;
   }

   SetLocalInt(oObject,"blocker",1);
   DelayCommand(60.0,DeleteLocalInt(oObject,"blocker"));

   if(combat != 1){
     nDiceRoll = 20;
   }
   if((nDiceRoll+nSkillRank) >= nDC)
   {
     if(combat != 1){
        SendMessageToPC(oPC,"Skill Check (Take 20: "+sSkill+"): " + IntToString(nSkillRank) + " + " + IntToString(nDiceRoll) + " = " +
     IntToString((nSkillRank+nDiceRoll)) + " Vs " + IntToString(nDC) + " !SUCCESS!");
     }
     else{
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank) + " + " + IntToString(nDiceRoll) + " = " +
     IntToString((nSkillRank+nDiceRoll)) + " Vs " + IntToString(nDC) + " !SUCCESS!");
     }

     nPCLevel = GetLevelByPosition(1,oPC)+GetLevelByPosition(2,oPC)+GetLevelByPosition(3,oPC);
     if(nPCLevel<30)
     {
       SetXP(oPC,(GetXP(oPC)+nLevel*100));
     }

     if(nSkill ==SKILL_SPELLCRAFT)
     {
       AssignCommand(oObject,ActionSpeakString("*The arcane solution is weaved into the lock with a click and a door appears...*"));
     }
     else if(nSkill == SKILL_SEARCH)
     {
       AssignCommand(oObject,ActionSpeakString("*Subtle scratches, virtually unnoticable signs, and hints only a truly keen eye would see reveals a hidden doorway...*"));
     }
     else if(nSkill == SKILL_LORE)
     {
       AssignCommand(oObject,ActionSpeakString("*Ancient puzzles, cultural symbols, and religious texts reveal the solution to the puzzle as it clicks and a door appears...*"));
     }
     DestroyObject(oObject,0.5);
     oTemp = CreateObject(OBJECT_TYPE_PLACEABLE,sDoorType,lWaypoint);
     SetFacing(GetFacing(oWaypoint));  // Sets the facing the same as the waypoint
     SetLocalString(oTemp,"destination",sDestinationWP);
     SetTag(oTemp,"dungtool");
     SetLocalString(oTemp,"waypoint",sWaypoint);
     SetLocalInt(oTemp,"active",1);
   }
   else
   {
     if(combat != 1){
        SendMessageToPC(oPC,"Skill Check (Take 20: "+sSkill+"): " + IntToString(nSkillRank) + " + " + IntToString(nDiceRoll) + " = " +
     IntToString((nSkillRank+nDiceRoll)) + " Vs " + IntToString(nDC) + " !FAILURE!");
     }
     else{
        SendMessageToPC(oPC,"Skill Check ("+sSkill+"): " + IntToString(nSkillRank) + " + " + IntToString(nDiceRoll) + " = " +
     IntToString((nSkillRank+nDiceRoll)) + " Vs " + IntToString(nDC) + " !FAILURE!");
     }
   }
}
