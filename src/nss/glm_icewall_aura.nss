/*
    OnEnter Aura script for the mist created when an Ice Wall is destroyed
*/

void main()
{
    object oTarget = GetEnteringObject();
    object oMist = GetNearestObjectByTag( "x3_plc_mist" );
    int nCL = GetLocalInt( oMist, "CasterLevel" );
    int nDamage = ( d6(1) + ( 1 * nCL ) );

    effect eCold = EffectDamage( nDamage, DAMAGE_TYPE_COLD, DAMAGE_POWER_ENERGY );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eCold, oTarget );
}
