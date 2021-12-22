void main()
{

    if ( GetLocalInt( OBJECT_SELF, "blocked" ) == 1 ){

        return;
    }

    SetLocalInt( OBJECT_SELF, "blocked", 1 );

    string sTag     = GetLocalString( OBJECT_SELF, "tag" );
    object oPLC     = GetNearestObjectByTag( sTag );
    int i           = 1;
    int nBaseEffect = GetLocalInt( OBJECT_SELF, "vfx_base" );
    effect eEffect;

    while ( GetIsObjectValid( oPLC ) ){

        eEffect   = EffectVisualEffect( 408 + Random( 16 ) );

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eEffect, oPLC );

        ++i;

        oPLC = GetNearestObjectByTag( sTag, OBJECT_SELF, i );
    }

    DelayCommand( 2.0, DestroyObject( OBJECT_SELF ) );
}
