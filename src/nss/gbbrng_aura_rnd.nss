//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  gbbrng_aura_rnd
//group:   gbbrng
//used as: OnHeartbeat Aura script for Gibbering Mouther
//date:    sept 21 2012
//author:  Glim

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x0_i0_enemy"
#include "ds_ai2_include"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void DoMeleeAttack( object oCritter, object oTarget );
void DoGrappleSwallow( object oCritter, object oTarget, string sTarget );
void DoAcidSpittle( object oCritter );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main()
{
    object oCritter = GetAreaOfEffectCreator( OBJECT_SELF );
    location lCritter = GetLocation( oCritter );
    int nAttacks = 1;
    int nTargets = 1;
    object oTarget;

    //Do ranged attack
    AssignCommand( oCritter, DoAcidSpittle( oCritter ) );

    //Do speach
    int nSpeak = GetLocalInt( oCritter, "Speak" );

    if( nSpeak == 2 )
    {
        int nStringtoSpeak = d3(1);
        string sSpeak;

        switch( nStringtoSpeak )
        {
            case 1:   sSpeak = "Oo oop mbaooboots soonnanoomd...";        break;
            case 2:   sSpeak = "Eeeae gdootb Oo'p goolboots naeg teba!";  break;
            case 3:   sSpeak = "Nooggan aeb! Eeeae'na eaeg ek gdana!";    break;
            default:  break;
        }

        AssignCommand( oCritter, SpeakString( sSpeak ) );
        SetLocalInt( oCritter, "Speak", 0 );
    }
    else
    {
        SetLocalInt( oCritter, "Speak", nSpeak + 1 );
    }

    //If there are no enemies in range, end script, else do melee attacks
    if( CheckEnemyGroupingOnTarget( oCritter, 1.65 ) <= 0 )
    {
        return;
    }
    else
    {
        //Tentacle Attacks on 6 nearest targets within 1.65 meter radius, duplicates allowed
        while( GetIsObjectValid( GetNearestPerceivedEnemy( oCritter, nTargets, CREATURE_TYPE_IS_ALIVE, TRUE ) ) && nAttacks <= 6 )
        {
            oTarget = GetNearestPerceivedEnemy( oCritter, nTargets, CREATURE_TYPE_IS_ALIVE, TRUE );
            DoMeleeAttack( oCritter, oTarget );
            nAttacks = nAttacks + 1;
            nTargets = nTargets + 1;
            if( !GetIsObjectValid( GetNearestPerceivedEnemy( oCritter, nTargets, CREATURE_TYPE_IS_ALIVE, TRUE ) ) )
            {
                nTargets = 1;
            }
        }
    }
}

void DoMeleeAttack( object oCritter, object oTarget )
{

    float fRange = GetDistanceBetween( oCritter, oTarget );

    //make sure the target is in melee range
    if( fRange <= 1.65 )
    {
        effect eVis1 = EffectVisualEffect( VFX_BEAM_BLACK );
        effect eVis2 = EffectVisualEffect( VFX_COM_BLOOD_LRG_RED );
        effect eDamage = EffectDamage( 1, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY );

        int nAC = GetAC( oTarget );
        int nBAB = GetBaseAttackBonus( oCritter ) + 4;
        int nRoll = d20(1);
        int nAttack = nBAB + nRoll;

        string sTarget = GetName( oTarget );
        string sAB = IntToString( nBAB );
        string sRoll = IntToString( nRoll );
        string sTotal = IntToString( nAttack );
        string sResult;

        //perform the attack
        if( nAC <= nAttack )
        {
            SendMessageToPC( oTarget, "<c¥  >Gibbering Mouther</c> <cÂ† >attacks "+sTarget+" : *hit* : ("+sRoll+" + "+sAB+" = "+sTotal+")</c>" );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis1, oTarget, 6.0 );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis2, oTarget );

            //if not already swallowed, attempt a grapple and swallow attack
            if( GetLocalObject( oCritter, "Swallowed" ) != oTarget && GetLocalInt( oTarget, "Swallowed" ) != 1 )
            {
                DelayCommand( 6.0, AssignCommand( oCritter, DoGrappleSwallow( oCritter, oTarget, sTarget ) ) );
            }
        }
        else
        {
            SendMessageToPC( oTarget, "<c¥  >Gibbering Mouther</c> <cÂ† >attacks "+sTarget+" : *miss* : ("+sRoll+" + "+sAB+" = "+sTotal+")</c>" );
        }
    }
}

void DoGrappleSwallow( object oCritter, object oTarget, string sTarget )
{
    if( GetLocalInt( oCritter, "Swallow" ) == 1 )
    {
        return;
    }

    if( DoGrapple( oTarget, oCritter ) == 1 )
    {
        effect eTrap = EffectCutsceneParalyze();
        effect eInvis = EffectVisualEffect( VFX_DUR_CUTSCENE_INVISIBILITY );
        effect eLink1 = EffectLinkEffects( eTrap, eInvis );
        eLink1 = SupernaturalEffect( eLink1 );

        effect eConDam = EffectAbilityDecrease( ABILITY_CONSTITUTION, 1 );
        effect eConHit = EffectVisualEffect( VFX_IMP_STARBURST_RED );
        eConDam = SupernaturalEffect( eConDam );

        AssignCommand( oTarget, ActionJumpToLocation( GetLocation( oCritter ) ) );
        DelayCommand( 0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink1, oTarget, 5.5 ) );
        DelayCommand( 6.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConDam, oTarget, 24.0 ) );
        DelayCommand( 6.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eConHit, oTarget ) );

        string sName = GetName( oTarget );
        string sSwallow = "<c¥  >*Wraps an appendange around "+sName+", pulling them inside itself, draining their blood!*</c>";
        SpeakString( sSwallow, TALKVOLUME_TALK );
        FloatingTextStringOnCreature( sSwallow, oCritter, FALSE );

        SetLocalInt( oCritter, "Swallow", 1 );
        SetLocalInt( oTarget, "Swallowed", 1 );
        SetLocalObject( oCritter, "Swallowed", oTarget );
        DelayCommand( 5.5, DeleteLocalInt( oCritter, "Swallow" ) );
        DelayCommand( 6.5, DeleteLocalInt( oTarget, "Swallowed" ) );
        DelayCommand( 6.5, DeleteLocalObject( oCritter, "Swallowed" ) );
    }
}

void DoAcidSpittle( object oCritter )
{
    effect eImpact = EffectVisualEffect( VFX_IMP_ACID_S );
    effect eBeam = EffectVisualEffect( VFX_BEAM_DISINTEGRATE );
    effect eDamage = EffectDamage( d4(1), DAMAGE_TYPE_ACID, DAMAGE_POWER_NORMAL );
    effect eLink = EffectLinkEffects( eImpact, eDamage );
    effect eBlind = EffectBlindness();

    float fDur = RoundsToSeconds( d4(1) );

    object oTarget = FindSingleRangedTarget();

    if( !GetIsObjectValid( oTarget ) || GetDistanceBetween( oTarget, oCritter ) < 3.3 )
    {
        oTarget = GetNearestPerceivedEnemy( oCritter );
    }

    if( !GetObjectSeen( oTarget, oCritter ) && !GetObjectHeard( oTarget, oCritter ) )
    {
        //Do nothing if enemy is not percieved even if in range.
    }
    else if( TouchAttackRanged( oTarget, TRUE ) >= 1 )
    {
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oTarget, 0.5 );
        DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_INSTANT, eLink, oTarget ) );

        if( FortitudeSave( oTarget, 16, SAVING_THROW_TYPE_ACID, oCritter ) == 0 )
        {
            DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBlind, oTarget, fDur ) );
        }
    }
}
