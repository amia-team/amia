// OnEnter event of crypt trigger to fully restore a PC.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/25/2003 jpavelch         Initial release.
//

void main( )
{
    object oPC = GetEnteringObject( );
    if ( !GetIsPC(oPC) ) return;

    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_POLYMORPH),
        GetLocation(oPC)
    );

    AssignCommand(
    GetObjectByTag("a13_restorebf"),
        ActionCastSpellAtObject(
            SPELL_GREATER_RESTORATION,
            oPC,
            METAMAGIC_ANY,
            TRUE,
            PROJECTILE_PATH_TYPE_DEFAULT,
            TRUE
        )
    );
}
