//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_td_mkplc
//description: Item onuse impact script for the DM PLC wand
//date:    nov 24 2008
//author:  Terra

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_ds_actions"

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void main(){

    string      sColorTag   = "<c è >";
    string      sEnd        = "</c";

    object      oPC         = GetItemActivator( );
    object      oTarget     = GetItemActivatedTarget( );

    location    lTarget     = GetItemActivatedTargetLocation( );

    object      oNear       = GetNearestObjectToLocation( OBJECT_TYPE_PLACEABLE, lTarget );

    int         iDur        = GetLocalInt( oPC, "mk_plc_dur" );
    int         iSpawnDelay = GetLocalInt( oPC, "mk_plc_del" );
    int         nSpawnNode  = GetLocalInt( oPC, "mk_plc_node" );
    int         nPlot       = GetLocalInt( oPC, "mk_plc_plot" );


    if( iDur <= 0 )
        iDur = 360;

    if( iSpawnDelay < 0 )
        iSpawnDelay = 0;

    SetLocalObject( oPC , "mk_plc_target", oTarget );
    SetLocalObject( oPC , "mk_plc_nearest", oNear );

    SetLocalLocation( oPC , "mk_plc_loc", lTarget );

    SetCustomToken( 20000, sColorTag+GetName( oTarget )+sEnd );
    SetCustomToken( 20001, sColorTag+GetName( oNear )+sEnd );

    SetCustomToken( 20020, sColorTag+IntToString( iSpawnDelay )+" seconds"+sEnd );

    switch( nSpawnNode ){

        case 1:
            SetCustomToken( 20021, sColorTag+"Nearest object"+sEnd );
            break;

        case 2:
            SetCustomToken( 20021, sColorTag+"Targeted object"+sEnd );
            break;

        case 3:
            SetCustomToken( 20021, sColorTag+"Self"+sEnd );
            break;

        default:
            SetCustomToken( 20021, sColorTag+"Targeted location"+sEnd );
            break;
    }

    if( iDur <= 0 )
        SetCustomToken( 20002, sColorTag+"PERMANENT"+sEnd );
    else
        SetCustomToken( 20002, sColorTag+IntToString( iDur )+" seconds"+sEnd );

    if( nPlot <= 0 )
        SetCustomToken( 20003, sColorTag+"FALSE"+sEnd );
    else
        SetCustomToken( 20003, sColorTag+"TRUE"+sEnd );

    clean_vars( oPC, 4, "td_mkplc" );

    DeleteLocalInt( oPC, "td_node" );
    SetLocalInt( oPC, "mk_save_get", 0 );
    SetLocalInt( oPC, "mk_nth", 1 );
    SetLocalInt( oPC, "td_listener_action", 0 );
    SetLocalInt( oPC, "td_spawn_subtree", 0 );

    AssignCommand( oPC ,ActionStartConversation( oPC, "td_plc_wand", TRUE, FALSE ) );
}
