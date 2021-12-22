void main()
{

    if ( GetLocalInt( OBJECT_SELF, "blocked" ) == 1 ){

        return;
    }

    SetLocalInt( OBJECT_SELF, "blocked", 1 );

    string sTag = GetLocalString( OBJECT_SELF, "tag" );
    int nVfx    = GetLocalInt( OBJECT_SELF, "vfx" );
    object oPLC = GetNearestObjectByTag( sTag );
    effect eVFX = EffectVisualEffect( nVfx );

    int i = 1;

    while ( GetIsObjectValid( oPLC ) ){

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVFX, oPLC );

        ++i;

        oPLC = GetNearestObjectByTag( sTag, OBJECT_SELF, i );
    }

    DelayCommand( 2.0, DestroyObject( OBJECT_SELF ) );
}
