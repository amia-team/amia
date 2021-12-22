// Creates a combust effect on the braziers.
//
void main()
{
    object oPC = GetEnteringObject( );
    if ( GetIsPC(oPC) ) {
        effect eVisual = EffectVisualEffect( VFX_IMP_FLAME_M );

        location lBrazier = GetLocation( GetNearestObjectByTag("Brazier", OBJECT_SELF, 1) );
        ApplyEffectAtLocation(
            DURATION_TYPE_INSTANT,
            eVisual,
            lBrazier
        );

        lBrazier = GetLocation( GetNearestObjectByTag("Brazier", OBJECT_SELF, 2) );
        ApplyEffectAtLocation(
            DURATION_TYPE_INSTANT,
            eVisual,
            lBrazier
        );
    }
}
