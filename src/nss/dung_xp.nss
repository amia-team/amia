/*
   Script that gives xp for dynamic dungeon tools

 - Maverick00053 11/12/2023
*/

void main()
{
    object oUnlockPC = GetLastUnlocked();
    if(!GetIsObjectValid(oUnlockPC)) oUnlockPC = GetLastDisarmed();
    object oObject = OBJECT_SELF;
    int nOpened = GetLocalInt(oObject,"unlockedfirst");

    int nPCLevel = GetLevelByPosition(1,oUnlockPC) + GetLevelByPosition(2,oUnlockPC) + GetLevelByPosition(3,oUnlockPC);
    int nLevel = GetLocalInt(oObject,"level");
    if((nPCLevel < 30) && (nOpened == 0))
    {
     SetXP(oUnlockPC,GetXP(oUnlockPC) + (100+nLevel*10));
     SetLocalInt(oObject,"unlockedfirst",1);
    }
    else if((nPCLevel == 30) && (nOpened == 0))
    {
     GiveXPToCreature(oUnlockPC,1);
    }
}
