/*
    Positive Elemental Boss - Exit Portal Script


*/


void main()
{
     object oPC = GetLastUsedBy();
     object oArea = GetArea(oPC);
     object oLoop = GetFirstObjectInArea(oArea);
     object oWayP = GetWaypointByTag("eleexitportal");
     int nInValid;

     while(GetIsObjectValid(oLoop))
     {

       if(GetObjectType(oLoop) == OBJECT_TYPE_CREATURE)
       {
          if((GetResRef(oLoop) == "elemental_raid_1") || (GetResRef(oLoop) == "elemental_raid_2") || (GetResRef(oLoop) == "elemental_raid_3")
           || (GetResRef(oLoop) == "elemental_raid_4") || (GetResRef(oLoop) == "elemental_raid_5") || (GetResRef(oLoop) == "elemental_raid_6")
            || (GetResRef(oLoop) == "elemental_raid_7"))
            {
               nInValid = 1;
               break;
            }
       }

       oLoop = GetNextObjectInArea(oLoop);
     }

     if(nInValid == 1)
     {
       SpeakString("*The crystal fails to activate*");
       return;
     }

     SpeakString("*The crystal shatters as it activates, creating a portal nearby*");
     CreateObject(OBJECT_TYPE_PLACEABLE,"ele_jump_portal",GetLocation(oWayP));
     // Removes the variable on the raid summoner when the boss "dies" so it can be summoned again
     object oRaidSpawner = GetObjectByTag("raidsummonerele");
     DeleteLocalInt(oRaidSpawner,"bossOut");
     //
     DestroyObject(OBJECT_SELF,1.0);


}
