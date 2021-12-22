void HitEm( object oOrigin, int nDamageType, int nDamage, int nBeam ){

    object oTarget = GetNearestCreature( CREATURE_TYPE_IS_ALIVE, TRUE, oOrigin );

    effect eDamage = EffectDamage( nDamage, nDamageType );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );

    effect eBeam   = EffectBeam( nBeam, oOrigin, BODY_NODE_CHEST );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.0 );
}


void main(){

    object oPC = GetEnteringObject();
    object oPillar;
    float fDelay = d10()/5.0;
    string sTag  = GetTag( OBJECT_SELF );

    if ( sTag == "electric" ){

        oPillar = GetNearestObjectByTag( "oscillator", OBJECT_SELF );

        DelayCommand( fDelay, HitEm( oPillar, DAMAGE_TYPE_ELECTRICAL, d20( 3 ), VFX_BEAM_LIGHTNING ) );
    }
    else{

        oPillar = GetNearestObjectByTag( "beamer", OBJECT_SELF, d4() );

        DelayCommand( fDelay, HitEm( oPillar, DAMAGE_TYPE_FIRE, d20( 3 ), VFX_BEAM_FIRE ) );
    }

}
