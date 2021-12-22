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
    ExecuteScript("ds_ai2_spawn", OBJECT_SELF);

    ActionCastSpellAtObject(
        SPELL_GREATER_STONESKIN,
        oSelf,
        METAMAGIC_ANY,
        TRUE,
        0,
        PROJECTILE_PATH_TYPE_DEFAULT,
        TRUE
    );

    ActionCastSpellAtObject(
        SPELL_GREATER_SPELL_MANTLE,
        oSelf,
        METAMAGIC_ANY,
        TRUE,
        0,
        PROJECTILE_PATH_TYPE_DEFAULT,
        TRUE
    );

    ActionCastSpellAtObject(
        SPELL_FREEDOM_OF_MOVEMENT,
        oSelf,
        METAMAGIC_ANY,
        TRUE,
        0,
        PROJECTILE_PATH_TYPE_DEFAULT,
        TRUE
    );

    ActionCastSpellAtObject(
        SPELL_PROTECTION_FROM_SPELLS,
        oSelf,
        METAMAGIC_ANY,
        TRUE,
        0,
        PROJECTILE_PATH_TYPE_DEFAULT,
        TRUE
    );
}
