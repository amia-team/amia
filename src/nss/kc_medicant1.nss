// Knight Commander feat: Medicant (OnEnter Aura)
//
// An aura that imparts allies with regeneration and a bonus to Heal.
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
    if (GetHasSpellEffect( 895, oCreature ) )
        return;

    effect eRegeneration;

    if( nClass < 5 ) {
        eRegeneration  = EffectRegenerate( 2, 6.0 );
    }
    else {
        eRegeneration  = EffectRegenerate( 3, 6.0 );
    }

    effect eSkillIncrease = EffectSkillIncrease( SKILL_HEAL, 5 * nCHA );

    effect eLink = EffectLinkEffects( eRegeneration, eSkillIncrease );

    eLink = ExtraordinaryEffect( eLink );

    // Apply if creature is a friendly.
    if( GetIsFriend( oCreature, oPC ) ){

        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_HEAD_HEAL ), oCreature );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oCreature );
    }
}
