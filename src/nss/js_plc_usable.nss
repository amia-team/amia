/*
    Toggles if job system PLC placables are useable or not

*/


void main()
{
   object oPC = OBJECT_SELF;
   int nToggle = GetLocalInt(oPC,"plctoggle");

   if(nToggle==1)
   {
    DeleteLocalInt(oPC,"plctoggle");
   }
   else
   {
    SetLocalInt(oPC,"plctoggle",1);
   }


}
