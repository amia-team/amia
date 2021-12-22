/*  Epic Spell :: Greater Ruin!

    --------
    Verbatim
    --------
    Greater Ruin shall now deal upon your foe 50d6 positive damage, will save for half damage.
    If cast upon a construct or undead foe, this spell acts like Crumble;

    if the construct succeeds it’s saving throw, it’ll deal half it’s damage in positive.
    This spell is not subject to spell resistance.
    +1 to the spell save DC if you have the Spell Focus: Divination feat,
    +3 for Greater Divination, and +6 for Epic Divination.

    ---------
    Changelog
    ---------
    Date        Name        Reason
    ----------------------------------------------------------------------------
    012807      kfw         Initial.
    013007      kfw         DM check.
    20070301    disco       Int and Cha check
    20080216    Disco       Added Transmutation option
    20100705    james       Enforce Right Ability Check
    ----------------------------------------------------------------------------
*/

// Includes.
#include "x2_inc_spellhook"
#include "x2_i0_spells"


void main( ){

    // Execute the spell hook first to check for overrides.
    if ( !X2PreSpellCastCode( ) ){

        return;
    }

    // Variables.
    object oCaster          = OBJECT_SELF;
    location lCaster        = GetLocation( oCaster );
    object oTarget          = GetSpellTargetObject( );
    int nTargetType         = GetRacialType( oTarget );
    location lTarget        = GetLocation( oTarget );
    int nDC                 = GetEpicSpellSaveDC( oCaster );


    // Only apply to creature and hostile targets.
    if( !GetIsDM( oCaster ) && ( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE || !GetIsReactionTypeHostile( oTarget, oCaster ) ) ){

        return;
    }

    //--------------------------------------------------------------------------
    // Transmutation
    //--------------------------------------------------------------------------
    int nTransmutation    = GetLocalInt( OBJECT_SELF, "ds_spell_"+IntToString( SPELL_EPIC_RUIN ) );

    if ( GetIsObjectValid( GetSpellCastItem() ) ) {

        nTransmutation = 1;
    }

    if ( !GetCanCastEpicSpells( OBJECT_SELF ) ) {

        SendMessageToPC( OBJECT_SELF, "You need either 20+ Cha, Int or Wis to cast this spell." );
        return;
    }


    int nDamage             = d6( 50 );

    effect eDamageVfx       = EffectVisualEffect( VFX_IMP_SUNSTRIKE );
    effect eCastVfx         = EffectVisualEffect( 487 );
    effect eShake           = EffectVisualEffect( VFX_FNF_SCREEN_SHAKE );
    int nDamageType         = DAMAGE_TYPE_POSITIVE;

    // Spell event.
    SignalEvent( oTarget, EventSpellCastAt( oCaster, GetSpellId( ) ) );

    //--------------------------------------------------------------------------
    // Transmutation
    //--------------------------------------------------------------------------
    //Set the damage effect

    // Divination feats add to the spell's DC.
    if(         GetHasFeat( FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION ) ){

        nDC += 6;
    }
    else if(    GetHasFeat( FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION ) ){

        nDC += 3;
    }
    else if(    GetHasFeat( FEAT_SPELL_FOCUS_TRANSMUTATION ) ){

        nDC += 1;
    }

    if ( nTransmutation == 2 ){

        // Ignore will saves, and use Crumble damage instead for constructs.
        if( nTargetType == RACIAL_TYPE_UNDEAD && GetChallengeRating( oTarget ) < 41.0 ){

            nDamage = nDamage*2;
        }
    }
    else{

        // Ignore will saves, and use Crumble damage instead for constructs.
        if( nTargetType == RACIAL_TYPE_CONSTRUCT && GetChallengeRating( oTarget ) < 41.0 ){

            nDamage = nDamage*2;
        }
    }

    // DM's.
    if ( GetIsDM( oCaster ) ){

        nDamage = 666;
    }

    // Calculate the final damage.
    effect eDamage = EffectDamage( nDamage, nDamageType, DAMAGE_POWER_PLUS_TWENTY );


    // Apply the visuals and damage.

    // Ground shaking!
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eShake, lCaster );
    DelayCommand( 0.25, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eShake, lTarget ) );

    // Energy ray.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eCastVfx, oTarget );

    // Damage.
    DelayCommand( 1.25, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectLinkEffects( eDamage, eDamageVfx ), oTarget ) );

    return;

}
