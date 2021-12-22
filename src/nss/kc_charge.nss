// Knight Commander feat: Vehement Charge.
//
// An aura that imparts a load of immunities and a speed bonus. A Discipline
// penalty, too.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/06/2011 PoS              Initial Release.
//

#include "x2_inc_spellhook"

void main( ) {

    object oPC      = OBJECT_SELF;

    // Get the KC level and charisma to determine the feat's strength.
    int    nCHA     = GetAbilityModifier( ABILITY_CHARISMA, oPC );
    int    nClass   = GetLevelByClass( CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC );

    // Charisma bonus is capped to KC level.
    if ( nCHA > nClass )
        nCHA = nClass;

    // Cycle through targets in a sphere shape until the target is invalid.
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation( oPC ), TRUE, OBJECT_TYPE_CREATURE );
    while ( GetIsObjectValid( oTarget ) )
    {
        effect eEffects = GetFirstEffect( oTarget );

        while( GetIsEffectValid( eEffects ) ){
            if ( GetEffectCreator( eEffects ) == oPC )
            {
                if( GetEffectSpellId( eEffects ) == 892  ||
                    GetEffectSpellId( eEffects ) == 895  ||
                    GetEffectSpellId( eEffects ) == 897  ){

                    // Remove all aura effects this PC has applied already.
                    RemoveEffect( oTarget, eEffects );
                }
            }
            eEffects = GetNextEffect( oTarget );
        }

        // Select the next target within the spell shape.
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation( oPC ), TRUE, OBJECT_TYPE_CREATURE );
    }

    // Declare major variables.
    effect eAOE = EffectAreaOfEffect(36, "kc_charge1", "****", "kc_charge2");

    effect eSpeedIncrease = EffectMovementSpeedIncrease( 3 * nCHA );
    effect eImmunity1     = EffectImmunity( IMMUNITY_TYPE_BLINDNESS );
    effect eImmunity2     = EffectImmunity( IMMUNITY_TYPE_CHARM );
    effect eImmunity3     = EffectImmunity( IMMUNITY_TYPE_CONFUSED );
    effect eImmunity4     = EffectImmunity( IMMUNITY_TYPE_DEAFNESS );
    effect eImmunity5     = EffectImmunity( IMMUNITY_TYPE_FEAR );
    effect eImmunity6     = EffectImmunity( IMMUNITY_TYPE_DAZED );
    effect eImmunity7     = EffectImmunity( IMMUNITY_TYPE_SLEEP );
    effect eImmunity8     = EffectImmunity( IMMUNITY_TYPE_SLOW );
    effect eImmunity9     = EffectImmunity( IMMUNITY_TYPE_STUN );
    effect ePenalty       = EffectSkillDecrease( SKILL_DISCIPLINE, 10 );

    effect eLink = EffectLinkEffects( eSpeedIncrease, eImmunity1 );
    eLink = EffectLinkEffects( eImmunity2, eLink );
    eLink = EffectLinkEffects( eImmunity3, eLink );
    eLink = EffectLinkEffects( eImmunity4, eLink );
    eLink = EffectLinkEffects( eImmunity5, eLink );
    eLink = EffectLinkEffects( eImmunity6, eLink );
    eLink = EffectLinkEffects( eImmunity7, eLink );
    eLink = EffectLinkEffects( eImmunity8, eLink );
    eLink = EffectLinkEffects( eImmunity9, eLink );
    eLink = EffectLinkEffects( ePenalty, eLink );
    eLink = EffectLinkEffects( eAOE, eLink );

    eLink = ExtraordinaryEffect( eLink );

    // Apply the VFX impact and effects.
    object oDummy = GetObjectByTag( "ds_permeffects" );
    SetName( oDummy, "ds_norestore");
    DelayCommand( 0.1, AssignCommand( oDummy, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oPC ) ) );
    DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_PDK_FINAL_STAND ), oPC ) );
}
