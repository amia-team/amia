// OnEntered event of the swinging blades crypt trap.  PC must make a DC 14
// reflex save or be thrown into the pit.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 07/18/2004 jpavelch         Initial release.
//2008-06-120 disco            Removed pit. Blades do damage now.


void main( )
{
    object oTrigger = OBJECT_SELF;

    if ( GetLocalInt(oTrigger, "AR_Disable") )
        return;

    SetLocalInt( oTrigger, "AR_Disable", TRUE );
    DelayCommand( 10.0, DeleteLocalInt(oTrigger, "AR_Disable") );

    object oPC = GetEnteringObject( );
    if ( !GetIsPC(oPC) ) return;

    location lPC = GetLocation( oPC );
    object oArea = GetAreaFromLocation( lPC );
    vector vPosition = GetPositionFromLocation( lPC );
    location lTarget = Location( oArea, vPosition, 90.0 );

    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect(473), lTarget );

    if ( ReflexSave(oPC, 14) == 0 ) {

        int nDamage = 1 + GetMaxHitPoints( oPC ) / ( 1 + d3() );

        DelayCommand( 0.5,  ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_MEDIUM ), oPC ) );
        DelayCommand( 0.5,  ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( nDamage ), oPC ) );
        DelayCommand( 0.5,  ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect(473), lTarget ) );

    }
}
