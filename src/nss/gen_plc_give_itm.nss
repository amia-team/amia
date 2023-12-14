/*
 Reusuable on use script for chests/items.

-Maverick00052 12/2/2023
*/

void main()
{
   object oPC = GetLastUsedBy();
   object oPLC = OBJECT_SELF;
   string sIdentifier = GetLocalString(oPLC,"identifier");
   string sResRef = GetLocalString(oPLC,"resref");
   int nUsedRecently = GetLocalInt(oPLC,sIdentifier+"identifier");
   float fDelay = GetLocalFloat(oPLC,"delay");

   if(nUsedRecently==0)
   {
     CreateItemOnObject(sResRef,oPC);
     SetLocalInt(oPLC,sIdentifier+"identifier",1);
     DelayCommand(fDelay,DeleteLocalInt(oPLC,sIdentifier+"identifier"));
   }
   else
   {
    SendMessageToPC(oPC,"You must wait a while before using this again");
   }
}
