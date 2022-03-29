/*
   Trap script for the Spider Egg Sack
*/

#include "ds_ai2_include"

void main()
{
  object oEgg = OBJECT_SELF;
  object oNearby = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC,oEgg);
  string sOwnerName = GetLocalString(oEgg,"owner");

  if((GetDistanceBetween(oEgg,oNearby) < 5.0) && GetIsObjectValid(oNearby) && (GetName(oNearby) != sOwnerName))
  {
    AssignCommand(OBJECT_SELF,ActionSpeakString("*Egg sack suddenly ruptures and spiderlings spill out*"));
    CreateObject(OBJECT_TYPE_CREATURE,"hunter_spiderlin",GetAheadLeftLocation(oEgg));
    CreateObject(OBJECT_TYPE_CREATURE,"hunter_spiderlin",GetAheadRightLocation(oEgg));
    CreateObject(OBJECT_TYPE_CREATURE,"hunter_spiderlin",GetFlankingLeftLocation(oEgg));
    CreateObject(OBJECT_TYPE_CREATURE,"hunter_spiderlin",GetFlankingRightLocation(oEgg));
    CreateObject(OBJECT_TYPE_CREATURE,"hunter_spiderlin",GetAheadLocation(oEgg));
    DestroyObject(oEgg,1.0);
  }
}
