/*
 Reusuable on use script for chests/items.

-Maverick00052 12/2/2023
*/

void main()
{
   object oPC = GetLastUsedBy();
   object oPLC = OBJECT_SELF;
   string sMessage = GetLocalString(oPLC,"message");
   string sResRef = GetLocalString(oPLC,"resref");
   int nUsedRecently = GetLocalInt(oPLC,"block");
   float fDelay = GetLocalFloat(oPLC,"delay");

   if(nUsedRecently==0)
   {
     CreateItemOnObject(sResRef,oPC);
     SetLocalInt(oPLC,"block",1);
     if(sMessage != "")
     {
      SendMessageToPC(oPC,sMessage);
     }
     DelayCommand(fDelay,DeleteLocalInt(oPLC,"block"));
   }
   else
   {
    SendMessageToPC(oPC,"You must wait a while before using this again");
   }
}
