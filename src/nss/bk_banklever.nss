/*
  Bank Lever Script

  - Maverick00053

*/


void main()
{

    object oLever       = OBJECT_SELF;
    object oPC          = GetItemActivator();
    object oDoor;
    object oBankChest;
    int nBankGroup;
    int nLeverGroup     = GetLocalInt(oLever, "group");
    int nDoorGroup;
    int nLockedState;
    int nCount = 1;
    int nBreak;

    // Runs a loop to check if the there is nearby chest open and if it matches with the same group
    oBankChest = GetNearestObjectByTag("BankerChest",oLever);
    nBankGroup = GetLocalInt(oBankChest, "group");
    while(GetIsObjectValid(oBankChest))
    {
      if(nBankGroup == nLeverGroup)
      {
        nBreak=1;
        break;
      }

      if(nBreak == 0)
      {
      oBankChest =  GetNearestObjectByTag("BankerChest",oLever,nCount);
      nBankGroup = GetLocalInt(oBankChest, "group");
      nCount++;
      }
    }

    // Runs a loop to lock/unlock the proper door.
    oDoor = GetNearestObjectByTag("BankDoor");
    nDoorGroup = GetLocalInt(oDoor, "group");
    nCount = 1;
    while(GetIsObjectValid(oDoor))
    {
    if(nDoorGroup == nLeverGroup)
    {
      nLockedState = GetLocked(oDoor);
      if(nLockedState != 1)
      {
      SetLocked(oDoor,1);
      AssignCommand(oDoor, ActionCloseDoor(oDoor));
      AssignCommand(oDoor, ActionSpeakString("*Door Locks*"));
      return;
      }
      else if(nLockedState == 1)
      {


      if(!GetIsObjectValid(oBankChest) || (nBreak == 0))
      {
        SetLocked(oDoor,0);
        AssignCommand(oDoor, ActionSpeakString("*Door Unlocks*"));
        return;
      }
      else
      {
        AssignCommand(oDoor, ActionSpeakString("*Cannot be unlocked till bank chest is despawned*"));
      }


      }
    }
    nCount++;
    oDoor = GetNearestObjectByTag("BankDoor",OBJECT_SELF,nCount);
    nDoorGroup = GetLocalInt(oDoor, "group");
    }
    //


}


