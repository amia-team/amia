#include "inc_ds_records"
#include "x2_inc_spellhook"
//custom spell constants
#include "inc_dc_spells"
#include "x2_inc_toollib"
#include "x2_inc_itemprop"
#include "x0_i0_spells"
#include "x2_i0_spells"
#include "nwnx_effects"

/*Shadow Drain
Illusion (Shadow)
Level: Sorcerer/Wizard 7
Components: V / S
Casting Time: 1 Standard Action
Range: large(Fireball effect radius, whichever one that is?)
Target: Self – pulse/round
Duration: 1 Round/Level (extendable/empowerable?) Requires Concentration check
Saving Throw: Will/Fort Negates
Spell Resistance: Yes

Opening up a gate way to the shadow plane through your own shadow, you let the essence of it flood through to explode outwards to latch onto any breathing and living thing. The essence of the plane clings onto them like a sticky, viscous liquid that cannot be removed. Slowly but surely, it begins to drain the coated victim of life and essence.

With an initial will save, the victim suffers 3d6 of cold and negative damage, as well as succumbs to slow on failure. Should the victim pass this initial save, they are able to overcome the shadowstuff and only suffer 1d6 cold and negative damage. Every round thereafter, they must make a fortitude save or risk yet more harm. On a failed fortitude thereafter, a drain of 2d4 to their strength, constitution and dexterity would occur. If this drain would reduce the victims ability score below what they currently have, they are instantly snuffed of life. Once latched on, the shadow stuff would remain for the duration of the casters strength before fading away. The caster must maintain concentration while this spell is in action.*/

void Proc( int nSpell, int nDC, object oTarget, object oCaster, int nFirst ){

    if( nFirst ){
        DelayCommand( 6.0, Proc( nSpell, nDC, oTarget, oCaster, 0 ) );
        return;
    }

    if( GetIsObjectValid( oCaster ) && GetHasSpellEffect( nSpell, oCaster ) &&
        GetIsObjectValid( oTarget ) && GetHasSpellEffect( nSpell, oTarget ) ){


        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_STARBURST_RED ), oTarget );

        if( FortitudeSave( oTarget, nDC, SAVING_THROW_TYPE_NONE, oCaster ) <= 0 ){

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectAbilityDecrease( ABILITY_STRENGTH, d2(4) ), oTarget, 6.0*30.0 );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectAbilityDecrease( ABILITY_CONSTITUTION, d2(4) ), oTarget, 6.0*30.0 );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectAbilityDecrease( ABILITY_DEXTERITY, d2(4) ), oTarget, 6.0*30.0 );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_STARBURST_RED ), oCaster );

            if( GetAbilityScore( oTarget, ABILITY_STRENGTH ) <= 3 ||
                GetAbilityScore( oTarget, ABILITY_CONSTITUTION ) <= 3 ||
                GetAbilityScore( oTarget, ABILITY_DEXTERITY ) <= 3 ){

                ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DEATH ), oTarget );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( GetMaxHitPoints( oTarget )+1000+Random(500) ), oTarget );
                return;
            }
        }

        DelayCommand( 6.0, Proc( nSpell, nDC, oTarget, oCaster, 0 ) );
    }
    else{

        if( GetIsObjectValid( oCaster ) )
            RemoveSpellEffects( nSpell, oCaster, oTarget );
        else
            RemoveEffectsBySpell( oTarget, nSpell );
    }
}

void ConcentrateAndPulseReallyScary( object oCaster, int nSpell, int nFirst ){

    if( nFirst || ( GetIsObjectValid( oCaster ) && GetHasSpellEffect( nSpell, oCaster ) ) ){

        int nAction = GetCurrentAction( oCaster );

        if( nFirst )
            nAction = ACTION_INVALID;

        if ( nAction == ACTION_DISABLETRAP || nAction == ACTION_TAUNT
            || nAction == ACTION_PICKPOCKET || nAction ==ACTION_ATTACKOBJECT
            || nAction == ACTION_COUNTERSPELL || nAction == ACTION_FLAGTRAP
            || nAction == ACTION_CASTSPELL || nAction == ACTION_ITEMCASTSPELL ||
            GetActionMode( oCaster, ACTION_MODE_STEALTH ) ) {

            FloatingTextStringOnCreature( "* Concentration broken! *", oCaster, FALSE );
            RemoveSpellEffects( nSpell, oCaster, oCaster );
            return;
        }
        else{

            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_STARBURST_RED ), oCaster );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_PULSE_NEGATIVE ), oCaster );

            location lTarget = GetLocation( oCaster );
            object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget );
            string TargetList = GetLocalString( oCaster, "ShadowstuffTargetList" );
            int nDC = GetLocalInt( oCaster, "ShadowstuffDC" );

            while( GetIsObjectValid( oTarget ) ){

                if( FindSubString( TargetList, ObjectToString( oTarget ) ) == -1 && GetIsReactionTypeHostile( oTarget, oCaster ) ){

                    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell));

                    if( MyResistSpell( oCaster, oTarget ) <= 0 ){

                        if( WillSave( oTarget, nDC, SAVING_THROW_TYPE_NONE, oCaster ) <= 0 ){

                            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( d6(3), DAMAGE_TYPE_COLD ), oTarget );
                            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( d6(3), DAMAGE_TYPE_NEGATIVE ), oTarget );
                            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_AURA_PULSE_GREY_BLACK ), oTarget, 6.0*30 );
                            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectSlow( ), oTarget, 6.0*30 );
                            AssignCommand( oTarget, Proc( nSpell, nDC, oTarget, oCaster, 1 ) );
                            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_STARBURST_RED ), oCaster );
                        }
                        else{

                            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( d6(1), DAMAGE_TYPE_COLD ), oTarget );
                            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( d6(1), DAMAGE_TYPE_NEGATIVE ), oTarget );
                        }
                    }

                    TargetList = TargetList+"|"+ObjectToString( oTarget );
                }

                oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget );
            }
            SetLocalString( oCaster, "ShadowstuffTargetList", TargetList );
        }
        DelayCommand( 6.0, ConcentrateAndPulseReallyScary( oCaster, nSpell, FALSE ) );
    }
}

int GetHas( object oPC, int nID ){

    effect eEffect = GetFirstEffect( oPC );
    while( GetIsEffectValid( eEffect ) ){

        if( GetEffectSpellId( eEffect ) == nID && GetEffectCreator( eEffect ) == oPC )
            return TRUE;

        eEffect = GetNextEffect( oPC );
    }

    return FALSE;
}

void main(){

    object oPC = OBJECT_SELF;
    int nID = GetSpellId();
    int nCL = GetCasterLevel(oPC);
    int nSpellDCBonus = SetSpellSchool( oPC, SPELL_SCHOOL_ILLUSION );

    SetLocalString( oPC, "ShadowstuffTargetList", "|" );
    SetLocalInt( oPC, "ShadowstuffDC", GetSpellSaveDC() + nSpellDCBonus );

    if( GetHas( oPC, nID ) ){
        RemoveSpellEffects( nID, oPC, oPC );
    }
    else
        ConcentrateAndPulseReallyScary( oPC, nID, TRUE );

    effect eBling = EffectLinkEffects( EffectVisualEffect( VFX_DUR_AURA_PULSE_GREY_BLACK ), EffectRegenerate( 1, 6.0 ) );
           eBling = EffectLinkEffects( eBling, EffectVisualEffect( VFX_DUR_TENTACLE ) );
           //eBling = EffectLinkEffects( eBling, EffectVisualEffect( VFX_DUR_ANTI_LIGHT_10 ) );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBling, oPC, RoundsToSeconds( nCL ) );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_SUMMON_EPIC_UNDEAD ), oPC );
}
