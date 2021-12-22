/*
    Custom Spell:
    Chronal Blast
    - Level 9 Wiz/Sorc Ranged (Evocation)
    - On Ranged Touch attack, paralyzes target for 1 round
      (immunity applies, no save, no SR). Failure means spell does
      nothing.
    - After 1 round, any target in Medium radius of the centre point
      (centered on spell’s original target location) will take 1d6
      per caster level of Divine Damage (no save, no SR).
*/

#include "x0_i0_spells"

void BlastDamage(object oCaster, object oRadius, int nCasterLvl);

void main()
{
    //Gather spell details
    object oCaster = GetLastSpellCaster( );
    int nCasterLvl;
    int nSpellPen;
    int nDC;
    int nSR;
    float fDur;

    //Check for Spell Penetration feats
    if( GetHasFeat( FEAT_SPELL_PENETRATION, oCaster ) == TRUE )
    {
        nSpellPen = 2;
    }
    if( GetHasFeat( FEAT_GREATER_SPELL_PENETRATION, oCaster ) == TRUE )
    {
        nSpellPen = 4;
    }
    if( GetHasFeat( FEAT_EPIC_SPELL_PENETRATION, oCaster ) == TRUE )
    {
        nSpellPen = 6;
    }

    //Check to see if it is an NPC creature casting the spell for caster level
    if( !GetIsPC( oCaster ) && !GetIsDM( oCaster ) )
    {
        nCasterLvl = GetHitDice( oCaster );
        nSR = ( d20( 1 ) + nCasterLvl + nSpellPen );
        nDC = ( 10 + 9 + GetAbilityModifier( ABILITY_CHARISMA, oCaster ) );
        fDur = RoundsToSeconds( nCasterLvl );
    }
    //else run the spell as normal for a PC
    else
    {
        nCasterLvl = GetNewCasterLevel( oCaster );
        nSR = ( d20( 1 ) + nCasterLvl + nSpellPen );
        nDC = GetSpellSaveDC();
        fDur = 900.0;
    }
/* Commented out, Evocation spell
    //remove Evocation bonus since all Custom spell slots are Evocation based
    if( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_EVOCATION, oCaster ) == TRUE )
    {
        nDC = nDC - 6;
    }
    else if( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_EVOCATION, oCaster ) == TRUE )
    {
        nDC = nDC - 4;
    }
    else if( GetHasFeat( FEAT_SPELL_FOCUS_EVOCATION, oCaster ) == TRUE )
    {
        nDC = nDC - 2;
    }

    //add in appropriate Spell Focus bonus to save DC
    if( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, oCaster ) == TRUE )
    {
        nDC = nDC + 6;
    }
    else if( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, oCaster ) == TRUE )
    {
        nDC = nDC + 4;
    }
    else if( GetHasFeat( FEAT_SPELL_FOCUS_TRANSMUTATION, oCaster ) == TRUE )
    {
        nDC = nDC + 2;
    }
*/
    //get target
    object oTarget = GetSpellTargetObject( );
    location lTarget = GetSpellTargetLocation( );

    //Do ranged touch attack
    if( TouchAttackRanged( oTarget ) == 0 )
    {
        return;
    }

    SignalEvent( oTarget, EventSpellCastAt( oCaster, SPELL_HOLD_MONSTER ) );

    effect eTrap = SupernaturalEffect( EffectCutsceneImmobilize() );
    effect eRadius = EffectVisualEffect( VFX_DUR_AURA_POISON );

    //warning VFX where target is standing and destroy after 6 seconds when blast effect hits
    object oRadius = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_solgreen", lTarget, FALSE, "" );
    DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eRadius, oRadius, 5.9) );
    DelayCommand( 6.0, DestroyObject( oRadius ) );

    //make sure target can’t move out of radius
    if( GetIsImmune( oTarget, IMMUNITY_TYPE_PARALYSIS ) == FALSE )
    {
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eTrap, oTarget, 6.0 );
    }

    //call for damage to be done in 1 round
    DelayCommand( 6.0, BlastDamage( oCaster, oRadius, nCasterLvl ) );
}

void BlastDamage( object oCaster, object oRadius, int nCasterLvl )
{
    //declare variables
    effect eVFX = EffectVisualEffect( VFX_IMP_DIVINE_STRIKE_HOLY );
    effect eBlast = EffectVisualEffect( VFX_FNF_SOUND_BURST );
    effect eKD = EffectKnockdown();
    location lRadius = GetLocation( oRadius );

    //get hostile targets still inside radius
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lRadius, FALSE, OBJECT_TYPE_CREATURE );

    while( GetIsObjectValid( oTarget ) )
    {
        if( !GetIsFriend( oTarget, oCaster ) )
        {
            //max out the damage dice at 30
            if ( nCasterLvl >= 31 )
            {
                nCasterLvl = 30;
            }
            int nDamage = d6( nCasterLvl );
            effect eDamage = EffectDamage( nDamage, DAMAGE_TYPE_DIVINE );
            effect eLink = EffectLinkEffects( eVFX, eDamage );

            SignalEvent( oTarget, EventSpellCastAt( oCaster, SPELL_DELAYED_BLAST_FIREBALL ) );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eLink, oTarget );
            DelayCommand( 0.01, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eKD, oTarget, 3.0 ) );
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lRadius, FALSE, OBJECT_TYPE_CREATURE );
    }
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eBlast, lRadius );
}
