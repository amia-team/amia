//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_trap_dialog
//description: Trap / Trap-setting routines
//used as: action script
//date:    march 10 2008
//author:  Terra/Disco
//-------------------------------------------------------------------------------
// Changelog
//-------------------------------------------------------------------------------
// 2011-07-08   Selmak      Added options to upgrade traps.
// 2011-11-07   Selmak      Recompile: Fixed upgrade component and trap duping.

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_traps"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC = OBJECT_SELF;
    int nNode  = GetLocalInt( oPC, "ds_node" );

    switch ( nNode ) {

        case 0:     break;
        case 1:     DeleteLocalInt( oPC, TRAP_HIT_MODE );   break;
        case 2:     SetLocalInt( oPC, TRAP_HIT_MODE, 1 );   break;
        case 3:     break;
        case 6:     FindMyTraps( oPC, 1.0, FALSE );         break;
        case 7:     FindMyTraps( oPC, 5.0, FALSE );         break;
        case 8:     FindMyTraps( oPC, 10.0, FALSE );        break;
        case 9:     FindMyTraps( oPC, 1.0, TRUE );          break;
        case 10:    FindMyTraps( oPC, 5.0, TRUE );          break;
        case 11:    FindMyTraps( oPC, 10.0, TRUE );         break;
        case 12:    UpgradeMyTraps( oPC, 1.0 );             break;
        case 13:    UpgradeMyTraps( oPC, 5.0 );             break;
        case 14:    UpgradeMyTraps( oPC, 10.0 );            break;
        default:    break;
    }
}

