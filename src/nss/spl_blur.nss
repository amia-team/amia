/*
    Blur
    Illusion (Glamer)
    Level: 	ard 2, Sorcerer / Wizard 2
    Components: V
    Casting Time: 	1 standard action
    Range: Ranged
    Target: 	Creature touched
    Duration: 	1Turn / Level
    Saving Throw: None
    Spell Resistance: None

    The subject’s outline appears blurred, shifting and wavering. This
    distortion grants the subject concealment (20% miss chance, plus 10% miss
    chance per Illusion Spell Focus feat).
*/

#include "x2_inc_spellhook"
#include "x0_i0_spells"

void main()
{
    object oCaster = GetLastSpellCaster( );
    float fDur;
    int nCasterLvl;
    int nMeta = GetMetaMagicFeat();

    //Check to see if it is an NPC creature casting the spell for variables
    if( !GetIsPC( oCaster ) && !GetIsDM( oCaster ) )
    {
        nCasterLvl = GetHitDice( oCaster );
        fDur = TurnsToSeconds( nCasterLvl );
    }
    //else run the spell as normal for a PC
    else
    {
        nCasterLvl = GetCasterLevel( oCaster );
        fDur = TurnsToSeconds( nCasterLvl );
    }

    object oTarget = GetSpellTargetObject( );
    location lTarget = GetSpellTargetLocation( );
    int nConceal = 20;

    if( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_ILLUSION, oCaster ) )
    {
        nConceal = 50;
    }
    else if( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_ILLUSION, oCaster ) )
    {
        nConceal = 40;
    }
    else if( GetHasFeat( FEAT_SPELL_FOCUS_ILLUSION, oCaster ) )
    {
        nConceal = 30;
    }

    //set duration
    if( nMeta == METAMAGIC_EXTEND )
    {
        nCasterLvl = nCasterLvl * 2;
    }

    effect eConceal = EffectConcealment( nConceal, MISS_CHANCE_TYPE_NORMAL );
    effect eVis = EffectVisualEffect( VFX_DUR_GLOW_LIGHT_GREEN );
    effect eLink = EffectLinkEffects( eConceal, eVis );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur );
}
