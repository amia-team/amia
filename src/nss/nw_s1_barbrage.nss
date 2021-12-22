/*  Feat :: Barbarian Rage : Normal, Greater, Thundering, Terrifying

    --------
    Verbatim
    --------
    This script will apply Amia's bonuses for Barbarian Rage as follows:
        1. +1 Attack and Magical Damage per 5 ranks of Barbarian. Capped to +5.
        2. -2 AC. Voided at 17 and above ranks of Barbarian.
        3. +1 HP per Barbarian rank.
        4. Thundering Rage feat gives 1d8 Sonic Damage and On Hit: Stun DC 20.
        5. Terrifying Rage feat gives Fear Aura with a Will save DC equal to your Intimidate skill.
        5.1. Failure fears your enemy for 1 round per 2 ranks of Barbarian.
        5.2. This aura only affects creatures up to 1.5 times your Barbarian rank.
        5.2. Creatures above 1.5 times your Barbarian rank are shaken: -2 Attack, Damage and Saves.
        6. Mighty Rage feat gives the following benefits:
        6.1 +1 Universal Saves/7 Barbarian Levels
        6.2 +5 Vampiric Regen
        6.3 +10 Bonus HP/Barbarian Level.
    The Barbarian's Rage lasts for 5 + Consitution modifier rounds.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    082706  kfw         Initial release.
    092506  kfw         Rage damage will now be randomly opposite to your base weapon damage.
    062307  kfw         See Amia release 1.37 for changes.
  20071009  disco       Sloppy scripting corrected and new rages implemented
  20071021  disco       Removed double feat decrements
  20071104  disco       Updated
  20101907  Jehran      Added Mighty Rage Benefits
  20110801  PoS         Modified rages for new balance change.
  20110901  PoS         Gives a usage back if done while recovering.
    ----------------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
// Includes
//-------------------------------------------------------------------------------
#include "x2_inc_itemprop"
#include "amia_include"
//#include "nwnx_funcs"
#include "inc_ds_records"


//-------------------------------------------------------------------------------
// Constants
//-------------------------------------------------------------------------------
const int BASE_DAMAGE_TYPE_PIERCING     = 1;
const int BASE_DAMAGE_TYPE_BLUDGEONING  = 2;
const int BASE_DAMAGE_TYPE_SLASHING     = 3;
const int BASE_DAMAGE_TYPE_SLASHPIERCE  = 4;


//-------------------------------------------------------------------------------
// Structures
//-------------------------------------------------------------------------------
// This structure stores data on the player's equipped weaponry.
struct _Weaponry{
    object oWep1;
    object oWep2;
    object oAmmo;
};


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
// Gets the player's equipped melee weapons, or ammo.
struct _Weaponry GetMeleeOrAmmo( object oPC );

// Macro to get the weapon's base damage type.
int GetWeaponBaseDamageType( object oWeapon );

//base rage types
void BasicRage( object oPC, int nDamageType );
void UnyieldingRage( object oPC );
void FerocityAttack( object oPC, int nDamageType );


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main( ){

    // Variables.
    object oPC                  = OBJECT_SELF;
    int nDamageType             = DAMAGE_TYPE_PIERCING;
    float fDuration             = RoundsToSeconds( 5 + GetAbilityModifier( ABILITY_CONSTITUTION ) );
    int nDuration               = FloatToInt( fDuration );
    struct _Weaponry Weaponry   = GetMeleeOrAmmo( oPC );
    int nThunderingRage         = GetHasFeat( FEAT_EPIC_THUNDERING_RAGE );
    int nTerrifyingRage         = GetHasFeat( FEAT_EPIC_TERRIFYING_RAGE );
    int nMightyRage             = GetHasFeat( FEAT_MIGHTY_RAGE );
    int nRageType               = GetPCKEYValue( oPC, "ds_rage_type" );
    int nClassLevel             = GetLevelByClass( CLASS_TYPE_BARBARIAN, oPC );

    // Prevent stacking.
    if( GetHasFeatEffect( FEAT_BARBARIAN_RAGE, oPC ) || GetHasFeatEffect( FEAT_MIGHTY_RAGE, oPC ) ) {

        FloatingTextStringOnCreature( "<cþ>- You're already raging! -</c>", oPC, FALSE );
        return;
    }

    // Cooldown of a turn between rages.
    if ( GetIsBlocked( oPC, "is_raging" ) > 0 ) {

        FloatingTextStringOnCreature( "<cþ>- You must recover for a turn before raging again! -</c>", oPC, FALSE );
        IncrementRemainingFeatUses( oPC, FEAT_BARBARIAN_RAGE );
        return;
    }

    // Figure the opposite damage type of the base damage type of the weapon or ammo.
    // Get weapon's or ammo's base damage type.
    if( GetIsObjectValid( Weaponry.oWep1 ) ){

        nDamageType = GetWeaponBaseDamageType( Weaponry.oWep1 );
    }
    else{

        nDamageType = GetWeaponBaseDamageType( Weaponry.oAmmo );
    }

    // Get the opposite base damage type.
    if(         nDamageType == BASE_DAMAGE_TYPE_PIERCING ){

        nDamageType = d2( ) > 1 ? DAMAGE_TYPE_BLUDGEONING : DAMAGE_TYPE_SLASHING;
    }
    else if(    nDamageType == BASE_DAMAGE_TYPE_BLUDGEONING ){

        nDamageType = d2( ) > 1 ? DAMAGE_TYPE_PIERCING : DAMAGE_TYPE_SLASHING;
    }
    else if(    nDamageType == BASE_DAMAGE_TYPE_SLASHING ){

        nDamageType = d2( ) > 1 ? DAMAGE_TYPE_BLUDGEONING : DAMAGE_TYPE_PIERCING;
    }
    else{

        nDamageType = DAMAGE_TYPE_BLUDGEONING;
    }

    // Candy.
    PlayVoiceChat( VOICE_CHAT_BATTLECRY1, oPC );    // Sfx.
    effect eCandyImpact         = EffectVisualEffect( VFX_IMP_SUPER_HEROISM );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eCandyImpact, oPC );

    //check which rage to use
    if ( nRageType == 1 && nClassLevel > 9 ){

        UnyieldingRage( oPC );
    }
    else if ( nRageType == 2 && nClassLevel > 14 ){

        FerocityAttack( oPC, nDamageType );
    }
    else{

        BasicRage( oPC, nDamageType );
    }

    // Thundering Rage feat, gives 1d8 Sonic damage and On Hit: Stun DC 20.
    itemproperty ipThunderDamage    = ItemPropertyDamageBonus(
                                        IP_CONST_DAMAGETYPE_SONIC,
                                        IP_CONST_DAMAGEBONUS_1d8 );

    itemproperty ipThunderStun      = ItemPropertyOnHitProps(
                                        IP_CONST_ONHIT_STUN,
                                        IP_CONST_ONHIT_SAVEDC_20,
                                        IP_CONST_ONHIT_DURATION_75_PERCENT_1_ROUND );


    // Terrifying Rage feat, gives Fear Aura: Will save DC equal to Barbarian's Intimidate skill to negate.
    effect eTerrifying = ExtraordinaryEffect( EffectAreaOfEffect( AOE_MOB_FEAR, "cs_barb_teraura", "****", "****" ) );

    /* Mighty Rage gives:
      +1 Universal Saves/7 Barbarian Levels (21 Barb will net +3 28 will net +4)
      +5 Vampiric Regen
      +10 Bonus HP/Barbarian Level. (Its a pseudo Damage Reduction)
    */
    effect eMightySave = ExtraordinaryEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, (nClassLevel / 7)));
    effect eMightyHP = ExtraordinaryEffect(EffectTemporaryHitpoints(nClassLevel * 10));
    itemproperty ipMightyRegen = ItemPropertyVampiricRegeneration(5);


    // If the Barbarian has the Thundering Rage feat, apply it to their weaponry.
    if( nThunderingRage ){

        if( GetIsObjectValid( Weaponry.oWep1 ) ){
            IPSafeAddItemProperty( Weaponry.oWep1, ipThunderDamage, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
            IPSafeAddItemProperty( Weaponry.oWep1, ipThunderStun, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING );
        }

        if( GetIsObjectValid( Weaponry.oWep2 ) ){
            IPSafeAddItemProperty( Weaponry.oWep2, ipThunderDamage, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
            IPSafeAddItemProperty( Weaponry.oWep2, ipThunderStun, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING );
        }

        if( GetIsObjectValid( Weaponry.oAmmo ) ){
            IPSafeAddItemProperty( Weaponry.oAmmo, ipThunderDamage, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
            IPSafeAddItemProperty( Weaponry.oAmmo, ipThunderStun, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING );
        }
    }

    // If the Barbarian has the Terrifying Rage feat, give them the aura.
    if( nTerrifyingRage ){

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eTerrifying, oPC, fDuration );
    }

    //If the Barbarian has teh Mighty Rage feat, give him all the bonuses.
    if ( nMightyRage ){
        if( GetIsObjectValid( Weaponry.oWep1 ) ){
            IPSafeAddItemProperty( Weaponry.oWep1, ipMightyRegen, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
        }

        if( GetIsObjectValid( Weaponry.oWep2 ) ){
            IPSafeAddItemProperty( Weaponry.oWep2, ipMightyRegen, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
        }

        if( GetIsObjectValid( Weaponry.oAmmo ) ){
            IPSafeAddItemProperty( Weaponry.oAmmo, ipMightyRegen, fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
        }
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eMightySave, oPC, fDuration );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eMightyHP, oPC, fDuration );
    }

    SetBlockTime( oPC, 1, nDuration, "is_raging" );

    DelayCommand( nDuration + TurnsToSeconds( 1 ), ApplyEffectToObject(
                                                                    DURATION_TYPE_INSTANT,
                                                                    EffectVisualEffect( VFX_IMP_HEAD_FIRE ),
                                                                    oPC
                                                                 ) );
    return;
}




//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

// Gets melee weapons, or ammo.
struct _Weaponry GetMeleeOrAmmo( object oPC ){

    // Variables.
    struct _Weaponry Weaponry;
    Weaponry.oWep1          = OBJECT_INVALID;   // Zerotize structure.
    Weaponry.oWep2          = OBJECT_INVALID;   // Ditto.
    Weaponry.oAmmo          = OBJECT_INVALID;   // Ditto.

    object oPrimary         = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oPC );
    object oSecondary       = GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oPC );
    int nPrimaryType        = GetBaseItemType( oPrimary );
    object oAmmo            = OBJECT_INVALID;


    // Primary present as Melee OR is a Shuriken, Dart or Throwing Axe.
    if( IPGetIsMeleeWeapon( oPrimary )          ||
        nPrimaryType == BASE_ITEM_SHURIKEN      ||
        nPrimaryType == BASE_ITEM_DART          ||
        nPrimaryType == BASE_ITEM_THROWINGAXE   ){

        Weaponry.oWep1 = oPrimary;

        // Secondary present (always melee).
        if( GetIsObjectValid( oSecondary ) )
            Weaponry.oWep2 = oSecondary;

    }
    // Ranged, seek out ammo.
    else{

        // X-bows -> Bolts.
        if( nPrimaryType == BASE_ITEM_LIGHTCROSSBOW || nPrimaryType == BASE_ITEM_HEAVYCROSSBOW )
            Weaponry.oAmmo = GetItemInSlot( INVENTORY_SLOT_BOLTS, oPC );
        // Bows -> Arrows.
        else if( nPrimaryType == BASE_ITEM_SHORTBOW || nPrimaryType == BASE_ITEM_LONGBOW )
            Weaponry.oAmmo = GetItemInSlot( INVENTORY_SLOT_ARROWS, oPC );
        // Slings -> Bullets.
        else if( nPrimaryType == BASE_ITEM_SLING )
            Weaponry.oAmmo = GetItemInSlot( INVENTORY_SLOT_BULLETS, oPC );

    }

    return( Weaponry );

}


// Macro to get the weapon's base damage type.
int GetWeaponBaseDamageType( object oWeapon ){

    return( StringToInt( Get2DAString( "baseitems", "WeaponType", GetBaseItemType( oWeapon ) ) ) );
}


void BasicRage( object oPC, int nDamageType ){

    /*
    +1 bonus to Attack per 4 levels of Barbarian. Capped at +6.
    +1 bonus to Damage per 4 levels of Barbarian. Capped at +5.
    +1 bonus to Will saves per 8 levels of Barbarian. Capped at +3.
    +1 bonus to Fort saves per 8 levels of Barbarian. Capped at +3.
    +2 hitpoints per Barbarian level.
    Penalized -2 to Armor Class. This is voided at Barbarian level 17 and above.
    */

    int nClassLevel = GetLevelByClass( CLASS_TYPE_BARBARIAN, oPC );

    int nDuration   = 5 + GetAbilityModifier( ABILITY_CONSTITUTION, oPC );
    effect eAB      = EffectAttackIncrease( GetAmountPerLevels( nClassLevel, 1, 4, 6 ) );
    effect eDam     = EffectLinkEffects( EffectDamageIncrease( GetAmountPerLevels( nClassLevel, 1, 4, 5 ), nDamageType ), eAB );
    effect eWP      = EffectLinkEffects( EffectSavingThrowIncrease( SAVING_THROW_WILL, GetAmountPerLevels( nClassLevel, 1, 8, 3 ) ), eDam );
    effect eFS      = EffectLinkEffects( EffectSavingThrowIncrease( SAVING_THROW_FORT, GetAmountPerLevels( nClassLevel, 1, 8, 3 ) ), eWP );
           eFS      = EffectLinkEffects( EffectSpellFailure( ), eFS );
    effect eCandy   = ExtraordinaryEffect( EffectVisualEffect( VFX_DUR_AURA_PULSE_RED_BLACK ) );

    effect eHP      = ExtraordinaryEffect( EffectTemporaryHitpoints( GetAmountPerLevels( nClassLevel, 2 ) ) );

    effect eBonus;

    if( nClassLevel < 17 ){

        effect eAC      = EffectLinkEffects( EffectACDecrease( 2 ), eFS );
        eBonus   = ExtraordinaryEffect( eAC );
    }
    else{

        eBonus   = ExtraordinaryEffect( eFS );
    }

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBonus, oPC, RoundsToSeconds( nDuration ) );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eHP, oPC, RoundsToSeconds( nDuration ) );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eCandy, oPC, RoundsToSeconds( nDuration ) );
}

void UnyieldingRage( object oPC ){

    /*
    +1 regeneration/round per 4 barbarian levels
    +1 Dodge AC per 6 barbarian levels capped at +4 AC
    +1 fort save per 8 Barbarian levels capped at +3
    +1 will save per 8 Barbarian levels capped at +3
    +1 reflex save per 8 Barbarian levels capped at +3
    +3 hit points per barbarian level.
    +1 AB per 8 Barbarian levels capped at +3
    */

    int nClassLevel = GetLevelByClass( CLASS_TYPE_BARBARIAN, oPC );

    //this must become level 10!
    if ( nClassLevel < 10 ){

        FloatingTextStringOnCreature( "<cþ>- Not enough Barbarian levels! -</c>", oPC, FALSE );
        return;
    }

    int nDuration   = 5 + GetAbilityModifier( ABILITY_CONSTITUTION, oPC );
    effect eAB      = EffectAttackIncrease( GetAmountPerLevels( nClassLevel, 1, 8, 3 ) );
    effect eAC      = EffectLinkEffects( EffectACIncrease( nClassLevel/6 > 4 ? 4 : nClassLevel/6 ), eAB );
    effect eRf      = EffectLinkEffects( EffectSavingThrowIncrease( SAVING_THROW_REFLEX, GetAmountPerLevels( nClassLevel, 1, 8, 3 ) ), eAC );
    effect eFo      = EffectLinkEffects( EffectSavingThrowIncrease( SAVING_THROW_FORT, GetAmountPerLevels( nClassLevel, 1, 8, 3 ) ), eRf );
    effect eWl      = EffectLinkEffects( EffectSavingThrowIncrease( SAVING_THROW_WILL, GetAmountPerLevels( nClassLevel, 1, 8, 3 ) ), eFo );
    effect eRg      = EffectLinkEffects( EffectRegenerate( GetAmountPerLevels( nClassLevel, 1, 4, 7 ), 6.0 ), eWl );
           eRg      = EffectLinkEffects( EffectSpellFailure( ), eRg );
    effect eBonus   = ExtraordinaryEffect( eRg );
    effect eCandy   = ExtraordinaryEffect( EffectVisualEffect( VFX_DUR_AURA_PULSE_BLUE_YELLOW ) );

    effect eHP      = ExtraordinaryEffect( EffectTemporaryHitpoints( GetAmountPerLevels( nClassLevel, 3 ) ) );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBonus, oPC, RoundsToSeconds( nDuration ) );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eHP, oPC, RoundsToSeconds( nDuration ) );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eCandy, oPC, RoundsToSeconds( nDuration ) );
}

void FerocityAttack( object oPC, int nDamageType ){

    /*
    +1 APR stacks with haste
    +2 Damage per 4 barbarian levels caps at +12
    +1 Fort save per 8 Barbarian levels capped at +3
    50 percent move speed increase (doesn't stack with haste)
    -4 penalty to Dodge Armour Class
    +1 HP per Barbarian level

    */

    int nClassLevel = GetLevelByClass( CLASS_TYPE_BARBARIAN, oPC );

    //this must become level 15!
    if ( nClassLevel < 15 ){

        FloatingTextStringOnCreature( "<cþ>- Not enough Barbarian levels! -</c>", oPC, FALSE );
        return;
    }

    // GetAmountPerLevel doesn't work as it should for DamageIncrease... workaround.
    int nDamageIncrease = GetAmountPerLevels( nClassLevel, 2, 4, 12 );

    switch( nDamageIncrease ){

        case 0: nDamageIncrease = DAMAGE_BONUS_1; break;
        case 1: nDamageIncrease = DAMAGE_BONUS_1; break;
        case 2: nDamageIncrease = DAMAGE_BONUS_2; break;
        case 3: nDamageIncrease = DAMAGE_BONUS_3; break;
        case 4: nDamageIncrease = DAMAGE_BONUS_4; break;
        case 5: nDamageIncrease = DAMAGE_BONUS_5; break;
        case 6: nDamageIncrease = DAMAGE_BONUS_6; break;
        case 7: nDamageIncrease = DAMAGE_BONUS_7; break;
        case 8: nDamageIncrease = DAMAGE_BONUS_8; break;
        case 9: nDamageIncrease = DAMAGE_BONUS_9; break;
        case 10: nDamageIncrease = DAMAGE_BONUS_10; break;
        case 11: nDamageIncrease = DAMAGE_BONUS_11; break;
        case 12: nDamageIncrease = DAMAGE_BONUS_12; break;
        default: nDamageIncrease = DAMAGE_BONUS_12; break;
    }

    int nDuration   = 5 + GetAbilityModifier( ABILITY_CONSTITUTION, oPC );
    effect eAt      = EffectModifyAttacks( 1 );
    effect eDa      = EffectLinkEffects( EffectDamageIncrease( nDamageIncrease, nDamageType ), eAt );
    effect eFo      = EffectLinkEffects( EffectSavingThrowIncrease( SAVING_THROW_FORT, GetAmountPerLevels( nClassLevel, 1, 8, 3 ) ), eDa );
    effect eAC      = EffectLinkEffects( EffectACDecrease( 4 ), eFo );
    effect eMo      = EffectLinkEffects( EffectMovementSpeedIncrease( 50 ), eAC );
    effect eSf      = EffectLinkEffects( EffectSpellFailure( ), eMo );
    effect eBonus   = ExtraordinaryEffect( eSf );
    effect eCandy   = ExtraordinaryEffect( EffectVisualEffect( VFX_DUR_AURA_PULSE_RED_GREEN ) );

    effect eHP      = ExtraordinaryEffect( EffectTemporaryHitpoints( GetAmountPerLevels( nClassLevel, 1 ) ) );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBonus, oPC, RoundsToSeconds( nDuration ) );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eHP, oPC, RoundsToSeconds( nDuration ) );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eCandy, oPC, RoundsToSeconds( nDuration ) );
}
