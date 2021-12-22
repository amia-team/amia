//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  udb_corridor_act
//group:   travel
//used as: action script for convo
//date:    jan 17 2009
//author:  disco


//-------------------------------------------------------------------------------
// changelog
//-------------------------------------------------------------------------------
// 2011-12-02   Selmak      Transition checks party members to see if they're
//                          actually in the same area as the transition.

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_spawns"



//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void JumpPartyMembers( object oPC, object oDoor, object oTarget, int nDistance ){

    string sMessage;
    int nDuration;

    if ( nDistance < 0 ){

        nDuration = 25 + abs( nDistance ) + d20();
        sMessage  = "<c  þ>Your travels bring you "+IntToString( abs( nDistance ) )+" meters deeper in the UD.\\nThe journey takes "+IntToString( nDuration )+" minutes.";
    }
    else if ( nDistance > 0 ){

        nDuration = 25 + nDistance + d20();
        sMessage  = "<c  þ>Your travels bring you "+IntToString( nDistance)+" meters higher in the UD.\\nThe journey takes "+IntToString( nDuration )+" minutes.";
    }
    else{


        nDuration = 25 +  d20();
        sMessage  = "<c  þ>Your travels keep you at the same depth in the UD.\nThe journey takes "+IntToString( nDuration )+" minutes.";

    }

    object oTransArea = GetArea( oPC );

    object oPartyMember = GetFirstFactionMember( oPC, FALSE );
    float fDistance;

    while ( GetIsObjectValid( oPartyMember ) ){

        if ( GetArea( oPartyMember ) == oTransArea ){

            fDistance = GetDistanceBetween( oDoor, oPartyMember );

            if ( fDistance < 5.0 && fDistance > 0.0 ){

                AssignCommand( oPartyMember, ClearAllActions() );
                AssignCommand( oPartyMember, JumpToObject( oTarget ) );
                SendMessageToPC( oPartyMember, sMessage );

            }

        }

        oPartyMember = GetNextFactionMember( oPC, FALSE );
    }
}

int Ambushed( object oPC, object oDoor, int nNode, int nTarget=0 ){

    if ( GetLocalInt( oDoor, "ambush" ) == -1 ){

        return FALSE;
    }

    int nRoll = d100();

    if ( nNode == 40 ){

        if ( nRoll > 20 ){

            return FALSE;
        }

        nNode = nTarget;
    }
    else if ( nRoll > 5 ){

        return FALSE;
    }

    string sWP;
    string sCritter1;
    string sCritter2;

    switch ( nNode ) {

        case 00:     return FALSE; break;
        case 01:     return FALSE; break;
        case 02:     sWP = "_2";  sCritter1 = "udb_smurfguard"; sCritter2 = "udb_smurflabour";    break;
        case 03:     sWP = "_2";  sCritter1 = "ff_troll_1"; sCritter2 = "ff_troll_2";    break;
        case 04:     sWP = "_2";  sCritter1 = "ff_ogrefodda"; sCritter2 = " ff_ogrefighta";    break;
        case 05:     sWP = "_1";  sCritter1 = "udb_phaerlock_1"; sCritter2 = "udb_phaerlock_2";    break;
        case 06:     sWP = "_1";  sCritter1 = "rua_bat_1"; sCritter2 = "rua_bat_2";    break;
        case 07:     sWP = "_1";  sCritter1 = "rua_bat_1"; sCritter2 = "rua_bat_2";    break;
        case 08:     return FALSE; break;
        case 09:     sWP = "_2";  sCritter1 = " rua_zombie_1"; sCritter2 = "rua_skeleton_1";    break;
        case 10:     return FALSE; break;
        case 11:     return FALSE; break;
        case 12:     sWP = "_2";  sCritter1 = "udb_gloura_1"; sCritter2 = "udb_gloura_4";    break;
        case 13:     sWP = "_2";  sCritter1 = "udb_duergartank"; sCritter2 = "udb_duergarcann";    break;
        case 14:     sWP = "_2";  sCritter1 = "ff_ogrefodda"; sCritter2 = " ff_ogrefighta";    break;
        case 15:     sWP = "_2";  sCritter1 = "udb_duergartank"; sCritter2 = "udb_duergarcann";    break;
        case 16:     sWP = "_2";  sCritter1 = "ff_ogrefodda"; sCritter2 = " ff_ogrefighta";    break;
        case 17:     sWP = "_2";  sCritter1 = "ud_ds_rebel_2"; sCritter2 = "ud_ds_rebel_4";    break;
        case 18:     return FALSE; break;
        case 19:     return FALSE; break;
        case 20:     return FALSE; break;
        case 21:     sWP = "_2";  sCritter1 = "rua_bat_1"; sCritter2 = "rua_bat_2";    break;
        case 22:     return FALSE; break;
        case 23:     sWP = "_3";  sCritter1 = " uce_mindf_normal"; sCritter2 = "uce_inteldev";    break;
        case 24:     sWP = "_2";  sCritter1 = "rua_bat_1"; sCritter2 = "rua_bat_1";    break;
        case 25:     sWP = "_3";  sCritter1 = "udb_kuotoa_1"; sCritter2 = "udb_kuotoa_2";    break;
        case 26:     sWP = "_3";  sCritter1 = "udb_baphi_1"; sCritter2 = "udb_baphi_2";    break;
        case 27:     sWP = "_3";  sCritter1 = "udb_bug_2"; sCritter2 = "udb_bug_3";    break;
        case 28:     sWP = "_3";  sCritter1 = "udb_golem_1"; sCritter2 = "udb_golem_2";    break;
        case 29:     sWP = "_3";  sCritter1 = "udb_elemental_1"; sCritter2 = "udb_elemental_2";    break;
        case 30:     sWP = "_3";  sCritter1 = "brog_ork_1"; sCritter2 = "brog_ork_4";    break;
        default:    return FALSE;    break;
    }

    sWP = "udb_ambush"+sWP;

    object oTarget      = GetWaypointByTag( sWP );
    object oPartyMember = GetFirstFactionMember( oPC, FALSE );
    string sMessage     = "You have been ambushed!";
    int nMembers;

    while ( GetIsObjectValid( oPartyMember ) ){

        if ( GetDistanceBetween( oDoor, oPartyMember ) < 10.0 ){

            AssignCommand( oPartyMember, ClearAllActions() );
            AssignCommand( oPartyMember, JumpToObject( oTarget ) );
            SendMessageToPC( oPartyMember, sMessage );
        }

        oPartyMember = GetNextFactionMember( oPC, FALSE );

        ++nMembers;
    }

    sWP                   = sWP+"a";
    object oArea          = GetArea( oTarget );
    location lTarget      = GetLocation( GetWaypointByTag( sWP ) );
    location lSpawnpoint;
    float fSpread;
    int i;
    int nSpawnCount       = 1 + d3() + nMembers;

    for( i=0; i<nSpawnCount; i++ ){

        fSpread = ( IntToFloat( d6( ) ) / 4.0 ) + 0.5;

        lSpawnpoint    = en_HexRadiate( oArea, lTarget, i, fSpread );

        if( d2() == 1 ){

            ds_spawn_critter( oPC, sCritter1, lSpawnpoint );
        }
        else{

            ds_spawn_critter( oPC, sCritter2, lSpawnpoint );
        }
    }

    return TRUE;
}


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC       = OBJECT_SELF;
    object oDoor     = GetLocalObject( oPC, "ds_target" );
    int nNode        = GetLocalInt( oPC, "ds_node" );
    string sWP;
    int nTarget;

    if ( nNode > 0 && nNode < 40 ){

        sWP = "ut_"+IntToString( nNode );
    }
    else if ( nNode == 40 ){

        int nRandom = 1 + Random( GetLocalInt( oDoor, "count" ) );
        nTarget = GetLocalInt( oDoor, "target_"+IntToString( nRandom ) );

        sWP = "ut_"+IntToString( nTarget );
    }
    else {

        return;
    }

    if ( Ambushed( oPC, oDoor, nNode, nTarget ) ){

        return;
    }

    if ( sWP != "" ){

        object oTarget = GetWaypointByTag( sWP );

        //distance calculation
        int nCurrentDepth = GetLocalInt( GetArea( oPC ), "depth" );
        int nTargetDepth  = GetLocalInt( GetArea( oTarget ), "depth" );
        int nDistance     = nCurrentDepth - nTargetDepth;

        JumpPartyMembers( oPC, oDoor, oTarget, nDistance );
    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------


