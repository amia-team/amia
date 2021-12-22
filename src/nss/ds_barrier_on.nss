void main(){

    object oLeft  = GetNearestObjectByTag( "ds_barrier_left" );
    object oRight = GetNearestObjectByTag( "ds_barrier_right" );

    if ( GetLocalInt( oLeft, "barrier_on" ) == 0 ){

        effect eBeam = EffectBeam( VFX_BEAM_MIND, oLeft, BODY_NODE_CHEST, FALSE );

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oRight, 30.0 );

        SetLocalInt( oLeft, "barrier_on", 1 );
        DelayCommand( 30.0, SetLocalInt( oLeft, "barrier_on", 2 ) );
        DelayCommand( 60.0, DeleteLocalInt( oLeft, "barrier_on" ) );
     }
}
