// OnOpen event of Guantlet of Terror chest.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 09/14/2003 jpavelch         Initial Release.
//

// Casts Wail of the Banshee over self.
//
void main()
{
    ActionCastSpellAtLocation(
        SPELL_WAIL_OF_THE_BANSHEE,
        GetLocation(OBJECT_SELF),
        METAMAGIC_ANY,
        TRUE,
        PROJECTILE_PATH_TYPE_DEFAULT,
        TRUE
    );
}
