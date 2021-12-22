void main()
{
object oPC = GetEnteringObject();
object oNPC = GetObjectByTag("FemaleSlave");
vector vAngle = GetPosition(oPC);

AssignCommand(oNPC, ClearAllActions(TRUE));
AssignCommand(oNPC, SetFacingPoint(vAngle));
AssignCommand(oNPC, ActionPlayAnimation(ANIMATION_FIREFORGET_BOW));
}
