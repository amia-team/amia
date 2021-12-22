/*
    Custom Spell:
    Temporal Stasis
    - Level 8 Wiz/Sorc Ranged (Transmutation)
    - On a successful Melee Touch Attack followed by Fortitude save, causes the target to be
    completely unable to act but also unable to be harmed in any way, until dispelled. Spell
    Resistance does apply.
    - PC version lasts only Rounds per Level.
    - NPC version lasts until freed (or 15 minutes with Kill + Respawn)
*/

#include "x0_i0_spells"

void main()
{
    //Gather spell details
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject( );
    location lTarget = GetSpellTargetLocation( );
    int nCasterLvl;
    int nSpellPen = 0;
    int nDC;
    int nSR;
    int nCHA = 0;
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

    //Run normally if cast by a PC
    if( GetIsPC( oCaster ) && !GetIsDMPossessed( oCaster ) )
    {
        nCasterLvl = GetNewCasterLevel( oCaster );
        nSR = ( d20( 1 ) + nCasterLvl + nSpellPen );
        nDC = GetSpellSaveDC();
        fDur = RoundsToSeconds( nCasterLvl );

        //Make sure the Caster isn't targetting themself
        if( oTarget == oCaster )
        {
            SendMessageToPC( oCaster, "You cannot target yourself with Temporal Stasis." );
            return;
        }
    }
    //Otherwise generate custom attributes for NPCs
    else
    {
        nCasterLvl = GetHitDice( oCaster );
        nSR = ( d20( 1 ) + nCasterLvl + nSpellPen );
        nCHA = GetAbilityModifier( ABILITY_CHARISMA, oCaster );
        nDC = ( 10 + 8 + nCHA );
        fDur = 900.0;
    }

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

    // Damage immunities.
    effect eDamage1     = EffectDamageImmunityIncrease( DAMAGE_TYPE_ACID, 100 );
    effect eDamage2     = EffectDamageImmunityIncrease( DAMAGE_TYPE_BLUDGEONING, 100 );
    effect eDamage3     = EffectDamageImmunityIncrease( DAMAGE_TYPE_COLD, 100 );
    effect eDamage4     = EffectDamageImmunityIncrease( DAMAGE_TYPE_DIVINE, 100 );
    effect eDamage5     = EffectDamageImmunityIncrease( DAMAGE_TYPE_ELECTRICAL, 100 );
    effect eDamage6     = EffectDamageImmunityIncrease( DAMAGE_TYPE_FIRE, 100 );
    effect eDamage7     = EffectDamageImmunityIncrease( DAMAGE_TYPE_MAGICAL, 100 );
    effect eDamage8     = EffectDamageImmunityIncrease( DAMAGE_TYPE_NEGATIVE, 100 );
    effect eDamage9     = EffectDamageImmunityIncrease( DAMAGE_TYPE_PIERCING, 100 );
    effect eDamage10    = EffectDamageImmunityIncrease( DAMAGE_TYPE_POSITIVE, 100 );
    effect eDamage11    = EffectDamageImmunityIncrease( DAMAGE_TYPE_SLASHING, 100 );
    effect eDamage12    = EffectDamageImmunityIncrease( DAMAGE_TYPE_SONIC, 100 );

    // Status immunities.
    effect eImmunity1   = EffectImmunity( IMMUNITY_TYPE_ABILITY_DECREASE );
    effect eImmunity2   = EffectImmunity( IMMUNITY_TYPE_AC_DECREASE );
    effect eImmunity3   = EffectImmunity( IMMUNITY_TYPE_ATTACK_DECREASE );
    effect eImmunity4   = EffectImmunity( IMMUNITY_TYPE_BLINDNESS );
    effect eImmunity5   = EffectImmunity( IMMUNITY_TYPE_CRITICAL_HIT );
    effect eImmunity6   = EffectImmunity( IMMUNITY_TYPE_CURSED );
    effect eImmunity7   = EffectImmunity( IMMUNITY_TYPE_ABILITY_DECREASE );
    effect eImmunity8   = EffectImmunity( IMMUNITY_TYPE_DAMAGE_DECREASE );
    effect eImmunity9   = EffectImmunity( IMMUNITY_TYPE_DAMAGE_IMMUNITY_DECREASE );
    effect eImmunity10  = EffectImmunity( IMMUNITY_TYPE_DEAFNESS );
    effect eImmunity11  = EffectImmunity( IMMUNITY_TYPE_DEATH );
    effect eImmunity12  = EffectImmunity( IMMUNITY_TYPE_DISEASE );
    effect eImmunity13  = EffectImmunity( IMMUNITY_TYPE_ENTANGLE );
    effect eImmunity14  = EffectImmunity( IMMUNITY_TYPE_KNOCKDOWN );
    effect eImmunity15  = EffectImmunity( IMMUNITY_TYPE_MIND_SPELLS );
    effect eImmunity16  = EffectImmunity( IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE );
    effect eImmunity17  = EffectImmunity( IMMUNITY_TYPE_NEGATIVE_LEVEL );
    effect eImmunity18  = EffectImmunity( IMMUNITY_TYPE_POISON );
    effect eImmunity19  = EffectImmunity( IMMUNITY_TYPE_SAVING_THROW_DECREASE );
    effect eImmunity20  = EffectImmunity( IMMUNITY_TYPE_SILENCE );
    effect eImmunity21  = EffectImmunity( IMMUNITY_TYPE_SKILL_DECREASE );
    effect eImmunity22  = EffectImmunity( IMMUNITY_TYPE_SPELL_RESISTANCE_DECREASE );
    effect eImmunity23  = EffectImmunity( IMMUNITY_TYPE_SNEAK_ATTACK );
    effect eImmunity24  = EffectImmunity( IMMUNITY_TYPE_SLOW );
    effect eImmunity25  = EffectImmunity( IMMUNITY_TYPE_SLEEP );

    // Link it all together... this goes on a while.
    effect eStop        = EffectCutsceneParalyze();
    effect eVis1        = EffectVisualEffect( VFX_DUR_FREEZE_ANIMATION );
    effect eVis2        = EffectVisualEffect( VFX_DUR_GLOBE_INVULNERABILITY );
    effect eVis3        = EffectVisualEffect( VFX_DUR_GLYPH_OF_WARDING );

    effect eLink        = EffectLinkEffects( eDamage1, eLink );
           eLink        = EffectLinkEffects( eDamage2, eLink );
           eLink        = EffectLinkEffects( eDamage3, eLink );
           eLink        = EffectLinkEffects( eDamage4, eLink );
           eLink        = EffectLinkEffects( eDamage5, eLink );
           eLink        = EffectLinkEffects( eDamage6, eLink );
           eLink        = EffectLinkEffects( eDamage7, eLink );
           eLink        = EffectLinkEffects( eDamage8, eLink );
           eLink        = EffectLinkEffects( eDamage9, eLink );
           eLink        = EffectLinkEffects( eDamage10, eLink );
           eLink        = EffectLinkEffects( eDamage11, eLink );
           eLink        = EffectLinkEffects( eDamage12, eLink );
           eLink        = EffectLinkEffects( eImmunity1, eLink );
           eLink        = EffectLinkEffects( eImmunity2, eLink );
           eLink        = EffectLinkEffects( eImmunity3, eLink );
           eLink        = EffectLinkEffects( eImmunity4, eLink );
           eLink        = EffectLinkEffects( eImmunity5, eLink );
           eLink        = EffectLinkEffects( eImmunity6, eLink );
           eLink        = EffectLinkEffects( eImmunity7, eLink );
           eLink        = EffectLinkEffects( eImmunity8, eLink );
           eLink        = EffectLinkEffects( eImmunity9, eLink );
           eLink        = EffectLinkEffects( eImmunity10, eLink );
           eLink        = EffectLinkEffects( eImmunity11, eLink );
           eLink        = EffectLinkEffects( eImmunity12, eLink );
           eLink        = EffectLinkEffects( eImmunity13, eLink );
           eLink        = EffectLinkEffects( eImmunity14, eLink );
           eLink        = EffectLinkEffects( eImmunity15, eLink );
           eLink        = EffectLinkEffects( eImmunity16, eLink );
           eLink        = EffectLinkEffects( eImmunity17, eLink );
           eLink        = EffectLinkEffects( eImmunity18, eLink );
           eLink        = EffectLinkEffects( eImmunity19, eLink );
           eLink        = EffectLinkEffects( eImmunity20, eLink );
           eLink        = EffectLinkEffects( eImmunity21, eLink );
           eLink        = EffectLinkEffects( eImmunity22, eLink );
           eLink        = EffectLinkEffects( eImmunity23, eLink );
           eLink        = EffectLinkEffects( eImmunity24, eLink );
           eLink        = EffectLinkEffects( eImmunity25, eLink );
           eLink        = EffectLinkEffects( eStop, eLink);
           eLink        = EffectLinkEffects( eVis1, eLink);
           eLink        = EffectLinkEffects( eVis2, eLink);
           eLink        = EffectLinkEffects( eVis3, eLink);

    //Make sure target isn't already affected by Temporal Stasis
    if( GetLocalInt( oTarget, "Temporal_Stasis" ) == 1 ||
        GetLocalInt( oTarget, "Null_Time" ) == 1 ||
        GetLocalInt( oTarget, "Trapped_Soul" ) == 1 )
    {
        return;
    }

    SignalEvent( oTarget, EventSpellCastAt( oCaster, SPELL_HOLD_MONSTER ) );

    //Do melee touch attack
    if( TouchAttackMelee( oTarget ) >= 1 )
    {
        //Spell Resistance applies
        if( GetSpellResistance( oTarget ) < nSR )
        {
            //Fort Save
            if( !MySavingThrow( SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL, oCaster ) )
            {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
                    SetLocalInt( oTarget, "Temporal_Stasis", 1 );
                    SetLocalObject( oTarget, "Stasis_Caster", oCaster );
                    //remove variable after effect
                    DelayCommand( fDur, SetLocalInt( oTarget, "Temporal_Stasis", 0 ) );
            }
        }
    }
}
