//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ai_death
//group:   ds_ai
//used as: OnDamage
//date:    dec 23 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_ondeath"
#include "ds_ai2_include"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oCritter         = OBJECT_SELF;
    object oKiller          = GetLastKiller();
    location lCritter = GetLocation( oCritter );
    int nDeathDice = GetLocalInt ( oCritter, "DeathDice" );

    effect eVFX = EffectVisualEffect( VFX_FNF_MYSTICAL_EXPLOSION );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oCritter );

    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 30.5, lCritter, TRUE, OBJECT_TYPE_CREATURE );

    while( GetIsObjectValid( oTarget ) )
    {
        int nSave = ReflexSave( oTarget, 30, SAVING_THROW_TYPE_COLD, oCritter );

        if( nSave == 0 )
        {
            effect eCold = EffectDamage( d6 ( nDeathDice ), DAMAGE_TYPE_COLD, DAMAGE_POWER_ENERGY );
            effect ePierce = EffectDamage( d6( nDeathDice/2 ), DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL );
            effect eExplode = EffectLinkEffects( eCold, ePierce );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eExplode, oTarget );
        }
        else if( nSave == 1 )
        {
            effect eCold = EffectDamage( d6(10), DAMAGE_TYPE_COLD, DAMAGE_POWER_ENERGY );
            effect ePierce = EffectDamage( d6(5), DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL );
            effect eExplode = EffectLinkEffects( eCold, ePierce );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eExplode, oTarget );
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 30.5, lCritter, TRUE, OBJECT_TYPE_CREATURE );
    }


    if( GetLastKiller() != OBJECT_SELF && GetLocalInt( oCritter, L_ISDEAD ) != 1 ){

        // Set have died once, stops giving out multiple amounts of XP.
        SetLocalInt( oCritter, L_ISDEAD, 1 );

        // Reward XP.
        int nXPResult = RewardXPForKill( );

        // Generate treasure.
        GenerateLoot( oCritter, nXPResult );
    }
}
