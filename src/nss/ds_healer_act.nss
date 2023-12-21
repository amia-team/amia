#include "inc_ds_actions"
#include "x0_i0_petrify"
#include "inc_func_classes"
#include "lycan_removal"

void main()
{

    object oPC     = OBJECT_SELF;
    object oHealer = GetLocalObject( oPC, "ds_target" );
    int nNode      = GetLocalInt( oPC, "ds_node" );
    effect eVis;
    effect eBad;
    int nPrice;
    int nHP;

    clean_vars( oPC, 4 );

    if ( nNode == 1 ){

        nHP    = GetMaxHitPoints( oPC ) - GetCurrentHitPoints( oPC );
        nPrice = nHP * 2;
    }
    else if ( nNode == 2 ){

        nPrice = 150;
    }
    else if ( nNode == 3 ){

        nPrice = 300;
    }
    else if ( nNode == 4 ){

        nPrice = 150;
    }
    else if ( nNode == 5 ){

        nPrice = 150;
    }
    else if ( nNode == 6 ){

        nPrice = 400;
    }
    else if ( nNode == 7 ){

        nPrice = 3500;
    }


    if ( GetAlignmentGoodEvil( oHealer ) == ALIGNMENT_GOOD ){

        nPrice = FloatToInt( nPrice * 0.9 );
    }
    else if ( GetAlignmentGoodEvil( oHealer ) == ALIGNMENT_EVIL ){

        nPrice = FloatToInt( nPrice * 1.1 );
    }

    if ( GetGold( oPC ) < nPrice ){

        if ( GetAlignmentGoodEvil( oHealer ) == ALIGNMENT_GOOD ){

            AssignCommand( oHealer, SpeakString( "I am really sorry... but you can't afford this treatment." ) );
        }
        else if ( GetAlignmentGoodEvil( oHealer ) == ALIGNMENT_EVIL ){

            AssignCommand( oHealer, SpeakString( "I don't care if you are dying... I want MONEY!" ) );
        }
        else{

            AssignCommand( oHealer, SpeakString( "Expenses, administration, my new tunic... these have to be paid for too..." ) );
        }

        return;
    }
    else{

        TakeGoldFromCreature( nPrice, oPC, TRUE );
    }

    if ( nNode == 1 ){

        eVis   = EffectVisualEffect( VFX_IMP_HEALING_S );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectHeal( nHP ), oPC );
    }
    else if ( nNode == 2 ){

        eVis   = EffectVisualEffect( VFX_IMP_HEALING_S );

        RemoveEffectOfType( oPC, EFFECT_TYPE_DISEASE );
        RemoveLycanInfection(oPC);
    }
    else if ( nNode == 3 ){

        eVis   = EffectVisualEffect( VFX_IMP_HEALING_S );

        RemoveEffectOfType( oPC, EFFECT_TYPE_POISON );
    }
    else if ( nNode == 4 ){

        eVis   = EffectVisualEffect( VFX_IMP_HEALING_S );

        RemoveEffectOfType( oPC, EFFECT_TYPE_CURSE );
    }
    else if ( nNode == 5 ){

        eVis   = EffectVisualEffect( VFX_IMP_RESTORATION_LESSER );

        eBad   = GetFirstEffect( oPC );

        while ( GetIsEffectValid( eBad ) ) {

            if ( GetEffectType( eBad ) == EFFECT_TYPE_ABILITY_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_AC_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_ATTACK_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_DAMAGE_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_SKILL_DECREASE ) {

                //remove if it isn't a custom spell effect
                if ( GetName( GetEffectCreator( eBad ) ) != "ds_norestore" ){

                    RemoveEffect( oPC, eBad );
                }
            }

            eBad = GetNextEffect( oPC );
        }
    }
    else if ( nNode == 6 ){

        eVis   = EffectVisualEffect( VFX_IMP_RESTORATION );

        eBad   = GetFirstEffect( oPC );

        while ( GetIsEffectValid( eBad ) ) {

            if ( GetEffectType( eBad ) == EFFECT_TYPE_ABILITY_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_AC_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_ATTACK_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_DAMAGE_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_SKILL_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_BLINDNESS ||
                 GetEffectType( eBad ) == EFFECT_TYPE_DEAF ||
                 GetEffectType( eBad ) == EFFECT_TYPE_PARALYZE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_NEGATIVELEVEL ){

                //remove if it isn't a custom spell effect
                if ( GetName( GetEffectCreator( eBad ) ) != "ds_norestore" ){

                    RemoveEffect( oPC, eBad );
                }
            }

            eBad = GetNextEffect( oPC );
        }
    }
    else if ( nNode == 7 ){

        eVis   = EffectVisualEffect( VFX_IMP_RESTORATION_GREATER );

        eBad   = GetFirstEffect( oPC );

        while ( GetIsEffectValid( eBad ) ) {

            if ( GetEffectType( eBad ) == EFFECT_TYPE_ABILITY_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_AC_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_ATTACK_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_DAMAGE_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_SKILL_DECREASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_BLINDNESS ||
                 GetEffectType( eBad ) == EFFECT_TYPE_DEAF ||
                 GetEffectType( eBad ) == EFFECT_TYPE_CURSE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_DISEASE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_POISON ||
                 GetEffectType( eBad ) == EFFECT_TYPE_PARALYZE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_CHARMED ||
                 GetEffectType( eBad ) == EFFECT_TYPE_DOMINATED ||
                 GetEffectType( eBad ) == EFFECT_TYPE_DAZED ||
                 GetEffectType( eBad ) == EFFECT_TYPE_CONFUSED ||
                 GetEffectType( eBad ) == EFFECT_TYPE_FRIGHTENED ||
                 GetEffectType( eBad ) == EFFECT_TYPE_NEGATIVELEVEL ||
                 GetEffectType( eBad ) == EFFECT_TYPE_PARALYZE ||
                 GetEffectType( eBad ) == EFFECT_TYPE_SLOW ||
                 GetEffectType( eBad ) == EFFECT_TYPE_STUNNED ){

                //remove if it isn't a custom spell effect
                if ( GetName( GetEffectCreator( eBad ) ) != "ds_norestore" ){

                    RemoveEffect( oPC, eBad );
                }
            }

            eBad = GetNextEffect( oPC );
        }

        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectHeal( GetMaxHitPoints( oPC ) - GetCurrentHitPoints( oPC ) ), oPC );
        RemoveLycanInfection(oPC);
    }


    if ( GetAlignmentGoodEvil( oHealer ) == ALIGNMENT_GOOD ){

        if ( GetGender( oHealer ) == GENDER_FEMALE ){

            PlaySound( "vs_chant_evoc_hf" );
        }
        else{

            PlaySound( "vs_chant_ench_hm" );
        }
    }
    else if ( GetAlignmentGoodEvil( oHealer ) == ALIGNMENT_EVIL ){

        if ( GetGender( oHealer ) == GENDER_FEMALE ){

            PlaySound( "vs_chant_necr_hf" );
        }
        else{

            PlaySound( "vs_chant_necr_hm" );
        }
    }
    else{

        if ( GetGender( oHealer ) == GENDER_FEMALE ){

            PlaySound( "vs_chant_illu_hf" );
        }
        else{

            PlaySound( "vs_chant_conj_hm" );
        }
    }

    AssignCommand( oHealer, PlayAnimation( ANIMATION_LOOPING_CONJURE2, 0.5, 2.5 ) );

    DelayCommand( 2.5, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC ) );

    //counter ECL bug
    GetECL( oPC );

}

