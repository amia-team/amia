// Temporary :: Unprotected Mythal Crystal Forge : Damages a player if they touch it.
void main()
{

    object oPC  = GetLastUsedBy( );
    // 90% hitpoint damage to fools.
    int nDamage = FloatToInt( IntToFloat( GetCurrentHitPoints( oPC ) ) * 0.9 );
    if( nDamage < 1 )
        nDamage = 1;

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectLinkEffects(
            EffectDamage( nDamage ),
            EffectVisualEffect( VFX_IMP_MAGBLUE )   ),
        oPC );

}
