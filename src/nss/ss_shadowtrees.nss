/* Creates a visual effect on multiple PLCs.
 */
void main(){

    if ( GetLocalInt( OBJECT_SELF, "blocked" ) == 1 ){

        return;
    }

    SetLocalInt( OBJECT_SELF, "blocked", 1 );

    string sTag    = GetLocalString( OBJECT_SELF, "tag" );
    object oPLC    = GetNearestObjectByTag( sTag );
    int i          = 1;
    int nEffect    = GetLocalInt( OBJECT_SELF, "vfx" );

    if ( !nEffect ){

        nEffect = VFX_DUR_GHOST_TRANSPARENT;
    }

    effect eEffect = EffectVisualEffect( nEffect );

    while ( GetIsObjectValid( oPLC ) ){


        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eEffect, oPLC );

        ++i;

        oPLC = GetNearestObjectByTag( sTag, OBJECT_SELF, i );
    }

    DelayCommand( 2.0, DestroyObject( OBJECT_SELF ) );
}
