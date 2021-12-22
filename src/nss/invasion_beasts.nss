/*
   Beastmen Invasion

   07/31/19 - Maverick00053

   Randomly generates a Beastmen invasion encounter on area.


*/
#include "cs_inc_leto"
#include "amia_include"
#include "nwnx_areas"

void SpawnPRLCheck(object oArea, int nTotalPRL);
void SpawnPRL(object oArea, int nTotalPRL);
void CreatePRL(location oLoopLocation);
void SpawnMob(object oArea, int nTotalMobs);
void SpawnLieutentant(object oArea, int nTotalLieutenant);
void SpawnBoss(object oArea, int nTotalLieutenant);
void MassWhisper(string sAreaName);

void main()
{

    object oArea = GetAreaByResRef("nx_ds_minbridge");
    object oModule = GetModule();
    string sAreaName = GetName(oArea);
    int nTotalLieutenant;

    /* // Below is not used right now but keeping it here for future changes.
    int nWidthInTiles  = GetAreaSize(AREA_WIDTH,  oArea);;
    int nHeightInTiles = GetAreaSize(AREA_HEIGHT, oArea);;
    int nAreaTiles = nWidthInTiles*nHeightInTiles;
    */

    int nAreaSize;
    int nTotalPRL;
    int nTotalMobs;

    // Create the Area below for the invasion

        if(oArea == OBJECT_INVALID)
        {
          oArea = AREAS_CreateArea("nx_ds_minbridge");
          SetLocalInt(oArea,"no_spawn", 1);
          SetLocalInt(oArea,"NoDestroy", 1);
        }
        else if(oArea != OBJECT_INVALID)
        {
          SetLocalInt(oArea,"no_spawn", 1);
          SetLocalInt(oArea,"NoDestroy", 1);
        }
        else
        {
          return;
        }



   //

    if(GetLocalInt(oArea,"invasion_area") != 1)
    {

    nTotalLieutenant = Random(4) + 8;
    nTotalPRL = 150;
    nTotalMobs = Random(9) + 11;

    //

    DelayCommand(65.0,MassWhisper(sAreaName));

    SendMessageToAllDMs("// Launching Beastmen Invasion Script. Give just over 60 seconds for the entire program to launch. Server Message will announce when ready.");

    DelayCommand(15.0,SendMessageToAllDMs("// Launching Beastmen PLC Spawns"));

    DelayCommand(30.0,SendMessageToAllDMs("// Launching Beastmen Mob Spawns"));

    DelayCommand(45.0,SendMessageToAllDMs("// Launching Beastmen Lieutenant Spawns"));

    DelayCommand(60.0,SendMessageToAllDMs("// Launching Orc Boss Spawn"));

    //
    //

    SpawnPRLCheck(oArea, nTotalPRL);

    DelayCommand(15.0,SpawnPRL(oArea, nTotalPRL));

    DelayCommand(30.0,SpawnMob(oArea, nTotalMobs));

    DelayCommand(45.0,SpawnLieutentant(oArea, nTotalLieutenant));

    DelayCommand(60.0,SpawnBoss(oArea, nTotalLieutenant));

    SetLocalInt(oArea,"invasion_area", 1);
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



   nRandom = Random(11);

   if(nRandom == 0)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasioncorpse1", oLoopLocation, FALSE);
   }
   else if(nRandom == 1)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasionmisc3", oLoopLocation, FALSE);
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
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasionmisc5", oLoopLocation, FALSE);
   }
   else if(nRandom == 5)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasiondebris1", oLoopLocation, FALSE);
   }
   else if(nRandom == 6)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasioncamp", oLoopLocation, FALSE);
   }
   else if(nRandom == 7)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasiondebris1", oLoopLocation, FALSE);
   }
   else if(nRandom == 8)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasioncamp", oLoopLocation, FALSE);
   }
   else if(nRandom == 9)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasionmisc3", oLoopLocation, FALSE);
   }
   else if(nRandom == 10)
   {
     CreateObject(OBJECT_TYPE_PLACEABLE,"invasionmisc3", oLoopLocation, FALSE);
   }
}


void SpawnMob(object oArea, int nTotalMobs)
{
    object oCreature1;
    object oCreature2;
    object oCreature3;
    object oCreature4;
    object oCreature5;
    object oCreature6;
    object oCreature7;
    object oCreature8;
    object oCreature9;
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

      oCreature1 = CreateObject(OBJECT_TYPE_CREATURE,"beasthero", lRandom, FALSE);

    //Makes sure that the higher up creatures get placed, and if not the count doesnt go up
    if(GetIsObjectValid(oCreature1))
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



      oCreature2 = CreateObject(OBJECT_TYPE_CREATURE,"beastbard", Location(oArea, vRandomPosN, fFacing), FALSE);
      oCreature3 = CreateObject(OBJECT_TYPE_CREATURE,"elitebeastarcher", Location(oArea, vRandomPosS, fFacing), FALSE);
      oCreature4 = CreateObject(OBJECT_TYPE_CREATURE,"beastshaman", Location(oArea, vRandomPosE, fFacing), FALSE);
      oCreature5 = CreateObject(OBJECT_TYPE_CREATURE,"elitebeastarcher", Location(oArea, vRandomPosW, fFacing), FALSE);
      oCreature6 = CreateObject(OBJECT_TYPE_CREATURE,"beastmonk", Location(oArea, vRandomPosNE, fFacing), FALSE);
      oCreature7 = CreateObject(OBJECT_TYPE_CREATURE,"beastmanchampion", Location(oArea, vRandomPosNW, fFacing), FALSE);
      oCreature8 = CreateObject(OBJECT_TYPE_CREATURE,"beastmanchampion", Location(oArea, vRandomPosSE, fFacing), FALSE);
      oCreature9 = CreateObject(OBJECT_TYPE_CREATURE,"beastmonk", Location(oArea, vRandomPosSW, fFacing), FALSE);


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



     oCreature = CreateObject(OBJECT_TYPE_CREATURE,"beastguard", lRandom, FALSE);


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

    oCreature = CreateObject(OBJECT_TYPE_CREATURE,"invasionbeastbs", lRandom, FALSE);


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
    SendMessageToPC(oPC, "-----");
    SendMessageToPC(oPC, "-----");
    SendMessageToPC(oPC, "News quickly spreads of an amassing army of Beastmen in Nexus: Minmar Bridge. They must be stopped before it is too late!");
    SendMessageToPC(oPC, "-----");
    SendMessageToPC(oPC, "-----");
    oPC = GetNextPC();
  }

}

