/*
    Custom NPC Only Ability:
    Boneyard Split
    - At 80%
        - Splits appart (inactive) for 60 seconds.
        - Does 20d6 Pierce + 20d6 Slash on a failed Reflex DC 37, Gargantuan Radius, Evasion Applies
        - Spawns 2 Skeletal Deathbringers and 10 Splinters
    - At 55%
        - Splits appart (inactive) for 60 seconds.
        - Does 15d6 Pierce + 15d6 Slash on a failed Reflex DC 37, Gargantuan Radius, Evasion Applies
        - Spawns 2 Skeletal Mageguards and 15 Splinters
    - At 30%
        - Splits appart (inactive) for 60 seconds.
        - Does 10d6 Pierce + 10d6 Slash on a failed Reflex DC 37, Gargantuan Radius, Evasion Applies
        - Spawns 2 Skeletal Mageguards, 2 Skeletal Deathbringers and 20 Splinters
*/

#include "ds_ai2_include"
#include "x2_inc_toollib"

void main(){

    //HP percent based boss events
    object oCritter = OBJECT_SELF;
    location lCritter = GetLocation( oCritter );
    object oArea = GetArea( oCritter );
    object oPile = GetNearestObjectByTag( "wp_bonepile", oCritter );
    int nHP = GetPercentageHPLoss( oCritter );
    int n80 = GetLocalInt( oCritter, "Split80" );
    int n55 = GetLocalInt( oCritter, "Split55" );
    int n30 = GetLocalInt( oCritter, "Split30" );
    effect ePara = EffectCutsceneParalyze();
    effect eSanc = EffectSanctuary( 999 );
    effect eInvis = EffectVisualEffect( VFX_DUR_CUTSCENE_INVISIBILITY );
    effect eVis = EffectVisualEffect( VFX_COM_CHUNK_BONE_MEDIUM );
    effect eVis2 = EffectVisualEffect( VFX_FNF_SUMMON_EPIC_UNDEAD );
    string sSplit = "<cеее>**Loses cohesion, shattering into smaller pieces!**</c>";
    string sForm = "<cеее>**Gathers itself back together and attacks anew!**</c>";
    location lRandom;
    object oNewBossPos;
    object oSplinter;

    if( nHP <= 80 && n80 != 1 )
    {
        SetLocalInt( oCritter, "Split80", 1 );
        oNewBossPos = GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) );

        ClearAllActions();
        AssignCommand( oCritter, JumpToObject( oNewBossPos, 0 ) );
        SetCreatureAppearanceType( oCritter, 857 );
        FloatingTextStringOnCreature( sSplit, oCritter );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oCritter );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSanc, oCritter, 1.0 );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eInvis, oCritter, 60.0 );
        TLVFXPillar( VFX_COM_CHUNK_BONE_MEDIUM, GetLocation( oCritter ), 5, 0.1f, 0.0f, 1.0f );
        DelayCommand( 1.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePara, oCritter, 60.0 ) );
        DelayCommand( 1.5, SetPlotFlag( oCritter, TRUE ) );

        DelayCommand( 59.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis2, GetLocation( oNewBossPos ) ) );
        DelayCommand( 60.0, SetPlotFlag( oCritter, FALSE ) );
        DelayCommand( 61.0, AssignCommand( oCritter, SpeakString( sForm ) ) );

        object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lCritter, TRUE, OBJECT_TYPE_CREATURE );
        while( GetIsObjectValid( oTarget ) )
        {
            if( GetIsEnemy( oTarget, oCritter ) == TRUE )
            {
                ActionCastFakeSpellAtObject( SPELL_QUILLFIRE, oTarget );

                int nDamage = GetReflexAdjustedDamage( d6(20), oTarget, 37, SAVING_THROW_TYPE_NONE, oCritter );
                effect ePierce = EffectDamage( nDamage, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL );
                effect eSlash = EffectDamage( nDamage, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_NORMAL );
                effect eLink = EffectLinkEffects( ePierce, eSlash );
                       eLink = EffectLinkEffects( eVis, eLink );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eLink, oTarget );
            }
            oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lCritter, TRUE, OBJECT_TYPE_CREATURE );
        }

        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        CreateObject( OBJECT_TYPE_CREATURE, "lab_skeldethbrng", lRandom );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        CreateObject( OBJECT_TYPE_CREATURE, "lab_magegrd_skel", lRandom );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        CreateObject( OBJECT_TYPE_CREATURE, "lab_magegrd_skel", lRandom );

        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
    }

    if( nHP <= 55 && n55 != 1 )
    {
        SetLocalInt( oCritter, "Split55", 1 );
        oNewBossPos = GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) );

        ClearAllActions();
        AssignCommand( oCritter, JumpToObject( oNewBossPos, 0 ) );
        SetCreatureAppearanceType( oCritter, 854 );
        FloatingTextStringOnCreature( sSplit, oCritter );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oCritter );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSanc, oCritter, 1.0 );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eInvis, oCritter, 60.0 );
        TLVFXPillar( VFX_COM_CHUNK_BONE_MEDIUM, GetLocation( oCritter ), 5, 0.1f, 0.0f, 1.0f );
        DelayCommand( 1.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePara, oCritter, 60.0 ) );
        DelayCommand( 1.5, SetPlotFlag( oCritter, TRUE ) );

        DelayCommand( 59.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis2, GetLocation( oNewBossPos ) ) );
        DelayCommand( 60.0, SetPlotFlag( oCritter, FALSE ) );
        DelayCommand( 61.0, AssignCommand( oCritter, SpeakString( sForm ) ) );

        object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lCritter, TRUE, OBJECT_TYPE_CREATURE );
        while( GetIsObjectValid( oTarget ) )
        {
            if( GetIsEnemy( oTarget, oCritter ) == TRUE )
            {
                int nDamage = GetReflexAdjustedDamage( d6(15), oTarget, 37, SAVING_THROW_TYPE_NONE, oCritter );
                effect ePierce = EffectDamage( nDamage, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL );
                effect eSlash = EffectDamage( nDamage, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_NORMAL );
                effect eLink = EffectLinkEffects( ePierce, eSlash );
                       eLink = EffectLinkEffects( eVis, eLink );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eLink, oTarget );
            }
            oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lCritter, TRUE, OBJECT_TYPE_CREATURE );
        }

        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        CreateObject( OBJECT_TYPE_CREATURE, "lab_magegrd_skel", lRandom );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        CreateObject( OBJECT_TYPE_CREATURE, "lab_magegrd_skel", lRandom );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        CreateObject( OBJECT_TYPE_CREATURE, "lab_skeldethbrng", lRandom );

        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
    }

    if( nHP <= 30 && n30 != 1 )
    {
        SetLocalInt( oCritter, "Split30", 1 );
        oNewBossPos = GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) );

        ClearAllActions();
        AssignCommand( oCritter, JumpToObject( oNewBossPos, 0 ) );
        SetCreatureAppearanceType( oCritter, 851 );
        FloatingTextStringOnCreature( sSplit, oCritter );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oCritter );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSanc, oCritter, 1.0 );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eInvis, oCritter, 60.0 );
        TLVFXPillar( VFX_COM_CHUNK_BONE_MEDIUM, GetLocation( oCritter ), 5, 0.1f, 0.0f, 1.0f );
        DelayCommand( 1.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePara, oCritter, 60.0 ) );
        DelayCommand( 1.5, SetPlotFlag( oCritter, TRUE ) );

        DelayCommand( 59.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis2, GetLocation( oNewBossPos ) ) );
        DelayCommand( 60.0, SetPlotFlag( oCritter, FALSE ) );
        DelayCommand( 61.0, AssignCommand( oCritter, SpeakString( sForm ) ) );

        object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lCritter, TRUE, OBJECT_TYPE_CREATURE );
        while( GetIsObjectValid( oTarget ) )
        {
            if( GetIsEnemy( oTarget, oCritter ) == TRUE )
            {
                int nDamage = GetReflexAdjustedDamage( d6(10), oTarget, 37, SAVING_THROW_TYPE_NONE, oCritter );
                effect ePierce = EffectDamage( nDamage, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL );
                effect eSlash = EffectDamage( nDamage, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_NORMAL );
                effect eLink = EffectLinkEffects( ePierce, eSlash );
                       eLink = EffectLinkEffects( eVis, eLink );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eLink, oTarget );
            }
            oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lCritter, TRUE, OBJECT_TYPE_CREATURE );
        }

        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        CreateObject( OBJECT_TYPE_CREATURE, "lab_magegrd_skel", lRandom );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        CreateObject( OBJECT_TYPE_CREATURE, "lab_magegrd_skel", lRandom );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        CreateObject( OBJECT_TYPE_CREATURE, "lab_skeldethbrng", lRandom );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        CreateObject( OBJECT_TYPE_CREATURE, "lab_skeldethbrng", lRandom );

        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
        lRandom = GetLocation( GetWaypointByTag( "splinter_"+IntToString( Random( 15 ) ) ) );
        oSplinter = CreateObject( OBJECT_TYPE_CREATURE, "lab_splinter", lRandom );
        SetLocalObject( oSplinter, "Boneyard", oNewBossPos );
    }
}
