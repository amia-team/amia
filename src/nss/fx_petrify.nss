void main(){

    object oPC = GetEnteringObject();
    int nColor = GetLocalInt( OBJECT_SELF, "vfx" );

    DestroyObject( OBJECT_SELF );

    int i;
    object oPLC;

    for( i=1; i<20; i++ ){

        oPLC = GetNearestObjectByTag( "sec_shadow_" + IntToString( i ) );

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect( VFX_DUR_PETRIFY ), oPLC );
        if ( nColor >= 1 ){

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect( nColor ), oPLC );
        }
    }
}
