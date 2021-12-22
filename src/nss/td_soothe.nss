#include "inc_ds_records"
#include "x2_inc_spellhook"
//custom spell constants
#include "inc_dc_spells"
#include "x2_inc_toollib"
#include "x2_inc_itemprop"
#include "x0_i0_spells"
#include "x2_i0_spells"
#include "nwnx_effects"


//This a blatant copy from the restroation script and should conform to Amias standards
void SootheRestore( object oTarget, int nCL ){

    // Variables.
    object oPC          = oTarget;
    effect eEffect      = GetFirstEffect( oPC );


    // Cycle the player's effects.
    while( GetIsEffectValid( eEffect ) ){

        // Variables.
        int nEffectType = GetEffectType( eEffect );

        switch( nEffectType ){

            // Ill effects.
            case EFFECT_TYPE_ABILITY_DECREASE:
            case EFFECT_TYPE_AC_DECREASE:
            case EFFECT_TYPE_ATTACK_DECREASE:
            case EFFECT_TYPE_DAMAGE_DECREASE:
            case EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE:
            case EFFECT_TYPE_SAVING_THROW_DECREASE:
            case EFFECT_TYPE_SPELL_RESISTANCE_DECREASE:
            case EFFECT_TYPE_SKILL_DECREASE:
            case EFFECT_TYPE_BLINDNESS:
            case EFFECT_TYPE_DEAF:
            case EFFECT_TYPE_PARALYZE:
            case EFFECT_TYPE_NEGATIVELEVEL:{

                //remove if it isn't a custom spell effect
                if ( GetName( GetEffectCreator( eEffect ) ) != "ds_norestore" ){

                    RemoveEffect( oPC, eEffect );
                }

                break;

            }

            default:
                break;

        }

        // Get the next effect on the player.
        eEffect         = GetNextEffect( oPC );

    }

    ApplyAreaAndRaceEffects( oPC );

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect( VFX_IMP_RESTORATION ),
        oPC );

    SignalEvent(oTarget, EventSpellCastAt( OBJECT_SELF, SPELL_RESTORATION, FALSE ) );
    int nHP = d4( (nCL/2) );

    effect eHP = EffectLinkEffects( EffectTemporaryHitpoints( nHP ), EffectVisualEffect( VFX_DUR_CESSATE_NEUTRAL ) );

    //Add our temp hps here
    RemoveEffectsBySpell( oTarget, SPELL_RESTORATION );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SetEffectSpellID( eHP, SPELL_RESTORATION ), oTarget, RoundsToSeconds( nCL ) );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_HEAD_HOLY ), oTarget );
}

void Soothe( object oPC, object oTarget, location lTarget ){

    int nSpellDCBonus;

    nSpellDCBonus = SetSpellSchool( oPC, SPELL_SCHOOL_NECROMANCY );

    int nCL = GetCasterLevel( oPC );
    int nCNT = nCL/2;


    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_STRIKE_HOLY ), lTarget );
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_WORD ), lTarget );

    oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );
    while( GetIsObjectValid( oTarget ) ){

        if( GetIsReactionTypeHostile( oTarget, oPC ) ){

            if( GetRacialType( oTarget ) == RACIAL_TYPE_UNDEAD && nCNT > 0 && GetChallengeRating( oTarget ) < 41.0 ){

                SignalEvent(oTarget, EventSpellCastAt( OBJECT_SELF, SPELL_UNDEATH_TO_DEATH, TRUE ) );

                if( FortitudeSave( oTarget, GetSpellSaveDC( )+nSpellDCBonus, SAVING_THROW_TYPE_NONE, oPC ) < 1 ){

                    //KILL!
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( GetMaxHitPoints( oTarget ) + Random( 100 ) + 10,DAMAGE_TYPE_DIVINE ), oTarget );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_HEAD_HOLY ), oTarget );

                }
                else{
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( d4( nCL ),DAMAGE_TYPE_DIVINE ), oTarget );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_HEAD_HOLY ), oTarget );
                }
                nCNT--;
            }
        }
        else{
            SootheRestore( oTarget, nCL );
        }

        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );
    }
}

void main(){

    Soothe( OBJECT_SELF, OBJECT_INVALID, GetSpellTargetLocation( ) );
}
