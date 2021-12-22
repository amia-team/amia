//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  td_bling
//group:   blingbling
//used as: action
//date:    -
//author:  Terrah

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void SpawnPLC( location lTarget, object oItem, int nColor );
int GetPLCsSpawned( object oItem );
void DestroyAll( object oItem );
void DestroyNearest( object oItem, location lTarget );
void AllowedMoreSpawn( object oPC, object oItem );

void main(){

    object      oPC     = OBJECT_SELF;
    object      oItem   = GetLocalObject( oPC, "ds_target" );
    location    lTarget = GetLocalLocation( oPC, "ds_target" );

    int nNode       = GetLocalInt( oPC, "ds_node" );
    int nSection    = GetLocalInt( oPC, "ds_section" );

    if( nSection <= 0 ){

        switch( nNode ){

            case 1:
                SetLocalString( oItem, "resref", "td_mf1_" );
                SetLocalInt( oPC, "ds_section", 1 );
            break;
            case 2:
                SetLocalString( oItem, "resref", "td_mf2_" );
                SetLocalInt( oPC, "ds_section", 1 );
            break;
            case 3:
                SetLocalString( oItem, "resref", "td_smk1_" );
                SetLocalInt( oPC, "ds_section", 1 );
            break;
            case 4:
                SetLocalString( oItem, "resref", "td_smk2_" );
                SetLocalInt( oPC, "ds_section", 1 );
            break;
            //Other things
            case 5:
                SetLocalInt( oPC, "ds_section", 2 );
            break;
            //Delete
            case 6:
                SetLocalInt( oPC, "ds_section", 3 );
            break;
        }
    }
    else if( nSection == 1 ){

        if( nNode > 6 )
            return;
        else
            SpawnPLC( lTarget, oItem, nNode );

        AllowedMoreSpawn( oPC, oItem );
    }
    //other
    else if( nSection == 2 ){

        string sRef = "";
        string sTag = "bling_"+ObjectToString( oItem );
        switch( nNode ){

            case 1:
            case 2:
            case 3:
                sRef = "plc_flrdesigns"+IntToString( nNode );
                break;
            case 4:
                sRef = "x2_plc_scircle";
                break;
            case 5:
                sRef = "nw_plc_piratex";
                break;
            case 6:
                sRef = "x0_runecircle";
                break;
            default:return;
        }

        CreateObject( OBJECT_TYPE_PLACEABLE, sRef, lTarget, FALSE, sTag );

        AllowedMoreSpawn( oPC, oItem );
    }
    //delete
    else if( nSection == 3 ){

        switch( nNode ){

            case 1: DestroyNearest( oItem, lTarget ); return;
            case 2: DestroyAll( oItem ); return;
            default:return;
        }

        AllowedMoreSpawn( oPC, oItem );
    }
}

void AllowedMoreSpawn( object oPC, object oItem ){

    int nPlcs = GetPLCsSpawned( oItem );
    SetLocalInt( oPC, "ds_check_1", nPlcs < 10 );
    SetLocalInt( oPC, "ds_section", 0 );
    SendMessageToPC( oPC, "You got " + IntToString( nPlcs ) + " PLCs spawned!");
}

void DestroyNearest( object oItem, location lTarget ){

    string sTag = "bling_"+ObjectToString( oItem );

    int nNth = 0;
    object oPLC = GetNearestObjectToLocation( OBJECT_TYPE_PLACEABLE, lTarget, ++nNth );
    object oFound = OBJECT_INVALID;
    while( GetIsObjectValid( oPLC ) ){

        if( GetTag( oPLC ) == sTag ){

            oFound = oPLC;
            break;
        }

        oPLC = GetNearestObjectToLocation( OBJECT_TYPE_PLACEABLE, lTarget, ++nNth );
    }

    if( oFound == OBJECT_INVALID )
        return;

    DestroyObject( oFound );
}

void DestroyAll( object oItem ){

    string sTag = "bling_"+ObjectToString( oItem );
    int n=0;
    object oPLC = GetObjectByTag( sTag, n );

    while( GetIsObjectValid( oPLC ) ){

        DestroyObject( oPLC, 0.5 );

        oPLC = GetObjectByTag( sTag, ++n );
    }
}

int GetPLCsSpawned( object oItem ){

    string sTag = "bling_"+ObjectToString( oItem );
    int n=0;
    object oPLC = GetObjectByTag( sTag, n );
    int nCount = 0;
    while( GetIsObjectValid( oPLC ) ){

        nCount++;

        oPLC = GetObjectByTag( sTag, ++n );
    }

    return nCount;
}

void SpawnPLC( location lTarget, object oItem, int nColor ){

    string sRef = GetLocalString( oItem, "resref" );
    string sTag = "bling_"+ObjectToString( oItem );

    switch( nColor ){

        case 1: sRef+="blue"; break;
        case 2: sRef+="green"; break;
        case 3: sRef+="purple"; break;
        case 4: sRef+="red"; break;
        case 5: sRef+="white"; break;
        case 6: sRef+="yellow"; break;
        default: return;
    }

    CreateObject( OBJECT_TYPE_PLACEABLE, sRef, lTarget, FALSE, sTag );
}
