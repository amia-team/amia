// Conversation action to give ProtElem at a price of 100gp.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 20050502   bbillington      Initial release.
//

void main()
{
    object oPC = GetPCSpeaker();

    AssignCommand(oPC, TakeGoldFromCreature(100, oPC, TRUE));
    AssignCommand(OBJECT_SELF, ActionCastSpellAtObject(SPELL_PROTECTION_FROM_ELEMENTS, oPC, METAMAGIC_ANY, TRUE, 1, PROJECTILE_PATH_TYPE_DEFAULT, FALSE));
}
