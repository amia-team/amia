/*  Amia :: Trigger :: OnEnter : Custom Ambience

    --------
    Verbatim
    --------
    This script is respawning and will occasionally play a customized ambience feature,
    whence triggered by a player in the perimeter.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    091806  kfw         Initial release.
    ----------------------------------------------------------------------------

*/


/* Constants. */
const string RESPAWN        = "respawn";
const string VFX            = "cs_vfx";
const float DELAY           = 180.0;


void main( ){

    // Variables.
    object oTrigger     = OBJECT_SELF;
    object oPC          = GetEnteringObject( );
    location lOrigin    = GetLocation( oTrigger );
    int nRespawn        = GetLocalInt( oTrigger, RESPAWN );
    int nVFX            = GetLocalInt( oTrigger, VFX );


    // Filter: PC's only.
    if( !GetIsPC( oPC ) )
        return;

    // Hasn't respawned, play the customized ambience feature.
    if( !nRespawn ){
        // Play custom ambience feature.
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( nVFX ), lOrigin );
        // Set respawn timer.
        SetLocalInt( oTrigger, RESPAWN, TRUE );
        DelayCommand( DELAY, AssignCommand( oTrigger, SetLocalInt( oTrigger, RESPAWN, FALSE ) ) );
    }

    return;

}
