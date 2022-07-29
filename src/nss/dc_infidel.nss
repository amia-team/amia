// Divine Champion: Purge Infidel. Replacement for Smite Evil on the DC class.
// Damages enemies not of the DC's alignment.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/06/2011 PoS              Initial Release.
// 07/22/2012 PoS              Restructured to apply fewer properties on a weapon.
// 07/25/2022 Opustus          Item property to damage increase to circumvent exploits.

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
    // Declare major variables
    object oPC              = GetSpellTargetObject();
    int nLevel              = GetLevelByClass( CLASS_TYPE_DIVINE_CHAMPION );
    int nCharismaBonus      = GetAbilityModifier( ABILITY_CHARISMA );
    int nAlignGoodEvil      = GetAlignmentGoodEvil( oPC );
    int nAlignLawChaos      = GetAlignmentLawChaos( oPC );
    string sAlignment       = GetAlignment( nAlignGoodEvil, nAlignLawChaos );

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

    // Alignment-dependent visuals
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

    eDur = SupernaturalEffect(eDur);

    // Apply VFX effects to the target
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDur, oPC, RoundsToSeconds( nCharismaBonus ) );


    // Making variables for the damage v. alignments effect
    int nDamage     = IPGetDamageBonusConstantFromNumber( nLevel );
    effect eDamageIncrease = EffectDamageIncrease(nDamage,DAMAGE_TYPE_DIVINE);

    effect eVersusGood = VersusAlignmentEffect(eDamageIncrease, ALIGNMENT_ALL, ALIGNMENT_GOOD);
    eVersusGood = SupernaturalEffect(eVersusGood);
    effect eVersusEvil = VersusAlignmentEffect(eDamageIncrease, ALIGNMENT_ALL, ALIGNMENT_EVIL);
    eVersusEvil = SupernaturalEffect(eVersusEvil);
    effect eVersusNeutral = VersusAlignmentEffect(eDamageIncrease, ALIGNMENT_NEUTRAL, ALIGNMENT_ALL);
    eVersusNeutral = SupernaturalEffect(eVersusNeutral);
    effect eVersusLawful = VersusAlignmentEffect(eDamageIncrease, ALIGNMENT_LAWFUL, ALIGNMENT_ALL);
    eVersusLawful = SupernaturalEffect(eVersusLawful);
    effect eVersusChaotic = VersusAlignmentEffect(eDamageIncrease, ALIGNMENT_CHAOTIC, ALIGNMENT_ALL);
    eVersusChaotic = SupernaturalEffect(eVersusChaotic);

    effect eVersusLN = VersusAlignmentEffect(eDamageIncrease, ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL);
    eVersusLN = SupernaturalEffect(eVersusLN);
    effect eVersusTN = VersusAlignmentEffect(eDamageIncrease, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
    eVersusTN = SupernaturalEffect(eVersusTN);
    effect eVersusCN = VersusAlignmentEffect(eDamageIncrease, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
    eVersusCN = SupernaturalEffect(eVersusCN);


    // These conditionals apply the damage effect vs. all non-DC's alignments
    if( sAlignment == "Lawful Good" )
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusEvil, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusNeutral, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusChaotic, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusLN, oPC, RoundsToSeconds(nCharismaBonus));
    }
    else if( sAlignment == "Neutral Good" )
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusEvil, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusLawful, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusChaotic, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusTN, oPC, RoundsToSeconds(nCharismaBonus));
    }
    else if( sAlignment == "Chaotic Good" )
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusEvil, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusNeutral, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusLawful, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusCN, oPC, RoundsToSeconds(nCharismaBonus));
    }
    else if( sAlignment == "Lawful Neutral" )
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusEvil, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusGood, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusChaotic, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusTN, oPC, RoundsToSeconds(nCharismaBonus));
    }
    else if( sAlignment == "Neutral Neutral" )
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusEvil, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusGood, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusLawful, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusCN, oPC, RoundsToSeconds(nCharismaBonus));
    }
    else if( sAlignment == "Chaotic Neutral" )
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusEvil, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusGood, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusLawful, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusTN, oPC, RoundsToSeconds(nCharismaBonus));
    }
    else if( sAlignment == "Lawful Evil" )
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusNeutral, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusGood, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusChaotic, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusLN, oPC, RoundsToSeconds(nCharismaBonus));
    }
    else if( sAlignment == "Neutral Evil" )
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusLawful, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusGood, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusChaotic, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusTN, oPC, RoundsToSeconds(nCharismaBonus));
    }
    else if( sAlignment == "Chaotic Evil" )
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusEvil, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusGood, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusNeutral, oPC, RoundsToSeconds(nCharismaBonus));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVersusCN, oPC, RoundsToSeconds(nCharismaBonus));
    }
}