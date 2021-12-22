// Conversation action to restore someone at a price of 1500gp.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 20050502   bbillington      Initial release.
//

void main()
{
    object oPC = GetPCSpeaker();

    AssignCommand(oPC, TakeGoldFromCreature(1500, oPC, TRUE));
    AssignCommand(OBJECT_SELF, ActionCastSpellAtObject(SPELL_GREATER_RESTORATION, oPC, METAMAGIC_ANY, TRUE, 1, PROJECTILE_PATH_TYPE_DEFAULT, FALSE));
}

