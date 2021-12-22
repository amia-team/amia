// Knight Commander feat: Bulwark of Vigilance (OnEnter Aura)
//
// An aura that slows down attackers in the radius, and applies a Tumble penalty.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/06/2011 PoS              Initial Release.
//

#include "x2_inc_spellhook"

void main(){

    // Variables.
    object oCreature        = GetEnteringObject( );
    object oPC              = GetAreaOfEffectCreator( );
    int    nCHA             = GetAbilityModifier( ABILITY_CHARISMA, oPC );
    int    nClass           = GetLevelByClass( CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC );

    // Charisma bonus is capped to KC level.
    if ( nCHA > nClass )
        nCHA = nClass;

    // Prevent stacking.
    if ( GetHasSpellEffect( 894, oCreature ) )
        return;

    // 8% movement decrease per KC level, -5 Tumble penalty per Charisma modifier
    effect eSpeedDecrease = EffectMovementSpeedDecrease( 8 * nClass );
    effect eSkillDecrease = EffectSkillDecrease( SKILL_TUMBLE, 5 * nCHA );

    effect eLink = EffectLinkEffects( eSpeedDecrease, eSkillDecrease );

    eLink = ExtraordinaryEffect( eLink );

    // Apply if creature is hostile to the KC.
    if( GetIsReactionTypeHostile( oCreature, oPC ) )
    {
        // Apply the VFX impact and effects.
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_SLOW ), oCreature );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oCreature );
    }
}
