// Divine Champion: Purge Infidel. Replacement for Smite Evil on the DC class.
// Damages enemies not of the DC's alignment.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/06/2011 PoS              Initial Release.
// 07/22/2012 PoS              Restructured to apply fewer properties on a weapon.
//

#include "x0_i0_spells"
#include "x2_inc_itemprop"

// Custom function to get the PC's full alignment.
string GetAlignment( int nAlignGoodEvil, int nAlignLawChaos )
{
    string sAlignment;

    if( nAlignLawChaos == ALIGNMENT_LAWFUL )
    {
        sAlignment = "Lawful ";
    }
    if( nAlignLawChaos == ALIGNMENT_NEUTRAL )
    {
        sAlignment = "Neutral ";
    }
    if( nAlignLawChaos == ALIGNMENT_CHAOTIC )
    {
        sAlignment = "Chaotic ";
    }
    if( nAlignGoodEvil == ALIGNMENT_GOOD )
    {
        sAlignment += "Good";
    }
    if( nAlignGoodEvil == ALIGNMENT_NEUTRAL )
    {
        sAlignment += "Neutral";
    }
    if( nAlignGoodEvil == ALIGNMENT_EVIL )
    {
        sAlignment += "Evil";
    }

    return sAlignment;
}

void main()
{
    //Declare major variables
    object oPC              = GetSpellTargetObject();
    int nLevel              = GetLevelByClass( CLASS_TYPE_DIVINE_CHAMPION );
    int nCharismaBonus      = GetAbilityModifier( ABILITY_CHARISMA );
    int nAlignGoodEvil      = GetAlignmentGoodEvil( oPC );
    int nAlignLawChaos      = GetAlignmentLawChaos( oPC );
    string sAlignment       = GetAlignment( nAlignGoodEvil, nAlignLawChaos );

    // If a weapon isn't found, use their gloves.
    object oMyWeapon        = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oPC );
    object oMySecondWeapon  = GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oPC );

    if( oMyWeapon == OBJECT_INVALID ) {
        oMyWeapon = GetItemInSlot( INVENTORY_SLOT_ARMS, oPC );
    }

    // Prevent stacking
    if( GetHasFeatEffect( 1177 ) == TRUE )
        return;

    // Fallen check
    if ( GetLocalInt( oPC, "Fallen" ) == 1 ) {
        FloatingTextStringOnCreature( "The plea to your deity is not heard...", oPC, FALSE );
        return;
    }

    // This feat does nothing with <0 charisma modifier
    if ( nCharismaBonus <= 0 ) {
        FloatingTextStringOnCreature( "You do not have enough Charisma to use this ability!", oPC, FALSE );
        return;
    }

    effect eVis;
    effect eDur;

    // Alignment-dependant visuals
    if( GetAlignmentGoodEvil( oPC ) == ALIGNMENT_EVIL ) {
        eVis = EffectVisualEffect( VFX_IMP_PULSE_NEGATIVE );
    }
    else {
        eVis = EffectVisualEffect( VFX_IMP_PULSE_HOLY );
    }

    if( GetAlignmentGoodEvil( oPC ) == ALIGNMENT_EVIL ) {
        eDur = EffectVisualEffect( VFX_DUR_PROTECTION_EVIL_MAJOR );
    }
    else {
        eDur = EffectVisualEffect( VFX_DUR_PROTECTION_GOOD_MAJOR );
    }

    // Apply Link and VFX effects to the target
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDur, oPC, RoundsToSeconds( nCharismaBonus ) );

    int nDamage     = IPGetDamageBonusConstantFromNumber( nLevel );
    int nDamageType = IP_CONST_DAMAGETYPE_DIVINE;

    // This horrible long piece of code assigns damage to the DC's weapon depending on their alignment.
    if( sAlignment == "Lawful Good" )
    {
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_NEUTRAL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_EVIL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_CHAOTIC, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        if( GetIsObjectValid( oMySecondWeapon ) )
        {
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_NEUTRAL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_EVIL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_CHAOTIC, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        }
    }
    else if( sAlignment == "Neutral Good" )
    {
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_LAWFUL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_EVIL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_CHAOTIC, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsSAlign( IP_CONST_ALIGNMENT_TN, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        if( GetIsObjectValid( oMySecondWeapon ) )
        {
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_LAWFUL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_EVIL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_CHAOTIC, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsSAlign( IP_CONST_ALIGNMENT_TN, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        }
    }
    else if( sAlignment == "Chaotic Good" )
    {
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_NEUTRAL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_EVIL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_LAWFUL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        if( GetIsObjectValid( oMySecondWeapon ) )
        {
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_NEUTRAL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_EVIL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_LAWFUL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        }
    }
    else if( sAlignment == "Lawful Neutral" )
    {
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_GOOD, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_EVIL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_CHAOTIC, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsSAlign( IP_CONST_ALIGNMENT_TN, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        if( GetIsObjectValid( oMySecondWeapon ) )
        {
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_GOOD, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_EVIL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_CHAOTIC, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsSAlign( IP_CONST_ALIGNMENT_TN, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        }
    }
    else if( sAlignment == "Neutral Neutral" )
    {
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_GOOD, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_EVIL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_CHAOTIC, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_LAWFUL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        if( GetIsObjectValid( oMySecondWeapon ) )
        {
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_GOOD, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_EVIL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_CHAOTIC, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_LAWFUL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        }
    }
    else if( sAlignment == "Chaotic Neutral" )
    {
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_GOOD, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_EVIL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_LAWFUL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsSAlign( IP_CONST_ALIGNMENT_TN, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        if( GetIsObjectValid( oMySecondWeapon ) ) {
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_GOOD, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_EVIL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_LAWFUL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsSAlign( IP_CONST_ALIGNMENT_TN, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        }
    }
    else if( sAlignment == "Lawful Evil" )
    {
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_NEUTRAL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_GOOD, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_CHAOTIC, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        if( GetIsObjectValid( oMySecondWeapon ) )
        {
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_NEUTRAL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_GOOD, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_LAWFUL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        }
    }
    else if( sAlignment == "Neutral Evil" )
    {
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_LAWFUL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_GOOD, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_CHAOTIC, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsSAlign( IP_CONST_ALIGNMENT_TN, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        if( GetIsObjectValid( oMySecondWeapon ) )
        {
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_LAWFUL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_GOOD, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_CHAOTIC, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsSAlign( IP_CONST_ALIGNMENT_TN, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        }
    }
    else if( sAlignment == "Chaotic Evil" )
    {
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_LAWFUL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_GOOD, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        IPSafeAddItemProperty( oMyWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_NEUTRAL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        if( GetIsObjectValid( oMySecondWeapon ) )
        {
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_LAWFUL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_GOOD, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
            IPSafeAddItemProperty( oMySecondWeapon, ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_NEUTRAL, nDamageType, nDamage ), RoundsToSeconds( nCharismaBonus ) );
        }
    }
}
