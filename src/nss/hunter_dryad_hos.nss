

void main()
{

   object oPC = GetPCSpeaker();
   AssignCommand(OBJECT_SELF,ActionSpeakString("Then I shall remove you from this place!"));
   AdjustReputation(oPC,OBJECT_SELF,-100);
   AssignCommand(OBJECT_SELF,ActionAttack(oPC));

}
