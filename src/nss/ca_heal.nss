// Conversation action to heal someone.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 20050502   bbillington      Initial release.
//

void main()
{
    AssignCommand(OBJECT_SELF,
                  ActionCastSpellAtObject(SPELL_HEAL, GetPCSpeaker(), METAMAGIC_ANY, TRUE,
                                          1, PROJECTILE_PATH_TYPE_DEFAULT, FALSE));
}

