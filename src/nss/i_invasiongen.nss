/*
   Demon Invasion Generator

   07/25/19 - Maverick00053

   Randomly generates an invasion encounter on used area.


*/

void SpawnPRLCheck(object oArea, int nTotalPRL);
void SpawnPRL(object oArea, int nTotalPRL);
void CreatePRL(location oLoopLocation);
void SpawnMob(object oArea, int nTotalMobs);
void SpawnLieutentant(object oArea, int nTotalLieutenant);
void SpawnBoss(object oArea, int nTotalLieutenant);
void MassWhisper(string sAreaName);

void main()
{
    object oPC = GetItemActivator();
    object oArea = GetArea(oPC);
    object oModule = GetModule();
    string sAreaName = GetName(oArea);
    int nTotalLieutenant;
    int nWidthInTiles  = GetAreaSize(AREA_WIDTH,  oArea);;
    int nHeightInTiles = GetAreaSize(AREA_HEIGHT, oArea);;
    int nAreaTiles = nWidthInTiles*nHeightInTiles;
    int nAreaSize;
    int nTotalPRL;
    int nTotalMobs;


    if((GetLocalInt(oArea,"invasion_area") != 1) && (GetIsDM(oPC)))
    {
    // Check for map size and adjusts spawns based on size.
    if(nAreaTiles == 1024)   // Extra Large Map        x16
    {
       nAreaSize = 1;
       nTotalLieutenant = Random(4) + 12;
       nTotalPRL = 600;
       nTotalMobs = Random(26) + 40;
       SetLocalInt(oArea, "InvasionLieutenants", nTotalLieutenant);
    }
    else if(nAreaTiles >= 718)  // Inbetween Large-XLarge map    x11
    {
       nAreaSize = 2;
       nTotalLieutenant = Random(4) + 12;
       nTotalPRL = 500;
       nTotalMobs = Random(23) + 30;
       SetLocalInt(oArea, "InvasionLieutenants", nTotalLieutenant);
    }
    else if(nAreaTiles >= 512)  // Inbetween Large-XLarge map     x8
    {
       nAreaSize = 3;
       nTotalLieutenant = Random(4) + 10;
       nTotalPRL = 480;
       nTotalMobs = Random(20) + 30;
       SetLocalInt(oArea, "InvasionLieutenants", nTotalLieutenant);
    }
    else if(nAreaTiles >= 306)  // Inbetween Large-XLarge map    x5
    {
       nAreaSize = 4;
       nTotalLieutenant = Random(4) + 8;
       nTotalPRL = 460;
       nTotalMobs = Random(17) + 22;
       SetLocalInt(oArea, "InvasionLieutenants", nTotalLieutenant);
    }
    else if(nAreaTiles >= 254)  // Large map      x4
    {
       nAreaSize = 5;
       nTotalLieutenant = Random(4) + 6;
       nTotalPRL = 440;
       nTotalMobs = Random(14) + 22;
       SetLocalInt(oArea, "InvasionLieutenants", nTotalLieutenant);
    }
    else if(nAreaTiles >= 64)  // Medium map - Baseline
    {
       nAreaSize = 6;
       nTotalLieutenant = Random(4) + 3;
       nTotalPRL = 220;
       nTotalMobs = Random(11) + 11;
       SetLocalInt(oArea, "InvasionLieutenants", nTotalLieutenant);
    }
    else if(nAreaTiles >= 48)  // Inbetween Small-Medium map   x.75
    {
       nAreaSize = 7;
       nTotalLieutenant = Random(3) + 2;
       nTotalPRL = 165;
       nTotalMobs = Random(8) + 7;
       SetLocalInt(oArea, "InvasionLieutenants", nTotalLieutenant);
    }
    else if(nAreaTiles >= 32)  // Inbetween Small-Medium map      x.5
    {
       nAreaSize = 8;
       nTotalLieutenant = Random(2) + 2;
       nTotalPRL = 110;
       nTotalMobs = Random(5) + 5;
       SetLocalInt(oArea, "InvasionLieutenants", nTotalLieutenant);
    }
    else if(nAreaTiles >= 16)  // Small map         x.25
    {
       nAreaSize = 9;
       nTotalLieutenant = Random(2) + 1;
       nTotalPRL = 55;
       nTotalMobs = Random(2) + 3;
       SetLocalInt(oArea, "InvasionLieutenants", nTotalLieutenant);
    }
    else if(nAreaTiles >= 4)  // Ultra small map    .0625
    {
       nAreaSize = 10;
       nTotalLieutenant = Random(2) + 1;
       nTotalPRL = 13;
       nTotalMobs = Random(2) + 1;
       SetLocalInt(oArea, "InvasionLieutenants", nTotalLieutenant);
    }

    //

    DelayCommand(65.0,MassWhisper(sAreaName));

    AssignCommand(oPC,SpeakString("// Launching Script. Give just over 60 seconds for the entire program to launch. Server Message will announce when ready.",TALKVOLUME_TALK));

    AssignCommand(oPC,DelayCommand(15.0,SpeakString("// Launching PLC Spawns",TALKVOLUME_TALK)));

    AssignCommand(oPC,DelayCommand(30.0,SpeakString("// Launching Mob Spawns",TALKVOLUME_TALK)));

    AssignCommand(oPC,DelayCommand(45.0,SpeakString("// Launching Lieutenant Spawns",TALKVOLUME_TALK)));

    AssignCommand(oPC,DelayCommand(60.0,SpeakString("// Launching Boss Spawn",TALKVOLUME_TALK)));

    //

    SpawnPRLCheck(oArea, nTotalPRL);

    DelayCommand(15.0,SpawnPRL(oArea, nTotalPRL));

    DelayCommand(30.0,SpawnMob(oArea, nTotalMobs));

    DelayCommand(45.0,SpawnLieutentant(oArea, nTotalLieutenant));

    DelayCommand(60.0,SpawnBoss(oArea, nTotalLieutenant));

    // Extra check to compensate for server lag, to double check that the variable was set.
    if(GetLocalInt(oArea,"InvasionLieutenants") == 0)
    {
    SetLocalInt(oArea, "InvasionLieutenants", nTotalLieutenant);
    }


    SetLocalInt(oArea,"invasion_area", 1);
    SetLocalInt(oArea,"no_spawn", 1);
    SetLocalInt(oArea,"NoDestroy", 1);
    }
}


// There was a problem with PLCs being placed over canyons or other weird locations. So the solution I came up with is
// that I first place a creature object in the location as a check. Then if it can be placed I know the area isn't over
// a cliff or another weird location. So I remove the creature and place the PLC in its spot.
void SpawnPRLCheck(object oArea, int nTotalPRL)
{
    object oCreature;
    object oObject;
    int nCountPRL = 0;
    int iWidthInTiles;
    int iHeightInTiles;
    int iWidthInMeters;
    int iHeightInMeters;
    int iWidthInMetersRandom;
    int iHeightInMetersRandom;
    float  fXPosition;
    float  fYPosition;
    float  fZPosition;
    vector vRandomPos;
    vector vRandomPosN;
    vector vRandomPosS;
    vector vRandomPosE;
    vector vRandomPosW;
    vector vRandomPosNE;
    vector vRandomPosNW;
    vector vRandomPosSE;
    vector vRandomPosSW;
    float    fFacing;
    location lRandom;



     // Generate PRLs Checkers
     while(nCountPRL < nTotalPRL)
    {

     // If a valid area was found, compute the random location.
    if(GetIsObjectValid(oArea))
    {
      // Determine the width and height of the area in tiles.
       iWidthInTiles  = GetAreaSize(AREA_WIDTH,  oArea);
       iHeightInTiles = GetAreaSize(AREA_HEIGHT, oArea);

      // Convert the width and height from tiles into meters.
       iWidthInMeters  = iWidthInTiles  * 10;
       iHeightInMeters = iHeightInTiles * 10;

      // Generate a random position in the area.
        fXPosition = IntToFloat(Random(iWidthInMeters  * 10)) / 10.0;
        fYPosition = IntToFloat(Random(iHeightInMeters * 10)) / 10.0;
        fZPosition = 0.0;
        vRandomPos = Vector(fXPosition, fYPosition, fZPosition);

      // Convert the random position to obtain the random location.
        fFacing = 0.0;
        lRandom = Location(oArea, vRandomPos, fFacing);
     }

        oObject = CreateObject(OBJECT_TYPE_CREATURE,"invasioncheck", lRandom, FALSE);

        if(GetIsObjectValid(oObject))
        {
            nCountPRL++;
        }



    }


}


void SpawnPRL(object oArea, int nTotalPRL)
{

    object oCreature;
    object oObject;
    int nCountPRL = 0;
    int iWidthInTiles;
    int iHeightInTiles;
    int iWidthInMeters;
    int iHeightInMeters;
    int iWidthInMetersRandom;
    int iHeightInMetersRandom;
    float  fXPosition;
    float  fYPosition;
    float  fZPosition;
    vector vRandomPos;
    vector vRandomPosN;
    vector vRandomPosS;
    vector vRandomPosE;
    vector vRandomPosW;
    vector vRandomPosNE;
    vector vRandomPosNW;
    vector vRandomPosSE;
    vector vRandomPosSW;
    float    fFacing;
    location lRandom;
    object oLoop = GetFirstObjectInArea(oArea);
    string oLoopResRef = GetResRef(oLoop);
    location oLoopLocation  = GetLocation(oLoop);



     // It will cycle through all the objects, find the invisibile checks, remove them and then create the PRL in its place
     while(GetIsObjectValid(oLoop) && (nCountPRL < nTotalPRL))
     {


        if(oLoopResRef == "invasioncheck")
        {
           DestroyObject(oLoop,0.0);
           DelayCommand(0.1,CreatePRL(oLoopLocation));
           nCountPRL++;

        }

        oLoop = GetNextObjectInArea(oArea);
        oLoopResRef = GetResRef(oLoop);
        oLoopLocation = GetLocation(oLoop);
     }


}


void CreatePRL(location oLoopLocation)
{
   object oModule = GetModule();
   int nRandom;



   nRandom = Random(16);

   if(nRandom == 0)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasioncorpse1", oLoopLocation, FALSE);
   }
   else if(nRandom == 1)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasionmisc7", oLoopLocation, FALSE);
   }
   else if(nRandom == 2)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasioncorpse3", oLoopLocation, FALSE);
   }
   else if(nRandom == 3)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasioncorpse5", oLoopLocation, FALSE);
   }
   else if(nRandom == 4)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasionmisc1", oLoopLocation, FALSE);
   }
   else if(nRandom == 5)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasionmisc2", oLoopLocation, FALSE);
   }
   else if(nRandom == 6)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasionmisc3", oLoopLocation, FALSE);
   }
   else if(nRandom == 7)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasionmisc4", oLoopLocation, FALSE);
   }
   else if(nRandom == 8)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasionmisc5", oLoopLocation, FALSE);
   }
   else if(nRandom == 9)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasionmisc6", oLoopLocation, FALSE);
   }
   else if(nRandom == 10)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasionfire1", oLoopLocation, FALSE);
   }
   else if(nRandom == 11)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasionfire2", oLoopLocation, FALSE);
   }
   else if(nRandom == 12)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasionfire3", oLoopLocation, FALSE);
   }
   else if(nRandom == 13)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasionfire4", oLoopLocation, FALSE);
   }
   else if(nRandom == 14)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasiondebris1", oLoopLocation, FALSE);
   }
   else if(nRandom == 15)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasiondebris2", oLoopLocation, FALSE);
  }



}


void SpawnMob(object oArea, int nTotalMobs)
{
    object oCreature;
    object oObject;
    int nCount = 0;
    int iWidthInTiles;
    int iHeightInTiles;
    int iWidthInMeters;
    int iHeightInMeters;
    int iWidthInMetersRandom;
    int iHeightInMetersRandom;
    float  fXPosition;
    float  fYPosition;
    float  fZPosition;
    vector vRandomPos;
    vector vRandomPosN;
    vector vRandomPosS;
    vector vRandomPosE;
    vector vRandomPosW;
    vector vRandomPosNE;
    vector vRandomPosNW;
    vector vRandomPosSE;
    vector vRandomPosSW;
    float    fFacing;
    location lRandom;





    // General fodder creatures
    while(nCount < nTotalMobs)
    {

     // If a valid area was found, compute the random location.
    if(GetIsObjectValid(oArea))
    {
      // Determine the width and height of the area in tiles.
       iWidthInTiles  = GetAreaSize(AREA_WIDTH,  oArea);
       iHeightInTiles = GetAreaSize(AREA_HEIGHT, oArea);

      // Convert the width and height from tiles into meters.
       iWidthInMeters  = iWidthInTiles  * 10;
       iHeightInMeters = iHeightInTiles * 10;

      // Generate a random position in the area.
        iWidthInMetersRandom = Random(iWidthInMeters  * 10);
        iHeightInMetersRandom = Random(iHeightInMeters * 10);
        fXPosition = IntToFloat(iWidthInMetersRandom) / 10.0;
        fYPosition = IntToFloat(iHeightInMetersRandom) / 10.0;
        fZPosition = 0.0;
        vRandomPos = Vector(fXPosition, fYPosition, fZPosition);

      // Convert the random position to obtain the random location.
        fFacing = 0.0;
        lRandom = Location(oArea, vRandomPos, fFacing);
     }

      oCreature = CreateObject(OBJECT_TYPE_CREATURE,"invasioncreature", lRandom, FALSE);

    //Makes sure that the higher up creatures get placed, and if not the count doesnt go up
    if(GetIsObjectValid(oCreature))
    {
      // If the middle monster was successfully placed then spawn the group around it
      vRandomPosN = Vector(fXPosition, fYPosition + 1.0, fZPosition);
      vRandomPosS = Vector(fXPosition, fYPosition - 1.0, fZPosition);
      vRandomPosE = Vector(fXPosition + 1.0, fYPosition, fZPosition);;
      vRandomPosW = Vector(fXPosition - 1.0, fYPosition, fZPosition);;
      vRandomPosNE = Vector(fXPosition + 1.0, fYPosition + 1.0, fZPosition);;
      vRandomPosNW = Vector(fXPosition - 1.0, fYPosition + 1.0, fZPosition);;
      vRandomPosSE = Vector(fXPosition + 1.0, fYPosition - 1.0, fZPosition);;
      vRandomPosSW = Vector(fXPosition - 1.0, fYPosition - 1.0, fZPosition);;

      oCreature = CreateObject(OBJECT_TYPE_CREATURE,"invasioncreat002", Location(oArea, vRandomPosN, fFacing), FALSE);
      oCreature = CreateObject(OBJECT_TYPE_CREATURE,"invasioncreat002", Location(oArea, vRandomPosS, fFacing), FALSE);
      oCreature = CreateObject(OBJECT_TYPE_CREATURE,"invasioncreat002", Location(oArea, vRandomPosE, fFacing), FALSE);
      oCreature = CreateObject(OBJECT_TYPE_CREATURE,"invasioncreat001", Location(oArea, vRandomPosW, fFacing), FALSE);
      oCreature = CreateObject(OBJECT_TYPE_CREATURE,"invasioncreat001", Location(oArea, vRandomPosNE, fFacing), FALSE);
      oCreature = CreateObject(OBJECT_TYPE_CREATURE,"invasioncreat005", Location(oArea, vRandomPosNW, fFacing), FALSE);
      oCreature = CreateObject(OBJECT_TYPE_CREATURE,"invasioncreat001", Location(oArea, vRandomPosSE, fFacing), FALSE);
      oCreature = CreateObject(OBJECT_TYPE_CREATURE,"invasioncreature", Location(oArea, vRandomPosSW, fFacing), FALSE);


      nCount++;
    }

    }

}


void SpawnLieutentant(object oArea, int nTotalLieutenant)
{
    object oCreature;
    object oObject;
    int nCountLieutenant = 0;
    int iWidthInTiles;
    int iHeightInTiles;
    int iWidthInMeters;
    int iHeightInMeters;
    int iWidthInMetersRandom;
    int iHeightInMetersRandom;
    float  fXPosition;
    float  fYPosition;
    float  fZPosition;
    vector vRandomPos;
    vector vRandomPosN;
    vector vRandomPosS;
    vector vRandomPosE;
    vector vRandomPosW;
    vector vRandomPosNE;
    vector vRandomPosNW;
    vector vRandomPosSE;
    vector vRandomPosSW;
    float    fFacing;
    location lRandom;


     //Generating the higher up monsters
     while(nCountLieutenant < nTotalLieutenant)
    {

     // If a valid area was found, compute the random location.
    if(GetIsObjectValid(oArea))
    {
      // Determine the width and height of the area in tiles.
       iWidthInTiles  = GetAreaSize(AREA_WIDTH,  oArea);
       iHeightInTiles = GetAreaSize(AREA_HEIGHT, oArea);

      // Convert the width and height from tiles into meters.
       iWidthInMeters  = iWidthInTiles  * 10;
       iHeightInMeters = iHeightInTiles * 10;

      // Generate a random position in the area.
        fXPosition = IntToFloat(Random(iWidthInMeters  * 10)) / 10.0;
        fYPosition = IntToFloat(Random(iHeightInMeters * 10)) / 10.0;
        fZPosition = 0.0;
        vRandomPos = Vector(fXPosition, fYPosition, fZPosition);

      // Convert the random position to obtain the random location.
        fFacing = 0.0;
        lRandom = Location(oArea, vRandomPos, fFacing);
     }

    oCreature = CreateObject(OBJECT_TYPE_CREATURE,"invasioncreat003", lRandom, FALSE);

    //Makes sure that the higher up creatures get placed, and if not the count doesnt go up
    if(GetIsObjectValid(oCreature))
    {
       nCountLieutenant++;
    }

    }

}


void SpawnBoss(object oArea, int nTotalLieutenant)
{
    object oCreature;
    object oObject;
    object oModule = GetModule();
    int nCountBoss = 0;
    int iWidthInTiles;
    int iHeightInTiles;
    int iWidthInMeters;
    int iHeightInMeters;
    int iWidthInMetersRandom;
    int iHeightInMetersRandom;
    float  fXPosition;
    float  fYPosition;
    float  fZPosition;
    vector vRandomPos;
    vector vRandomPosN;
    vector vRandomPosS;
    vector vRandomPosE;
    vector vRandomPosW;
    vector vRandomPosNE;
    vector vRandomPosNW;
    vector vRandomPosSE;
    vector vRandomPosSW;
    float    fFacing;
    location lRandom;

    // Generates the boss mob
    while(nCountBoss < 1)
    {

     // If a valid area was found, compute the random location.
    if(GetIsObjectValid(oArea))
    {
      // Determine the width and height of the area in tiles.
       iWidthInTiles  = GetAreaSize(AREA_WIDTH,  oArea);
       iHeightInTiles = GetAreaSize(AREA_HEIGHT, oArea);

      // Convert the width and height from tiles into meters.
       iWidthInMeters  = iWidthInTiles  * 10;
       iHeightInMeters = iHeightInTiles * 10;

      // Generate a random position in the area.
        fXPosition = IntToFloat(Random(iWidthInMeters  * 10)) / 10.0;
        fYPosition = IntToFloat(Random(iHeightInMeters * 10)) / 10.0;
        fZPosition = 0.0;
        vRandomPos = Vector(fXPosition, fYPosition, fZPosition);

      // Convert the random position to obtain the random location.
        fFacing = 0.0;
        lRandom = Location(oArea, vRandomPos, fFacing);
     }

    oCreature = CreateObject(OBJECT_TYPE_CREATURE,"invasioncreat004", lRandom, FALSE);


    //Makes sure that the higher up creatures get placed, and if not the count doesnt go up
    if(GetIsObjectValid(oCreature))
    {
       nCountBoss++;
    }

    }
}


void MassWhisper(string sAreaName)
{
  object oPC =  GetFirstPC();

  while(GetIsObjectValid(oPC) == TRUE)
  {
    SendMessageToPC(oPC, "A monsterous crack and boom can be heard thundering across the isle. A portal spews forth a horde of demonic entities upon " + sAreaName + ". Rumors, and speculation quickly spread the isle as alarms are risen and to arms is called. This threat must be stomped out before they cause too much damage. ");
    oPC = GetNextPC();
  }

}

