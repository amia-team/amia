/*
 This script is a simple statue interaction script that will give the player an object.
 Used in the actland epic dungeon.

-Maverick00052 11/20/2023
*/

void main()
{
   object oPC = GetLastUsedBy();
   object oStatue = OBJECT_SELF;
   string sIdentifier = GetLocalString(oStatue,"identifier");
   string sResRef = GetLocalString(oStatue,"resref");
   int nUsedRecently = GetLocalInt(oStatue,sIdentifier+"identifier");

   if(nUsedRecently==0)
   {
     CreateItemOnObject(sResRef,oPC);
     SetLocalInt(oStatue,sIdentifier+"identifier",1);
     DelayCommand(300.0,DeleteLocalInt(oStatue,sIdentifier+"identifier"));
   }
   else
   {
    SendMessageToPC(oPC,"You must wait a while before receiving another blessing");
   }




}
