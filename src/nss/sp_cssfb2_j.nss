// OnSpawn script with defensive spells pre-cast.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 12/31/2003 jpavelch         Initial Release.
//


void main( )
{
    object oSelf = OBJECT_SELF;

    // Execute default OnSpawn script.
    ExecuteScript("j_ai_onspawn", OBJECT_SELF);

    ActionCastSpellAtObject(
        SPELL_TRUE_SEEING,
        oSelf,
        METAMAGIC_ANY,
        TRUE,
        0,
        PROJECTILE_PATH_TYPE_DEFAULT,
        TRUE
    );

    ActionCastSpellAtObject(
        SPELL_STONESKIN,
        oSelf,
        METAMAGIC_ANY,
        TRUE,
        0,
        PROJECTILE_PATH_TYPE_DEFAULT,
        TRUE
    );
}
