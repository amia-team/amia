// Jungle of Thorns (OnHeartbeat Aura)
//
// Creates an area of effect that slows upon entry and deals damage depending
// on whether the effect is saved or not. Also entangles if failed.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/18/2012 PaladinOfSune    Initial Release.
//

#include "X0_I0_SPELLS"

void main()
{
    // Variables.
    effect eHold = EffectEntangle();
    effect eEntangle = EffectVisualEffect( VFX_DUR_ENTANGLE );
    object oCreator = GetAreaOfEffectCreator();

    // Link visual and effect.
    effect eLink = EffectLinkEffects( eHold, eEntangle );

    int nSpellDCBonus;

    // Apply bonus DC from spell focuses.
    if ( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_CONJURATION, oCreator ) )
        nSpellDCBonus = 6;
    else if ( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_CONJURATION, oCreator ) )
        nSpellDCBonus = 4;
    else if ( GetHasFeat( FEAT_SPELL_FOCUS_CONJURATION, oCreator ) )
        nSpellDCBonus = 2;

    // All custom spells are evocation school, so we need this code here to make sure the DC is calcuated correctly.
    if( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_EVOCATION, oCreator ) )
        nSpellDCBonus -= 6;
    else if( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_EVOCATION, oCreator ) )
        nSpellDCBonus -= 4;
    else if( GetHasFeat( FEAT_SPELL_FOCUS_EVOCATION, oCreator ) )
        nSpellDCBonus -= 2;

    // Used for damage calculation.
    int nAC;
    int nTumble;
    int nDexMod;
    int nDamage;

    int nDamageSave = d4( 10 );
    int nDamageFail = d4( 10 ) + d4 ( GetCasterLevel( oCreator ) );

    effect eDamage;

    object oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCreator ))
        {
            // Check for Spell Resistance.
            if(!MyResistSpell( oCreator, oTarget))
            {
                if( GetIsImmune( oTarget, IMMUNITY_TYPE_ENTANGLE ) ) { // Freedom negates this.
                    eDamage = EffectDamage( nDamageSave, DAMAGE_TYPE_SLASHING );
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget );
                }
                //Make reflex save
                else if( !ReflexSave( oTarget, GetSpellSaveDC() + nSpellDCBonus, SAVING_THROW_TYPE_SPELL, oCreator ) )
                {
                    //Apply linked effects
                    nAC = GetAC( oTarget );
                    nTumble = GetSkillRank( SKILL_TUMBLE, oTarget, TRUE ) / 5;
                    nAC = nAC - nTumble;

                    nDexMod = GetAbilityModifier( ABILITY_DEXTERITY, oTarget );

                    // Creatures with Uncanny Dodge get to keep their Dexterity.
                    if( !GetHasFeat( FEAT_UNCANNY_DODGE_1, oTarget ) &&
                    !GetHasFeat( FEAT_UNCANNY_DODGE_2, oTarget ) &&
                    !GetHasFeat( FEAT_UNCANNY_DODGE_3, oTarget ) &&
                    !GetHasFeat( FEAT_UNCANNY_DODGE_4, oTarget ) &&
                    !GetHasFeat( FEAT_UNCANNY_DODGE_5, oTarget ) &&
                    !GetHasFeat( FEAT_UNCANNY_DODGE_6, oTarget ) ){

                        if( nDexMod >= 0 )
                        {
                            nAC = nAC - nDexMod;
                        }
                    }

                    // Apply damage according to AC, and entangle.
                    nDamage = nDamageFail - nAC;
                    eDamage = EffectDamage( nDamage, DAMAGE_TYPE_SLASHING );
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget );
                }
                else
                {
                    // Apply damage.
                    eDamage = EffectDamage( nDamageSave, DAMAGE_TYPE_SLASHING );
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget );
                }

            }

        }
        // Get the new target.
        oTarget = GetNextInPersistentObject();
    }

}
