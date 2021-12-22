/*  Arcane Archer :: Imbue Arrow

    --------
    Verbatim
    --------
    Arcane archer's imbue arrow feat.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    062307  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

// Includes.
#include "x2_inc_itemprop"
#include "amia_include"

// Prototypes.

// Imbues a bundle of arrows with the specified spell.
int ImbueArrow( object oPC, int nSpell, object oArrows, int nSpellCastAs, int nExtended );


// Function definitions.

// Imbues a bundle of arrows with the specified spell.
int ImbueArrow( object oPC, int nSpell, object oArrows, int nSpellCastAs, int nExtended ){

    // Variables
    int nAARank         = GetLevelByClass( CLASS_TYPE_ARCANE_ARCHER, oPC );
    int nFeatUses       = GetHasFeat( FEAT_PRESTIGE_IMBUE_ARROW, oPC );
    int nDamageType     = 255;


    // Filter: Basic arrows only.
    if( GetTag( oArrows ) != "NW_WAMAR001" )
        return( FALSE );

    // Filter: Insufficient imbue arrow feat uses.
    if( nFeatUses < 1 ){
        FloatingTextStringOnCreature( "- Your imbue arrow feat has been used up for the day. -", oPC, FALSE );
        return( FALSE );
    }

    // Determine spell damage.
    switch( nSpell ){

        case SPELL_SOUND_BURST:         nDamageType = IP_CONST_DAMAGETYPE_SONIC;            break;
        case SPELL_ICE_STORM:           nDamageType = IP_CONST_DAMAGETYPE_COLD;             break;
        case SPELL_MESTILS_ACID_BREATH: nDamageType = IP_CONST_DAMAGETYPE_ACID;             break;
        case SPELL_FIREBALL:            nDamageType = IP_CONST_DAMAGETYPE_FIRE;             break;
        case SPELL_LIGHTNING_BOLT:      nDamageType = IP_CONST_DAMAGETYPE_ELECTRICAL;       break;
        case SPELL_ENERVATION:          nDamageType = IP_CONST_DAMAGETYPE_NEGATIVE;         break;
        default:                        return( FALSE );

    }

    // Decrement imbue arrow feat uses.
    DecrementRemainingFeatUses( oPC, FEAT_PRESTIGE_IMBUE_ARROW );

    // Stacking: Nix existing.
    IPRemoveMatchingItemProperties( oArrows, ITEM_PROPERTY_DAMAGE_BONUS, DURATION_TYPE_TEMPORARY, -1 );

    // Imbue the arrow bundle.
    IPSafeAddItemProperty(
        oArrows,
        ItemPropertyDamageBonus( nDamageType, IP_CONST_DAMAGEBONUS_1d8 ),
        NewHoursToSeconds( nAARank ),
        X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,
        FALSE,
        FALSE );

    // Candy.
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_PIXIEDUST ), oPC, 3.0 );
    // Sound vfx.
    AssignCommand( oPC, PlaySound( "sce_positive" ) );

    return( TRUE );

}

