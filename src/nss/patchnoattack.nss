//::///////////////////////////////////////////////
//:: patchnoattack
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Derrick's script to make combat dummies not attack
    you.

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void main()
{
    object oPC = GetLastAttacker();
    SetIsTemporaryFriend(oPC,OBJECT_SELF,FALSE,0.01);
    DelayCommand(0.01,SetIsTemporaryEnemy(oPC));
}
