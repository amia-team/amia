/*  i_ds_customitem6

--------
Verbatim
--------
Pools custom item request scripts

---------
Changelog
---------

Date         Name        Reason
------------------------------------------------------------------
2008-11-03   Disco       Start
2009-03-06   Disco       Added 10 new requests, end of file.
2009-03-16   Disco       Corrections, finished Humanity Widget
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


//-------------------------------------------------------------------------------
//Prototypes
//-------------------------------------------------------------------------------

void MetavirsScintillatingShadows( object oPC );

void HolyWater( object oPC, object oTarget );

void MonkDispel( object oTarget );

void SiphonMagic( object oPC, object oTarget );

void BladesongSerenade( object oPC, object oTarget );

void BlackguardFervour( object oPC, object oTarget, location lTarget );

void HumanityWidget( object oPC );

void Balm( object oPC, object oTarget, int nDamageType, int nVFX );

void ObscuringMist( object oPC );

void FearHowl( object oPC );

void BarkSkin( object oPC, object oTarget );

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

            if ( sItemName == "Metavir's Scintillating Shadows" ){

                //1/day
                AssignCommand( oPC, MetavirsScintillatingShadows( oPC ) );

            }
            else if ( sItemName == "Martial Oracle" ){

                //5/day

                float fDuration = TurnsToSeconds( GetAbilityModifier( ABILITY_CHARISMA, oPC ) );
                int nConceal    = 10 + ( GetHitDice( oPC ) * 2 );
                int nAB         = GetAbilityModifier( ABILITY_WISDOM, oPC );

                if ( nConceal > 50 ){

                    nConceal = 50;
                }

                if ( nAB > 5 ){

                    nAB = 5;
                }

                effect eTotal   = EffectAttackIncrease( nAB );
                eTotal          = EffectLinkEffects( EffectConcealment( nConceal ), eTotal );
                eTotal          = EffectLinkEffects( EffectVisualEffect( VFX_EYES_CYN_HUMAN_FEMALE ), eTotal );

                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eTotal, oPC, fDuration );
            }
            else if ( sItemName == "Vhid'Zakath's Censer of Purity" ){

                //1/day. Black orb
                float fDuration = TurnsToSeconds( 10 );
                effect eVFX     = EffectAreaOfEffect( AOE_MOB_TYRANT_FOG, "****", "****", "****" );
                effect eBuff    = EffectImmunity( IMMUNITY_TYPE_POISON );

                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVFX, oPC, fDuration );

                oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 10.0, GetLocation( oPC ), FALSE );

                //Cycle through the targets within the spell shape until an invalid object is captured.
                while(GetIsObjectValid(oTarget)){

                    if ( GetIsReactionTypeFriendly( oTarget, oPC ) ){

                        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration );
                    }

                    oTarget = GetNextObjectInShape( SHAPE_SPHERE, 10.0, GetLocation( oPC ), FALSE );
                }
            }
            else if ( sItemName == "Hot Chicken Wings" ){

                if ( GetCreatureWingType( oPC ) == CREATURE_WING_TYPE_BIRD ){

                    SetCreatureWingType( CREATURE_WING_TYPE_NONE, oPC );
                }
                else{

                    SetCreatureWingType( CREATURE_WING_TYPE_BIRD, oPC );
                }
            }
            else if ( sItemName == "Blessing of the Martyr" ){

                int nResult = TakeFeatUses( oPC, FEAT_WHOLENESS_OF_BODY, 1 );

                if ( nResult ){

                    int nHeal   = GetMaxHitPoints( oTarget ) - GetCurrentHitPoints( oTarget );
                    int nDamage = nHeal / 2;
                    int nHealth = GetCurrentHitPoints( oPC );

                    if ( nHealth <= nDamage ){

                        nHeal = ( nHealth * 2 ) - 2;
                        nDamage = nHealth - 1;
                    }

                    effect eHeal   = EffectHeal( nHeal );
                    effect eDamage = EffectDamage( nDamage );
                    effect eVis1   = EffectVisualEffect( VFX_IMP_PDK_FINAL_STAND );
                    effect eVis2   = EffectVisualEffect( VFX_IMP_PDK_INSPIRE_COURAGE );
                    effect eVis3   = EffectVisualEffect( VFX_COM_BLOOD_LRG_RED );

                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eHeal, oTarget );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oPC );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis1, oTarget );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis2, oPC );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis3, oPC );
                }
            }
            else if ( sItemName == "Trick Coin" ){

                clean_vars( oPC, 4 );
                SetLocalString( oPC, "ds_action", "ds_customit_act" );
                SetLocalInt( oPC, "ds_check_1", 1 );
                AssignCommand( oPC, ActionStartConversation( oPC, "ds_customitem", TRUE, FALSE ) );

            }
            else if ( sItemName == "Stone Talon Strike" ){

                int nResult = TakeFeatUses( oPC, FEAT_KI_DAMAGE, 3 );

                if ( nResult ){

                    object oWeapon = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oPC );

                    if ( !GetIsObjectValid( oWeapon ) ){

                        SendMessageToPC( oPC, "You need to have a weapon in your right hand!" );
                        return;
                    }

                    effect eVis1     = EffectVisualEffect( VFX_IMP_PDK_FINAL_STAND );
                    effect eVis2     = EffectVisualEffect( VFX_IMP_PDK_GENERIC_HEAD_HIT );

                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis1, oPC );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis2, oPC );

                    itemproperty ip1 = ItemPropertyExtraMeleeDamageType( IP_CONST_DAMAGETYPE_BLUDGEONING );
                    itemproperty ip2 = ItemPropertyMassiveCritical( IP_CONST_DAMAGEBONUS_2d12 );

                    IPSafeAddItemProperty( oWeapon, ip1, TurnsToSeconds( 5 ) );
                    IPSafeAddItemProperty( oWeapon, ip2, TurnsToSeconds( 5 ) );
                }
            }
            else if ( sItemName == "Humanity Widget" ){

                //this is the first bit, for getting his original colors
                HumanityWidget( oPC );
            }
            else if ( sItemName == "Illegalise It" ){

                if ( GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ){

                    SetStolenFlag( oTarget, TRUE );

                    SendMessageToPC( oPC, GetName( oTarget )+" has been flagged as stolen!" );
                }
            }
            else if ( sItemName == "Holy Water for Unholy People" ){

                HolyWater( oPC, oTarget );
            }
            else if ( sItemName == "Absorb Magic" ){

                AssignCommand( oPC, MonkDispel( oTarget ) );
            }
            else if ( sItemName == "Natural D20" ){

                int nMod    = GetAbilityModifier( ABILITY_CHARISMA, oPC );

                string sRoll = "<c þ >[?] <c fþ>Charisma Check</c> = D20: </c>";
                int nRoll    = 16 + Random( 5 );
                sRoll += "<cþ  >"+IntToString( nRoll )+"</c><c þ > + Modifier ( <cþ  > " +IntToString( nMod ) +"</c>";
                sRoll += "<c þ > ) = <cþ  >" +IntToString( nRoll + nMod ) + "</c><c þ > [?]</c>";

                AssignCommand( oPC, ActionSpeakString( sRoll ) );
            }
            else if ( sItemName == "Siphon Magic" ){

                AssignCommand( oPC, SiphonMagic( oPC, oTarget ) );
            }
            else if ( sItemName == "Bladesong Serenade" ){

                BladesongSerenade( oPC, oTarget );
            }
            else if ( sItemName == "Item signer" ){

                if ( GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ){

                    if ( GetIdentified( oTarget ) ){

                        SetDescription( oTarget, GetDescription( oTarget ) + "\n\n<c þ >Puff!</c>" );
                    }
                }
            }
            else if ( sItemName == "Shadower" ){

                effect eShield = EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR );

                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield, oTarget, 1200.0 );
            }
            else if ( sItemName == "Blackguard's Fervour" ){

                AssignCommand( oPC, BlackguardFervour( oPC, oTarget, lTarget ) );
            }
            else if ( sItemName == "Flameberry Balm" ){

                AssignCommand( oPC, Balm( oPC, oTarget, IP_CONST_DAMAGETYPE_FIRE, ITEM_VISUAL_FIRE ) );
            }
            else if ( sItemName == "Iceberry Balm" ){

                AssignCommand( oPC, Balm( oPC, oTarget, IP_CONST_DAMAGETYPE_COLD, ITEM_VISUAL_COLD ) );
            }
            else if ( sItemName == "Obscuring Mist" ){

                ObscuringMist( oPC );
            }
            else if ( sItemName == "Runes of power" ){

                AssignCommand( oPC, FearHowl( oPC ) );
            }
            else if ( sItemName == "Barkskin" ){

                AssignCommand( oPC, BarkSkin( oPC, oPC ) );
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}


//-------------------------------------------------------------------------------
//Definitions
//-------------------------------------------------------------------------------

void MetavirsScintillatingShadows( object oPC ){

    float fDuration = TurnsToSeconds( GetLevelByClass( CLASS_TYPE_WIZARD, oPC ) );
    effect eTotal   = EffectSkillIncrease( SKILL_HIDE, 5 );
    eTotal          = EffectLinkEffects( EffectSavingThrowIncrease( SAVING_THROW_WILL, 3 ), eTotal );
    eTotal          = EffectLinkEffects( EffectUltravision(), eTotal );
    eTotal          = EffectLinkEffects( EffectConcealment( 15 ), eTotal );
    eTotal          = EffectLinkEffects( EffectSpellImmunity( SPELL_LIGHT ), eTotal );
    eTotal          = EffectLinkEffects( EffectSpellImmunity( SPELL_CONTINUAL_FLAME ), eTotal );
    eTotal          = EffectLinkEffects( EffectVisualEffect( 522 ), eTotal );
    eTotal          = EffectLinkEffects( EffectVisualEffect( 346 ), eTotal );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eTotal, oPC, fDuration );

}

void HolyWater( object oPC, object oTarget ){


    if ( !GetIsWeapon( oTarget ) ){

        SendMessageToPC( oPC, "This is not a weapon!" );
        return;
    }

    // Apply casting visual to the weapon wielder.
    effect eCastVisual = EffectVisualEffect( VFX_COM_HIT_DIVINE );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eCastVisual, oPC );

    // Anti-stacking.
    IPRemoveMatchingItemProperties( oTarget, ITEM_PROPERTY_DAMAGE_BONUS );
    IPRemoveMatchingItemProperties( oTarget, ITEM_PROPERTY_VISUALEFFECT );

    itemproperty ipDamage = ItemPropertyDamageBonus( IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d4 );
    itemproperty ipVisual = ItemPropertyVisualEffect( ITEM_VISUAL_HOLY );

    // Apply damage power and visual to the weapon itself.
    IPSafeAddItemProperty( oTarget, ipDamage, TurnsToSeconds( 3 ), X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
    IPSafeAddItemProperty( oTarget, ipVisual, TurnsToSeconds( 3 ) );
}

void MonkDispel( object oTarget ){

    if ( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE ){

        return;
    }

    if ( !TakeFeatUses( OBJECT_SELF, FEAT_STUNNING_FIST, 1 ) ){

        return;
    }

    if ( TouchAttackMelee( oTarget ) < 1 ){

        return;
    }

    DoSpellBreach( oTarget, 4, 5 );
}

void SiphonMagic( object oPC, object oTarget ){

    if ( GetHasSpell( SPELL_MORDENKAINENS_DISJUNCTION ) > 0 ){

        DecrementRemainingSpellUses( oPC, SPELL_MORDENKAINENS_DISJUNCTION );

        int nCL   = GetLevelByClass( CLASS_TYPE_SORCERER, oPC );
        int nRoll = nCL + d20();

        if ( nRoll > 40 ){

            nRoll = 40;
        }

        spellsDispelMagic( oTarget, nRoll, EffectVisualEffect( VFX_FNF_BLINDDEAF ), EffectVisualEffect( VFX_IMP_BLIND_DEAF_M ), FALSE, TRUE );

        effect eHeal = EffectHeal( nCL * 2 );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eHeal, oPC );
    }
    else{

        SendMessageToPC( oPC, "You have no uses of Mordenkainen's Disjunction left!" );
    }

}

void BladesongSerenade( object oPC, object oTarget ){

    float fDur = RoundsToSeconds( GetLevelByClass( CLASS_TYPE_BARD, oPC ) );

    if ( fDur == 0.0 ){

        SendMessageToPC( oPC, "You don't have any Bard levels" );
        return;
    }

    DecrementRemainingSpellUses( oPC, SPELL_EAGLE_SPLEDOR );

    if ( !GetIsWeapon( oTarget ) ){

        SendMessageToPC( oPC, "This is not a weapon!" );
        return;
    }

    // Apply casting visual to the weapon wielder.
    effect eCastVisual = EffectVisualEffect( VFX_FNF_SOUND_BURST );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eCastVisual, oPC );

    // Apply damage power and visual to the weapon itself.
    itemproperty ipDamage = ItemPropertyOnHitProps( IP_CONST_ONHIT_DAZE, IP_CONST_ONHIT_SAVEDC_22, IP_CONST_ONHIT_DURATION_75_PERCENT_1_ROUND );
    itemproperty ipVisual = ItemPropertyVisualEffect( ITEM_VISUAL_ELECTRICAL );
    IPSafeAddItemProperty( oTarget, ipDamage, fDur );
    IPSafeAddItemProperty( oTarget, ipVisual, fDur );
}

void BlackguardFervour( object oPC, object oTarget, location lTarget ){

    if ( TakeFeatUses( oPC, FEAT_TURN_UNDEAD, 1 ) ){

        float fDur          = RoundsToSeconds( 20 );

        effect ePosVis      = EffectVisualEffect( VFX_IMP_EVIL_HELP );
        effect eNegVis      = EffectVisualEffect( VFX_IMP_DOOM );
        effect eImpact      = EffectVisualEffect( VFX_FNF_LOS_EVIL_30 );

        effect eBonAttack   = EffectAttackIncrease( 1 );
        effect eBonSave     = EffectSavingThrowIncrease( SAVING_THROW_ALL, 1 );
        effect eBonDam      = EffectDamageIncrease( 1, DAMAGE_TYPE_SLASHING );
        effect eBonSkill    = EffectSkillIncrease( SKILL_ALL_SKILLS, 1 );
        effect ePosDur      = EffectVisualEffect( VFX_DUR_CESSATE_NEGATIVE );

        effect ePosLink     = EffectLinkEffects( eBonAttack, eBonSave );
        ePosLink            = EffectLinkEffects( ePosLink, eBonDam );
        ePosLink            = EffectLinkEffects( ePosLink, eBonSkill );
        ePosLink            = EffectLinkEffects( ePosLink, ePosDur );

        effect eNegAttack   = EffectAttackDecrease( 1 );
        effect eNegSave     = EffectSavingThrowDecrease( SAVING_THROW_ALL, 1 );
        effect eNegDam      = EffectDamageDecrease( 1, DAMAGE_TYPE_SLASHING );
        effect eNegSkill    = EffectSkillDecrease( SKILL_ALL_SKILLS, 1 );
        effect eNegDur      = EffectVisualEffect( VFX_DUR_CESSATE_NEGATIVE );

        effect eNegLink     = EffectLinkEffects( eNegAttack, eNegSave );
        eNegLink            = EffectLinkEffects( eNegLink, eNegDam );
        eNegLink            = EffectLinkEffects( eNegLink, eNegSkill );
        eNegLink            = EffectLinkEffects( eNegLink, eNegDur );

        location lPC        = GetLocation( oPC );

        //Apply Impact
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact, lTarget );

        //Get the first target in the radius around the caster
        oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lPC );

        while ( GetIsObjectValid( oTarget ) ) {

            if ( GetIsFriend( oTarget ) ) {

                //Fire spell cast at event for target
                SignalEvent(oTarget, EventSpellCastAt( oPC, SPELL_PRAYER, FALSE));

                //Apply VFX impact and bonus effects
                ApplyEffectToObject( DURATION_TYPE_INSTANT, ePosVis, oTarget );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePosLink, oTarget, fDur );
            }
            else if ( spellsIsTarget( oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC ) )  {

                //Fire spell cast at event for target
                SignalEvent(oTarget, EventSpellCastAt( oPC, SPELL_PRAYER));

                if ( !MyResistSpell( oPC, oTarget ) ){

                    //Apply VFX impact and bonus effects
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eNegVis, oTarget);
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eNegLink, oTarget, fDur );
                }
            }

            //Get the next target in the specified area around the caster
            oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lPC );
        }
    }
}

void HumanityWidget( object oPC ){

    int nCurrentHair = GetColor( oPC, COLOR_CHANNEL_HAIR );
    int nCurrentSkin = GetColor( oPC, COLOR_CHANNEL_SKIN );
    effect eVis      = EffectVisualEffect( VFX_IMP_HEALING_S );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );

    if ( nCurrentHair == 111 ){

        SetColor( oPC, COLOR_CHANNEL_HAIR, 3 );
    }
    else{

        SetColor( oPC, COLOR_CHANNEL_HAIR, 111 );
    }

    if ( nCurrentSkin == 107 ){

        SetColor( oPC, COLOR_CHANNEL_SKIN, 3 );
    }
    else{

        SetColor( oPC, COLOR_CHANNEL_SKIN, 107 );
    }
}

void Balm( object oPC, object oTarget, int nDamageType, int nVFX ){

    object oWeapon = GetWeapon( oTarget );

    if ( !GetIsObjectValid( oWeapon ) ){

        SendMessageToPC( oPC, "This is not a weapon or the target has no weapon!" );

        return;
    }

    float fDur = TurnsToSeconds( GetLevelByClass( CLASS_TYPE_DRUID, oPC ) );

    if ( fDur == 0.0 ){

        SendMessageToPC( oPC, "You need Druid levels for this." );
        return;
    }

    //remove any other temp stuff
    IPRemoveMatchingItemProperties( oTarget, ITEM_PROPERTY_DAMAGE_BONUS );
    IPRemoveMatchingItemProperties( oTarget, ITEM_PROPERTY_VISUALEFFECT );

    // Apply damage power and visual to the weapon itself.
    itemproperty ipDamage = ItemPropertyDamageBonus( nDamageType, IP_CONST_DAMAGEBONUS_1d8 );
    itemproperty ipVisual = ItemPropertyVisualEffect( nVFX );
    IPSafeAddItemProperty( oTarget, ipDamage, fDur, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
    IPSafeAddItemProperty( oTarget, ipVisual, fDur );
}

void ObscuringMist( object oPC ){

    if ( GetHasSpell( SPELL_CAMOFLAGE ) > 0 ){

        DecrementRemainingSpellUses( oPC, SPELL_CAMOFLAGE );
    }
    else{

        SendMessageToPC( oPC, "You have no uses of Camouflage left!" );
        return;
    }

    effect eImpact  = EffectVisualEffect(VFX_IMP_DEATH);
    effect eVis     = EffectVisualEffect(VFX_DUR_GHOST_SMOKE_2);
    effect eDur     = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
    effect eCover   = EffectConcealment(20);
    effect eLink    = EffectLinkEffects(eDur, eCover);
    eLink           = EffectLinkEffects(eLink, eVis);

    int nDuration   = GetLevelByClass( CLASS_TYPE_DRUID, oPC );

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds( nDuration ) );
}

void FearHowl( object oPC ){

    //Declare major variables
    effect eVis    = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eHowl   = EffectFrightened();
    effect eDur    = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2   = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eImpact = EffectVisualEffect(VFX_FNF_HOWL_MIND);

    effect eLink = EffectLinkEffects(eHowl, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);

    float fDelay;
    int nHD         = GetHitDice(oPC);
    int nDC         = 20 + GetAbilityModifier( ABILITY_CHARISMA, oPC );
    int nDuration   = 1 + (nHD/4);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oPC );

    location lCenter = GetLocation( oPC );

    //Get first target in spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lCenter );

    while ( GetIsObjectValid( oTarget ) ){

        if ( GetIsEnemy( oTarget ) && oTarget != oPC ){

            fDelay = GetDistanceToObject(oTarget)/10;

            //Fire cast spell at event for the specified target
            SignalEvent( oTarget, EventSpellCastAt( oPC, SPELLABILITY_HOWL_FEAR ) );

            //Make a saving throw check
            if ( !MySavingThrow( SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR ) ) {

                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(GetScaledDuration(nDuration , oTarget))));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }

        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lCenter );
    }
}

void BarkSkin( object oPC, object oTarget ){

    if ( GetHasSpell( SPELL_SUMMON_CREATURE_II, oPC ) > 0 ){

        DecrementRemainingSpellUses( oPC, SPELL_SUMMON_CREATURE_II );
    }
    else{

        SendMessageToPC( oPC, "You have no uses of Summon Monster II left!" );
        return;
    }

    //Declare major variables
    object oTarget   = GetSpellTargetObject();
    int nCasterLevel = GetLevelByClass( CLASS_TYPE_RANGER, oPC );
    float fDuration  = NewHoursToSeconds( nCasterLevel );
    effect eVis      = EffectVisualEffect( VFX_DUR_PROT_BARKSKIN );
    effect eHead     = EffectVisualEffect( VFX_IMP_HEAD_NATURE );
    effect eDur      = EffectVisualEffect( VFX_DUR_CESSATE_POSITIVE );
    effect eAC;
    int nBonus;

    //Signal spell cast at event
    SignalEvent( oTarget, EventSpellCastAt( oPC, SPELL_BARKSKIN, FALSE ) );

    //Determine AC Bonus based Level.
    if ( nCasterLevel <= 6 ) {

        nBonus = 3;
    }
    else{

        if ( nCasterLevel <= 12 ) {

            nBonus = 4;
        }
        else {

            nBonus = 5;
        }
    }

    //Make sure the Armor Bonus is of type Natural
    eAC          = EffectACIncrease( nBonus, AC_NATURAL_BONUS );
    effect eLink = EffectLinkEffects( eVis, eAC );
    eLink        = EffectLinkEffects( eLink, eDur );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eHead, oTarget );
}
