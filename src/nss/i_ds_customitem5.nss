'/*  i_ds_customitem5

--------
Verbatim
--------
Pools custom item request scripts

---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "nw_i0_spells"
#include "amia_include"
#include "inc_ds_actions"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
void PsychicConcussion( object oPC );
void MagicalPanpipe( object oPC );
void GooglyEyeLook( object oPC, object oTarget );
void SilverFlute( object oPC );
void SlashingDispel( object oTarget );
void AdvancedImbuing( object oPC );
void MassPetrifaction( object oPC, location lTarget );
void ShowCard( object oPC );
void HealPotionVariant( object oPC );

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            string sItemName = GetName(oItem);
            location lTarget = GetItemActivatedTargetLocation();

            if ( sItemName == "Psychic Concussion" ){

                AssignCommand( oPC, PsychicConcussion( oPC ) );
            }
            else if ( sItemName == "Magical Panflute" ){

                MagicalPanpipe( oPC );
            }
            else if ( sItemName == "The Googly-eye Look" ){

                GooglyEyeLook( oPC, oTarget );
            }
            else if ( sItemName == "Silver Flute" ){

                AssignCommand( oPC, SilverFlute( oPC ) );
            }
            else if ( sItemName == "Slashing Dispel" ){

                AssignCommand( oPC, SlashingDispel( oTarget ) );
            }
            else if ( sItemName == "Advanced Imbuing" ){

                AssignCommand( oPC, AdvancedImbuing( oPC ) );
            }
            else if ( sItemName == "Mass Petrifaction" ){

                AssignCommand( oPC, MassPetrifaction( oPC, lTarget ) );
            }
            else if ( sItemName == "Master's Insigina Ring" ){

                AssignCommand( oPC, ActionCastSpellAtObject( ULTRAVISION_ON, oPC, 1, TRUE, 0, 1, TRUE ) );
            }
            else if ( sItemName == "AAA Card" ){

                AssignCommand( oPC, ShowCard( oPC ) );
            }
            else if ( sItemName == "Soul Tonic" ){

                AssignCommand( oPC, HealPotionVariant( oPC ) );
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------


//40d4 magic damage
//30 foot radius, self only, AoE
//DC 20 + INT mod + WIS mod
//Failed save causes Stun for 3 rounds, successful save negates stun and halves damage.
//drains 3 Ki damage/use
void PsychicConcussion( object oPC ){

    if ( !TakeFeatUses( oPC, FEAT_KI_DAMAGE, 3 ) ){

        return;
    }

    effect eVis     = EffectVisualEffect( VFX_FNF_MYSTICAL_EXPLOSION );
    effect eImp     = EffectVisualEffect( VFX_IMP_SONIC );
    effect eImp2    = EffectVisualEffect( VFX_FNF_SOUND_BURST );
    effect eDam     = EffectDamage( d4(40) );
    effect eStun    = EffectStunned();
    int nDC         = 20 + GetAbilityModifier( ABILITY_WISDOM, oPC ) +GetAbilityModifier( ABILITY_INTELLIGENCE, oPC );

    location lTarget = GetLocation( oPC );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );

    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 30.0, lTarget, FALSE, OBJECT_TYPE_CREATURE );

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while ( GetIsObjectValid( oTarget ) ){

        if ( GetIsEnemy( oTarget, oPC ) ) {

            if ( WillSave( oTarget, nDC, SAVING_THROW_TYPE_NONE, oPC ) == 0 ){

                eDam = EffectDamage( d4(40) );

                ApplyEffectToObject( DURATION_TYPE_INSTANT, eImp, oTarget );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eImp2, oTarget );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, oTarget );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eStun, oTarget, 18.0 );
            }
            else{

                eDam = EffectDamage( d4(20) );

                ApplyEffectToObject( DURATION_TYPE_INSTANT, eImp, oTarget );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, oTarget );
            }
        }

        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 30.0, lTarget, FALSE, OBJECT_TYPE_CREATURE );
    }
}


void MagicalPanpipe( object oPC ){

    effect eSong = EffectVisualEffect( VFX_DUR_BARD_SONG );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSong, oPC, 180.0 );

    AssignCommand( oPC, SpeakString( "*plays an ancient Panflute*" ) );

}

void GooglyEyeLook( object oPC, object oTarget ){

    if ( !GetIsPC( oTarget ) ){

        return;
    }

    if ( WillSave( oTarget, 40, SAVING_THROW_TYPE_NONE, oPC ) == 0 ){

        effect eDaze = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DOMINATED );

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDaze, oPC, 30.0 );

        SendMessageToPC( oTarget, "You have been charmed by the Krin - Be very afraid." );
        AssignCommand( oTarget, SpeakString( "Ohh Krin, you're so great. Of course I want to help you!" ) );
    }
}

void SilverFlute( object oPC ){


    if ( !TakeFeatUses( oPC, FEAT_BARD_SONGS, 1 ) ){

        return;
    }

    int nCL = GetLevelByClass( CLASS_TYPE_BARD , oPC );

    if ( nCL > 20 ){

        nCL = 20;
    }

    effect eDam ;
    effect eHeal;
    effect eVis      = EffectVisualEffect( VFX_IMP_SUNSTRIKE );
    effect eVis2     = EffectVisualEffect( VFX_IMP_HEALING_M );
    effect eImp      = EffectVisualEffect( VFX_FNF_LOS_HOLY_20 );
    int nDC          = 10 + nCL;
    location lTarget = GetLocation( oPC );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );

    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 30.0, lTarget, FALSE, OBJECT_TYPE_CREATURE );

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while ( GetIsObjectValid( oTarget ) ){

        if ( GetIsEnemy( oTarget, oPC ) && WillSave( oTarget, nDC ) == 0 ){

            eDam     = EffectDamage( (d8()+nCL) );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eImp, oTarget );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, oTarget );
        }

        if ( GetIsFriend( oTarget, oPC ) ){

             eHeal    = EffectHeal( (d8()+nCL) );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eImp, oTarget );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eHeal, oTarget );
        }

        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 30.0, lTarget, FALSE, OBJECT_TYPE_CREATURE );
    }
}

void SlashingDispel( object oTarget ){

    if ( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE ){

        return;
    }

    int nBonus = 0;

    if ( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_ABJURATION ) ){

        nBonus = 6;
    }
    else if ( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_ABJURATION ) ){

        nBonus = 4;
    }
    else if ( GetHasFeat( FEAT_SPELL_FOCUS_ABJURATION ) ){

        nBonus = 2;
    }


    int nCL = GetLevelByClass( CLASS_TYPE_WIZARD );
    int nDC = 10 + 5 + GetAbilityModifier( ABILITY_INTELLIGENCE ) + nBonus;

    effect eDispelAll   = EffectDispelMagicAll( nCL );
    effect eVis         = EffectVisualEffect(VFX_IMP_DISPEL);
    effect eStun        = EffectStunned();


    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDispelAll, oTarget);

    if ( WillSave( oTarget, nDC ) == 0 ){

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds( d4(2) ) );
    }
}

void AdvancedImbuing( object oPC ){

    clean_vars( oPC, 4 );

    SetLocalString( oPC, "ds_action", "ds_adv_imbuing" );

    AssignCommand( oPC, ActionStartConversation( oPC, "ds_adv_imbuing", TRUE, FALSE ) );
}

void MassPetrifaction( object oPC, location lTarget ){

    int nSpellToTake = GetHasSpell( SPELL_ENERGY_DRAIN, oPC );

    if ( nSpellToTake > 0 ){

        DecrementRemainingSpellUses( oPC, SPELL_ENERGY_DRAIN );
    }
    else{

        SendMessageToPC( oPC, "You need to have Energy Drain memorised to use this item." );
        return;
    }

    int nBonus = 0;

    if ( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION ) ){

        nBonus = 6;
    }
    else if ( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION ) ){

        nBonus = 4;
    }
    else if ( GetHasFeat( FEAT_SPELL_FOCUS_TRANSMUTATION ) ){

        nBonus = 2;
    }

    int nCL = GetLevelByClass( CLASS_TYPE_WIZARD );
    int nDC = 10 + 9 + GetAbilityModifier( ABILITY_INTELLIGENCE ) + nBonus;

    effect eVis     = EffectVisualEffect( VFX_IMP_DUST_EXPLOSION );
    effect eImp     = EffectVisualEffect( VFX_IMP_STUN );
    effect ePetr    = EffectPetrify( );

    //location lTarget = GetLocation( oPC );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );

    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 30.0, lTarget, FALSE, OBJECT_TYPE_CREATURE );

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while ( GetIsObjectValid( oTarget ) ){

        if ( GetIsEnemy( oTarget, oPC ) ) {

            if ( FortitudeSave( oTarget, nDC ) == 0 ){

                ApplyEffectToObject( DURATION_TYPE_INSTANT, eImp, oTarget );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePetr, oTarget, RoundsToSeconds( nCL ) );
            }
        }

        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 30.0, lTarget, FALSE, OBJECT_TYPE_CREATURE );
    }
}

void ShowCard( object oPC ){

    effect eSong = EffectVisualEffect( VFX_DUR_PROTECTION_GOOD_MINOR );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSong, oPC, 1.0 );

    AssignCommand( oPC, SpeakString( "*<cÍ Í>flashes a glossy AAA Membership Card*</c>" ) );

    PlayAnimation( ANIMATION_LOOPING_GET_MID, 1.0, 2.0 );
}

void HealPotionVariant( object oPC ){

    effect eHeal    = EffectHeal( 999 );
    effect eVFX     = EffectVisualEffect( VFX_IMP_HEAD_HEAL );
    effect eHarm    = EffectACDecrease( 4 );
    eHarm           = EffectLinkEffects( EffectAbilityDecrease( ABILITY_WISDOM, 4 ), eHarm );
    float fDuration = RoundsToSeconds( d4( 2 ) );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eHeal, oPC );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oPC );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eHarm, oPC, fDuration );

    PlayAnimation( ANIMATION_FIREFORGET_DRINK );
}




