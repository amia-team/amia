//obsolete

void main()
{
object oPC = GetLastUsedBy();
object oChair = OBJECT_SELF;

if(GetIsObjectValid(oPC))
{
    AssignCommand(oPC,ActionSit(oChair));
}

}
