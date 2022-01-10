//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ele_raid_death


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_ondeath"
#include "ds_ai2_include"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void Spawner(object oCritter, object oKiller);
void Spawn(string sCreature, location lLocation);
void RollLoot(location lLocation, object oCritter);

void main(){

    object oCritter = OBJECT_SELF;
    object oKiller = GetLastKiller();

    Spawner(oCritter, oKiller);
}


void Spawner(object oCritter, object oKiller)
{
    string sResRef = GetResRef(oCritter);
    location lLocation = GetLocation(oCritter);

    if(sResRef == "elemental_raid_1")
    {
      DelayCommand(2.0,Spawn("elemental_raid_2", GetStepLeftLocation(oCritter)));
      DelayCommand(2.0,Spawn("elemental_raid_2", GetStepRightLocation(oCritter)));
      AssignCommand(oCritter,SpeakString("*The elemental crumbles in defeat, but quickly thereafter two halves stand up and begin to fight*"));
    }
    else if(sResRef == "elemental_raid_2")
    {
      DelayCommand(2.0,Spawn("elemental_raid_3", GetStepLeftLocation(oCritter)));
      DelayCommand(2.0,Spawn("elemental_raid_3", GetStepRightLocation(oCritter)));
      AssignCommand(oCritter,SpeakString("*The elemental crumbles in defeat, but quickly thereafter two halves stand up and begin to fight*"));
    }
    else if(sResRef == "elemental_raid_3")
    {
      DelayCommand(2.0,Spawn("elemental_raid_4", GetStepLeftLocation(oCritter)));
      DelayCommand(2.0,Spawn("elemental_raid_4", GetStepRightLocation(oCritter)));
      AssignCommand(oCritter,SpeakString("*The elemental crumbles in defeat, but quickly thereafter two halves stand up and begin to fight*"));
    }
    else if(sResRef == "elemental_raid_4")
    {
      DelayCommand(2.0,Spawn("elemental_raid_5", GetStepLeftLocation(oCritter)));
      DelayCommand(2.0,Spawn("elemental_raid_5", GetStepRightLocation(oCritter)));
      AssignCommand(oCritter,SpeakString("*The elemental crumbles in defeat, but quickly thereafter two halves stand up and begin to fight*"));
    }
    else if(sResRef == "elemental_raid_5")
    {
      DelayCommand(2.0,Spawn("elemental_raid_6", GetStepLeftLocation(oCritter)));
      DelayCommand(2.0,Spawn("elemental_raid_6", GetStepRightLocation(oCritter)));
      AssignCommand(oCritter,SpeakString("*The elemental crumbles in defeat, but quickly thereafter two halves stand up and begin to fight*"));
    }
    else if(sResRef == "elemental_raid_6")
    {
      RollLoot(lLocation, oCritter);
    }

}


void Spawn(string sCreature, location lLocation)
{
  effect eVisE = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_FIRE);
  object oCritterS1 = CreateObject(OBJECT_TYPE_CREATURE,sCreature,lLocation);
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVisE,lLocation);
}

void RollLoot(location lLocation, object oCritter)
{
  int nRan = Random(100) + 1;
  int nRan2 = Random(200) + 1;
  object oChest;

  if(nRan <= 10)  // 10% of Epic Loot
  {
     oChest = CreateObject(OBJECT_TYPE_PLACEABLE,"ele_loot",lLocation);
     AssignCommand(oCritter,SpeakString("*There is something gleaming in the remains*"));
     GenerateEpicLoot(oChest);
  }

  if(nRan2 == 1) // .5% of Ioun
  {
     if(!GetIsObjectValid(oChest))
     {
      oChest = CreateObject(OBJECT_TYPE_PLACEABLE,"ele_loot",lLocation);
     }

     AssignCommand(oCritter,SpeakString("*There is something gleaming in the remains*"));

     int nRanStone = Random(12)+1;
     string sStone;

     switch(nRanStone)
     {
       case 1: sStone = "is_chryso"; break;
       case 2: sStone = "is_iol"; break;
       case 3: sStone = "is_lavender"; break;
       case 4: sStone = "is_purp"; break;
       case 5: sStone = "is_whit"; break;
       case 6: sStone = "x2_is_blue"; break;
       case 7: sStone = "x2_is_deepred"; break;
       case 8: sStone = "x2_is_drose"; break;
       case 9: sStone = "x2_is_paleblue"; break;
       case 10: sStone = "x2_is_pink"; break;
       case 11: sStone = "x2_is_pandgreen"; break;
       case 12: sStone = "x2_is_sandblue"; break;
     }

     CreateItemOnObject(sStone,oChest);
  }

}
