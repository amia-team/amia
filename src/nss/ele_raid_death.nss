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
    else if((sResRef == "elemental_raid_6") && (GetLocalInt(oCritter,"epicDrop")==1))
    {
      AssignCommand(oCritter,SpeakString("*The elemental crumbles in defeat and it appears that a useful object remains buried in its chest!*"));
    }
}


void Spawn(string sCreature, location lLocation)
{
  effect eVisE = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_FIRE);
  object oCritterS1 = CreateObject(OBJECT_TYPE_CREATURE,sCreature,lLocation);
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVisE,lLocation);

  if(sCreature=="elemental_raid_6")
  {
   int nRan = Random(100) + 1;

   if(nRan <= 15)
   {
     object oEpic = GenerateEpicLootReturn(oCritterS1);
     SetLocalInt(oCritterS1,"epicDrop",1);
     SetDroppableFlag(oEpic,TRUE);
   }
  }
}


