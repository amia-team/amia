//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  td_mkplc
//description: Conversation action script
//date:    nov 24 2008
//author:  Terra

//-----------------------------------------------------------------------------
// changelog
//-----------------------------------------------------------------------------
// 18 June 2011 - Selmak added support for cloned job system alchemy lab in
//                main function

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_ds_actions"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------

void Spawn_Save( int nSaveGet, int nSlot, int nDur, int nPlot, object oPC, location lLoc, object ToStore );
void UpDateSaveSlots( object oMod, object oPC );
void SpawnPredefinedPLC( string sResRef, location lSpawnLoc, int nDur, int nPlot, string sAccountName );
string GetPreDefinedResRefFromNode( int nSubTreeNode, int ds_node );
void DeleteAllSpawnedInMod( string sAccoutName );
void DeleteAllSpawnedInArea( string sAccoutName, object oArea );

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void main(){

    string          sColorTag   = "<c è >";
    string          sEnd        = "</c";

    object          oPC         = OBJECT_SELF;
    object          oNearest    = GetLocalObject( oPC, "mk_plc_nearest" );
    object          oTarget     = GetLocalObject( oPC, "mk_plc_target" );
    object          oModule     = GetModule( );

    location        lTarget     = GetLocalLocation( oPC, "mk_plc_loc" );

    int             nNode       = GetLocalInt( oPC, "ds_node" );
    int             nSubNode    = GetLocalInt( oPC, "td_node" );
    int             nDur        = GetLocalInt( oPC, "mk_plc_dur" );
    int             nPlot       = GetLocalInt( oPC, "mk_plc_plot" );
    int             iSpawnDelay = GetLocalInt( oPC, "mk_plc_del" );
    int             nSpawnNode  = GetLocalInt( oPC, "mk_plc_node" );

    //SendMessageToPC( oPC,"td_node: "+IntToString( nSubNode ) );
    //SendMessageToPC( oPC,"ds_node: "+IntToString( nNode )  );

    switch( nSpawnNode ){

        case 1:
            lTarget = GetLocation( oNearest );
            break;

        case 2:
            lTarget = GetLocation( oTarget );
            break;

        case 3:
            lTarget = GetLocation( oPC );
            break;

        default:
            break;
    }

    if( nSubNode != 1 ){

    DeleteLocalInt( oPC, "td_spawn_subtree" );

        switch( nNode ){

        //Start listener
        case 1:

            SetLocalInt( oPC, "td_styler_listener", TRUE );
            SetLocalInt( oPC, "td_listener_action", 1 );
            FloatingTextStringOnCreature( "Speak your new time to the shoutchannel now.", oPC, FALSE );
            ActionPauseConversation();
            break;

        //Toggle plot
        case 2:

            if( nPlot <= 0 ){

                SetCustomToken( 20003, sColorTag+"TRUE</c" );
                SetLocalInt( oPC, "mk_plc_plot", 1 );
            }

            else{

                SetCustomToken( 20003, sColorTag+"FALSE</c" );
                SetLocalInt( oPC, "mk_plc_plot", 0 );
            }

            break;

        // Save nearest for cloaning
        case 3:

            // Update the data
            ActionPauseConversation();

            UpDateSaveSlots( oModule, oPC );

            SetLocalInt( oPC, "mk_save_get", 1 );
            SetLocalObject( oPC, "mk_plc_target", oNearest );

            //Set secondary tree
            SetLocalInt( oPC, "td_node", 1 );

            ActionResumeConversation();

            break;
       // Save target for cloaning
        case 4:

            // Update the data
            ActionPauseConversation();

            UpDateSaveSlots( oModule, oPC );

            SetLocalInt( oPC, "mk_save_get", 1 );

            ActionResumeConversation();

            //Set secondary tree
            SetLocalInt( oPC, "td_node", 1 );

            break;

        //Spawn from slot
        case 5:
            ActionPauseConversation();

            UpDateSaveSlots( oModule, oPC );

            SetLocalInt( oPC, "mk_save_get", 0 );

            //Set secondary tree
            SetLocalInt( oPC, "td_node", 1 );

            ActionResumeConversation();
            break;
        //Destroy Target
        case 6:
            DestroyObject( oTarget );
            SetCustomToken( 20000, "" );
            DeleteLocalObject( oPC, "mk_plc_target" );
            break;

        //Destroy Nearest
        case 7:
            DestroyObject( oNearest );
            oNearest = GetNearestObjectToLocation( OBJECT_TYPE_PLACEABLE, lTarget );
            SetCustomToken( 20001, sColorTag+GetName( oNearest )+sEnd );
            SetLocalObject( oPC, "mk_plc_nearest", oNearest );
            break;
        //Get next close item
        case 8:
            oNearest = GetNearestObjectToLocation( OBJECT_TYPE_PLACEABLE, lTarget, GetLocalInt( oPC, "mk_nth" ) );
            SetCustomToken( 20001, sColorTag+GetName( oNearest )+" nth: "+IntToString(GetLocalInt( oPC, "mk_nth" ))+"."+sEnd );
            SetLocalObject( oPC, "mk_plc_nearest", oNearest );
            SetLocalInt( oPC, "mk_nth", GetLocalInt( oPC, "mk_nth" )+1 );
            break;
        // Update data
        case 10:

            if( nPlot <= 0 )
            SetCustomToken( 20003, sColorTag+"FALSE"+sEnd );
            else
            SetCustomToken( 20003, sColorTag+"TRUE"+sEnd );

            nDur = StringToInt( GetLocalString( oPC, "td_color_chat") );

            if( GetLocalInt( oPC, "td_listener_action" ) == 1 ){

                if( nDur <= 0 )
                    SetCustomToken( 20002, sColorTag+"PERMANENT"+sEnd );
                 else
                    SetCustomToken( 20002, sColorTag+IntToString( nDur )+" seconds"+sEnd );

                SetLocalInt( oPC, "mk_plc_dur", nDur );
            }
            else{

                SetCustomToken( 20020, sColorTag+IntToString( nDur )+" seconds"+sEnd );
                SetLocalInt( oPC, "mk_plc_del", nDur );
            }

            DeleteLocalInt( oPC, "td_node" );

            break;
        //Change spawn node
        case 11:

            SetLocalInt( oPC, "td_node", 1 );
            break;


        //Start listener
        case 12:

            SetLocalInt( oPC, "td_styler_listener", TRUE );
            SetLocalInt( oPC, "td_listener_action", 2 );
            FloatingTextStringOnCreature( "Speak your new time to the shoutchannel now.", oPC, FALSE );
            ActionPauseConversation();
            break;

        //Summoning circle
        case 13:
            DelayCommand( IntToFloat( iSpawnDelay ), SpawnPredefinedPLC( "x2_plc_scircle", lTarget, nDur, nPlot, GetPCPlayerName( oPC ) ) );
            break;

        //Evil smoke
        case 14:
            DelayCommand( IntToFloat( iSpawnDelay ), SpawnPredefinedPLC( "x3_plc_smokemag", lTarget, nDur, nPlot, GetPCPlayerName( oPC ) ) );
            break;

        //Water shaft
        case 15:
            DelayCommand( IntToFloat( iSpawnDelay ), SpawnPredefinedPLC( "x3_plc_swater", lTarget, nDur, nPlot, GetPCPlayerName( oPC ) ) );
            break;

        //Mist
        case 16:
            DelayCommand( IntToFloat( iSpawnDelay ), SpawnPredefinedPLC( "x3_plc_mist", lTarget, nDur, nPlot, GetPCPlayerName( oPC ) ) );
            break;

        //Dust plume
        case 17:
            DelayCommand( IntToFloat( iSpawnDelay ), SpawnPredefinedPLC( "plc_dustplume", lTarget, nDur, nPlot, GetPCPlayerName( oPC ) ) );
            break;

        //Lightshaft color
        case 18:
            SetLocalInt( oPC, "td_node", 1 );
            SetLocalInt( oPC, "td_spawn_subtree", 1 );
            break;

        //Portal Variant
        case 19:
            SetLocalInt( oPC, "td_node", 1 );
            SetLocalInt( oPC, "td_spawn_subtree", 2 );
            break;

        //Magic sparks color
        case 20:
            SetLocalInt( oPC, "td_node", 1 );
            SetLocalInt( oPC, "td_spawn_subtree", 3 );
            break;

        //Thin lightshaft variant
        case 21:
            SetLocalInt( oPC, "td_node", 1 );
            SetLocalInt( oPC, "td_spawn_subtree", 4 );
            break;

        //Non glowing flames size
        case 22:
            SetLocalInt( oPC, "td_node", 1 );
            SetLocalInt( oPC, "td_spawn_subtree", 5 );
            break;

        //Glowing flames size
        case 23:
            SetLocalInt( oPC, "td_node", 1 );
            SetLocalInt( oPC, "td_spawn_subtree", 6 );
            break;

        //Bubbles size
        case 24:
            SetLocalInt( oPC, "td_node", 1 );
            SetLocalInt( oPC, "td_spawn_subtree", 7 );
            break;

        //Nuke'em'all
        case 25:
            DeleteAllSpawnedInMod( GetPCPlayerName( oPC ) );
            break;

        //Area wide destruction
        case 26:
            DeleteAllSpawnedInArea( GetPCPlayerName( oPC ), oPC );
            break;

            default:return;
        }

    return;
    }
    //Secondary tree
    else{

    SetLocalInt( oPC, "td_node", 0 );

    switch( nNode ){
        //Spawn predefined
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
        case 13:
        case 14:
        case 15:
        case 16:
        case 17:
        case 18:
        case 19:
        case 20:
        //SendMessageToPC( oPC,"ResRef: "+GetPreDefinedResRefFromNode( GetLocalInt( oPC, "td_spawn_subtree" ), nNode ) );
        //SendMessageToPC( oPC,"sub_tree_node: "+IntToString( GetLocalInt( oPC, "td_spawn_subtree" ) )  );
        DelayCommand( IntToFloat( iSpawnDelay ), SpawnPredefinedPLC( GetPreDefinedResRefFromNode( GetLocalInt( oPC, "td_spawn_subtree" ), nNode ), lTarget, nDur, nPlot, GetPCPlayerName( oPC ) ) );
        break;
        //Spawn nodes
        case 27:
            SetLocalInt( oPC, "mk_plc_node", 3 );
            SetCustomToken( 20021, sColorTag+"Self"+sEnd );

            break;

        case 28:
            SetLocalInt( oPC, "mk_plc_node", 2 );
            SetCustomToken( 20021, sColorTag+"Targeted object"+sEnd );

            break;

        case 29:
            SetLocalInt( oPC, "mk_plc_node", 1 );
            SetCustomToken( 20021, sColorTag+"Nearest object"+sEnd );

            break;

        case 30:
            SetLocalInt( oPC, "mk_plc_node", 0 );
            SetCustomToken( 20021, sColorTag+"Targeted location"+sEnd );

            break;

        //Saveslots;
        case 31:
        case 32:
        case 33:
        case 34:
        case 35:
        case 36:
        case 37:
        case 38:
        case 39:
        case 40:
            DelayCommand( IntToFloat( iSpawnDelay ), Spawn_Save( GetLocalInt( oPC, "mk_save_get"), nNode - 30, nDur, nPlot, oPC, lTarget, oTarget ) );
            //DeleteLocalInt( oPC, "mk_save_get" );
            break;
        }
    }


}

//-----------------------------------------------------------------------------
// functions
//-----------------------------------------------------------------------------
void DeleteAllSpawnedInMod( string sAccoutName ){

    int     nLoop   = 0;
    object  oPLC    = GetObjectByTag( sAccoutName+"_PLC", nLoop );

    while( GetIsObjectValid( oPLC ) ){

        DestroyObject( oPLC );
        oPLC = GetObjectByTag( sAccoutName+"_PLC", nLoop++ );
    }
}
//-----------------------------------------------------------------------------
void DeleteAllSpawnedInArea( string sAccoutName, object oPC ){

    int     nLoop   = 1;
    object  oPLC    = GetNearestObjectByTag( sAccoutName+"_PLC", oPC, nLoop );

    while( GetIsObjectValid( oPLC ) ){

        DestroyObject( oPLC );
        oPLC = GetNearestObjectByTag( sAccoutName+"_PLC", oPC, nLoop++ );
    }

}
//-----------------------------------------------------------------------------
void Spawn_Save( int nSaveGet, int nSlot, int nDur, int nPlot, object oPC, location lLoc, object ToStore ){

object oModule = GetModule( );

    if( nSaveGet == 0 ){
        //SendMessageToPC( oPC, "Debug: trying to spawn your placeable..." );
        string sResRef   = GetLocalString( oModule, GetPCPlayerName( oPC )+"mk_slot_"+IntToString( nSlot ) );

        object oPLC      = CreateObject( OBJECT_TYPE_PLACEABLE, sResRef, lLoc, FALSE, GetPCPlayerName( oPC )+"_PLC" );

        if ( GetStringLeft( sResRef, 5 ) == "ds_j_" ){
            string sCloneTag;
            if ( sResRef == "ds_j_alchemy" ) sCloneTag = "ds_j_alchemist";


            SetLocalString( oPLC, "clone_tag", sCloneTag );


        }

        if( nDur > 0 )
            DestroyObject( oPLC, IntToFloat( nDur ) );

        DelayCommand( 1.0 ,SetPlotFlag( oPLC, nPlot ) );

        return;
    }

    else{

    if( !GetIsObjectValid( ToStore ) ){

        SendMessageToPC( oPC, "<cè  >The PLC you're trying to save doesnt exist!" );
        return;
    }

    SetLocalString( oModule, GetPCPlayerName( oPC )+"mk_slot_"+IntToString( nSlot ), GetResRef( ToStore ) );
    SetLocalString( oModule, GetPCPlayerName( oPC )+"mk_s_slot_"+IntToString( nSlot ), GetName( ToStore ) );
    SendMessageToPC( oPC, "<c è >Stored <"+GetName( ToStore )+"> in slot: "+IntToString( nSlot ));

    return;
    }

}
//-----------------------------------------------------------------------------
void UpDateSaveSlots( object oMod, object oPC ){

            string sColorTag   = "<c è >";
            string sEnd        = "</c";

            SetCustomToken(20005, sColorTag+GetLocalString( oMod, GetPCPlayerName( oPC )+"mk_s_slot_1" )+sEnd );
            SetCustomToken(20006, sColorTag+GetLocalString( oMod, GetPCPlayerName( oPC )+"mk_s_slot_2" )+sEnd );
            SetCustomToken(20007, sColorTag+GetLocalString( oMod, GetPCPlayerName( oPC )+"mk_s_slot_3" )+sEnd );
            SetCustomToken(20008, sColorTag+GetLocalString( oMod, GetPCPlayerName( oPC )+"mk_s_slot_4" )+sEnd );
            SetCustomToken(20009, sColorTag+GetLocalString( oMod, GetPCPlayerName( oPC )+"mk_s_slot_5" )+sEnd );
            SetCustomToken(20010, sColorTag+GetLocalString( oMod, GetPCPlayerName( oPC )+"mk_s_slot_6" )+sEnd );
            SetCustomToken(20011, sColorTag+GetLocalString( oMod, GetPCPlayerName( oPC )+"mk_s_slot_7" )+sEnd );
            SetCustomToken(20012, sColorTag+GetLocalString( oMod, GetPCPlayerName( oPC )+"mk_s_slot_8" )+sEnd );
            SetCustomToken(20013, sColorTag+GetLocalString( oMod, GetPCPlayerName( oPC )+"mk_s_slot_9" )+sEnd );
            SetCustomToken(20014, sColorTag+GetLocalString( oMod, GetPCPlayerName( oPC )+"mk_s_slot_10" )+sEnd );

}
//-----------------------------------------------------------------------------
void SpawnPredefinedPLC( string sResRef, location lSpawnLoc, int nDur, int nPlot, string sAccountName ){

        object oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, sResRef, lSpawnLoc, FALSE, sAccountName+"_PLC" );

        if( nDur > 0 )
            DestroyObject( oPLC, IntToFloat( nDur ) );

        DelayCommand( 0.5 ,SetPlotFlag( oPLC, nPlot ) );

}
//-----------------------------------------------------------------------------
string GetPreDefinedResRefFromNode( int nSubTreeNode, int ds_node ){

    string sReturn = "";

    switch( nSubTreeNode ){

    //Lightshaft - color
    case 1: sReturn = "plc_sol";break;
    //Portal
    case 2: sReturn = "";break;
    //Magic sparks
    case 3: sReturn = "plc_magic";break;
    //magicshaft
    case 4: sReturn = "x3_plc_slight";break;
    //non glowy flames
    case 5: sReturn = "x3_plc_flame";break;'
    //glowy flames
    case 6: sReturn = "plc_flame";break;
    //bubbles
    case 7: sReturn = "nw_plc_bubbles";break;
    default: return "";
    }

    switch( ds_node ){

    //size small
    case 1:
        //Bubbles
        if( nSubTreeNode == 7 )
            sReturn += "sm";
        else if( nSubTreeNode == 5 )
            sReturn += "003";
        else
            sReturn += "small";
    break;

    //size medium
    case 2:
        //Bubbles
        if( nSubTreeNode == 7 )
            sReturn += "md";
        else if( nSubTreeNode == 5 )
            sReturn += "002";
        else
            sReturn += "medium";
    break;

    //size large
    case 3:
        //Bubbles
        if( nSubTreeNode == 7 )
            sReturn += "lg";
        else if( nSubTreeNode == 5 )
            sReturn += "001";
        else
            sReturn += "large";
    break;

    //color blue
    case 4: sReturn += "blue"; break;

    //color cyan
    case 5: sReturn += "cyan"; break;

    //color green
    case 6: sReturn += "green"; break;

    //color orange
    case 7: sReturn += "orange"; break;

    //color purple
    case 8: sReturn += "purple"; break;

    //color red
    case 9: sReturn += "red"; break;

    //color white
    case 10: sReturn += "white"; break;

    //color yellow
    case 11: sReturn += "yellow"; break;

    //variant magicshaft blue
    case 12: sReturn += "b"; break;

    //variant magicshaft green
    case 13: sReturn += "g"; break;

    //variant magicshaft red
    case 14: sReturn += "r"; break;

    //variant magicshaft white
    case 15: sReturn += "w"; break;

    //variant magicshaft large yellow
    case 16: sReturn = "x3_plc_ylightl"; break;

    //variant magicshaft medium yellow
    case 17: sReturn = "x3_plc_ylightm"; break;

    //variant magicshaft small yellow
    case 18: sReturn = "x3_plc_ylights"; break;

    //variant portal yellow
    case 19:sReturn = "plc_portal"; break;

    //variant portal blue
    case 20:sReturn = "nw_plc_portal2"; break;

    default: return "";
    }

return sReturn;
}
