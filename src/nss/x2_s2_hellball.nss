/*  Epic Spell :: Hellball!

    --------
    Verbatim
    --------
    Hellballshall now deal upon any, including the caster, within a 20-foot radius the following damages:
    10d6 fire, 20d6 negative, and 20d6 positive.
    This spell is subject to neither a saving throw nor spell resistance.

    ---------
    Changelog
    ---------
    Date        Name        Reason
    ----------------------------------------------------------------------------
    012807      kfw         Initial.
    013007      kfw         DM check.
    20070301    disco       Int and Cha check
    20100705    james       Enforce Right Ability Check
    ----------------------------------------------------------------------------
*/

// Includes.
#include "x2_inc_spellhook"
#include "x2_i0_spells"


void main( ){

    // Execute the spell hook first to check for overrides.
    if( !X2PreSpellCastCode( ) )
        return;


    // requirements

    if ( !GetCanCastEpicSpells( OBJECT_SELF ) ) {


        SendMessageToPC( OBJECT_SELF, "You need either 20+ Cha, Int or Wis to cast this spell." );
        return;
    }
    RemoveEffectsBySpell( OBJECT_SELF, SPELL_ETHEREALNESS);

    // Variables.
    object oCaster          = OBJECT_SELF;
    int nDM                 = GetIsDM( oCaster );
    location lTarget        = GetSpellTargetLocation( );
    location lCaster        = GetLocation( oCaster );
    int nDC                 = GetEpicSpellSaveDC( oCaster );

    effect eFireDamage, ePositiveDamage, eNegativeDamage;
    int nFireDamage = 0, nPositiveDamage = 0, nNegativeDamage = 0;

    effect eDeathVfx        = EffectVisualEffect( VFX_FNF_DEMON_HAND );
    effect eDamageVfx       = EffectVisualEffect( VFX_FNF_FIREBALL );

    effect eCastVfx         = EffectVisualEffect( 464 );
    effect eShake           = EffectVisualEffect( VFX_FNF_SCREEN_SHAKE );




    // Apply the visuals and damage.

    // Ground shaking at the caster!
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eShake, lCaster );
    // Hellball visual!
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eCastVfx, lTarget );

    // Cycle through all creatures at the target location.
    object oTarget          = GetFirstObjectInShape(
                                SHAPE_SPHERE,
                                20.0,
                                lTarget,
                                TRUE,
                                OBJECT_TYPE_CREATURE );

    while( GetIsObjectValid( oTarget ) ){

    //Terra: lets not ignore pvp rules unless I'm hitting myself.
    if( !GetIsFriend( oTarget, oCaster ) || oTarget == oCaster ){
            // Spell event.
            SignalEvent( oTarget, EventSpellCastAt( oCaster, GetSpellId( ) ) );

            // Ground shaking!
            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eShake, GetLocation( oTarget ) );
            // Damage.

            nFireDamage = d6( 10 );
            if( nFireDamage < 30 )
                nFireDamage = 30;
            if( nDM )
                nFireDamage = 777;
            eFireDamage = EffectDamage( nFireDamage, DAMAGE_TYPE_FIRE, DAMAGE_POWER_PLUS_TWENTY );

            nPositiveDamage = d6( 20 );
            if( nPositiveDamage < 60 )
                nPositiveDamage = 60;
            if( nDM )
                nPositiveDamage = 777;
            ePositiveDamage = EffectDamage( nPositiveDamage, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_PLUS_TWENTY );

            nNegativeDamage = d6( 20 );
            if( nNegativeDamage < 60 )
                nNegativeDamage = 60;
            if( nDM )
                nNegativeDamage = 777;
            eNegativeDamage = EffectDamage( nNegativeDamage, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_PLUS_TWENTY );

            // If the damage obliterates this creature, vaporize it.
            if( nFireDamage + nPositiveDamage + nNegativeDamage > GetCurrentHitPoints( oTarget ) )
                DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDeathVfx, oTarget ) );
            // Doesn't quite kill it, ooze blood & guts!
            else
                DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamageVfx, oTarget ) );

            // Apply the damages.
            DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eFireDamage, oTarget ) );
            DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, ePositiveDamage, oTarget ) );
            DelayCommand( 2.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eNegativeDamage, oTarget ) );
        }
        // Get the next unfortunate victim.
        oTarget = GetNextObjectInShape(
                    SHAPE_SPHERE,
                    20.0,
                    lTarget,
                    TRUE,
                    OBJECT_TYPE_CREATURE );

    }

    return;

}
