//obsolete and bugged!

void main()
{
object oPC;

oPC = GetItemActivator();

object oCaster;
oCaster = oPC;

location oTarget;
oTarget = GetItemActivatedTargetLocation();

AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_GRENADE_FIRE, oTarget, METAMAGIC_ANY, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));

oCaster = oPC;

DelayCommand(3.0, AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_CLOUD_OF_BEWILDERMENT, oTarget, METAMAGIC_ANY, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE)));

}
