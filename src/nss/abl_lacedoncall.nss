/*
    Custom NPC Ability:
    Lacedon Call
    - Simply summons 3 Abyssal Lacedons at the location of the Target
*/

void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetLocalObject( oCaster, "abl_lacedoncall" );
    location lTarget = GetLocation( oTarget );
    effect eWater = EffectVisualEffect( VFX_FNF_GAS_EXPLOSION_MIND );

    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eWater, lTarget );

    CreateObject( OBJECT_TYPE_CREATURE, "abyss_lacedon", lTarget );
    CreateObject( OBJECT_TYPE_CREATURE, "abyss_lacedon", lTarget );
    CreateObject( OBJECT_TYPE_CREATURE, "abyss_lacedon", lTarget );
}
