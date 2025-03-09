/*
   Djinni Door Scripts
   - Mav, March 2025
*/

object HasKeyOne(object oPC, object oDoor);

object HasKeyTwo(object oPC, object oDoor);

void RelockDoor(object oDoor);

void main()
{
  object oPC = GetClickingObject();
  object oDoor = OBJECT_SELF;
  object oKey1 = HasKeyOne(oPC,oDoor);
  object oKey2 = HasKeyTwo(oPC,oDoor);

  if(GetIsObjectValid(oKey1) && GetIsObjectValid(oKey2))
  {
    AssignCommand(oDoor,ActionSpeakString("<c ¿ >**The barrier around the door shimmers and disappears. It won't remain down forever.**</c>"));
    DestroyObject(oKey1);
    DestroyObject(oKey2);
    SetLocked(oDoor,FALSE);
    DelayCommand(300.0,RelockDoor(oDoor));
  }
  else if(GetIsObjectValid(oKey1) || GetIsObjectValid(oKey2))
  {
    AssignCommand(oDoor,ActionSpeakString("<c ¿ >**The barrier responds briefly. You appear to be missing another key**</c>"));
  }
  else
  {
    AssignCommand(oDoor,ActionSpeakString("<c ¿ >**The barrier rejects your attempts to open the door**</c>"));
  }

}

object HasKeyOne(object oPC, object oDoor)
{
  string sKey1 = GetLocalString(oDoor,"key1");
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


object HasKeyTwo(object oPC, object oDoor)
{
  string sKey2 = GetLocalString(oDoor,"key2");
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

void RelockDoor(object oDoor)
{
  SetLocked(oDoor,TRUE);
  AssignCommand(oDoor,ActionSpeakString("<c ¿ >**The door relocks and the barrier appears again**</c>"));
  AssignCommand(oDoor,ActionCloseDoor(oDoor));
}
