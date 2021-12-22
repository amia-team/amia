/*  i_ds_customitem7

--------
Verbatim
--------
Pools custom item request scripts

---------
Changelog
---------

Date         Name        Reason
------------------------------------------------------------------
2009-10-13   Disco       Start
2018-08-12   Hrothmus    Removed Shadow Affinity and Tenebrous Tempo (moved to i_umbran_arts)
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "amia_include"
#include "inc_ds_actions"
#include "x2_inc_itemprop"
#include "x2_inc_spellhook"
#include "X0_I0_SPELLS"
#include "nwnx_effects"
#include "inc_td_appearanc"


//-------------------------------------------------------------------------------
//Prototypes
//-------------------------------------------------------------------------------

void EmptyFunction( object oTarget );

void AlannasShinies( location lTarget );

void GaseousForm( object oItem );

void LifeSoundtrack( );

void DemonHand( object oPC );

void ApplyFaerieFire( object oPC );

void EnforcedSilencer( object oTarget );

void MassEnervation( object oTarget );


void WhiteDragon( object oPC );

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
            string sItemName = GetName( oItem );
            location lTarget = GetItemActivatedTargetLocation();

            if ( sItemName == "Orbb Haranth" ){

                AssignCommand( oPC, DemonHand( oTarget ) );
            }
            else if ( sItemName == "Jud's Jingling Bells" ){

                AssignCommand( oPC, ApplyFaerieFire( oPC ) );
            }
            else if ( sItemName == "Enforced Silencer" ){

                AssignCommand( oPC, EnforcedSilencer( oTarget ) );
            }
            else if ( sItemName == "Mass Enervation" ){

                AssignCommand( oPC, MassEnervation( oTarget ) );
            }
            else if ( sItemName == "Life's Soundtrack" ){

                AssignCommand( oPC, LifeSoundtrack( ) );
            }
            else if ( sItemName == "Gaseous Form" ){

                AssignCommand( oPC, GaseousForm( oItem ) );
            }
            else if ( sItemName == "Last Resort" ){

                AssignCommand( oPC, AlannasShinies( lTarget ) );
            }
            else if ( sItemName == "White Dragonshape" ){

                AssignCommand( oPC, WhiteDragon( oPC ) );
            }
            else if ( sItemName == "" ){

                AssignCommand( oPC, EmptyFunction( oTarget ) );
            }


        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}


//-------------------------------------------------------------------------------
//Definitions
//-------------------------------------------------------------------------------


void EmptyFunction( object oTarget ){

}

void AlannasShinies( location lTarget ){

    object oPC  = OBJECT_SELF;
    effect eVFX = EffectAreaOfEffect( AOE_PER_FOGSTINK, "empty", "empty", "empty" );
    effect eVis = EffectVisualEffect( VFX_IMP_POISON_L );
    effect eDam = EffectLinkEffects( EffectBlindness( ), EffectDeaf() );

    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eVFX, lTarget, 5.0 );

    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 10.0, lTarget, FALSE );

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while ( GetIsObjectValid( oTarget ) ){

        if ( !GetIsReactionTypeFriendly( oTarget ) ){

            //Fire cast spell at event for the specified target
            SignalEvent( oTarget, EventSpellCastAt( OBJECT_SELF, SPELL_BLINDNESS_AND_DEAFNESS ) );

            if ( FortitudeSave( oTarget, 40, SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF ) ){

                //Apply the VFX impact and effects
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDam, oTarget, RoundsToSeconds( 6 ) );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget );
            }
            else{

                SendMessageToPC( OBJECT_SELF, "debug: "+GetName( oTarget )+" made fort save" );
            }
        }
        else{

            SendMessageToPC( OBJECT_SELF, "debug: "+GetName( oTarget )+" is friendly" );
        }

        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 10.0, lTarget, FALSE );
    }
}


void GaseousForm( object oItem ){

    object oPC = OBJECT_SELF;

    //Find oPC's current appearance type
    int nAppear = GetAppearanceType( oPC );

    switch( nAppear ){

        case 818: {// Has invisible human appearance (size 100)

            //Find stored appearance
            nAppear = GetLocalInt( oItem, "STORED_APPEARANCE" );

            //Set the apearance to the stored appearance
            SetCreatureAppearanceType( oPC, nAppear );

            //remove the VFX
            effect eEffect = GetFirstEffect( oPC );

            while ( GetIsEffectValid(eEffect) ) {

                if ( GetEffectCreator( eEffect ) == oPC && GetEffectType( eEffect ) == EFFECT_TYPE_AREA_OF_EFFECT ){

                    RemoveEffect( oPC, eEffect );
                }

                eEffect = GetNextEffect( oPC );
            }

            break;
        }

        default: {// Does not have invisible appearance

            //Store our current appearance
            SetLocalInt( oItem, "STORED_APPEARANCE", nAppear );

            //Set appearance to the invisible human (size 100)
            SetCreatureAppearanceType( oPC, 818 );

            effect eVFX = EffectAreaOfEffect( 46 );

            //Apply the visual. Note: can be removed by resting
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVFX, oPC );

            break;
        }
    }
}

/*
void EmptyFunction( object oTarget ){

}
void EmptyFunction( object oTarget ){

}
void EmptyFunction( object oTarget ){

}
void EmptyFunction( object oTarget ){

}

*/

void LifeSoundtrack( ){

    object oPC = OBJECT_SELF;

    clean_vars( oPC, 4 );

    SetLocalString( oPC, "ds_action", "ds_music_act" );
    SetLocalInt( oPC, "ds_section", 1 );
    SetLocalInt( oPC, "ds_check_1", 1 );

    ActionStartConversation( oPC, "ds_music", TRUE, FALSE );
}



void DemonHand( object oTarget ){

    if ( !GetIsPC( oTarget ) ){

        SendMessageToPC( OBJECT_SELF, "The target of this spell must be a PC." );
        return;
    }

    effect eParal  = EffectParalyze();
    effect eDnHand = EffectVisualEffect( VFX_FNF_DEMON_HAND );
    effect eFrozen = EffectVisualEffect( VFX_DUR_BLUR );

    if ( GetIsImmune( oTarget, IMMUNITY_TYPE_PARALYSIS ) ) {

        SendMessageToPC( OBJECT_SELF, "This target is immune to paralysis." );
        return;
    }

    if ( !MySavingThrow( SAVING_THROW_REFLEX, oTarget, 30, SAVING_THROW_TYPE_CHAOS ) ){

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDnHand, oTarget );

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eFrozen, oTarget, RoundsToSeconds( 5 ) );

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eParal, oTarget, RoundsToSeconds( 5 ) );

        FloatingTextStringOnCreature( "*" + GetName( oTarget ) + " is gripped by a demonic hand!*", oTarget );
    }
    else{

        SendMessageToPC( OBJECT_SELF, "Target made saving throw." );
    }
}


void ApplyFaerieFire( object oPC ){

    if ( !TakeFeatUses( oPC, FEAT_BARD_SONGS, 1 ) ){

        return;
    }

    object oTarget;
    location lTarget = GetLocation( oPC );
    int nGlow   = 0;

    float fTime = RoundsToSeconds( GetLevelByClass( CLASS_TYPE_BARD , oPC ) );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_BARD_SONG ), oPC, fTime );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_FNF_HOWL_WAR_CRY ), oPC, fTime );

    PlaySound( "as_cv_flute1" );

    switch ( d6() ){

        case 1: nGlow = VFX_DUR_GLOW_ORANGE; break;
        case 2: nGlow = VFX_DUR_GLOW_PURPLE; break;
        case 3: nGlow = VFX_DUR_GLOW_RED; break;
        case 4: nGlow = VFX_DUR_GLOW_YELLOW; break;
        case 5: nGlow = VFX_DUR_GLOW_GREEN; break;
        case 6: nGlow = VFX_DUR_GLOW_WHITE; break;
    }

    effect eHarm = EffectSkillDecrease( SKILL_MOVE_SILENTLY, 20 );
    eHarm        = EffectLinkEffects( EffectAttackDecrease( 2 ) , eHarm );
    eHarm        = EffectLinkEffects( EffectVisualEffect( nGlow ) , eHarm );

    oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 10.0, lTarget, FALSE );

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while( GetIsObjectValid( oTarget ) ){

        if ( GetIsReactionTypeHostile( oTarget, oPC ) ){

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eHarm, oTarget, fTime );
        }

        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 10.0, lTarget, FALSE );
    }
}

void EnforcedSilencer( object oTarget ){

    if ( TouchAttackRanged( oTarget ) > 0 ){

        int nDC = 10 + ( GetHitDice( OBJECT_SELF ) / 2 ) + GetAbilityModifier( ABILITY_DEXTERITY );

        if ( ReflexSave( oTarget, nDC ) == 0 ){

            effect eSilence = EffectSilence();
            effect eDamage  = EffectDamage( ( 6 + d8() ), DAMAGE_TYPE_BASE_WEAPON );

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ExtraordinaryEffect( EffectSilence() ), oTarget, RoundsToSeconds( 10 ) );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
        }
    }
}

void MassEnervation( object oTarget ){

    if ( GetHasSpell( SPELL_FINGER_OF_DEATH ) > 0 ){

        DecrementRemainingSpellUses( OBJECT_SELF, SPELL_FINGER_OF_DEATH );
    }
    else{

        SendMessageToPC( OBJECT_SELF, "You have no uses of Finger of Death left!" );
        return;
    }

    //Declare major variables
    effect eVis         = EffectVisualEffect( VFX_IMP_REDUCE_ABILITY_SCORE );
    effect eDur         = EffectVisualEffect( VFX_DUR_CESSATE_NEGATIVE );
    effect eDrain;
    effect eLink;

    int nCL             = GetLevelByClass( CLASS_TYPE_WIZARD );
    int nResist         = 0;
    int nResistMod;
    int nRoll;
    int nDC             = 10 + nCL + 7 + GetAbilityModifier( ABILITY_INTELLIGENCE );
    int nDrain;

    location lTarget    = GetLocation( oTarget );

    if ( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_NECROMANCY ) ){

        nDC += 6;
    }
    else if ( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_NECROMANCY ) ){

        nDC += 4;
    }
    else if ( GetHasFeat( FEAT_SPELL_FOCUS_NECROMANCY ) ){

        nDC += 2;
    }

    if ( GetHasFeat( FEAT_EPIC_SPELL_PENETRATION ) ){

        nResistMod = 6;
    }
    else if ( GetHasFeat( FEAT_GREATER_SPELL_PENETRATION ) ){

        nResistMod = 4;
    }
    else if ( GetHasFeat( FEAT_SPELL_PENETRATION ) ){

        nResistMod = 2;
    }



    object oObject = GetFirstObjectInShape( SHAPE_SPHERE, 10.0, lTarget, FALSE );

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while ( GetIsObjectValid( oObject ) ){

        if ( !GetIsReactionTypeFriendly( oObject ) ){

            //Fire cast spell at event for the specified target
            SignalEvent( oObject, EventSpellCastAt( OBJECT_SELF, SPELL_ENERVATION ) );

            nResist = nResistMod + nCL + d20();
            nRoll   = GetSpellResistance( oObject ) + d20();

            //Resist magic check
            if ( nRoll > nResist ){

                if ( FortitudeSave( oObject, nDC, SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF ) ){

                    eDrain       = EffectNegativeLevel( d4() );
                    eLink        = EffectLinkEffects( eDrain, eDur );

                    //Apply the VFX impact and effects
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oObject, NewHoursToSeconds( nCL ) );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oObject );
                }
                else{

                    SendMessageToPC( OBJECT_SELF, "debug: "+GetName( oObject )+" made fort save vs DC "+IntToString( nDC ) );
                }
            }
            else{

                SendMessageToPC( OBJECT_SELF, "debug: "+GetName( oObject )+" made resist save" );
                SendMessageToPC( OBJECT_SELF, "debug: "+IntToString( nRoll )+" vs "+IntToString( nResist ) );
            }
        }
        else{

            SendMessageToPC( OBJECT_SELF, "debug: "+GetName( oObject )+" is friendly" );
        }

        oObject = GetNextObjectInShape( SHAPE_SPHERE, 10.0, lTarget, FALSE );
    }
}

void WhiteDragon( object oPC ){

    if ( !TakeFeatUses( oPC, FEAT_EPIC_WILD_SHAPE_DRAGON, 1 ) ){

        SendMessageToPC( oPC, "You need a charge of your dragonshape to use this!" );
        return;
    }

    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_SUMMONDRAGON ), oPC );

    // Variables
    effect ePoly = EffectPolymorph( 214 );

    int bWeapon = StringToInt(Get2DAString("polymorph","MergeW",214)) == 1;
    int bArmor  = StringToInt(Get2DAString("polymorph","MergeA",214)) == 1;
    int bItems  = StringToInt(Get2DAString("polymorph","MergeI",214)) == 1;

    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oArmorOld = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
    object oRing1Old = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oPC);
    object oRing2Old = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oPC);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,oPC);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,oPC);
    object oBeltOld = GetItemInSlot(INVENTORY_SLOT_BELT,oPC);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);

    if (GetIsObjectValid(oShield)){

        if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
        {
            oShield = OBJECT_INVALID;
        }
    }

    int nCannotDrown = ds_check_uw_items( oPC );

    //Apply the VFX impact and effects
    ClearAllActions(); // prevents an exploit
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePoly, oPC );

    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);

    SetLocalInt( oPC, "CannotDrown", nCannotDrown );

    if (bWeapon)
    {
        IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);
    }
    if (bArmor)
    {
        IPWildShapeCopyItemProperties(oShield,oArmorNew);
        IPWildShapeCopyItemProperties(oHelmetOld,oArmorNew);
        IPWildShapeCopyItemProperties(oArmorOld,oArmorNew);
    }
    if (bItems)
    {
        IPWildShapeCopyItemProperties(oRing1Old,oArmorNew);
        IPWildShapeCopyItemProperties(oRing2Old,oArmorNew);
        IPWildShapeCopyItemProperties(oAmuletOld,oArmorNew);
        IPWildShapeCopyItemProperties(oCloakOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBootsOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBeltOld,oArmorNew);
    }
}
