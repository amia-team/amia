/*
 Special Trigger to remove a merc if players happen to sneak one out

*/


void main()
{
  object oTrigger = OBJECT_SELF;
  object oCritter = GetEnteringObject( );
  object oPC = GetMaster(oCritter);

  if(GetIsPC(oPC))
  {
   return;
  }

  string sTag = GetTag(oCritter);
  if(sTag=="henchmenmerc")
  {
   RemoveHenchman(oPC,oCritter);
  }

}
