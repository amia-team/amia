// Luminous Cloud (OnEnter)
//
// Creatures entering the aura take -20 hide, are invis purged, and if
// polymorphed, are unshifted.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/22/2012 Mathias          Initial Release.
//
#include "X0_I0_SPELLS"

void main() {

    // Variables.
    object  oPC             = GetAreaOfEffectCreator();
    int     nWIS            = GetAbilityModifier( ABILITY_WISDOM, oPC );
    int     nSpellDC        = 10 + 8 + nWIS;
    effect  eBlueGlow       = EffectVisualEffect( VFX_DUR_AURA_BLUE );
    effect  eHidePenalty    = EffectSkillDecrease( SKILL_HIDE, 20 );
    effect  eLink           = EffectLinkEffects( eBlueGlow, eHidePenalty );
    effect  ePolyEffect;

    // Apply bonus DC from spell focuses.
    if ( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_EVOCATION, oPC ) )
        nSpellDC = 6;
    else if ( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_EVOCATION, oPC ) )
        nSpellDC = 4;
    else if ( GetHasFeat( FEAT_SPELL_FOCUS_EVOCATION, oPC ) )
        nSpellDC = 2;

    //Get the first object in the persistant AOE
    object oCreature = GetFirstInPersistentObject( OBJECT_SELF, OBJECT_TYPE_CREATURE );
    while(GetIsObjectValid(oCreature))
    {
        // Dont affect the caster.
        if( oCreature != oPC )
        {
            // Purge invisibility like the proper spell.
            if (GetHasSpellEffect(SPELL_IMPROVED_INVISIBILITY, oCreature) == TRUE) {

                RemoveAnySpellEffects(SPELL_IMPROVED_INVISIBILITY, oCreature);

            } else if (GetHasSpellEffect(SPELL_INVISIBILITY, oCreature) == TRUE) {

                RemoveAnySpellEffects(SPELL_INVISIBILITY, oCreature);

            } else if (GetHasSpellEffect(SPELLABILITY_AS_INVISIBILITY, oCreature) == TRUE) {

                RemoveAnySpellEffects(SPELLABILITY_AS_INVISIBILITY, oCreature);

            } else if(GetHasSpellEffect(SPELLABILITY_AS_IMPROVED_INVISIBLITY, oCreature) == TRUE) {

                RemoveAnySpellEffects(SPELLABILITY_AS_IMPROVED_INVISIBLITY, oCreature);
            }

            // Cycle through effects on the creature, looking for invis and polymorph.
            effect  eEffect         = GetFirstEffect( oCreature );
            while( GetIsEffectValid( eEffect ) ) {

                if ( ( GetEffectType( eEffect ) == EFFECT_TYPE_INVISIBILITY ) || ( GetEffectType( eEffect ) == EFFECT_TYPE_IMPROVEDINVISIBILITY ) ) {

                    // Remove invis.
                    RemoveEffect( oCreature, eEffect );

                } else if ( GetEffectType( eEffect ) == EFFECT_TYPE_POLYMORPH ) {

                    // Save the polymorph effect.
                    ePolyEffect = eEffect;
                }
                eEffect = GetNextEffect( oCreature );
            }


            // Check if creature is polymorphed.
            if( GetIsEffectValid( ePolyEffect ) ) {

                // Roll will save.
                if( !WillSave( oCreature, nSpellDC, SAVING_THROW_TYPE_SPELL, oPC ) ) {

                    // Remove polymorph on failed save.
                    RemoveEffect( oCreature, ePolyEffect );
                }
            }
        }
        oCreature = GetNextInPersistentObject( OBJECT_SELF, OBJECT_TYPE_CREATURE );
    }
}
