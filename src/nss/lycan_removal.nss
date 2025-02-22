/*
   Lycan Removal
   ------------
   Lycan Infection Removal

   12/7/23 - Maverick00053
*/

#include "nwnx_feat"
#include "nwnx_creature"
#include "x2_inc_spellhook"

//Lycan infection removal for spells, etc.
void RemoveLycanInfection(object oPC);

//void main(){}

void RemoveLycanInfection(object oPC)
{
  int nInfectedCheck = GetPCKEYValue(oPC,"lycanInfected");

  if((GetLevelByClass(53,oPC)==0))
  {
    if(GetHasFeat(1249,oPC) == TRUE)
    {
      NWNX_Creature_RemoveFeat(oPC,1249);
      DeletePCKEYValue(oPC,"lycanInfected");
      SendMessageToPC(oPC,"You are cured of the lycanthrope disease running its way through your veins!");
    }
    else if(GetHasFeat(1250,oPC) == TRUE)
    {
      NWNX_Creature_RemoveFeat(oPC,1250);
      DeletePCKEYValue(oPC,"lycanInfected");
      SendMessageToPC(oPC,"You are cured of the lycanthrope disease running its way through your veins!");
    }
    else if(GetHasFeat(1251,oPC) == TRUE)
    {
      NWNX_Creature_RemoveFeat(oPC,1251);
      DeletePCKEYValue(oPC,"lycanInfected");
      SendMessageToPC(oPC,"You are cured of the lycanthrope disease running its way through your veins!");
    }
    else if(GetHasFeat(1252,oPC) == TRUE)
    {
      NWNX_Creature_RemoveFeat(oPC,1252);
      DeletePCKEYValue(oPC,"lycanInfected");
      SendMessageToPC(oPC,"You are cured of the lycanthrope disease running its way through your veins!");
    }
    else if(GetHasFeat(1253,oPC) == TRUE)
    {
      NWNX_Creature_RemoveFeat(oPC,1253);
      DeletePCKEYValue(oPC,"lycanInfected");
      SendMessageToPC(oPC,"You are cured of the lycanthrope disease running its way through your veins!");
    }
    else if(GetHasFeat(1254,oPC) == TRUE)
    {
      NWNX_Creature_RemoveFeat(oPC,1254);
      DeletePCKEYValue(oPC,"lycanInfected");
      SendMessageToPC(oPC,"You are cured of the lycanthrope disease running its way through your veins!");
    }
    else if(GetHasFeat(1276,oPC) == TRUE)
    {
      NWNX_Creature_RemoveFeat(oPC,1276);
      DeletePCKEYValue(oPC,"lycanInfected");
      SendMessageToPC(oPC,"You are cured of the lycanthrope disease running its way through your veins!");
    }
    else if(GetHasFeat(1329,oPC) == TRUE)
    {
      NWNX_Creature_RemoveFeat(oPC,1329);
      DeletePCKEYValue(oPC,"lycanInfected");
      SendMessageToPC(oPC,"You are cured of the lycanthrope disease running its way through your veins!");
    }
    else if(GetHasFeat(1330,oPC) == TRUE)
    {
      NWNX_Creature_RemoveFeat(oPC,1330);
      DeletePCKEYValue(oPC,"lycanInfected");
      SendMessageToPC(oPC,"You are cured of the lycanthrope disease running its way through your veins!");
    }
    else if(GetHasFeat(1331,oPC) == TRUE)
    {
      NWNX_Creature_RemoveFeat(oPC,1331);
      DeletePCKEYValue(oPC,"lycanInfected");
      SendMessageToPC(oPC,"You are cured of the lycanthrope disease running its way through your veins!");
    }
    else if(GetHasFeat(1332,oPC) == TRUE)
    {
      NWNX_Creature_RemoveFeat(oPC,1332);
      DeletePCKEYValue(oPC,"lycanInfected");
      SendMessageToPC(oPC,"You are cured of the lycanthrope disease running its way through your veins!");
    }
    else if(GetHasFeat(1333,oPC) == TRUE)
    {
      NWNX_Creature_RemoveFeat(oPC,1333);
      DeletePCKEYValue(oPC,"lycanInfected");
      SendMessageToPC(oPC,"You are cured of the lycanthrope disease running its way through your veins!");
    }
    else if(nInfectedCheck==1)
    {
      NWNX_Creature_RemoveFeat(oPC,1249);
      NWNX_Creature_RemoveFeat(oPC,1250);
      NWNX_Creature_RemoveFeat(oPC,1251);
      NWNX_Creature_RemoveFeat(oPC,1252);
      NWNX_Creature_RemoveFeat(oPC,1253);
      NWNX_Creature_RemoveFeat(oPC,1254);
      NWNX_Creature_RemoveFeat(oPC,1276);
      NWNX_Creature_RemoveFeat(oPC,1329);
      NWNX_Creature_RemoveFeat(oPC,1330);
      NWNX_Creature_RemoveFeat(oPC,1331);
      NWNX_Creature_RemoveFeat(oPC,1332);
      NWNX_Creature_RemoveFeat(oPC,1333);
      DeletePCKEYValue(oPC,"lycanInfected");
      SendMessageToPC(oPC,"You are cured of the lycanthrope disease running its way through your veins!");
    }
  }

}
