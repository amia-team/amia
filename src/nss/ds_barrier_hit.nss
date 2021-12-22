void main(){

    object oPC    = GetEnteringObject();
    object oLeft  = GetNearestObjectByTag( "ds_barrier_left" );

    if ( GetLocalInt( oLeft, "barrier_on" ) == 1 ){

        effect eHit1 = EffectDamage( d6(6), DAMAGE_TYPE_NEGATIVE );
        effect eHit2 = EffectDamage( d6(6), DAMAGE_TYPE_POSITIVE );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eHit1, oPC );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eHit2, oPC );
    }
}
