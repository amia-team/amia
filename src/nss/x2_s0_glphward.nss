//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  x2_s0_glphward
//description: glyph of warding impact script
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
// Effect
//-----------------------------------------------------------------------------
void GlyphTheGlyph( object oOwner, location lTarget, float fDur ){

    object oGlyph = GetLocalObject( oOwner, "glyph" );

    //Clean up, only allow one glyph
    if( GetIsObjectValid( oGlyph ) ){

    effect eEffect = GetFirstEffect( oGlyph );

        while( GetIsEffectValid( eEffect ) ){

            RemoveEffect( oGlyph, eEffect );

            eEffect = GetNextEffect( oGlyph );
        }

    DestroyObject( oGlyph );
    }

    oGlyph = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_magicyellow", lTarget, FALSE, GetName( oOwner ) );

    AssignCommand( oGlyph, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_GLYPH_OF_WARDING ),oGlyph , fDur ) );
    AssignCommand( oGlyph, ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, EffectAreaOfEffect( AOE_PER_CUSTOM_AOE, "td_glyph_ent" ), lTarget, fDur ) );

    SetLocalObject( oOwner, "glyph", oGlyph );

    SetLocalObject( oGlyph, "caster", oOwner );

    DestroyObject( oGlyph, fDur );
}

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void main(){

    if (!X2PreSpellCastCode()){
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    location    lTarget = GetSpellTargetLocation( );
    object      oTarget = GetSpellTargetObject();
    float       fDur    = IntToFloat( GetNewCasterLevel( OBJECT_SELF )*60 );



    if( GetIsObjectValid( oTarget ) && GetIsEnemy( oTarget ) ){

        SignalEvent(oTarget, EventSpellCastAt( OBJECT_SELF, SPELL_GLYPH_OF_WARDING ) );

        int nCL = GetNewCasterLevel( OBJECT_SELF );
        //cap
        if( nCL > 10 )
            nCL = 10;
        int nDam = GetReflexAdjustedDamage( d6( nCL ), oTarget, GetShifterDC( OBJECT_SELF, GetSave( OBJECT_SELF) ), DAMAGE_TYPE_SONIC );

        if( nDam > 0 ){
            effect eDam = EffectDamage( nDam, DAMAGE_TYPE_SONIC );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, oTarget );
        }

        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_SOUND_BURST ), oTarget );
        return;
    }
    else
        DelayCommand( 0.5, GlyphTheGlyph( OBJECT_SELF ,lTarget, fDur ) );

}


