/*
  Laser VFX Generation Script
  - Mav, 2/23/25
*/
object HasKeyOne(object oPC, object oSourcePLC);

object HasKeyTwo(object oPC, object oSourcePLC);

void UnLockDoor(object oDoor, object oSourcePLC);

void RelockDoor(object oDoor, object oSourcePLC);

void DeleteVariables(object oTarget);

void RemoveEffectVFX(object oTarget);

void StartPuzzle(object oSourcePLC);

void main()
{
  object oPC = GetLastUsedBy();
  object oSourcePLC = OBJECT_SELF;
  object oArea = GetArea(oSourcePLC);
  object oKey1 = HasKeyOne(oPC,oSourcePLC);
  object oKey2 = HasKeyTwo(oPC,oSourcePLC);
  string sID1 = GetLocalString(oSourcePLC,"puzzleid1");
  string sID2 = GetLocalString(oSourcePLC,"puzzleid2");
  string sDoorTag = GetLocalString(oSourcePLC,"door");
  effect eVis = EffectVisualEffect(184);


  if((GetLocalInt(oArea,sID1)==1) && (GetLocalInt(oArea,sID2)==1))
  {
   if(GetLocalInt(oSourcePLC,"finished")==0)
   {
    UnLockDoor(GetObjectByTag(sDoorTag),oSourcePLC);
    AssignCommand(oSourcePLC,ActionSpeakString("<c ¿ >**As you touch the statue once more you hear a click and the distant groaning of a door being unlocked. The keys locked in place disintegrate**</c>"));
    SetLocalInt(oSourcePLC,"finished",1);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oSourcePLC);
   }
   else
   {
    AssignCommand(oSourcePLC,ActionSpeakString("<c ¿ >**As you touch the statue it remains entirely unresponsive**</c>"));
   }
  }
  else if(GetLocalInt(oSourcePLC,"active")==1)
  {
    AssignCommand(oSourcePLC,ActionSpeakString("<c ¿ >**The two keys are still firmly locked in place. It is completely unresponsive otherwise.**</c>"));
  }
  else if(GetIsObjectValid(oKey1) && GetIsObjectValid(oKey2))
  {
    SetLocalInt(oSourcePLC,"active",1);
    AssignCommand(oSourcePLC,ActionSpeakString("<c ¿ >**The statue shimmers and magic echos through the hall as beams of power are activated on either side of the statue. The keys lock into place.**</c>"));
    DestroyObject(oKey1);
    DestroyObject(oKey2);
    StartPuzzle(oSourcePLC);
    DeleteLocalInt(oArea,sID1+"locked");
    DeleteLocalInt(oArea,sID2+"locked");
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oSourcePLC);

  }
  else if(GetIsObjectValid(oKey1) || GetIsObjectValid(oKey2))
  {
    AssignCommand(oSourcePLC,ActionSpeakString("<c ¿ >**You appear to be missing the other key**</c>"));
  }
  else
  {
    AssignCommand(oSourcePLC,ActionSpeakString("<c ¿ >**The statue appears to have two open mouths for keys. It appears completely unresponsive otherwise.**</c>"));
  }

}

object HasKeyOne(object oPC, object oSourcePLC)
{
  string sKey1 = GetLocalString(oSourcePLC,"key1");
  object oNothing;
  int nCount = 0;

  object oInventoryItem = GetFirstItemInInventory(oPC);

  while(GetIsObjectValid(oInventoryItem))
  {
    if((GetResRef(oInventoryItem)==sKey1))
    {
      return oInventoryItem;
      break;
    }
   oInventoryItem = GetNextItemInInventory(oPC);
  }

  return oNothing;
}


object HasKeyTwo(object oPC, object oSourcePLC)
{
  string sKey2 = GetLocalString(oSourcePLC,"key2");
  object oNothing;
  int nCount = 0;

  object oInventoryItem = GetFirstItemInInventory(oPC);

  while(GetIsObjectValid(oInventoryItem))
  {
    if((GetResRef(oInventoryItem)==sKey2))
    {
      return oInventoryItem;
      break;
    }
   oInventoryItem = GetNextItemInInventory(oPC);
  }

  return oNothing;
}

void UnLockDoor(object oDoor, object oSourcePLC)
{
 SetLocked(oDoor,FALSE);
 DelayCommand(30.0,RelockDoor(oDoor,oSourcePLC));
}

void RelockDoor(object oDoor, object oSourcePLC)
{
  object oArea = GetArea(oDoor);
  string sID1 = GetLocalString(oSourcePLC,"puzzleid1");
  string sID2 = GetLocalString(oSourcePLC,"puzzleid2");

  object oStatue1 = GetObjectByTag("laser1");
  object oStatue2 = GetObjectByTag("laser2");
  object oStatue3 = GetObjectByTag("laser3");
  object oStatue4 = GetObjectByTag("laser4");
  object oStatue5 = GetObjectByTag("laser5");
  object oStatue6 = GetObjectByTag("laser6");
  object oStatue7 = GetObjectByTag("laser7");
  object oStatue8 = GetObjectByTag("laser8");
  object oStatue9 = GetObjectByTag("laser21");
  object oStatue10 = GetObjectByTag("laser22");
  object oStatue11 = GetObjectByTag("laser23");
  object oStatue12 = GetObjectByTag("laser24");
  object oStatue13 = GetObjectByTag("laser25");
  object oStatue14 = GetObjectByTag("laser26");
  object oStatue15 = GetObjectByTag("laser27");
  object oStatue16 = GetObjectByTag("laser28");

  object oStart1 = GetObjectByTag("laserstart1");
  object oStart2 = GetObjectByTag("laserstart2");
  object oEnd1 = GetObjectByTag("laserend1");
  object oEnd2 = GetObjectByTag("laserend2");
  object oOrb1 = GetObjectByTag("floatingorb1");
  object oOrb2 = GetObjectByTag("floatingorb2");

  RemoveEffectVFX(oStatue1);
  DeleteVariables(oStatue1);
  RemoveEffectVFX(oStatue15);
  DeleteVariables(oStatue15);
  ExecuteScript("laser_puz_remove",oStatue1);
  ExecuteScript("laser_puz_remove",oStatue15);
  RemoveEffectVFX(oStart1);
  RemoveEffectVFX(oStart2);
  RemoveEffectVFX(oEnd1);
  RemoveEffectVFX(oEnd2);
  RemoveEffectVFX(oOrb1);
  RemoveEffectVFX(oOrb2);

  SetFacing(0.0,oStatue1);
  SetFacing(0.0,oStatue2);
  SetFacing(0.0,oStatue3);
  SetFacing(0.0,oStatue4);
  SetFacing(0.0,oStatue9);
  SetFacing(0.0,oStatue10);
  SetFacing(0.0,oStatue11);
  SetFacing(0.0,oStatue12);

  SetFacing(180.0,oStatue5);
  SetFacing(180.0,oStatue6);
  SetFacing(180.0,oStatue7);
  SetFacing(180.0,oStatue8);
  SetFacing(180.0,oStatue13);
  SetFacing(180.0,oStatue14);
  SetFacing(180.0,oStatue15);
  SetFacing(180.0,oStatue16);


  SetLocked(oDoor,TRUE);
  AssignCommand(oDoor,ActionSpeakString("<c ¿ >**The door relocks and the barrier appears again**</c>"));
  AssignCommand(oDoor,ActionCloseDoor(oDoor));

  DeleteLocalInt(oArea,sID1);
  DeleteLocalInt(oArea,sID2);
  DeleteLocalInt(oSourcePLC,"active");
  DeleteLocalInt(oSourcePLC,"finished");

}

void DeleteVariables(object oTarget)
{
  DeleteLocalInt(oTarget,"active");
  DeleteLocalString(oTarget,"source");
}

void RemoveEffectVFX(object oTarget)
{
  effect eLoop = GetFirstEffect(oTarget);
  while(GetIsEffectValid(eLoop))
  {
   RemoveEffect(oTarget,eLoop);
   eLoop = GetNextEffect(oTarget);
  }
}


void StartPuzzle(object oSourcePLC)
{
   effect eVis1 = EffectVisualEffect(VFX_DUR_AURA_ORANGE);
   effect eVis2 = EffectVisualEffect(VFX_DUR_AURA_BLUE);
   object oStarting1 = GetObjectByTag("laserstart1");
   object oStarting2 = GetObjectByTag("laserstart2");
   object oEnding1 = GetObjectByTag("laserend1");
   object oEnding2 = GetObjectByTag("laserend2");
   object oOrb1 = GetObjectByTag("floatingorb1");
   object oOrb2 = GetObjectByTag("floatingorb2");

   ApplyEffectToObject(DURATION_TYPE_PERMANENT,eVis1,oEnding1);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT,eVis2,oEnding2);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT,eVis1,oOrb1);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT,eVis2,oOrb2);

   ExecuteScript("laser_main",oStarting1);

   ExecuteScript("laser_main",oStarting2);


}
