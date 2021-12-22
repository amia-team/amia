// OnPhysicalAttacked event of the divider.  Kills the PC that attacks it.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/01/2004 jpavelch         Initial Release.
//


void main( )
{
    object oPC = GetLastAttacker( );
    if ( !GetIsPC(oPC) ) return;

    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_LIGHTNING_M),
        GetLocation(oPC)
    );
    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectDeath(TRUE),
        oPC
    );
    FloatingTextStrRefOnCreature( 30967, oPC );
}
