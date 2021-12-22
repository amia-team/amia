void main(){

    object oPC = GetEnteringObject();
    int nColor = GetLocalInt( OBJECT_SELF, "vfx" );

    DestroyObject( OBJECT_SELF );

    if ( !nColor ){

        nColor = VFX_DUR_GLOW_GREY;
    }

    int i;
    object oPLC;

    for( i=1; i<10; i++ ){

        oPLC = GetNearestObjectByTag( "sec_shadow_" + IntToString( i ) );

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR ), oPLC );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect( nColor ), oPLC );
    }
}
