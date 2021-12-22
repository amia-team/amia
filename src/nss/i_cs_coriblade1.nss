// Fury of the Blackguard [Longsword onHit and onUse]

// Includes
#include "x2_inc_switches"
#include "x2_inc_itemprop"

void main( ){

    // Variables
    int nEvent              = GetUserDefinedItemEventNumber( );
    int nResult             = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oItem    = GetItemActivated( );
            object oPC      = GetItemActivator( );
            int nBGD_rank   = GetLevelByClass( CLASS_TYPE_BLACKGUARD, oPC );
            float fDuration = RoundsToSeconds( nBGD_rank );

            // Candy
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_LOS_EVIL_10 ), oPC );

            // Laugh emote
            AssignCommand( oPC, ActionPlayAnimation( ANIMATION_LOOPING_TALK_LAUGHING, 1.0, 1.5 ) );

            // Laugh voice
            PlayVoiceChat( VOICE_CHAT_LAUGH, oPC );

            // 1 round per BGD level of Aura of Glory [Cursed]
            AssignCommand( oPC, ActionCastSpellAtObject(
                                                        562,
                                                        oPC,
                                                        METAMAGIC_ANY,
                                                        TRUE,
                                                        nBGD_rank,
                                                        PROJECTILE_PATH_TYPE_DEFAULT,
                                                        TRUE ) );

            // AC -3, STR +2, Haste and a Red Aura VFX
            effect eBoost = EffectLinkEffects(
                                                EffectACDecrease( 3 ),
                                                EffectAbilityIncrease( ABILITY_STRENGTH, 2 ) );

            eBoost = EffectLinkEffects( eBoost, EffectHaste( ) );

            eBoost = EffectLinkEffects( eBoost, EffectVisualEffect( VFX_DUR_AURA_FIRE ) );

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBoost, oPC, fDuration );

            break;

        }

        case X2_ITEM_EVENT_ONHITCAST:{

            // Variables
            object oVictim  = GetSpellTargetObject( );

            // Blood splatter VFX
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_COM_CHUNK_RED_LARGE ), oVictim );

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

}
