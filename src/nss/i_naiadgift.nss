/* Gift of the Naiad - Custom Bard Song

Expends 3 charges of the Bard Song feat, affecting a Large radius and 2 HD per
CL of creatures in that radius, with a song duration of 1 Round per CL. Those
affected must make a Will save vs 10 + CHA mod + 1/2 Bard Levels or be Dazed for
rounds equal to CHA mod. Constructs/undead are immune, mind protections apply,
as does Deafness / Silence.

Revision History
Date     Name             Description
-------- ---------------- ---------------------------------------------
15/08/14 Glim             Initial Release

*/

//
void CycleSongTargets( object oCaster, int nHD, int nDC, float fDur );
//
#include "amia_include"
#include "x2_inc_switches"

void ActivateItem()
{
    object oCaster = GetItemActivator();
    location lCaster = GetLocation( oCaster );
    effect eHowl = EffectVisualEffect( VFX_FNF_HOWL_MIND );
    effect eDur = EffectVisualEffect( VFX_DUR_BARD_SONG );
    float fDur;
    float fCL;
    int nSong = GetLocalInt( oCaster, "NaiadSong" );
    int nCL = GetLevelByClass( CLASS_TYPE_BARD, oCaster );
    int nCHA = GetAbilityModifier( ABILITY_CHARISMA, oCaster );
    int nHD;
    int nDC;
    int nDur;

    //check first that there's enough remaining Bard Song uses, then decrement
    if( !TakeFeatUses( oCaster, FEAT_BARD_SONGS, 3 ) )
    {
        SendMessageToPC( oCaster, "[You do not have enough uses of Bard Song remaining.]" );
        return;
    }
    //check also that the song isn't currently applied already
    if( nSong != 0 )
    {
        SendMessageToPC( oCaster, "[This song is already active. You must wait for it to finish.]" );
        return;
    }

    //calculations before targetting
    nHD = nCL * 2;
    fCL = IntToFloat( nCL );
    nDC = 10 + nCHA + FloatToInt( fCL * 0.5 );
    fDur = IntToFloat( nCL * 6 );

    //vfx and song for activation
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eHowl, lCaster );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDur, oCaster, fDur );
    PlaySound( "as_cv_flute1" );

    //block further uses of the Song until this one expires
    SetLocalInt( oCaster, "NaiadSong", 1 );
    DelayCommand( fDur, SetLocalInt( oCaster, "NaiadSong", 0 ) );
    DelayCommand( fDur + 0.5, FloatingTextStringOnCreature( "[Gift of the Naiad song has finished and is ready for use.]", oCaster ) );

    //run targetting cycle
    nDur = nCL;
    SetLocalInt( oCaster, "NaiadDur", nDur );
    CycleSongTargets( oCaster, nHD, nDC, fDur );
}

void CycleSongTargets( object oCaster, int nHD, int nDC, float fDur )
{
    location lCaster = GetLocation( oCaster );
    int nDur = GetLocalInt( oCaster, "NaiadDur" );
    int nTargetHD;
    int nRace;
    int nSave = 2;
    int nImmune = 0;
    effect eDaze = EffectDazed();
    effect eVFX = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_NEGATIVE );
    effect eLink = EffectLinkEffects( eVFX, eDaze );
    effect eCycle;

    //check and make sure caster isn't dead
    if( GetIsDead( oCaster ) || nDur == 0 )
    {
        return;
    }

    //cycle targets
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lCaster, FALSE, OBJECT_TYPE_CREATURE );
    while( GetIsObjectValid( oTarget ) )
    {
        if( GetIsEnemy( oTarget, oCaster ) )
        {
            //check remaining HD to affect against target's HD
            nTargetHD = GetHitDice( oTarget );
            if( nTargetHD <= nHD &&
                oTarget != oCaster )
            {
                //set up immunity checks
                nRace = GetRacialType( oTarget );
                eCycle = GetFirstEffect( oTarget );
                while( GetIsEffectValid( eCycle ) )
                {
                    if( GetEffectType( eCycle ) == EFFECT_TYPE_DEAF ||
                        GetEffectType( eCycle ) == EFFECT_TYPE_SILENCE )
                    {
                        nImmune = 1;
                    }
                    eCycle = GetNextEffect( oTarget );
                }

                //check for immunities (if found, nSave automatically = 2 for immune)
                if( nRace != RACIAL_TYPE_CONSTRUCT &&
                    nRace != RACIAL_TYPE_UNDEAD &&
                    nImmune != 1 )
                {
                    nSave = WillSave( oTarget, nDC, SAVING_THROW_TYPE_SPELL, oCaster );
                }

                if( nSave == 0 )
                {
                    //remove affected HD from pool
                    nHD = nHD - nTargetHD;

                    //apply effect
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur );
                }
            }
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lCaster, FALSE, OBJECT_TYPE_CREATURE );
    }

    //repeat if effect duration has not expired and affected HD cap has not been reached
    nDur = nDur - 1;
    SetLocalInt( oCaster, "NaiadDur", nDur );
    if( nDur >= 1 && nHD >= 1 )
    {
        DelayCommand( 6.0, CycleSongTargets( oCaster, nHD, nDC, fDur ) );
    }
}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
