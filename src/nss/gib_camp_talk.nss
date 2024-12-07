/*
 Special Trigger to display message when entering Gibberling Camp
*/


void main()
{
  object oTrigger = OBJECT_SELF;
  object oPC = GetEnteringObject( );

  if(!GetIsPC(oPC))
  {
   return;
  }

  if((GetLocalInt(oTrigger,"delay")==1) ||(GetLocalInt(oPC,"gibgreeting")==1))
  {
   return;
  }

  object oLeader = GetObjectByTag("GibLeader");
  DelayCommand(0.5,AssignCommand(oLeader,ActionSpeakString("Come speak with me when you have a moment! *Gabriel waves you over*")));
  SetLocalInt(oTrigger,"delay",1);
  SetLocalInt(oPC,"gibgreeting",1);
  DelayCommand(60.0, DeleteLocalInt(oTrigger,"delay"));
}
