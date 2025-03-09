/*
  Laser Puzzle Used - Convo Script
- Maverick00053

*/

void LaunchConvo( object oPC, object oPLC);

void main()
{
   object oPC = GetLastUsedBy();
   object oPLC = OBJECT_SELF;

   LaunchConvo(oPC,oPLC);

}

void LaunchConvo( object oPC, object oPLC)
{
    AssignCommand(oPC, ActionStartConversation(oPLC, "c_laser_puzz", TRUE, FALSE));
}


