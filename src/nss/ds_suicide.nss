void main(){

    effect eOuch = EffectDamage( 10000, DAMAGE_TYPE_BASE_WEAPON, DAMAGE_POWER_PLUS_TWENTY );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eOuch, OBJECT_SELF );
}

