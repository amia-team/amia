// Hunter Dialogue that launches on conversation complete - If selection was to hunt.
// - Edited: Maverick00053 - 3/24/22

#include "inc_call_time"
#include "amia_include"

// Spawn the prey in the hunting zone
void spawnPrey(int nInstance, int nRandomCount, int nRandom, string sArea);
// Clear out any old prey in the hunting zone
void clearPrey(object oPC, int nSpawnEnd, int nSpawnStart, int nRandom, string sArea);

void main()
{
   object oPC = GetPCSpeaker();
   object oWidget = GetItemPossessedBy(oPC, "ds_pckey");
   object oWaypoint;
   int nAreaSelected = GetLocalInt(oWidget,"BGHAreaSelected");
   int nPCLevel = GetLevelByPosition(1,oPC) + GetLevelByPosition(2,oPC) + GetLevelByPosition(3,oPC);
   int nRandom;
   int nPreviousTime = GetLocalInt(oWidget,"PreviousStartTime");
   int nCurrentTime = GetRunTimeInSeconds();
   int nCooldownTime = (nCurrentTime - nPreviousTime);
   string sArea;
   object oJobJournal = GetItemPossessedBy(oPC, "js_jobjournal");
   string sPrimaryJob = GetLocalString(oJobJournal,"primaryjob");
   string sSecondaryJob = GetLocalString(oJobJournal,"secondaryjob");

   //Timer Cooldown
   if((nCooldownTime < 600) && (sPrimaryJob == "Hunter" || sSecondaryJob == "Hunter")) // SET TO 600
   {
     SendMessageToPC(oPC,"You must wait " + IntToString(10-(nCooldownTime/60)) + " minutes before hunting again!");
     return;
   }
   else if((nCooldownTime < 3600) && (sPrimaryJob != "Hunter" && sSecondaryJob != "Hunter"))// SET TO 3600
   {
     SendMessageToPC(oPC,"You must wait " + IntToString(60-(nCooldownTime/60)) + " minutes before hunting again!");
     return;
   }

   // Guide Checks
   if(GetTag(OBJECT_SELF) == "hunter_guide")
   {
   if(GetGold(oPC) < 10000)
   {
     AssignCommand(OBJECT_SELF,ActionSpeakString("Sorry. You need more gold."));
     return;
   }
   else
   {
     TakeGoldFromCreature(10000,oPC,TRUE);
   }
   }

   if(nAreaSelected == 7) // This is the hunter picking "random" hunt. Will randomly select a zone.
   {
     int nRanTemp = Random(6)+1;
     nAreaSelected = nRanTemp;
   }

   // Based on selection it will pick a waypoint to TP them to.
   if(nAreaSelected == 1) // Cave - 13 Waypoints - 1-5, 6-9, 10-13
   {
     if(nPCLevel >= 25)
     {
        nRandom = Random(13)+1;

        // Special catch to reduce the likely chance of the non hunter, hostile humanoid spawns
        if((nRandom==10) || (nRandom==9)  || (nRandom==3))
        {
          nRandom = Random(13)+1;
        }

     }
     else if(nPCLevel >= 15)
     {
        nRandom = Random(9)+1;

        // Special catch to reduce the likely chance of the non hunter, hostile humanoid spawns
        if((nRandom==9) || (nRandom==3))
        {
          nRandom = Random(9)+1;
        }
     }
     else if(nPCLevel >= 5)
     {
        nRandom = Random(5)+1;

        // Special catch to reduce the likely chance of the non hunter, hostile humanoid spawns
        if((nRandom==3))
        {
          nRandom = Random(5)+1;
        }

     }
     oWaypoint = GetWaypointByTag("hunter_cave_s"+IntToString(nRandom));
     sArea = "cave";
   }
   else if(nAreaSelected == 2) // Desert - 14 Waypoints - 1-5, 6-10, 11-14
   {
     if(nPCLevel >= 25)
     {
        nRandom = Random(14)+1;

        // Special catch to reduce the likely chance of the non hunter, hostile humanoid spawns
        if((nRandom==7))
        {
          nRandom = Random(14)+1;
        }
     }
     else if(nPCLevel >= 15)
     {
        nRandom = Random(10)+1;

        // Special catch to reduce the likely chance of the non hunter, hostile humanoid spawns
        if((nRandom==7))
        {
          nRandom = Random(10)+1;
        }
     }
     else if(nPCLevel >= 5)
     {
        nRandom = Random(5)+1;
     }
     oWaypoint = GetWaypointByTag("hunter_dese_s"+IntToString(nRandom));
     sArea = "dese";
   }
   else if(nAreaSelected == 3) // Snow Mountains - 15 Waypoints - 1-5, 5-10, 10-15
   {
     if(nPCLevel >= 25)
     {
        nRandom = Random(15)+1;

        // Special catch to reduce the likely chance of the non hunter, hostile humanoid spawns
        if((nRandom==14) || (nRandom==3))
        {
          nRandom = Random(15)+1;
        }
     }
     else if(nPCLevel >= 15)
     {
        nRandom = Random(10)+1;

        // Special catch to reduce the likely chance of the non hunter, hostile humanoid spawns
        if((nRandom==3))
        {
          nRandom = Random(10)+1;
        }
     }
     else if(nPCLevel >= 5)
     {
        nRandom = Random(5)+1;

        // Special catch to reduce the likely chance of the non hunter, hostile humanoid spawns
        if((nRandom==3))
        {
          nRandom = Random(5)+1;
        }
     }
     oWaypoint = GetWaypointByTag("hunter_snow_s"+IntToString(nRandom));
     sArea = "snow";
   }
   else if(nAreaSelected == 4) // Underdark - 12 Waypoints - 1-4, 5-8, 9-12
   {
     if(nPCLevel >= 25)
     {
        nRandom = Random(12)+1;

        // Special catch to reduce the likely chance of the non hunter, hostile humanoid spawns
        if((nRandom==10) || (nRandom==6) || (nRandom==4))
        {
          nRandom = Random(12)+1;
        }
     }
     else if(nPCLevel >= 15)
     {
        nRandom = Random(8)+1;

        // Special catch to reduce the likely chance of the non hunter, hostile humanoid spawns
        if((nRandom==6) || (nRandom==4))
        {
          nRandom = Random(8)+1;
        }
     }
     else if(nPCLevel >= 5)
     {
        nRandom = Random(4)+1;

        // Special catch to reduce the likely chance of the non hunter, hostile humanoid spawns
        if((nRandom==4))
        {
          nRandom = Random(4)+1;
        }
     }
     oWaypoint = GetWaypointByTag("hunter_under_s"+IntToString(nRandom));
     sArea = "under";
   }
   else if(nAreaSelected == 5) // Forest - 12 Waypoints - 1-4, 5-8, 9-12
   {
     if(nPCLevel >= 25)
     {
        nRandom = Random(12)+1;

        // Special catch to reduce the likely chance of the non hunter, hostile humanoid spawns
        if((nRandom==11) || (nRandom==7) || (nRandom==3))
        {
          nRandom = Random(12)+1;
        }
     }
     else if(nPCLevel >= 15)
     {
        nRandom = Random(8)+1;

        // Special catch to reduce the likely chance of the non hunter, hostile humanoid spawns
        if((nRandom==7) || (nRandom==3))
        {
          nRandom = Random(8)+1;
        }
     }
     else if(nPCLevel >= 5)
     {
        nRandom = Random(4)+1;

        // Special catch to reduce the likely chance of the non hunter, hostile humanoid spawns
        if((nRandom==3))
        {
          nRandom = Random(4)+1;
        }
     }
     oWaypoint = GetWaypointByTag("hunter_wood_s"+IntToString(nRandom));
     sArea = "wood";
   }
   else if(nAreaSelected == 6) // Randomly visit one of the bandit areas
   {
     if(nPCLevel >= 25)
     {
        nRandom = Random(12)+1;
        switch(nRandom)
        {
          case 1: oWaypoint = GetWaypointByTag("hunter_cave_s3"); sArea = "cave"; break;
          case 2: oWaypoint = GetWaypointByTag("hunter_cave_s9"); sArea = "cave";  break;
          case 3: oWaypoint = GetWaypointByTag("hunter_cave_s10"); sArea = "cave";  break;
          case 4: oWaypoint = GetWaypointByTag("hunter_dese_s7"); sArea = "dese";  break;
          case 5: oWaypoint = GetWaypointByTag("hunter_snow_s3"); sArea = "snow";  break;
          case 6: oWaypoint = GetWaypointByTag("hunter_snow_s14"); sArea = "snow";  break;
          case 7: oWaypoint = GetWaypointByTag("hunter_under_s4"); sArea = "under";  break;
          case 8: oWaypoint = GetWaypointByTag("hunter_under_s6"); sArea = "under";  break;
          case 9: oWaypoint = GetWaypointByTag("hunter_under_s10"); sArea = "under";  break;
          case 10: oWaypoint = GetWaypointByTag("hunter_wood_s3"); sArea = "wood";  break;
          case 11: oWaypoint = GetWaypointByTag("hunter_wood_s7"); sArea = "wood";  break;
          case 12: oWaypoint = GetWaypointByTag("hunter_wood_s11"); sArea = "wood";  break;
        }

     }
     else if(nPCLevel >= 15)
     {
        nRandom = Random(8)+1;
        switch(nRandom)
        {
          case 1: oWaypoint = GetWaypointByTag("hunter_cave_s3"); sArea = "cave"; break;
          case 2: oWaypoint = GetWaypointByTag("hunter_cave_s9"); sArea = "cave";  break;
          case 3: oWaypoint = GetWaypointByTag("hunter_dese_s7"); sArea = "dese";  break;
          case 4: oWaypoint = GetWaypointByTag("hunter_snow_s3"); sArea = "snow";  break;
          case 5: oWaypoint = GetWaypointByTag("hunter_under_s4"); sArea = "under";  break;
          case 6: oWaypoint = GetWaypointByTag("hunter_under_s6"); sArea = "under";  break;
          case 7: oWaypoint = GetWaypointByTag("hunter_wood_s3"); sArea = "wood";  break;
          case 8: oWaypoint = GetWaypointByTag("hunter_wood_s7"); sArea = "wood";  break;
        }

     }
     else if(nPCLevel >= 5)
     {
        nRandom = Random(4)+1;
        switch(nRandom)
        {
          case 1: oWaypoint = GetWaypointByTag("hunter_cave_s3"); sArea = "cave"; break;
          case 2: oWaypoint = GetWaypointByTag("hunter_snow_s3"); sArea = "snow";  break;
          case 3: oWaypoint = GetWaypointByTag("hunter_under_s4"); sArea = "under";  break;
          case 4: oWaypoint = GetWaypointByTag("hunter_wood_s3"); sArea = "wood";  break;
        }

     }
   }


   AssignCommand(oPC,ActionSpeakString("<c~��>*You head off onto a long hunt by yourself. Putting your tracking skills to the test*</c>"));
   SetLocalLocation(oPC,"hunter_start_loc",GetLocation(oPC));

   int nSpawnStart = GetLocalInt(oWaypoint,"spawnstart");
   int nSpawnEnd = GetLocalInt(oWaypoint,"spawnend");
   int nCount = GetLocalInt(oWaypoint,"count");
   int nRandomCount = Random(nCount)+1;

   // Check for if the instance is occupied
   if((GetLocalInt(oWaypoint,"IsOccupied") == 1) && (GetTag(OBJECT_SELF) == "hunter_guide"))
   {
     AssignCommand(OBJECT_SELF,ActionSpeakString("Seems the area we headed to was already occupied by another hunter. Here is your money back. We can try somewhere else right away if you wish."));
     GiveGoldToCreature(oPC,10000);
     return;
   }
   else if(GetLocalInt(oWaypoint,"IsOccupied") == 1)
   {
     AssignCommand(oPC,ActionSpeakString("<c~��>*You quickly realize that the area you have picked is occupied by another hunter. You head back for the moment, but can leave on another trip immediately*</c>"));
     return;
   }

   int nRandomJobJournal = Random(100)+1;
   //Journal log percentage check
   if((sPrimaryJob == "Hunter"))
   {
     // Hunt is always a success!
   }
   else if((sSecondaryJob == "Hunter") && (nRandomJobJournal >= 80))
   {
     AssignCommand(oPC,ActionSpeakString("<c~��>*After some time you return unsuccesful. Better luck next time*</c>"));
     return;
   }
   else
   {
     if(nRandomJobJournal >= 60)
     {
       AssignCommand(oPC,ActionSpeakString("<c~��>*After some time you return unsuccesful. Better luck next time*</c>"));
       return;
     }
   }

   SetLocalInt(oWaypoint,"IsOccupied",1);
   SetLocalString(oPC,"Hunter_Waypoint",GetTag(oWaypoint));
   DelayCommand( 1.0, AssignCommand( oPC, ClearAllActions() ) );
   DelayCommand( 1.1, AssignCommand( oPC, JumpToObject( oWaypoint, 0 ) ) );

   clearPrey(oPC, nSpawnEnd, nSpawnStart, nRandom, sArea);

   if(nSpawnStart == nSpawnEnd)
   {
     spawnPrey(nSpawnStart,nRandomCount,nRandom, sArea);
   }
   else
   {
     int i;
     for(i = 0; i <= (nSpawnEnd - nSpawnStart); i++)
     {
       DelayCommand( 1.0, spawnPrey(nSpawnStart+i,nRandomCount,nRandom, sArea));
     }
   }



}

void spawnPrey(int nInstance, int nRandomCount, int nRandom, string sArea)
{

  object oWaypoint = GetWaypointByTag("hunter_"+sArea+"_sw"+IntToString(nInstance));
  string sResRef = GetLocalString(oWaypoint,"resRef"+IntToString(nRandomCount));
  string sInstance = "instance"+IntToString(nRandom)+sArea;
  if((sResRef == "hunter_chest_5") || (sResRef == "hunter_chest_15") || (sResRef == "hunter_chest_25"))
  {
    object oChest = CreateObject(OBJECT_TYPE_PLACEABLE,sResRef,GetLocation(oWaypoint),FALSE,sInstance);
    AssignCommand(oChest, SetFacing( (GetFacing(oWaypoint)) + 180.0));
  }
  else
  {
    CreateObject(OBJECT_TYPE_CREATURE,sResRef,GetLocation(oWaypoint),FALSE,sInstance);
  }

}

void clearPrey(object oPC, int nSpawnEnd, int nSpawnStart, int nRandom, string sArea)
{
    string sInstance = "instance"+IntToString(nRandom)+sArea;
    object oClear;

    int i;
    for(i = 0; i <= (nSpawnEnd - nSpawnStart); i++)
    {
       oClear = GetObjectByTag(sInstance,i);
       if(GetIsObjectValid(oClear))
       {
        DestroyObject(oClear);
       }
    }

}
