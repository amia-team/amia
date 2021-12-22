//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  gbbrng_ondeath
//group:   ds_ai
//used as: OnDeath for Brood Gibberling and Gibbering Mouther
//date:    sept 15 2012
//author:  disco (modified by Glim)

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_ondeath"
#include "ds_ai2_include"
#include "inc_ds_qst"
#include "inc_ds_actions"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void ResetPortal( object oPortal );
void DoPhaseTransition( object oBoss );
void DropChaosGrowth( object oBoss );
void CleanBossCrystals( object oKiller );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oCritter         = OBJECT_SELF;
    object oKiller          = GetLastKiller();

    //Identify creature using the script to know how to act
    string sIdentity = GetResRef( oCritter );

    if( sIdentity == "gibberling_brood" )
    {
        object oRock = GetNearestObjectByTag( "gbbrng_lvl2_block" );

        if( oRock != OBJECT_INVALID )
        {
            location lSpawn = GetLocation( GetNearestObjectByTag( "gbbrng_surprise" ) );

            CreateObject( OBJECT_TYPE_CREATURE, "gibberling_norml", lSpawn );
            CreateObject( OBJECT_TYPE_CREATURE, "gibberling_norml", lSpawn );
            CreateObject( OBJECT_TYPE_CREATURE, "gibberling_norml", lSpawn );
            CreateObject( OBJECT_TYPE_CREATURE, "gibberling_norml", lSpawn );
            CreateObject( OBJECT_TYPE_CREATURE, "gibberling_norml", lSpawn );

            string sSurprise = "<c¥  >**lets out a horrendous wailing sound as it falls and the sound of crumbling rock can be heard as a tunnel opens nearby!**</c>";
            SpeakString( sSurprise );
            FloatingTextStringOnCreature( sSurprise, OBJECT_SELF, FALSE );

            effect eShake = EffectVisualEffect( VFX_FNF_SCREEN_SHAKE );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eShake, oRock );

            DestroyObject( oRock, 3.0 );
        }
    }
    if( sIdentity == "gibberingmouther" )
    {
        object oPortal = GetNearestObjectByTag( "gbbrdeep_gbbrmad_2" );

        if( oPortal != OBJECT_INVALID && GetObjectType( oPortal ) != OBJECT_TYPE_WAYPOINT )
        {
            SetUseableFlag( oPortal, TRUE );

            AssignCommand( oPortal, ResetPortal( oPortal ) );

            string sSurprise = "<c¥  >**as the Mouther is slain, its form is sucked back into the rift at the heart of the strange apparatus!**</c>";
            SpeakString( sSurprise );
            FloatingTextStringOnCreature( sSurprise, OBJECT_SELF, FALSE );

            string sCorpse  =  GetLocalString( OBJECT_SELF, "q_corpse" );

            if ( sCorpse != "" ){

                CreateObject( OBJECT_TYPE_PLACEABLE, sCorpse, GetLocation( OBJECT_SELF ) );
            }
            else{

                int nNextState = qst_check( oKiller );
                qst_resolve_party( oKiller, nNextState );
            }

            AssignCommand( oKiller, CleanBossCrystals( oKiller ) );
        }
    }
    if( sIdentity == "alienist_portal" )
    {
        object oBoss = GetNearestObjectByTag( "alienist_boss_1", oCritter );
        int nCounter = GetLocalInt( oBoss, "Counter" );

        if( nCounter != 4 )
        {
            nCounter = nCounter + 1;
            SetLocalInt( oBoss, "Counter", nCounter );
            AssignCommand( oBoss, SpeakString( "<c¥ ¥>You only delay the inevitable. His will cannot be denied!</c>" ) );
        }
        if( nCounter == 4 )
        {
            effect eKill = EffectDamage( 30 );

            AssignCommand( oBoss, SpeakString( "<c¥ ¥>His will... cannot be... denied......</c>" ) );
            SetPlotFlag( oBoss, FALSE );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eKill, oBoss );
        }
        return;
    }
    if (sIdentity == "alienist_boss_1" )
    {
        object oBoss = GetLocalObject( oCritter, "Boss2" );

        effect eRemove = GetFirstEffect( oBoss );
        while (GetIsEffectValid( eRemove ) )
        {
            RemoveEffect( oBoss, eRemove );

            eRemove = GetNextEffect( oBoss );
        }
        AssignCommand( oBoss, DoPhaseTransition( oBoss ) );
        return;
    }
    if (sIdentity == "alienist_boss_2" )
    {
        SpeakString( "<c¥ ¥>They won't let me sleep... for long......</c>" );

        string sCorpse  =  GetLocalString( OBJECT_SELF, "q_corpse" );

        if ( sCorpse != "" ){

            CreateObject( OBJECT_TYPE_PLACEABLE, sCorpse, GetLocation( OBJECT_SELF ) );
        }
        else{

            int nNextState = qst_check( oKiller );
            qst_resolve_party( oKiller, nNextState );
        }

        AssignCommand( oKiller, CleanBossCrystals( oKiller ) );
        object oPortOut = GetObjectByTag( "alienist_spawn" );
        CreateObjectVoid( OBJECT_TYPE_PLACEABLE, "gbbr_port_out", GetLocation( oPortOut ), FALSE, "", TurnsToSeconds( 10 ) );
    }

    if( GetLastKiller() != OBJECT_SELF && GetLocalInt( oCritter, L_ISDEAD ) != 1 ){

        // Set have died once, stops giving out multiple amounts of XP.
        SetLocalInt( oCritter, L_ISDEAD, 1 );

        // Reward XP.
        int nXPResult = RewardXPForKill( );

        // Generate treasure.
        GenerateLoot( oCritter, nXPResult );
    }
}

void ResetPortal( object oPortal )
{
    DelayCommand( TurnsToSeconds( 15 ), SetUseableFlag( oPortal, FALSE ) );
}

void DoPhaseTransition( object oBoss )
{
    SetLocalInt( oBoss, "CS_DSPWN", 1 );
    DelayCommand( 1.0, AssignCommand( oBoss, ActionPlayAnimation( ANIMATION_LOOPING_SPASM, 1.0, 3.0 ) ) );
    DelayCommand( 1.0, AssignCommand( oBoss, SpeakString( "<c¥ ¥>**suddenly wakes, startling and crying out** Aaah! Wha-... Nyuh...</c>" ) ) );
    DelayCommand( 6.0, AssignCommand( oBoss, SpeakString( "<c¥ ¥>What... what did you... nyuh...</c>" ) ) );
    DelayCommand( 11.0, AssignCommand( oBoss, SpeakString( "<c¥ ¥>No... nonono... I had everything, I -was- everything!</c>" ) ) );
    DelayCommand( 15.0, TurnToFaceObject( GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oBoss ), oBoss ) );
    DelayCommand( 16.0, AssignCommand( oBoss, SpeakString( "<c¥ ¥>And you... what did you do...?</c>" ) ) );
    DelayCommand( 21.0, AssignCommand( oBoss, SpeakString( "<c¥ ¥>You took it from me! How could you?!?!</c>" ) ) );
    DelayCommand( 25.0, SetPlotFlag( oBoss, FALSE ) );
    DelayCommand( 25.1, ChangeToStandardFaction( oBoss, STANDARD_FACTION_HOSTILE ) );
    DelayCommand( 25.2, ActionAttack( GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oBoss ) ) );
    DelayCommand( 32.0, DropChaosGrowth( oBoss ) );
}

void DropChaosGrowth( object oBoss )
{
    if( GetIsDead( oBoss ) == TRUE )
    {
        return;
    }

    object oPC = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oBoss );

    if( oPC == OBJECT_INVALID )
    {
        return;
    }

    int nGrowths = GetLocalInt( oBoss, "Growths" );
    string sGrowths = IntToString( nGrowths );

    effect eAura = EffectAreaOfEffect( AOE_MOB_MENACE, "chaos_zone_enter", "****", "chaos_zone_exit" );
    CreateObjectVoid( OBJECT_TYPE_PLACEABLE, "alien_growth", GetLocation( oBoss ), FALSE, "alien_growth_"+sGrowths, 121.0 );
    DelayCommand( 1.0, ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAura, GetLocation( GetNearestObjectByTag( "alien_growth_"+sGrowths, oBoss ) ), 120.0 ) );
    DelayCommand( 9.0, SetLocalInt( oBoss, "Growths", nGrowths + 1 ) );
    DelayCommand( 13.0, DropChaosGrowth( oBoss ) );
}

void CleanBossCrystals( object oKiller )
{
    location lKiller = GetLocation( oKiller );

    object oClean = GetFirstObjectInShape( SHAPE_SPHERE, 200.0, lKiller, FALSE, OBJECT_TYPE_PLACEABLE );
    while( GetIsObjectValid( oClean ) )
    {
        if( GetTag( oClean ) == "alien_growth" )
        {
            DestroyObject( oClean );
        }
        oClean = GetNextObjectInShape( SHAPE_SPHERE, 200.0, lKiller, FALSE, OBJECT_TYPE_PLACEABLE );
    }
}

