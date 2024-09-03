/*
   Main script that will be put in the generic trigger in front of the dungeon to activate all the dynamic dungeon tools

 - Maverick00053 11/12/2023
*/
#include "ds_ai2_include"
#include "dung_inc"

// Function that clears all dungeon tool PLC and NPCs
void ClearAllPLCnNPC(object oTrans, string sDungeon);

// Spawns traps at waypoints
void SpawnTraps(object oTrans, string sDungeon, int nLevel);

// Spawns physical blocking PLC at waypoints
void SpawnBlockers(object oTrans, string sDungeon, int nLevel);

// Spawns challenges at waypoints. These challenges can be NPCs, animals, or PLCs.
void SpawnChallenges(object oTrans, string sDungeon, int nLevel);

// Spawns hidden doors or hidden door spawning PLCs at waypoints
void SpawnHiddenDoors(object oTrans, string sDungeon, int nLevel);

// Generates a random resref string from templates premade. These templates represent male/female of almost all races.
string RandomRaceAndGender(object oTrans);

// Generates a random animal skin number, and name to go with it
int RandomAnimal();

// GLOBAL animal name variable that is set in the RandomAnimal function
string sAnimalName;

// Using the level of the dungeon set on the initial trigger in the dungeon, it will return an appropriate
// level animal template
string AnimalLevel(int nLevel);

// Returns a resref of a random mundane PLC to populate around challenge NPCs that are generated
string RandomMundanePLC();

// Returns a resref of a random puzzle PLC to solve, SpawnChallenge uses this
string RandomPuzzlePLC();


void main()
{
   object oTrans = OBJECT_SELF;
   string sDungeon = GetLocalString(oTrans,"dungeon");
   int nLevel = GetLocalInt(oTrans,"level");
   int nActive = GetLocalInt(oTrans,"activated");
   int nTriggerCount = GetLocalInt(oTrans,"triggerCount");
   float nTimer = GetLocalFloat(oTrans,"resetTimer");

   if(nTimer==0.0)
   {
     nTimer=600.0;
   }

   if(nActive==0)
   {
     ClearAllPLCnNPC(oTrans, sDungeon);

     SpawnTraps(oTrans, sDungeon, nLevel);

     SpawnBlockers(oTrans, sDungeon, nLevel);

     SpawnChallenges(oTrans, sDungeon, nLevel);

     SpawnHiddenDoors(oTrans, sDungeon, nLevel);

     int i;
     object oTransObject;
     for(i=0;i<nTriggerCount;i++)
     {
      oTransObject = GetObjectByTag(sDungeon+"DTS",i);
      SetLocalInt(oTransObject,"activated",1);
      DelayCommand(nTimer,DeleteLocalInt(oTransObject,"activated"));
     }
   }
}

void ClearAllPLCnNPC(object oTrans, string sDungeon)
{

   int nBlockCount = GetLocalInt(oTrans,"blockerCount");
   int nTrapCount = GetLocalInt(oTrans,"trapCount");
   int nChallengeCount = GetLocalInt(oTrans,"challengeCount");
   int nHDoorCount = GetLocalInt(oTrans,"hdoorCount");
   int a;
   int i;
   int nWaypointCount;
   string sWayPoint;
   object oWayPoint;
   object oSubWayPoint;
   object oTemp;


   // Start of Clear TRAP objects
   for(a=1;a<nTrapCount+1;a++) // Runs through all your blocker waypoints
   {
    oWayPoint = GetWaypointByTag(sDungeon+"Trap"+IntToString(a));
    sWayPoint = GetTag(oWayPoint);
    oTemp = GetNearestObjectByTag("dungtool",oWayPoint);
    DestroyObject(oTemp);
   }
   // End of Clear TRAP Objects

   // Start of Clear BLOCKER objects
   for(a=1;a<nBlockCount+1;a++) // Runs through all your blocker waypoints
   {
    oWayPoint = GetWaypointByTag(sDungeon+"Block"+IntToString(a));
    nWaypointCount = GetLocalInt(oWayPoint,"count");
    sWayPoint = GetTag(oWayPoint);
    oTemp = GetNearestObjectByTag(sWayPoint+"PLC",oWayPoint);
    DestroyBlockers(oTemp);
   }
   // End of Clear BLOCKER Objects

   // Start of Clear CHALLENGE objects
   for(a=1;a<nChallengeCount+1;a++) // Runs through all your CHALLENGE waypoints
   {
    oWayPoint = GetWaypointByTag(sDungeon+"Challenge"+IntToString(a));
    nWaypointCount = GetLocalInt(oWayPoint,"count");
    sWayPoint = GetTag(oWayPoint);
    for(i=1;i<nWaypointCount+1;i++) // Runs through all your sub CHALLENGE waypoints for each waypoint if they exist
    {
      oSubWayPoint = GetWaypointByTag(sWayPoint+"Sub"+IntToString(i));
      oTemp = GetNearestObjectByTag("dungtool",oSubWayPoint);
      DestroyObject(oTemp);
    }
      oTemp = GetNearestObjectByTag("dungtool",oWayPoint);
      DestroyObject(oTemp);
   }
   // End of Clear CHALLENGE Objects

   // Start of Clear HIDDEN DOOR objects
   for(a=1;a<nHDoorCount+1;a++) // Runs through all your HIDDEN DOOR waypoints
   {
    oWayPoint = GetWaypointByTag(sDungeon+"HDoor"+IntToString(a));
    oTemp = GetNearestObjectByTag("dungtool",oWayPoint);
    DestroyObject(oTemp);
   }
   // End of Clear HIDDEN DOOR  Objects



}

void SpawnTraps(object oTrans, string sDungeon, int nLevel)
{
  int nTrapCount = GetLocalInt(oTrans,"trapCount");
  int nTrapType1;
  int nTrapType2;
  int nTrapType3;
  int nTrapType4;
  int nTrapType5;
  int nTrapType6;
  int nTrapType7;
  int nTrapType8;
  int nTrapType9;
  int nTrapTypeFinal;
  int nPercentageSpawnChance = GetLocalInt(oTrans,"trapPercentage");

  int a;
  for(a=1;a<nTrapCount+1;a++) // Runs through all your blocker waypoints
  {
   if((Random(100)+1)<=nPercentageSpawnChance)
   {
    object oWayPoint = GetWaypointByTag(sDungeon+"Trap"+IntToString(a));
    string sWayPoint = GetTag(oWayPoint);
    location lWayPoint = GetLocation(oWayPoint);

    if(nLevel>=25)
    {
     nTrapType1=TRAP_BASE_TYPE_DEADLY_ACID;
     nTrapType2=TRAP_BASE_TYPE_DEADLY_ACID_SPLASH;
     nTrapType3=TRAP_BASE_TYPE_STRONG_ELECTRICAL;
     nTrapType4=TRAP_BASE_TYPE_STRONG_FIRE;
     nTrapType5=TRAP_BASE_TYPE_DEADLY_FROST;
     nTrapType6=TRAP_BASE_TYPE_DEADLY_GAS;
     nTrapType7=TRAP_BASE_TYPE_DEADLY_SONIC;
     nTrapType8=TRAP_BASE_TYPE_DEADLY_SPIKE;
     nTrapType9=TRAP_BASE_TYPE_DEADLY_TANGLE;
    }
    else if(nLevel>=20)
    {
     nTrapType1=TRAP_BASE_TYPE_STRONG_ACID;
     nTrapType2=TRAP_BASE_TYPE_STRONG_ACID_SPLASH;
     nTrapType3=TRAP_BASE_TYPE_AVERAGE_ELECTRICAL;
     nTrapType4=TRAP_BASE_TYPE_AVERAGE_FIRE;
     nTrapType5=TRAP_BASE_TYPE_STRONG_FROST;
     nTrapType6=TRAP_BASE_TYPE_STRONG_GAS;
     nTrapType7=TRAP_BASE_TYPE_STRONG_SONIC;
     nTrapType8=TRAP_BASE_TYPE_STRONG_SPIKE;
     nTrapType9=TRAP_BASE_TYPE_STRONG_TANGLE;
    }
    else if(nLevel>=10)
    {
     nTrapType1=TRAP_BASE_TYPE_AVERAGE_ACID;
     nTrapType2=TRAP_BASE_TYPE_AVERAGE_ACID_SPLASH;
     nTrapType3=TRAP_BASE_TYPE_MINOR_ELECTRICAL;
     nTrapType4=TRAP_BASE_TYPE_MINOR_FIRE;
     nTrapType5=TRAP_BASE_TYPE_AVERAGE_FROST;
     nTrapType6=TRAP_BASE_TYPE_AVERAGE_GAS;
     nTrapType7=TRAP_BASE_TYPE_AVERAGE_SONIC;
     nTrapType8=TRAP_BASE_TYPE_AVERAGE_SPIKE;
     nTrapType9=TRAP_BASE_TYPE_AVERAGE_TANGLE;
    }
    else if(nLevel>=1)
    {
     nTrapType1=TRAP_BASE_TYPE_MINOR_ACID;
     nTrapType2=TRAP_BASE_TYPE_MINOR_ACID_SPLASH;
     nTrapType3=TRAP_BASE_TYPE_MINOR_TANGLE;     // Removed minor electric because it was too powerful
     nTrapType4=TRAP_BASE_TYPE_MINOR_SPIKE;      // Removed minor fire because it was too powerful
     nTrapType5=TRAP_BASE_TYPE_MINOR_FROST;
     nTrapType6=TRAP_BASE_TYPE_MINOR_GAS;
     nTrapType7=TRAP_BASE_TYPE_MINOR_SONIC;
     nTrapType8=TRAP_BASE_TYPE_MINOR_SPIKE;
     nTrapType9=TRAP_BASE_TYPE_MINOR_TANGLE;
    }

    int nRandom = Random(9)+1;
    switch(nRandom)
    {
     case 1: nTrapTypeFinal = nTrapType1 ; break;
     case 2: nTrapTypeFinal = nTrapType2 ; break;
     case 3: nTrapTypeFinal = nTrapType3 ; break;
     case 4: nTrapTypeFinal = nTrapType4 ; break;
     case 5: nTrapTypeFinal = nTrapType5 ; break;
     case 6: nTrapTypeFinal = nTrapType6 ; break;
     case 7: nTrapTypeFinal = nTrapType7 ; break;
     case 8: nTrapTypeFinal = nTrapType8 ; break;
     case 9: nTrapTypeFinal = nTrapType9 ; break;
    }

    object oTemp = CreateTrapAtLocation(nTrapTypeFinal,lWayPoint,2.0,"dungtool",STANDARD_FACTION_HOSTILE,"dung_xp");
    SetLocalInt(oTemp,"level",nLevel);
   }
  }

}

void SpawnBlockers(object oTrans, string sDungeon, int nLevel)
{
  string sBlockerType;
  int nRandom;
  int nPercentageSpawnChance = GetLocalInt(oTrans,"blockerPercentage");
  int nBlockCount = GetLocalInt(oTrans,"blockerCount");
  int nBlocked1 = GetLocalInt(oTrans,"banBlocker1");
  int nBlocked2 = GetLocalInt(oTrans,"banBlocker2");

  int a;
  for(a=1;a<nBlockCount+1;a++) // Runs through all your blocker waypoints
  {
   if((Random(100)+1)<=nPercentageSpawnChance)
   {
    nRandom = Random(6)+1; // Scale this up if you are adding more options

    // Rerolls the random variable if a blocked number is not present
    while(((nRandom == nBlocked1) || (nRandom == nBlocked2)) )
    {
      nRandom = Random(6)+1;
    }

    switch(nRandom)
    {
     case 1: sBlockerType = "rockblockage" ; break;
     case 2: sBlockerType = "iceblockage" ; break;
     case 3: sBlockerType = "magmablockage" ; break;
     case 4: sBlockerType = "magicalblockage" ; break;
     case 5: sBlockerType = "chargedcblockage" ; break;
     case 6: sBlockerType = "mushroomblockage" ; break;
    }

    object oWayPoint = GetWaypointByTag(sDungeon+"Block"+IntToString(a));
    string sWayPoint = GetTag(oWayPoint);
    int nWaypointCount = GetLocalInt(oWayPoint,"count");
    location lWayPoint = GetLocation(oWayPoint);

    int i;
    object oSubWayPoint;
    location lSubWayPoint;
    object oTemp;

    for(i=1;i<nWaypointCount+1;i++) // Runs through all your sub blocker waypoints for each waypoint if they exist
    {
      oSubWayPoint = GetWaypointByTag(sWayPoint+"Sub"+IntToString(i));
      lSubWayPoint = GetLocation(oSubWayPoint);
      oTemp = CreateObject(OBJECT_TYPE_PLACEABLE,sBlockerType,lSubWayPoint,FALSE,sWayPoint+"PLC");
      SetFacing(GetFacing(oSubWayPoint));  // Sets the facing the same as the waypoint
      SetLocalInt(oTemp,"level",nLevel);
      SetLocalInt(oTemp,"count",nWaypointCount);

    }

    oTemp = CreateObject(OBJECT_TYPE_PLACEABLE,sBlockerType,lWayPoint,FALSE,sWayPoint+"PLC");
    SetFacing(GetFacing(oWayPoint));  // Sets the facing the same as the waypoint
    SetLocalInt(oTemp,"level",nLevel);
    SetLocalString(oTemp, "dungeon", sDungeon);
    SetLocalInt(oTemp,"count",nWaypointCount);
   }
  }
}

void SpawnChallenges(object oTrans, string sDungeon, int nLevel)
{
  int nRandType;
  int nChallengeCount = GetLocalInt(oTrans,"challengeCount");
  int nBanPLC = GetLocalInt(oTrans,"banPLC");
  int nBanNPC = GetLocalInt(oTrans,"banNPC");

  // Making sure there isn't any weirdness if someone messes up and sets ban to both types.
  if((nBanPLC==1) && (nBanNPC==1))
  {
    nBanPLC=0;
    nBanNPC=0;
  }

  int a;
  int nIsNPC;
  int nAnimalType;
  int nPercentageSpawnChance = GetLocalInt(oTrans,"challengePercentage");
  string sChallengeType;
  string sChallengePLC;
  string sChallengeObject;
  string sChallengeName;
  string sChallengeBio;
  object oTempChallenge;

  for(a=1;a<nChallengeCount+1;a++) // Runs through all your blocker waypoints
  {
   if((Random(100)+1)<=nPercentageSpawnChance)
   {
    object oWayPoint = GetWaypointByTag(sDungeon+"Challenge"+IntToString(a));
    string sWayPoint = GetTag(oWayPoint);
    int nWaypointCount = GetLocalInt(oWayPoint,"count");
    location lWayPoint = GetLocation(oWayPoint);

    nRandType = Random(9)+1; // Scale this up if you are adding more options
    switch(nRandType) // Generates random challenge type
    {
     case 1: sChallengeType = "talknpc"; sChallengeName = "Knowledgeable Adventurer"; sChallengeBio = "This individual appears to be quite knowledgeable about something. Perhaps you should talk to them?"; nIsNPC=1; sChallengeObject = RandomRaceAndGender(oTrans); break;
     case 2: sChallengeType = "injurednpc"; sChallengeName = "Injured Adventurer"; sChallengeBio = "This poor individual is injured! Perhaps you should offer some aid?"; nIsNPC=1; sChallengeObject = RandomRaceAndGender(oTrans); break;
     case 3: sChallengeType = "lorepuzzle"; sChallengeName = "Quizzical Contraption"; sChallengeBio = "What a mysterious device before you. Perhaps you could twinker with it a bit and solve it?"; nIsNPC=0; sChallengeObject = RandomPuzzlePLC(); break;
     case 4: sChallengeType = "spellcraftumdpuzzle"; sChallengeName = "Shimmering Magical Contraption"; sChallengeBio = "This device shimmers with magic and yet it appears to be a puzzle of some kind! Can you solve it?"; nIsNPC=0; sChallengeObject = RandomPuzzlePLC(); break;
     case 5: sChallengeType = "cagedanimal"; nAnimalType=RandomAnimal(); sChallengeBio = "This animal appears like it might be lost? Perhaps a certain talented Druid or Ranger might be interested in communicating with them."; nIsNPC=1; sChallengeObject = AnimalLevel(nLevel); break;
     case 6: sChallengeType = "depressednpc"; sChallengeName = "Distressed Adventurer"; sChallengeBio = "This poor individual looks to be in distress! Are those tears you see? Perhaps you should speak with them?"; nIsNPC=1; sChallengeObject = RandomRaceAndGender(oTrans); break;
     case 7: sChallengeType = "appraisepuzzle"; sChallengeName = "Useless Junk"; sChallengeBio = "What an absolute pile of junk! You should just ignore this and move on... absolutely nothing to see here"; nIsNPC=0; sChallengeObject = RandomPuzzlePLC(); break;
     case 8: sChallengeType = "summonshrine"; sChallengeName = "Glowing Contraption"; sChallengeBio = "This device seems to give off a powerful glow. You should see if you can claim it for yourself?"; nIsNPC=0; sChallengeObject = RandomPuzzlePLC(); break;
     case 9: sChallengeType = "buffshrine"; sChallengeName = "Pulsing Contraption"; sChallengeBio = "This device seems to give off a powerful pulse of magic. You should see if you can claim it for yourself?"; nIsNPC=0; sChallengeObject = RandomPuzzlePLC(); break;
    }

    int i;
    object oSubWayPoint;
    location lSubWayPoint;
    object oTemp;

    if((nIsNPC==1) && (nBanNPC==0) && (sChallengeType != "cagedanimal"))// The extra PLCs will only be placed IF it is an NPC, otherwise it will just throw down the animal or interactable PLC
    {
     for(i=1;i<nWaypointCount+1;i++) // Runs through all your sub challenge waypoints for each waypoint if they exist
     {

       sChallengePLC = RandomMundanePLC();

       oSubWayPoint = GetWaypointByTag(sWayPoint+"Sub"+IntToString(i));
       lSubWayPoint = GetLocation(oSubWayPoint);
       oTemp = CreateObject(OBJECT_TYPE_PLACEABLE,sChallengePLC,lSubWayPoint);
       SetTag(oTemp,"dungtool");
       SetFacing(GetFacing(oSubWayPoint));  // Sets the facing the same as the waypoint
       SetLocalInt(oTemp,"level",nLevel);
      }

    }   // End of for loop i

    if(nIsNPC==1)
    {
     if(nBanNPC==0)
     {
      oTempChallenge = CreateObject(OBJECT_TYPE_CREATURE,sChallengeObject,lWayPoint);
     }
    }
    else
    {
     if(nBanPLC==0)
     {
      oTempChallenge = CreateObject(OBJECT_TYPE_PLACEABLE,sChallengeObject,lWayPoint);
     }
    }

    if(((nBanNPC==1) && (nIsNPC==1)) || ((nBanPLC==1) && (nIsNPC==0)))
    {
       // DO NOTHING
    }
    else
    {

     SetLocalString(oTempChallenge,"type",sChallengeType);
     // Add in custom convo if set
     SetLocalString(oTempChallenge,"customConvo",GetLocalString(oTrans,sChallengeType+"CustomConvo"));

     if(sChallengeType=="cagedanimal") // If it is an animal there are special conditions
     {
      SetName(oTempChallenge,sAnimalName);
      SetCreatureAppearanceType(oTempChallenge,nAnimalType);
      SetDescription(oTempChallenge,sChallengeBio);
     }
     else
     {
      SetName(oTempChallenge,sChallengeName);
      SetDescription(oTempChallenge,sChallengeBio);
     }

     SetFacing(GetFacing(oWayPoint));
     SetLocalString(oTempChallenge,"waypoint",sDungeon+"Challenge"+IntToString(a));
     SetLocalInt(oTempChallenge,"level",nLevel);
     SetTag(oTempChallenge,"dungtool");
    }
   }
  }  // End of for loop a

}

void SpawnHiddenDoors(object oTrans, string sDungeon, int nLevel)
{

  int nHDoorCount = GetLocalInt(oTrans,"hdoorCount");  // How many hidden door challenges
  int nDoorWPCount = GetLocalInt(oTrans,"doorwp");  // How many hidden door destination waypoints
  int nBanPLC = GetLocalInt(oTrans,"banPLC");
  int nBanNPC = GetLocalInt(oTrans,"banNPC");
  string sHDoorBio;

  // Making sure there isn't any weirdness if someone messes up and sets ban to both types.
  if((nBanPLC==1) && (nBanNPC==1))
  {
    nBanPLC=0;
    nBanNPC=0;
  }

  int a;
  int nRandom;
  int nRandType;
  int nRandLockDoor;
  int nIsNPC;
  int nDC = nLevel + 10 + (nLevel-(nLevel/3));
  int nPercentageSpawnChance = GetLocalInt(oTrans,"hdoorPercentage");
  object oTemp;
  string sDoorType;
  string sRandomNPC;

  for(a=1;a<nHDoorCount+1;a++) // Runs through all your hidden door waypoints
  {
   if((Random(100)+1)<=nPercentageSpawnChance)
   {
    nRandType = Random(5)+1; // Scale this up if you are adding more options
    nRandLockDoor = Random(2) + 1;
    switch(nRandType)
    {
     case 1: sDoorType = "dungdoorspellcra" ; nIsNPC=0; sHDoorBio = "Something appears to be sealed by a magical spell of some kind."; break;
     case 2: sDoorType = "dungdoorsearch" ; nIsNPC=0; sHDoorBio = "Something seems to be hidden here but you can't quite make it out."; break;
     case 3: sDoorType = "hiddendoornpc"; sRandomNPC = RandomRaceAndGender(oTrans); nIsNPC=1; sHDoorBio = "This adventurer appears to be distracted and peering at a piece of paper."; break;   // Special case hidden door. NPC with map spawns.
     case 4: sDoorType = "dungdoorlore" ; nIsNPC=0; break;
     case 5: nIsNPC=0; if(nRandLockDoor==1){sDoorType = "hiddendoorlocked";}else if(nRandLockDoor==2){sDoorType = "hiddendoorlock2";} sHDoorBio = "The doorway before you appears to be locked tight."; break;
    }

    nRandom = Random(nDoorWPCount)+1;

    object oWayPoint = GetWaypointByTag(sDungeon+"HDoor"+IntToString(a));
    location lWayPoint = GetLocation(oWayPoint);

    if(sDoorType=="hiddendoornpc")
    {
     if(nBanNPC==0)
     {
      oTemp = CreateObject(OBJECT_TYPE_CREATURE,sRandomNPC,lWayPoint);
      SetName(oTemp,"Distracted Adventurer");
      // Add in custom convo if set
      SetLocalString(oTemp,"customConvo",GetLocalString(oTrans,sDoorType+"CustomConvo"));
      SetDescription(oTemp,sHDoorBio);
     }
    }
    else
    {
     if(nBanPLC==0)
     {
      oTemp = CreateObject(OBJECT_TYPE_PLACEABLE,sDoorType,lWayPoint);
      SetDescription(oTemp,sHDoorBio);
     }
    }

    if(((nBanNPC==1) && (nIsNPC==1)) || ((nBanPLC==1) && (nIsNPC==0)))
    {
       // DO NOTHING
    }
    else
    {
     SetLocalInt(oTemp,"active",1);
     SetLocalInt(oTemp,"level",nLevel);
     SetLocalString(oTemp,"waypoint",sDungeon+"HDoor"+IntToString(a));
     SetFacing(GetFacing(oWayPoint));  // Sets the facing the same as the waypoint
     SetLocalString(oTemp,"destination",sDungeon+"DoorWP"+IntToString(nRandom));
     SetLocalString(oTemp,"type",sDoorType);
     SetTag(oTemp,"dungtool");

     if((sDoorType == "hiddendoorlocked") || (sDoorType == "hiddendoorlock2"))
     {
      SetLockLockDC(oTemp,nDC);
      SetLockUnlockDC(oTemp,nDC);
      SetLocked(oTemp,1);
     }
    }

   }
  }
}

string RandomRaceAndGender(object oTrans)
{
   int nUnderdark = GetLocalInt(oTrans,"underdark");
   string sRace = "";
   int nRandRace = Random(12)+1; // Scale this up if you are adding more options

   if(nUnderdark==0)
   {
    switch(nRandRace)
    {
     case 1: sRace = "dungnpcfhuman" ; break;
     case 2: sRace = "dungnpcmhuman" ; break;
     case 3: sRace = "dungnpcfelf" ; break;
     case 4: sRace = "dungnpcmelf" ; break;
     case 5: sRace = "dungnpcfdwarf" ; break;
     case 6: sRace = "dungnpcmdwarf" ; break;
     case 7: sRace = "dungnpcfhalflin" ; break;
     case 8: sRace = "dungnpcmhalflin" ; break;
     case 9: sRace = "dungnpcfhalforc" ; break;
     case 10: sRace = "dungnpcmhalforc" ; break;
     case 11: sRace = "dungnpcfgnome" ; break;
     case 12: sRace = "dungnpcmgnome" ; break;
    }
   }
   else if(nUnderdark==1)
   {
    switch(nRandRace)
    {
     case 1: sRace = "dungnpcmsvif" ; break;
     case 2: sRace = "dungnpcfsvif" ; break;
     case 3: sRace = "dungnpcmduergar" ; break;
     case 4: sRace = "dungnpcfduergar" ; break;
     case 5: sRace = "dungnpcmdrow" ; break;
     case 6: sRace = "dungnpcfdrow" ; break;
     case 7: sRace = "dungnpcmkobold" ; break;
     case 8: sRace = "dungnpcfkobold" ; break;
     case 9: sRace = "dungnpcmkuotoa" ; break;
     case 10: sRace = "dungnpcfkuotoa" ; break;
     case 11: sRace = "dungnpcmgoblin" ; break;
     case 12: sRace = "dungnpcfgoblin" ; break;
    }
   }

   return sRace;
}

int RandomAnimal()
{
   int nAnimal;
   int nRandAnimal = Random(33)+1; // Scale this up if you are adding more options
   switch(nRandAnimal)
   {
    case 1: nAnimal = 8; sAnimalName = "Badger"; break;
    case 2: nAnimal = 10; sAnimalName = "Bat"; break;
    case 3: nAnimal = 12; sAnimalName = "Black Bear"; break;
    case 4: nAnimal = 21; sAnimalName = "Boar"; break;
    case 5: nAnimal = 31; sAnimalName = "Dire Chicken"; break;
    case 6: nAnimal = 35; sAnimalName = "Deer"; break;
    case 7: nAnimal = 98; sAnimalName = "Jaguar"; break;
    case 8: nAnimal = 145 ; sAnimalName = "Raven"; break;
    case 9: nAnimal = 176; sAnimalName = "Dog"; break;
    case 10: nAnimal = 181; sAnimalName = "Wolf"; break;
    case 11: nAnimal = 183; sAnimalName = "Cobra"; break;
    case 12: nAnimal = 184; sAnimalName = "White Wolf"; break;
    case 13: nAnimal = 203; sAnimalName = "Cougar"; break;
    case 14: nAnimal = 1265; sAnimalName = "Longhorn"; break;
    case 15: nAnimal = 913; sAnimalName = "Dire Rabbit"; break;
    case 16: nAnimal = 1016; sAnimalName = "Lynx"; break;
    case 17: nAnimal = 1021; sAnimalName = "Moose"; break;
    case 18: nAnimal = 1022; sAnimalName = "Red Fox"; break;
    case 19: nAnimal = 1064; sAnimalName = "Racoon"; break;
    case 20: nAnimal = 1225; sAnimalName = "Dog"; break;
    case 21: nAnimal = 1226; sAnimalName = "Dog"; break;
    case 22: nAnimal = 1241; sAnimalName = "Cat"; break;
    case 23: nAnimal = 1241; sAnimalName = "Cat"; break;
    case 24: nAnimal = 1242; sAnimalName = "Cat"; break;
    case 25: nAnimal = 1246; sAnimalName = "Cat"; break;
    case 26: nAnimal = 1251; sAnimalName = "Cat"; break;
    case 27: nAnimal = 1257; sAnimalName = "Dire Rat"; break;
    case 28: nAnimal = 1260; sAnimalName = "Rat"; break;
    case 29: nAnimal = 1496; sAnimalName = "Goat"; break;
    case 30: nAnimal = 1499; sAnimalName = "Boar"; break;
    case 31: nAnimal = 1508; sAnimalName = "Monkey"; break;
    case 32: nAnimal = 1827; sAnimalName = "Alligator"; break;
    case 33: nAnimal = 1927; sAnimalName = "Bison"; break;
   }

   return nAnimal;
}

string AnimalLevel(int nLevel)
{

   string sAnimalLevel = "";
   int nAnimalLevel;

   if(nLevel <= 2) sAnimalLevel= "dunganimal1";
   else if(nLevel <= 4) sAnimalLevel = "dunganimal3";
   else if(nLevel <= 6) sAnimalLevel = "dunganimal5";
   else if(nLevel <= 8) sAnimalLevel = "dunganimal7";
   else if(nLevel <= 10) sAnimalLevel = "dunganimal9";
   else if(nLevel <= 12) sAnimalLevel = "dunganimal11";
   else if(nLevel <= 14) sAnimalLevel = "dunganimal13";
   else if(nLevel <= 16) sAnimalLevel = "dunganimal15";
   else if(nLevel <= 18) sAnimalLevel = "dunganimal17";
   else if(nLevel <= 20) sAnimalLevel = "dunganimal19";
   else if(nLevel <= 22) sAnimalLevel = "dunganimal21";
   else if(nLevel <= 24) sAnimalLevel = "dunganimal23";
   else if(nLevel <= 26) sAnimalLevel = "dunganimal25";
   else if(nLevel <= 28) sAnimalLevel = "dunganimal27";
   else if(nLevel <= 30) sAnimalLevel = "dunganimal29";

   return sAnimalLevel;

}

string RandomMundanePLC()
{
   string sMundanePLC = "";
   int nRandPLC = Random(23)+1; // Scale this up if you are adding more options
   switch(nRandPLC)
   {
    case 1: sMundanePLC = "plc_campfrwspit" ; break;
    case 2: sMundanePLC = "plc_campfr" ; break;
    case 3: sMundanePLC = "plc_campfrwpot" ; break;
    case 4: sMundanePLC = "tm_pl_brokecrate" ; break;
    case 5: sMundanePLC = "nw_plc_ropecoil1" ; break;
    case 6: sMundanePLC = "dungeontent" ; break;
    case 7: sMundanePLC = "dungeontent2" ; break;
    case 8: sMundanePLC = "tm_pl_barlup1" ; break;
    case 9: sMundanePLC = "tm_pl_candle05" ; break;
    case 10: sMundanePLC = "plc_woodpile" ; break;
    case 11: sMundanePLC = "plc_bookpiles" ; break;
    case 12: sMundanePLC = "plc_ruinwagon" ; break;
    case 13: sMundanePLC = "nw_plc_flagumber" ; break;
    case 14: sMundanePLC = "x3_plc_brazier" ; break;
    case 15: sMundanePLC = "nw_plc_ropecoil2" ; break;
    case 16: sMundanePLC = "tm_pl_candle07" ; break;
    case 17: sMundanePLC = "x0_cookpot" ; break;
    case 18: sMundanePLC = "po_plc_x0_map_" ; break;
    case 19: sMundanePLC = "plc_footstool" ; break;
    case 20: sMundanePLC = "plc_stool" ; break;
    case 21: sMundanePLC = "plc_urn" ; break;
    case 22: sMundanePLC = "x2_plc_cball" ; break;
    case 23: sMundanePLC = "x2_plc_book2" ; break;
   }

   return sMundanePLC;
}

string RandomPuzzlePLC()
{
   string sPuzzlePLC = "";
   int nRandPLC = Random(24)+1; // Scale this up if you are adding more options
   switch(nRandPLC)
   {
    case 1: sPuzzlePLC = "dungpuzzleplc1" ; break;
    case 2: sPuzzlePLC = "dungpuzzleplc2" ; break;
    case 3: sPuzzlePLC = "dungpuzzleplc3" ; break;
    case 4: sPuzzlePLC = "dungpuzzleplc4" ; break;
    case 5: sPuzzlePLC = "dungpuzzleplc5" ; break;
    case 6: sPuzzlePLC = "dungpuzzleplc6" ; break;
    case 7: sPuzzlePLC = "dungpuzzleplc7" ; break;
    case 8: sPuzzlePLC = "dungpuzzleplc8" ; break;
    case 9: sPuzzlePLC = "dungpuzzleplc9" ; break;
    case 10: sPuzzlePLC = "dungpuzzleplc10" ; break;
    case 11: sPuzzlePLC = "dungpuzzleplc11" ; break;
    case 12: sPuzzlePLC = "dungpuzzleplc12" ; break;
    case 13: sPuzzlePLC = "dungpuzzleplc13" ; break;
    case 14: sPuzzlePLC = "dungpuzzleplc14" ; break;
    case 15: sPuzzlePLC = "dungpuzzleplc15" ; break;
    case 16: sPuzzlePLC = "dungpuzzleplc16" ; break;
    case 17: sPuzzlePLC = "dungpuzzleplc17" ; break;
    case 18: sPuzzlePLC = "dungpuzzleplc18" ; break;
    case 19: sPuzzlePLC = "dungpuzzleplc19" ; break;
    case 20: sPuzzlePLC = "dungpuzzleplc20" ; break;
    case 21: sPuzzlePLC = "dungpuzzleplc21" ; break;
    case 22: sPuzzlePLC = "dungpuzzleplc22" ; break;
    case 23: sPuzzlePLC = "dungpuzzleplc23" ; break;
    case 24: sPuzzlePLC = "dungpuzzleplc24" ; break;
   }

   return sPuzzlePLC;
}
