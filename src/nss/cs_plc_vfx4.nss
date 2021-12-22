/*  PLC :: Visual Effect: Smoke and Glitter!

    --------
    Verbatim
    --------
    This script will make a puff of smoke or a wisp of glitter!

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    012207  kfw         Initial release.
    ----------------------------------------------------------------------------
*/

// Constants.
const string DELAY      = "PLC_DELAY";

void main( ){

    // Variables.
    object oPLC         = OBJECT_SELF;
    object oSource      = GetNearestObjectByTag( "cs_src_emit1", oPLC );


    // Delay check.
    if( GetLocalInt( oPLC, DELAY ) )
        return;
    else{
        // Refresh delay.
        SetLocalInt( oPLC, DELAY, TRUE );
        DelayCommand( 30.0, SetLocalInt( oPLC, DELAY, FALSE ) );
    }

    // Make the vfx.
    PlaySound( "it_potion" );

    if( d2( ) == 1 )
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect( VFX_FNF_SMOKE_PUFF ),
            oSource );
    else
        ApplyEffectToObject(
            DURATION_TYPE_TEMPORARY,
            EffectVisualEffect( VFX_DUR_PIXIEDUST ),
            oSource,
            8.0 );

    return;

}
