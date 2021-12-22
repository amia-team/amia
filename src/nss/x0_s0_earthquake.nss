//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  X0_S0_Earthquake
//description: Earthquake impact script
//used as: spellscript
//date:    feb 07 2009
//author:  Terra

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------

int Immunity( object oGarfish ){

    if( GetIsPC( oGarfish ) )
        return FALSE;
    else if( GetHasFeat( FEAT_SKILL_FOCUS_TUMBLE, oGarfish ) )
        return TRUE;

    return FALSE;
}

void main(){

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Vars
    object oCaster      = OBJECT_SELF;
    int nCasterLvl      = GetCasterLevel( oCaster );
    int nDC             = GetSpellSaveDC( );
    int nCap = 20;
    location lTarget    = GetSpellTargetLocation( );

    effect eDam;
    int nDamage;
    float fDelay;

    //determin bonus for spell foci
    if (GetHasFeat (FEAT_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nCap = 21;
    }
    if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nCap = 23;
    }
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nCap = 25;
    }
    //cap
    if( nCasterLvl > nCap )
        nCasterLvl = nCap;


    //Spellscript
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect( 356 ), oCaster , 6.0 );

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

    while( GetIsObjectValid( oTarget ) ){


        if( GetIsEnemy( oTarget, oCaster ) && !GetPlotFlag( oTarget ) && oTarget != oCaster && !Immunity( oTarget ) ){

            SignalEvent( oTarget, EventSpellCastAt( oCaster , SPELL_EARTHQUAKE ) );

            //Calculate new vars
            nDamage = GetReflexAdjustedDamage( d8( nCasterLvl ), oTarget, nDC , SAVING_THROW_TYPE_ALL, oCaster );
            fDelay = GetDistanceBetweenLocations( lTarget, GetLocation( oTarget ) ) / 20;

            //Smack it on

            if( nDamage > 0 ){

                eDam = EffectDamage( nDamage, DAMAGE_TYPE_BLUDGEONING,DAMAGE_POWER_PLUS_FIVE );
                DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, oTarget ) );
                DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_HEAD_NATURE ), oTarget ) );
            }
            if( ReflexSave( oTarget, nDC, SAVING_THROW_TYPE_NONE, oCaster ) == 0 ){

                DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectKnockdown( ), oTarget, 6.0 ) );

            }

        }

    oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

    }
}

//-----------------------------------------------------------------------------
// functions
//-----------------------------------------------------------------------------






