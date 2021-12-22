// Knight Commander feat: Medicant
//
// An aura that imparts allies with regeneration and a bonus to Heal.
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
    effect eAOE = EffectAreaOfEffect(36, "kc_medicant1", "****", "kc_medicant2");

    effect eRegeneration;

    if( nClass < 5 ) {
        eRegeneration  = EffectRegenerate( 2, 6.0 );
    }
    else {
        eRegeneration  = EffectRegenerate( 3, 6.0 );
    }

    effect eSkillIncrease = EffectSkillIncrease( SKILL_HEAL, 5 * nCHA );

    effect eLink = EffectLinkEffects( eRegeneration, eSkillIncrease );
    eLink = EffectLinkEffects( eAOE, eLink );

    eLink = ExtraordinaryEffect( eLink );

    // Apply the VFX impact and effects.
    DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_HEAD_HEAL ), oPC ) );
    DelayCommand( 0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC ));
}
