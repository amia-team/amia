/*  i_bx_dc_items_1

--------
Verbatim
--------
Pools custom item request scripts

---------
Changelog
---------

Date      Name      Reason
------------------------------------------------------------------
20070820  Disco     Empty file for Brax
20070901  Braxton   Added Neus's Bakudan attack
20070910  Braxton   Added Xavi's Siren Song
20070917  Braxton   Added Wakaman's Epic Warding visual
20070928  Braxton   Added Ron's Dragon Potion
20070929  Braxton   Fixes and scripting style correction
20071027  Braxton   Trent's Aura of Hope added

------------------------------------------------------------------

-----------------------
Item Name Reference Log
-----------------------

Player          Name            Function
------------------------------------------------------------------
Neus            Bakudan         Bakudan(oPC, oTarget, lTarget)
Xavi            Siren Song      SirenSong(oPC, oItem)
Wakaman         Epic Warding    EpicWard(oPC, oItem)
BrainSplitter   Dragopotion     DragonPotion(oPC, oItem)

------------------------------------------------------------------


*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x0_i0_spells"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
void Bakudan( object oPC, object oTarget, location lTarget );
void SirenSong( object oPC );
void EpicWard( object oPC );
void DragonPotion( object oPC, object oItem );
void HopeAura( object oPC );


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch ( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            string sItemName = GetName(oItem);
            location lTarget = GetItemActivatedTargetLocation();

            if( sItemName == "Bakudan"){

                Bakudan( oPC, oTarget, lTarget );
            }
            if( sItemName == "Siren Song"){

                SirenSong( oPC );
            }
            if( sItemName == "Epic Warding"){

                EpicWard( oPC );
            }
            if( sItemName == "Dragopotion"){

                DragonPotion( oPC, oItem );
            }
            if( sItemName == "Aura of Hope"){

                HopeAura( oPC );
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}
//-------------------------------------------------------------------------------
// Functions - See Subheading for individual scripts
//-------------------------------------------------------------------------------

// ---------------------
// Neus's Bakudan Attack
// ---------------------
void Bakudan( object oPC, object oTarget, location lTarget ){

    int iCharges = 0;
    int iCounter = 0;

    while( GetHasFeat( FEAT_KI_CRITICAL, oPC ) && iCounter < 5 ){

        DecrementRemainingFeatUses( oPC, FEAT_KI_DAMAGE );
        iCharges++;
        iCounter++;
     }

    if( iCharges == 0 ){

        SendMessageToPC( oPC, "You cannot use this technique without at least 1 charge of Ki Damage." );
        return;
    }

    // General Effects
    effect eMovement    = EffectMovementSpeedDecrease( 20 * iCharges );
    effect eArcane      = EffectSpellFailure( 20 * iCharges );
    effect eVisual      = EffectVisualEffect( VFX_FNF_GAS_EXPLOSION_FIRE );
    effect eVisualTwo   = EffectVisualEffect( VFX_DUR_GLOW_RED );

    // Linked Effects
    effect eFort        = EffectLinkEffects( eMovement, eArcane );
    eFort               = EffectLinkEffects( eFort, eVisualTwo );

    if( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE ){

        // Multiple Attack

        // Local Variables for multiple
        int iDC             = 10 + GetAbilityModifier( ABILITY_WISDOM, oPC );
        int iChargesDup     = iCharges;

        // Local Effects for multiple
        effect eDamage      = EffectDamage( 8 );
        effect eAttack      = EffectLinkEffects( eVisual, eDamage );

        while( iChargesDup ){

            object oNewVictim = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );

            while ( GetIsObjectValid( oNewVictim ) ){

                if ( oNewVictim == oPC ){

                    oNewVictim = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );
                }

                DelayCommand( 0.1 * iChargesDup , ApplyEffectToObject( DURATION_TYPE_INSTANT, eAttack, oNewVictim ) );

                if ( FortitudeSave( oNewVictim, iDC ) == 0 ){

                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eFort, oNewVictim, RoundsToSeconds( iCharges ) );
                }

                oNewVictim = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );
            }

            iChargesDup--;
        }
    }
    else { //Singular Attack

        // Local Variables for singular
        int iDC         = GetAbilityScore( oPC, ABILITY_WISDOM );
        int iChargesDup = iCharges;

        // Local Effects for singular
        effect eDamage      = EffectDamage( 6 );
        effect eAttack      = EffectLinkEffects( eDamage, eVisual );

        while( iChargesDup ){

            DelayCommand( 0.1 * iChargesDup, ApplyEffectToObject( DURATION_TYPE_INSTANT, eAttack, oTarget ) );
            iChargesDup--;
        }

        iChargesDup = iCharges;

        while( iChargesDup ){

            object oNewVictim     = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget );

            while ( GetIsObjectValid( oNewVictim ) ){

                 if ( oNewVictim != oPC ){

                     DelayCommand( 0.1 * iChargesDup, ApplyEffectToObject( DURATION_TYPE_INSTANT, eAttack, oNewVictim ) );

                     if ( FortitudeSave( oNewVictim, iDC ) == 0 ){

                        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVisualTwo, oNewVictim, RoundsToSeconds( iCharges ) );
                        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eMovement, oNewVictim, RoundsToSeconds( iCharges ) );
                        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eArcane, oNewVictim, RoundsToSeconds( iCharges ) );
                     }
                 }

                 oNewVictim = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget );
            }

            iChargesDup--;
        }
    }
}

// -----------------------------------------------------------------------------------------
// Xavi's Siren Song, failed will save results in -CHA mod to will saves for CHA mod rounds.
// -----------------------------------------------------------------------------------------
void SirenSong ( object oPC ){

    AssignCommand( oPC, SpeakString( "Item activated" ) );

    // Check ability to sing.
    if ( !GetHasFeat( FEAT_BARD_SONGS, oPC ) ){

        // Check if caster has remaining bardsong.
        FloatingTextStrRefOnCreature( 85587, oPC );
        return;
    }

    if ( GetHasEffect( EFFECT_TYPE_SILENCE, oPC ) ){

        // Check if caster is silenced.
        FloatingTextStrRefOnCreature( 85764, oPC );
        return;
    }

    //AssignCommand( oPC, SpeakString( "Has feat and is not silent" ) );


    // Variables
    int nCHAmod     = GetAbilityModifier( ABILITY_CHARISMA, oPC );
    int nLevel      = GetLevelByClass( CLASS_TYPE_BARD, oPC );
    int nDuration   = 10; //+nLevel +nCHAmod
    int nDC         = nCHAmod + nLevel+ nDuration;

    //AssignCommand( oPC, SpeakString( "CHA mod: "+IntToString( nCHAmod ) ) );

    // Efects
    effect eSave    = EffectSavingThrowDecrease( SAVING_THROW_WILL, nCHAmod, SAVING_THROW_TYPE_ALL );
    effect eFailed  = EffectVisualEffect( 49 ); //Dazed effect
    effect eLink    = EffectLinkEffects( eSave, eFailed );
    effect eWail    = EffectVisualEffect( 39 ); //Wail of the Banshee effect

    // Apply Caster Effect
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eWail, oPC );

    // Apply Effects to Targets
    location lSelf = GetLocation( oPC );
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lSelf );

    while( GetIsObjectValid( oTarget ) ){

        //AssignCommand( oPC, SpeakString( "Creature: "+GetName( oTarget ) ) );

        // Check if target is hostile.
        if ( GetIsReactionTypeHostile( oTarget, oPC ) ){

            //AssignCommand( oPC, SpeakString( "Hostile: "+GetName( oTarget ) ) );

           // Check if target can hear (Is not deaf).
            if ( !GetHasEffect( EFFECT_TYPE_DEAF, oTarget ) ){

                //AssignCommand( oPC, SpeakString( "Not Deaf: "+GetName( oTarget ) ) );

                int nWill = WillSave( oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, oPC );

                if ( nWill == 0 ){

                    //AssignCommand( oPC, SpeakString( "Failed save: "+GetName( oTarget ) ) );

                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds( nCHAmod ) );
                }
            }
        }

        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lSelf );
    }

    DecrementRemainingFeatUses( oPC, FEAT_BARD_SONGS );
}

// --------------------------------------------------
// Wakaman's Epic Warding visual, lasts 1 hour / day.
// --------------------------------------------------
void EpicWard( object oPC ){

    effect eWard = EffectVisualEffect( 495 );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eWard, oPC, RoundsToSeconds( 20 ) );
}

// ------------------------
// Ron's Dragon Skin potion
// Script credit to Ron
// ------------------------
void DragonPotion( object oPC, object oItem ){

    int nSkin = GetAppearanceType( oPC );

    if ( nSkin == 42 ){

        SetCreatureAppearanceType( oPC , 1 );
        SetPortraitResRef( oPC , "decandiel_" );
        SetItemStackSize( oItem , 10 );
    }
    else {

        SetCreatureAppearanceType( oPC, 42 );
        SetPortraitId( oPC, 193 );
        SetItemStackSize( oItem, 10 );
    }
}

// -------------------------------------------
// Trent's Aura of Hope VFX & +4 Saves to Fear
// -------------------------------------------
void HopeAura( object oPC ){

    effect ePulse = EffectVisualEffect( 515 );
    effect eHoly = EffectVisualEffect( 273 );
    effect eLink = EffectLinkEffects( ePulse, eHoly );
    effect eSave = EffectSavingThrowIncrease( SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_FEAR );
    float fDur = TurnsToSeconds( 4 );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eLink, oPC, fDur );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eSave, oPC, fDur );

    location lSelf = GetLocation( oPC );
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_SMALL, lSelf );

    while( GetIsObjectValid( oTarget ) ){

        if( GetIsReactionTypeFriendly( oTarget, oPC )){

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eSave, oTarget, fDur );

        }

        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lSelf );
    }
}
