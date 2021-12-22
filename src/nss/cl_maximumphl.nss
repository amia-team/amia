// OnClosed event of Maximus' Phylactory.  Spawns him if all six bones are
// inside the thing.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/25/2004 jpavelch         Initial Release.
//

#include "amia_include"

// Resets the state of this object concerning which items are contained
// within.
//
void InitSelf( )
{
    object oSelf = OBJECT_SELF;

    int i;
    for ( i=1; i<=6; ++i )
        SetLocalInt( oSelf, "AR_ReqItem_" + IntToString(i), FALSE );
}

// Creates the man of the hour.
//
void CreateMaximus( object oWaypoint )
{
    object oMaximus =   CreateObject(
                            OBJECT_TYPE_CREATURE,
                            "brog_maximus",
                            GetLocation(oWaypoint)
                        );
    AssignCommand( oMaximus, SetFacing(GetFacing(oWaypoint)) );
}

// Creates some cool visual effects then spawns the man of the hour.
//
void SpawnMaximus( )
{
    object oWaypoint = GetWaypointByTag( "wp_newmaxispawn" );
    location lWaypoint = GetLocation( oWaypoint );

    // Shake the earth and do the cool undead summon first.
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), lWaypoint, 3.0 );

    DelayCommand( 1.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD), lWaypoint ) );

    // Now create the man of the hour..
    DelayCommand( 2.0, CreateMaximus(oWaypoint) );
}

// Removes all items from the inventory of this object.
//
void DestroyAllInventory( )
{
    object oSelf = OBJECT_SELF;

    object oItem = GetFirstItemInInventory( oSelf );
    while ( GetIsObjectValid(oItem) ) {
        DestroyObject( oItem );
        oItem = GetNextItemInInventory( oSelf );
    }
}


void main( )
{
    object oSelf = OBJECT_SELF;

    InitSelf( );

    // Check each item in inventory off.
    string sTag;
    object oItem = GetFirstItemInInventory( oSelf );
    while ( GetIsObjectValid(oItem) ) {
        sTag = GetTag( oItem );
        if ( sTag == "Bones1" )      SetLocalInt( oSelf, "AR_ReqItem_1", TRUE );
        else if ( sTag == "Bones2" ) SetLocalInt( oSelf, "AR_ReqItem_2", TRUE );
        else if ( sTag == "Bones3" ) SetLocalInt( oSelf, "AR_ReqItem_3", TRUE );
        else if ( sTag == "Bones4" ) SetLocalInt( oSelf, "AR_ReqItem_4", TRUE );
        else if ( sTag == "Bones5" ) SetLocalInt( oSelf, "AR_ReqItem_5", TRUE );
        else if ( sTag == "Bones6" ) SetLocalInt( oSelf, "AR_ReqItem_6", TRUE );

        oItem = GetNextItemInInventory( oSelf );
    }

    int nSpawnMaximus = TRUE;

    // Now check the list to see if everything is present.
    int i, hasItem;
    for ( i=1; i<=6; ++i ) {
        hasItem = GetLocalInt( oSelf, "AR_ReqItem_" + IntToString(i) );
        if ( hasItem == FALSE ) {
            nSpawnMaximus = FALSE;
            break;
        }
    }

    if ( nSpawnMaximus == TRUE ) {

        object oPC = GetLastClosedBy();

        int nCount = GetLocalInt( oPC, "mxm" );

        SetLocalInt( oPC, "mxm", ( nCount + 1 ) );

        if ( nCount == 0 ){

            log_to_exploits( oPC, "Spawned Maximus", "cl_maximumphl", nCount );
            SpawnMaximus( );
            DestroyAllInventory( );
        }
        else{

            SendMessageToPC( oPC, "Despite the bones being consumed, nothing else appears to happen." );
            //log_to_exploits( oPC, "Maximus Pissed", "cl_maximumphl", nCount );
        }
    }
}
