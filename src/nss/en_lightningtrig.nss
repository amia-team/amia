// Creates a lightning effect on the obelisks.
//
void main()
{
    object oPC = GetEnteringObject( );
    if ( GetIsPC(oPC) ) {
        effect eVisual = EffectVisualEffect( VFX_IMP_LIGHTNING_M );

        location lObelisk = GetLocation( GetNearestObjectByTag("hv_obelisk", OBJECT_SELF, 1) );
        ApplyEffectAtLocation(
            DURATION_TYPE_INSTANT,
            eVisual,
            lObelisk
        );

        lObelisk = GetLocation( GetNearestObjectByTag("hv_obelisk", OBJECT_SELF, 2) );
        ApplyEffectAtLocation(
            DURATION_TYPE_INSTANT,
            eVisual,
            lObelisk
        );
    }
}
