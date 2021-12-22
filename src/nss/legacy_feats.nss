//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_cust_feat
//description: Script for custom feats
//used as: Custom featscript

/*
---------
Changelog
---------
Date         Name        Reason
------------------------------------------------------------------
2012-05-03   PoS         Start
2012-09-20   Glim        Added Shadow Fusion
2012-10-02   PoS         Added Tactical Approach
2013-02-23   PoS         Added Bladesinging & Augment Summoning
2013-04-12   Glim        Added Deep Guard Acrobatic Fighting
2013-08-24   Terrah      Renamed ds_cust_feat renamed into legacy_feats, see ds_cust_feat
------------------------------------------------------------------
*/

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------

#include "inc_ds_records"
#include "x2_inc_spellhook"
//custom spell constants
#include "inc_dc_feats"
#include "x2_inc_toollib"
#include "x2_inc_itemprop"
#include "x0_i0_spells"
#include "x2_i0_spells"
#include "x0_i0_position"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------
void ShadedgeSynthesis( object oPC, object oTarget );
void ShadowFusion( object oPC );
void TacticalApproach( object oPC );
void AugmentSummon( object oPC );
void BladeSinging( object oPC );
void AcrobaticRoll( object oPC, object oTarget );
void IntuitiveAttack( object oPC );


//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void main( ){
    //standard entry block
    object      oPC         = OBJECT_SELF;
    object      oTarget     = GetSpellTargetObject( );
    location    lTarget     = GetSpellTargetLocation( );
    object      oWeapon     = IPGetTargetedOrEquippedMeleeWeapon();
    int         nSpell      = GetSpellId( );
    string      sPCKey      = GetName( GetPCKEY( oPC ) );
    int         nCustSpellID= GetLocalInt(oPC, "CustomFeatID");

    //Precast code, this function also trigges the spellhook
    if( !X2PreSpellCastCode( ) ){
        return;
    }
    //Allow the DM to cast any custom spell
    if (GetIsDM(oPC) || GetIsDMPossessed(oPC)){
        switch (nCustSpellID){
            case CS_SHADEDGE_SYNTH:
                ShadedgeSynthesis( oPC, oTarget);
                break;
            case CS_SHADOW_FUSE:
                ShadowFusion( oPC );
                break;
            case CS_TACTICAL_APPROACH:
                TacticalApproach( oPC );
                break;
            case CS_BLADESINGING:
                BladeSinging( oPC );
                break;
            case CS_ACROBATIC_ROLL:
                AcrobaticRoll( oPC, oTarget );
                break;
            case CS_INTUITIVE_ATTACK:
                IntuitiveAttack( oPC );
                break;
            default:
                return;
        }
        return;
    }
    // Enter IF block for PCKEY check
    if( sPCKey == "Q7RRL6CL_20120203141910" ){
        switch( nSpell ){
            case DC_FEAT_ACT:
                ShadedgeSynthesis( oPC, oTarget );
                break;
            default:
                SendMessageToPC( oPC, "This feat does nothing!" );
        }
    }else if( sPCKey == "QC7TMME3_20120223043017" ){
        switch( nSpell ){
            case DC_FEAT_ACT:
                ShadowFusion( oPC );
                break;
            default:
                SendMessageToPC( oPC, "This feat does nothing!" );
        }
    }else if( sPCKey == "DPNJ9PTR_20110726031551" ){
        switch( nSpell ){
            case DC_FEAT_ACT:
                TacticalApproach( oPC );
                break;
            default:
                SendMessageToPC( oPC, "This feat does nothing!" );
        }
    }else if( sPCKey == "Q7RRQXMF_20111229212850" ){
        switch( nSpell ){
            case DC_FEAT_INS:
                BladeSinging( oPC );
                break;
            default:
                SendMessageToPC( oPC, "This feat does nothing!" );
        }
    }else if( sPCKey == "QGM9JJ6F_20130129050147" ){
        switch( nSpell ){
            case DC_FEAT_INS:
                AugmentSummon( oPC );
                break;
            default:
                SendMessageToPC( oPC, "This feat does nothing!" );
        }
    }else if( sPCKey == "QC7QX6DJ_20121207155013" ){
        switch( nSpell ){
            case DC_FEAT_INS:
                AcrobaticRoll( oPC, oTarget );
                break;
            default:
                SendMessageToPC( oPC, "This feat does nothing!" );
        }
    }else if( sPCKey == "ActivateWhenPCIsMade" ){
        switch( nSpell ){
            case DC_FEAT_INS:
                IntuitiveAttack( oPC );
                break;
            default:
                SendMessageToPC( oPC, "This feat does nothing!" );
        }
    }
    else
    {
        SendMessageToPC( oPC, "This feat does nothing!" );
    }

}

void ShadedgeSynthesis( object oPC, object oTarget )
{
    int nCount = GetLocalInt( oPC, "cus_feat_use_act" );

    if( nCount >= 3 )
    {
        SendMessageToPC( oPC, "You have exhausted all uses for this feat today." );
        return;
    }

    nCount = nCount + 1;

    SetLocalInt( oPC, "cus_feat_use_act", nCount );

    if( !GetSlashingWeapon( GetWeapon( oTarget ) ) )
    {
        SendMessageToPC( oPC, "This ability only works on slashing weapons!" );
        return;
    }

    // prevent stacking with self
    if ( GetHasSpellEffect( GetSpellId(), oTarget ) )
    {
        RemoveEffectsFromSpell( oTarget, GetSpellId() );
    }

    effect eDamage  = EffectDamageIncrease( DAMAGE_BONUS_3, DAMAGE_TYPE_NEGATIVE );
    effect eDur     = EffectVisualEffect( VFX_DUR_GHOST_SMOKE );
    effect eVis1    = EffectVisualEffect( VFX_IMP_DEATH_WARD );

    float fDuration = TurnsToSeconds( GetLevelByClass( CLASS_TYPE_WIZARD, oPC ) + GetLevelByClass( CLASS_TYPE_BARD, oPC ) + GetLevelByClass( CLASS_TYPE_SORCERER, oPC ) );

    effect eLink    = EffectLinkEffects( eDamage, eDur );

    // VFX candy.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis1, oTarget );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ExtraordinaryEffect( eLink ), oTarget, fDuration );

    SetBlockTime( oPC, 0, FloatToInt( fDuration ), "synthesis_on" );
}

void ShadowFusion( object oPC )
{
    location lPC = GetLocation( oPC );
    int nShadowRank = GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oPC );
    float fDur = TurnsToSeconds( nShadowRank );

    if( GetHasFeat( FEAT_SUMMON_SHADOW, oPC ) == FALSE )
    {
        return;
    }

    DecrementRemainingFeatUses( oPC, FEAT_SUMMON_SHADOW );

    effect eHowl = EffectVisualEffect( VFX_FNF_HOWL_ODD );
    effect ePulse = EffectVisualEffect( VFX_DUR_AURA_MAGENTA );
    effect eDim = EffectVisualEffect( VFX_DUR_ANTI_LIGHT_10 );
    effect eRadius = EffectVisualEffect( VFX_DUR_AURA_ODD );
    effect eEvil = EffectVisualEffect( VFX_DUR_TENTACLE );

    effect eConceal = EffectConcealment( 50 );
    effect eNeg = EffectDamageImmunityIncrease( DAMAGE_TYPE_NEGATIVE, 100 );
    effect eLevel = EffectImmunity( IMMUNITY_TYPE_NEGATIVE_LEVEL );
    effect eAbil = EffectImmunity( IMMUNITY_TYPE_ABILITY_DECREASE );
    effect eAura = EffectAreaOfEffect( AOE_PER_CUSTOM_AOE, "", "shadow_fuse_aura", "" );

    effect eLink = EffectLinkEffects( ePulse, eDim );
           eLink = EffectLinkEffects( eRadius, eLink );
           eLink = EffectLinkEffects( eEvil, eLink );
           eLink = EffectLinkEffects( eConceal, eLink );
           eLink = EffectLinkEffects( eNeg, eLink );
           eLink = EffectLinkEffects( eLevel, eLink );
           eLink = EffectLinkEffects( eAbil, eLink );
           eLink = EffectLinkEffects( eAura, eLink );

           eLink = ExtraordinaryEffect( eLink );

    effect eInvis = ExtraordinaryEffect( EffectInvisibility( INVISIBILITY_TYPE_NORMAL ) );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eHowl, oPC );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, fDur );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eInvis, oPC, fDur );
    CreateObjectVoid( OBJECT_TYPE_PLACEABLE, "cus_shadow_fuse", lPC, FALSE, "", 6.0 );
}

void TacticalApproach( object oPC )
{
    // Variables for effects and visuals.
    effect eImpact  = EffectVisualEffect( VFX_IMP_AC_BONUS );
    object oArmor;

    if ( GetHasSpellEffect( 930 ) )
    {
        // Cycle through targets in a sphere shape until the target is invalid.
        object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation( oPC ), TRUE, OBJECT_TYPE_CREATURE );
        while ( GetIsObjectValid( oTarget ) )
        {
            effect eEffects = GetFirstEffect( oTarget );

            while( GetIsEffectValid( eEffects ) ){
                if ( GetEffectCreator( eEffects ) == oPC )
                {
                    if( GetEffectSpellId( eEffects ) == 930 )
                    {
                        // Remove all aura effects this PC has applied already.
                        RemoveEffect( oTarget, eEffects );
                    }
                }
                eEffects = GetNextEffect( oTarget );
            }

            oArmor = GetItemInSlot( INVENTORY_SLOT_CHEST, oTarget );
            if ( GetHasSpellEffect( 930, oArmor ) )
            {
                RemoveEffectsFromSpell( oArmor, 930 );
            }

            // Select the next target within the spell shape.
            oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation( oPC ), TRUE, OBJECT_TYPE_CREATURE );
        }
    }
    else
    {

        effect eAOE    = EffectAreaOfEffect( AOE_MOB_DRAGON_FEAR, "cs_tactical_a", "****", "cs_tactical_b" );
        effect eSTR    = EffectAbilityIncrease( ABILITY_STRENGTH, 3 );

        itemproperty eFeat1 = ItemPropertyBonusFeat( 440 );
        itemproperty eFeat2 = ItemPropertyBonusFeat( 841 );

        oArmor = GetItemInSlot( INVENTORY_SLOT_CHEST, oPC );

        // Link the AOE and the effect to apply to the PC directly.
        effect eLink = EffectLinkEffects( eSTR, eAOE );
        eLink = ExtraordinaryEffect( eLink );

        // Apply the VFX impact and effects.
        DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oPC ) );
        DelayCommand( 0.1, IPSafeAddItemProperty( oArmor, eFeat1, 1000000.0f ) );
        DelayCommand( 0.1, IPSafeAddItemProperty( oArmor, eFeat2, 1000000.0f ) );
        DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_INSTANT, eImpact, oPC ) );
   }
}

void AugmentSummon( object oPC )
{
    object oSummon  = GetAssociate( ASSOCIATE_TYPE_SUMMONED, oPC );
    effect eSTR     = EffectAbilityIncrease( ABILITY_STRENGTH, 4 );
    effect eCON     = EffectAbilityIncrease( ABILITY_CONSTITUTION, 4 );
    effect eVFX     = EffectVisualEffect( VFX_IMP_IMPROVE_ABILITY_SCORE );

    if( oSummon != OBJECT_INVALID )
    {
        if( !GetHasSpellEffect( GetSpellId(), oSummon ) )
        {
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eSTR, oSummon );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eCON, oSummon );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oSummon );
            SendMessageToPC( oPC, "Augment Summoning added to "+GetName( oSummon ) );
        }
    }
}

void BladeSinging( object oPC ) // This will later be expanded when the player requests more abilities
{
    int nINT        = GetAbilityModifier( ABILITY_INTELLIGENCE, oPC );
    object oWeapon  = GetWeapon( oPC );
    object oShield  = GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oPC );

    if( nINT > 7 )
    {
        nINT = 7;
    }

    if( nINT < 0 )
    {
        nINT = 0;
    }

    // General Bladesinger bonuses
    effect eAC                  = EffectACIncrease( nINT, AC_SHIELD_ENCHANTMENT_BONUS );
    effect eConc                = EffectSkillIncrease( SKILL_CONCENTRATION, 5 );
    effect eDisc                = EffectSkillIncrease( SKILL_DISCIPLINE, 5 );
    effect eParry               = EffectSkillIncrease( SKILL_PARRY, 10 );
    effect eSpell               = EffectSkillDecrease( SKILL_SPELLCRAFT, 10 );
    effect eVFX1                = EffectVisualEffect( 685 );

    // Song of Fury bonuses
    effect eAttack              = EffectModifyAttacks( 1 );
    effect eAB                  = EffectAttackDecrease( 2 );
    effect eConc2               = EffectSkillDecrease( SKILL_CONCENTRATION, 10 );
    effect eVFX2                = EffectVisualEffect( 687 );
    itemproperty ipOnHitDaze    = ItemPropertyOnHitProps( IP_CONST_ONHIT_DAZE, IP_CONST_ONHIT_SAVEDC_26, IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS );
    itemproperty ipDamage       = ItemPropertyDamageBonus( IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d6 );

    effect eLink                = EffectLinkEffects( eAC, eConc );
           eLink                = EffectLinkEffects( eDisc, eLink );
           eLink                = EffectLinkEffects( eParry, eLink );
           eLink                = EffectLinkEffects( eSpell, eLink );
           eLink                = EffectLinkEffects( eVFX1, eLink );
           eLink                = EffectLinkEffects( eAttack, eLink );
           eLink                = EffectLinkEffects( eAB, eLink );
           eLink                = EffectLinkEffects( eConc2, eLink );

    eLink   = ExtraordinaryEffect( eLink );

    if( GetHasSpellEffect( GetSpellId(), oPC ) )
    {
        FloatingTextStringOnCreature( " - Bladesong Deactivated -", oPC, FALSE );
        RemoveEffectsFromSpell( oPC, GetSpellId() );
        RemoveEffectsFromSpell( oWeapon, GetSpellId() );
        return;
    }
    else if( GetHasSpellEffect( GetSpellId(), oWeapon ) )
    {
        FloatingTextStringOnCreature( " - Bladesong Deactivated -", oPC, FALSE );
        RemoveEffectsFromSpell( oPC, GetSpellId() );
        RemoveEffectsFromSpell( oWeapon, GetSpellId() );
        return;
    }
    else
    {
        if( oShield != OBJECT_INVALID )
        {
            FloatingTextStringOnCreature( " - You cannot Bladesing with an off-hand weapon/shield equipped! -", oPC, FALSE );
            return;
        }

        if ( GetHasSpellEffect( SPELL_DARKFIRE, oWeapon ) || GetHasSpellEffect( SPELL_FLAME_WEAPON, oWeapon ) )
        {
            RemoveEffectsFromSpell( oWeapon, SPELL_DARKFIRE );
            RemoveEffectsFromSpell( oWeapon, SPELL_FLAME_WEAPON );
        }

        FloatingTextStringOnCreature( " - Bladesong Activated -", oPC, FALSE );

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oPC );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oPC );
        IPSafeAddItemProperty( oWeapon, ipDamage, 1000000.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE );
        IPSafeAddItemProperty( oWeapon, ipOnHitDaze, 1000000.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE );
    }
}

void AcrobaticRoll( object oPC, object oTarget )
{
    //Only works on the living and enemy targets
    if( !GetIsObjectValid( oTarget ) || !GetIsEnemy( oTarget, oPC ) )
    {
        return;
    }

    //If the target blocks the movement
    int nCL = GetCharacterLevel( oPC ) / 2;
    int nDex = GetAbilityModifier( ABILITY_DEXTERITY, oPC );
    int nDC = 10 + nCL + nDex;
    int nSave = ReflexSave( oTarget, nDC, SAVING_THROW_TYPE_NONE, oPC );
    string sName = GetName( oTarget );
    if( nSave >= 1 )
    {
        SpeakString( "*attempts to roll behind "+sName+" but comes up short*" );
        return;
    }

    //else continue with a successful roll
    string sText;
    int nText = d6(1);
    int nCry = d3(1);

    float fDir = GetFacing( oTarget );
    float fAngleOpposite = GetOppositeDirection( fDir );
    location lRoll = GenerateNewLocation( oTarget, DISTANCE_TINY, fAngleOpposite, fDir);

    switch( nText )
    {
        case 1:     sText = "*plunges, rolls, springs and backstabs*";   break;
        case 2:     sText = "*leaps, shouts and slashes*";               break;
        case 3:     sText = "*ducks, sidesteps and hits ferociously*";   break;
        case 4:     sText = "*runs, jumps, turns and pounces*";          break;
        case 5:     sText = "*bounces, and stabs twice from behind*";    break;
        case 6:     sText = "*charges, skips, rotates and attacks*";     break;
        default:    break;
    }

    effect eLand = EffectVisualEffect( VFX_IMP_DUST_EXPLOSION );

    //apply temporary sneak attack
    object oArmor = GetItemInSlot( INVENTORY_SLOT_CHEST, oPC );
    itemproperty ipSneak = ItemPropertyBonusFeat( IP_CONST_FEAT_SNEAK_ATTACK_5D6 );
    IPSafeAddItemProperty( oArmor, ipSneak, 12.0 );

    //if the target is attacking this pc, break the target out of combat (flatfooted)
    if( GetAttackTarget( oTarget ) == oPC )
    {
        AssignCommand( oTarget, ClearAllActions() );
    }

    //roll visual effects and such
    ClearAllActions();
    SpeakString( sText );
    //check for Silence
    if( !GetHasEffect( EFFECT_TYPE_SILENCE, oPC) )
    {
        PlayVoiceChat( nCry, oPC );
    }
    ActionPlayAnimation( ANIMATION_LOOPING_GET_LOW, 2.0, 1.0 );
    DelayCommand( 1.0, ActionJumpToLocation( lRoll ) );
    DelayCommand( 1.1, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eLand, lRoll ) );
    DelayCommand( 1.2, ActionAttack( oTarget ) );
}


void IntuitiveAttack( object oPC )
{
    int nSTR     = GetAbilityModifier( ABILITY_STRENGTH, oPC );
    int nWIS     = GetAbilityModifier( ABILITY_WISDOM, oPC );

    effect eSTRMalus = EffectAttackDecrease( nSTR );
    effect eWISBonus = EffectAttackIncrease( nWIS );

    if( !GetHasSpellEffect( GetSpellId(), oPC ) )
    {
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( eSTRMalus ), oPC );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( eWISBonus ), oPC );
        SendMessageToPC( oPC, "Intuitive Attack activated!" );
    }
    else
    {
        RemoveEffectsFromSpell( oPC, GetSpellId() );
        SendMessageToPC( oPC, "Intuitive Attack deactivated!" );
    }
}
