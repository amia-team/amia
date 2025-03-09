/*
  Alphabet Puzzle Generation Script  - On Use Script for Puzzle PLC
- Maverick00053

*/

void LaunchConvoActivate( object oPC, object oPLC);
void LaunchConvoActivated( object oPC, object oPLC);

void main()
{
   object oPC = GetLastUsedBy();
   object oPLC = OBJECT_SELF;
   int nActivated = GetLocalInt(oPLC,"activated");

   if(nActivated != 1)
   {
    LaunchConvoActivate(oPC,oPLC);
   }
   else
   {
    LaunchConvoActivated(oPC,oPLC);
   }

}

void LaunchConvoActivate( object oPC, object oPLC)
{
    AssignCommand(oPC, ActionStartConversation(oPLC, "c_alphabet_puz", TRUE, FALSE));
}

void LaunchConvoActivated( object oPC, object oPLC)
{
    AssignCommand(oPC, ActionStartConversation(oPLC, "c_alphabet_act", TRUE, FALSE));
}

