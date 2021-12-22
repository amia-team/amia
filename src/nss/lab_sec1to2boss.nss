/* OnUse Event for Labyrinth: Massacre flames

1) If bosses are in play, do nothing.
2) If no bosses, spawn boss if PC hasn't already done so this reset.

Revision History
Date     Name             Description
-------- ---------------- ---------------------------------------------
04/19/12 Glim             Initial Release
02/22/14 Glim             Altered based on new dungeon parameters.

*/

#include "amia_include"

void SpawnHorrors( object oArea, object oPC, location lAcid, location lCold, location lElec, location lFire );

void main( )
{
    object oPC = GetLastUsedBy();
    object oArea = GetArea( oPC );
    object oFire = OBJECT_SELF;

    //First, check for bosses in play. If found, do nothing.
    if( GetIsObjectValid( GetFirstObjectInAreaByTag( oArea, "sec_acid_horror" ) ) ||
        GetIsObjectValid( GetFirstObjectInAreaByTag( oArea, "sec_cold_horror" ) ) ||
        GetIsObjectValid( GetFirstObjectInAreaByTag( oArea, "sec_elec_horror" ) ) ||
        GetIsObjectValid( GetFirstObjectInAreaByTag( oArea, "sec_fire_horror" ) ) )
    {
        SpeakString( "**the flame proves too unstable to interact with at present**" );
        return;
    }

    //Second, check to see if we should be spawning bosses (if not blocked and
    //if all four fires have been activated in the same manner.
    string sPLC = GetTag( oFire );
    int nSpawner = GetLocalInt( oPC, "HorrorSpawner" );
    int nActive = GetLocalInt( oFire, "Active" );

    //DM spawnblock
    int nSpawnDisabled = GetLocalInt( GetArea( oFire ), "no_spawn" );
    if( nSpawnDisabled )
    {
        return;
    }

    if( nSpawner == 1 )
    {
        SendMessageToPC( oPC, "[You have already spawned this boss during the current reset. Please come back after the server has reset.]" );
        return;
    }
    else if( nActive == 1 )
    {
        SendMessageToPC( oPC, "[You have already activated this. Activate the other flames to continue.]" );
        return;
    }
    else
    {
        object oAcidFlame = GetNearestObjectByTag( "sec_acidflame", oFire );
        object oColdFlame = GetNearestObjectByTag( "sec_coldflame", oFire );
        object oElecFlame = GetNearestObjectByTag( "sec_elecflame", oFire );
        object oFireFlame = GetNearestObjectByTag( "sec_fireflame", oFire );

        string sVFX;
        string sFire = GetTag( oFire );
        if( sFire == "sec_acidflame" )
        {
            sVFX = "flamegreen";
            oAcidFlame = oFire;
        }
        else if( sFire == "sec_coldflame" )
        {
            sVFX = "flamewhite";
            oColdFlame = oFire;
        }
        else if( sFire == "sec_elecflame" )
        {
            sVFX = "flameblue";
            oElecFlame = oFire;
        }
        else if( sFire == "sec_fireflame" )
        {
            sVFX = "flamered";
            oFireFlame = oFire;
        }
        object oVFX = GetNearestObjectByTag( sVFX, oFire );
        effect eVis = EffectVisualEffect( VFX_DUR_ELEMENTAL_SHIELD );

        ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eVis, GetLocation( oVFX ), 600.0 );

        SetLocalObject( oFire, "HorrorTarget", oPC );
        SetLocalInt( oFire, "Active", 1 );
        DelayCommand( 600.0, SetLocalInt( oFire, "Active", 0 ) );

        if( GetLocalInt( oAcidFlame, "Active" ) == 1 &&
            GetLocalInt( oColdFlame, "Active" ) == 1 &&
            GetLocalInt( oElecFlame, "Active" ) == 1 &&
            GetLocalInt( oFireFlame, "Active" ) == 1 )
        {
            effect eVis1 = EffectVisualEffect( VFX_FNF_TIME_STOP );
            effect eAcid = EffectVisualEffect( VFX_IMP_ACID_L );
            effect eCold = EffectVisualEffect( VFX_IMP_FROST_L );
            effect eElec = EffectVisualEffect( VFX_IMP_LIGHTNING_M  );
            effect eFire = EffectVisualEffect( VFX_IMP_FLAME_M );
            location lAcid = GetLocation( GetWaypointByTag( "vitriflame" ) );
            location lCold = GetLocation( GetWaypointByTag( "frostfire" ) );
            location lElec = GetLocation( GetWaypointByTag( "arcflame" ) );
            location lFire = GetLocation( GetWaypointByTag( "heartfire" ) );

            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis1, lAcid );
            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis1, lCold );
            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis1, lElec );
            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis1, lFire );
            DelayCommand( 1.3, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eAcid, lAcid ) );
            DelayCommand( 1.4, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eCold, lCold ) );
            DelayCommand( 1.6, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eElec, lElec ) );
            DelayCommand( 1.7, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eFire, lFire ) );

            DelayCommand( 1.5, SpawnHorrors( oArea, oPC, lAcid, lCold, lElec, lFire ) );

            //Lock them in
            object oDoor1 = GetNearestObjectByTag( "massacre_sec_to_bone", oPC );
            object oDoor2 = GetNearestObjectByTag( "massacre_bone_to_sec", oPC );
            SetLocked( oDoor1, TRUE );
            SetLocked( oDoor2, TRUE );
            DelayCommand( 600.0, SetLocked( oDoor1, FALSE ) );
            DelayCommand( 600.1, SetLocked( oDoor2, FALSE ) );
        }
    }
}

void SpawnHorrors( object oArea, object oPC, location lAcid, location lCold, location lElec, location lFire )
{
    object oSpawner = GetFirstObjectInArea( oArea );
    while( GetIsObjectValid( oSpawner ) )
    {
        if( GetObjectType( oSpawner ) == OBJECT_TYPE_CREATURE )
        {
            if( ds_check_partymember( oPC, oSpawner ) == TRUE || oSpawner == oPC )
            {
                SetLocalInt( oSpawner, "HorrorSpawner", 1 );
            }
        }
        oSpawner = GetNextObjectInArea( oArea );
    }

    object oAcid = CreateObject( OBJECT_TYPE_CREATURE, "sec_acid_horror", lAcid );
    object oCold = CreateObject( OBJECT_TYPE_CREATURE, "sec_cold_horror", lCold );
    object oElec = CreateObject( OBJECT_TYPE_CREATURE, "sec_elec_horror", lElec );
    object oFire = CreateObject( OBJECT_TYPE_CREATURE, "sec_fire_horror", lFire );

    object oFlameA = GetNearestObjectByTag( "sec_acidflame", oPC );
    object oFlameC = GetNearestObjectByTag( "sec_coldflame", oPC );
    object oFlameE = GetNearestObjectByTag( "sec_elecflame", oPC );
    object oFlameF = GetNearestObjectByTag( "sec_fireflame", oPC );

    object oAttackA = GetLocalObject( oFlameA, "HorrorTarget" );
    object oAttackC = GetLocalObject( oFlameC, "HorrorTarget" );
    object oAttackE = GetLocalObject( oFlameE, "HorrorTarget" );
    object oAttackF = GetLocalObject( oFlameF, "HorrorTarget" );

    DelayCommand( 0.5, AssignCommand( oAcid, SpeakString( "Protean breach. Commencing decontamination." ) ) );
    DelayCommand( 0.6, AssignCommand( oCold, SpeakString( "Protean breach. Commencing decontamination." ) ) );
    DelayCommand( 0.7, AssignCommand( oElec, SpeakString( "Protean breach. Commencing decontamination." ) ) );
    DelayCommand( 0.8, AssignCommand( oFire, SpeakString( "Protean breach. Commencing decontamination." ) ) );
    DelayCommand( 0.9, AssignCommand( oAcid, ClearAllActions() ) );
    DelayCommand( 1.0, AssignCommand( oAcid, ActionAttack( oAttackA ) ) );
    DelayCommand( 1.1, AssignCommand( oCold, ClearAllActions() ) );
    DelayCommand( 1.2, AssignCommand( oCold, ActionAttack( oAttackC ) ) );
    DelayCommand( 1.3, AssignCommand( oElec, ClearAllActions() ) );
    DelayCommand( 1.4, AssignCommand( oElec, ActionAttack( oAttackE ) ) );
    DelayCommand( 1.5, AssignCommand( oFire, ClearAllActions() ) );
    DelayCommand( 1.6, AssignCommand( oFire, ActionAttack( oAttackF ) ) );
}
