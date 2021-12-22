/*
    Baleful Polymorph
    Wizard/Sorceror/Druid Innate 5
    School: Transmutation
    Range: Close
    Target: One
    Duration: 1 + 1 Round / 10 CL; +1 Round if you have Epic Transmutation.
    Save: Fortitude
    Spell Resistance: Yes

    Baleful Polymorph transforms the target into a chicken/penguin randomly if
    the fort save is failed. The target is also granted 50% speed increase for
    as long as the duration of the polymorph.
*/

#include "x2_inc_spellhook"
#include "x0_i0_spells"
#include "inc_dc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject( );

    int nSpellDCBonus = SetSpellSchool( oPC, SPELL_SCHOOL_TRANSMUTATION );
    int nCasterLevel = GetCasterLevel( oPC );

    effect ePoly;

    int nDur = 1 + nCasterLevel / 10;

    if( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, oPC ) )
    {
        nDur += 1;
    }

    if(!GetIsReactionTypeFriendly(oTarget)) {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt( oPC, DC_SPELL_R_5 ));
        //Make SR check
        if (!MyResistSpell(oPC, oTarget)) {

            if( !MySavingThrow( SAVING_THROW_FORT, oTarget, GetSpellSaveDC() + nSpellDCBonus ) ) {
                ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_KNOCK ), oTarget );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_PWSTUN ), oTarget );

                // Random chance 50/50 of being turned into a Chicken or a Penguin as well as applying a 50% speed increase
                if ( d100() <= 50 ) {
                    ePoly = EffectPolymorph( POLYMORPH_TYPE_PENGUIN, TRUE );
                } else {
                    ePoly = EffectPolymorph( POLYMORPH_TYPE_CHICKEN, TRUE );
                }
                effect eLink = EffectLinkEffects( ePoly, EffectMovementSpeedIncrease( 50 ) );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds( nDur ) );
            }
        }
    }
}
