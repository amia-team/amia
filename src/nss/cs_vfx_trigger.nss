/* VFX Trigger

    Verbatim
    --------
    Generates a permanent VFX at a designated PLC

*/

void main( ){

    // Variables
    object oTrigger     = OBJECT_SELF;
    object oPC          = GetEnteringObject( );
    int nVFX            = GetLocalInt( oTrigger, "vfx" );
    effect eVFX         = EffectVisualEffect( nVFX );
    string szPLC        = GetLocalString( oTrigger, "plc" );
    object oPLC         = GetNearestObjectByTag( szPLC );

    // Verify Respawn Status
    if( GetLocalInt( oTrigger, "spawned" ) )
        return;

    // Spawn once-only
    SetLocalInt( oTrigger, "spawned", 1 );

    // Verify PC, VFX and C
    if( GetIsPC( oPC ) && nVFX && GetIsObjectValid( oPLC ) )
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVFX, oPLC );

    return;

}
