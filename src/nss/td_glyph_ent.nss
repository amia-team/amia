//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  td_glyph_ent
//description: glyph of warding enter script
//used as: spellscript
//date:    feb 06 2009
//author:  Terra

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "x2_inc_spellhook"
#include "inc_td_shifter"
//-----------------------------------------------------------------------------
// Save
//-----------------------------------------------------------------------------
int GetSave( object oCaster ){

    int nMod = 0;

    if( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_ABJURATION, oCaster ) )
        nMod = 6;

    else if( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_ABJURATION, oCaster ) )
        nMod = 4;

    else if( GetHasFeat( FEAT_SPELL_FOCUS_ABJURATION, oCaster ) )
        nMod = 2;

    return 13 + GetAbilityModifier( ABILITY_WISDOM, oCaster ) + nMod ;
}
//-----------------------------------------------------------------------------
// Cleanup
//-----------------------------------------------------------------------------
void DestroyGlyph( object oWP ){

    effect eEffect = GetFirstEffect( oWP );

    while( GetIsEffectValid( eEffect ) ){

        RemoveEffect( oWP, eEffect );

        eEffect = GetNextEffect( oWP );
    }

    DestroyObject( oWP );
}
//-----------------------------------------------------------------------------
// Trigger
//-----------------------------------------------------------------------------
void Glyph( object oCaster, object oWP, object oTarget ){

    if( oTarget == oCaster )
        return;

    else if( GetIsObjectValid( oTarget ) && GetIsEnemy( oTarget, oCaster ) ){

        SignalEvent(oTarget, EventSpellCastAt( oCaster, SPELL_GLYPH_OF_WARDING ) );

        int nCL = GetCasterLevel( oCaster );
        //cap
        if( nCL > 10 )
            nCL = 10;
        int nDam = GetReflexAdjustedDamage( d6( nCL ), oTarget, GetShifterDC( oCaster, GetSave( oCaster ) ), DAMAGE_TYPE_SONIC, oCaster );

        SendMessageToPC( oCaster, "<cþ þ>Something triggered your glyph of warding." );

        if( nDam > 0 ){
            effect eDam = EffectDamage( nDam, DAMAGE_TYPE_SONIC );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam , oTarget );
        }

        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_SOUND_BURST ), oWP );

        DelayCommand( 3.0, DestroyGlyph( oWP ) );

        return;
    }

    else
        SendMessageToPC( oCaster, "<cþ þ>Something entered your glyph of warding." );

}
//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------
void main(){

    object oTarget = GetEnteringObject( );
    object oWP     = GetAreaOfEffectCreator( );
    object oCaster = GetLocalObject( oWP, "caster" );

    if( !GetIsObjectValid( oCaster ) )
        DestroyGlyph( oWP );

    AssignCommand( oCaster,Glyph( oCaster, oWP, oTarget ) );

}
