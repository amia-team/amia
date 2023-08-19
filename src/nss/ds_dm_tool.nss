//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_trans_actions
//group:   transmutation
//used as: action script
//date:    apr 02 2007
//author:  disco

// 2009/09/20 disco            Added some new DM toys

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_info"
#include "amia_include"
#include "inc_player_api"

//-------------------------------------------------------------------------------
// prototypes: general
//-------------------------------------------------------------------------------

//makes plotted object unplotted and vice versa
void toggle_object_plot_flag( object oDM, object oObject );

//-------------------------------------------------------------------------------
// prototypes: Item manipulation
//-------------------------------------------------------------------------------

//makes undroppable item droppable and vice versa
//nCursed = TRUE makes item cursed (pc droppable/undroppable)
//nCursed = FALSE makes item undroppable (doesn't drop from loot)
void toggle_item_drop_flag( object oDM, object oItem, int nCursed=TRUE );

//makes stolen item unstolen and vice versa
void toggle_item_stolen_flag( object oDM, object oItem );

//strips all properties from an item
void strip_item_props( object oDM, object oItem );

//-------------------------------------------------------------------------------
// prototypes: PLC manipulation
//-------------------------------------------------------------------------------

//rotates selected PLC
void rotate_plc( object oDM, object oPLC, float fDegrees );

//creates a lock on a PLC (if it has an inventory)
//also creates a corresponding key on oDM
void lock_key_plc( object oDM, object oPLC );

//creates a corresponding key on oDM
void create_key( object oDM, object oPLC );

//makes activated PLC unactivated and vice versa
void toggle_plc_illuminate_flag( object oDM, object oPLC );

//makes unusable PLC usable and vice versa
void toggle_plc_usable_flag( object oDM, object oPLC );

//destroys PLCs in a certain radius
void destroy_plcs( object oDM, float fDistance );

//-------------------------------------------------------------------------------
// prototypes: PC manipulation
//-------------------------------------------------------------------------------

//authorise cdkey-account combination
//if activate == FALSE you only show the current list
void authorise( object oDM, object oTarget, int nActivate=FALSE );

//boots PCs, but not DMs
void boot_pc( object oDM, object oTarget );

//bans PCs, but not DMs
//set nBoot to TRUE to boot as well
void ban_pc( object oDM, object oTarget, int nBoot=FALSE );

//destroy items and loot stuff in area
void destroy_trash( object oDM, object oArea );

//allow critters to spawn or not
void toggle_area_flag( object oDM, object oArea, string sFlag );

//make a list of the 5 closest PLCs
void list_plcs( object oDM );

//use selected PLC for manipulation
void select_plc( object oDM, int nIndex );

//selects the closest door
void select_door( object oDM );

void ShowJournal( object oPC, object oTarget );

void ShowQuest( object oPC, object oTarget, string sQuest );

//sets a flag on a PC that reports the DM when he changes areas
void trace_pc( object oDM, object oPC );

//creates a copy of a PC or NPC
void copy_creature( object oDM, object oTarget );

//kills creature and leaves a corpse
void create_corpse( object oDM, object oTarget, int nLootable=1 );

//ports party of oPC to oDM
void port_party( object oDM, object oPC );

//shows stolen (nType=1), plot (nType=2), or cursed (nType=3) items on oPC
//4=items with 10+ ownership changes
//5=items with more than 1000 characters
void list_items( object oDM, object oPC, int nType=1 );

//transfers inventory
//1 = copies items from oPC to a newly created chest
//2 = moves items, gold, xp from oPC to oDM
//3 = moves items, gold from oDM to oPC
//4 = moves XP from oDM to oPC
void transfer_items( object oDM, object oPC, int nType=1 );

void do_transfer( object oDM, object oPC, int nType );

//strips history from items
void strip_items( object oDM, object oPC, int nType=1 );

//resets oPC to standard reputation
void reset_reputation( object oDM, object oPC );

//applies vfx to object for easy identification
void highlight( object oDM, object oTarget );

//makes immortal NOC immortal and vice versa
void toggle_npc_immortal_flag( object oDM, object oNPC );

//detects double IPs
void find_double_ip( object oDM );

//create a warning in the database
void log_warning( object oDM, object oPC );

//marks critters as hostile or reverts the marking
void mark_critters( object oDM, int nRevert );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oDM      = OBJECT_SELF;
    object oTarget  = GetLocalObject( oDM, "ds_target" );
    int nSection    = GetLocalInt( oDM, "ds_section" );
    int nNode       = GetLocalInt( oDM, "ds_node" );

    if ( nSection == 1 && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ){

        switch ( nNode ) {

            case 0:      return; break;

            case 01:     toggle_item_drop_flag( oDM, oTarget );                     break;
            case 02:     toggle_item_drop_flag( oDM, oTarget, FALSE );              break;
            case 03:     toggle_object_plot_flag( oDM, oTarget );                   break;
            case 04:     toggle_item_stolen_flag( oDM, oTarget );                   break;
            case 05:     CopyItemFixed( oTarget, oDM , TRUE );                           break;
            case 19:     GetItemInfo( oTarget, oDM );                               break;
            case 21:     SetItemCharges( oTarget, GetItemCharges( oTarget) + 1 );   break;
            case 22:     SetItemCharges( oTarget, GetItemCharges( oTarget) - 1 );   break;
            case 23:     SetItemCharges( oTarget, 100 );                            break;
            case 24:     SetItemCharges( oTarget, 1 );                              break;
            case 25:     strip_item_props( oDM, oTarget );                          break;
            case 26:     SafeDestroyObject( oTarget );                              break;
            case 30:     SetCustomToken( 4500, GetName( oTarget ) );                break;

            default:     return; break;
        }
    }
    else if ( nSection == 2 && GetObjectType( oTarget ) == OBJECT_TYPE_PLACEABLE ){

        switch ( nNode ) {

            case 0:      return; break;

            case 01:     lock_key_plc( oDM, oTarget );                              break;
            case 02:     toggle_plc_illuminate_flag( oDM, oTarget );                break;
            case 03:     toggle_plc_usable_flag( oDM, oTarget );                    break;
            case 04:     toggle_object_plot_flag( oDM, oTarget );                   break;
            case 05:     create_key( oDM, oTarget );                                break;
            case 19:     GetPlaceableInfo( oTarget, oDM );                          break;
            case 21:     rotate_plc( oDM, oTarget, 30.0 );                          break;
            case 22:     rotate_plc( oDM, oTarget, 45.0 );                          break;
            case 23:     rotate_plc( oDM, oTarget, 90.0 );                          break;
            case 24:     rotate_plc( oDM, oTarget, -30.0 );                         break;
            case 25:     rotate_plc( oDM, oTarget, -45.0 );                         break;
            case 26:     rotate_plc( oDM, oTarget, -90.0);                          break;
            case 27:     rotate_plc( oDM, oTarget, 180.0 );                         break;
            case 28:     SafeDestroyObject( oTarget );                              break;
            case 30:     SetCustomToken( 4500, GetName( oTarget ) );                break;

            default:     return; break;
        }
    }
    else if ( nSection == 3 && GetIsObjectValid( oTarget ) == FALSE ){

        object oArea = GetArea( oDM );

        switch ( nNode ) {

            case 0:      return; break;

            case 03:     toggle_area_flag( oDM, oArea, "FreeRespawn" );             break;
            case 04:     toggle_area_flag( oDM, oArea, "FreeRest" );                break;
            case 05:     toggle_area_flag( oDM, oArea, "NoCasting" );               break;
            case 06:     toggle_area_flag( oDM, oArea, "PreventPortToLeader" );     break;
            case 07:     toggle_area_flag( oDM, oArea, "PreventRodOfPorting" );     break;
            case 08:     toggle_area_flag( oDM, oArea, "CS_MAP_REVEAL" );           break;
            case 09:     toggle_area_flag( oDM, oArea, "no_spawn" );                break;
            case 10:     list_plcs( oDM );                                          break;
            case 11:     select_door( oDM );                                        break;
            case 12:     mark_critters( oDM, 0 );                                   break;
            case 13:     mark_critters( oDM, 1 );                                   break;
            case 19:     GetAreaInfo( oDM, oArea );                                 break;
            case 20:     SetCustomToken( 4500, GetName( oArea ) );                  break;
            case 21:     select_plc( oDM, 1 );                                      break;
            case 22:     select_plc( oDM, 2 );                                      break;
            case 23:     select_plc( oDM, 3 );                                      break;
            case 24:     select_plc( oDM, 4 );                                      break;
            case 25:     select_plc( oDM, 5 );                                      break;
            case 26:     destroy_plcs( oDM, 1.0 );                                  break;
            case 27:     destroy_plcs( oDM, 5.0 );                                  break;
            case 28:     destroy_trash( oDM, oArea );                               break;
            case 30:     SetCustomToken( 4500, GetName( oTarget ) );                break;
            case 31:     toggle_area_flag( oDM, oArea, "NoDestroy");                break;

            default:     return; break;
        }
    }
    else if ( nSection == 4 && GetIsPC( oTarget ) == TRUE ){

        switch ( nNode ) {

            case 0:      return; break;

            case 01 :    port_party( oDM, oTarget );                                break;
            case 02 :    AssignCommand( oDM, ActionForceFollowObject( oTarget ) );  break;
            case 03 :    trace_pc( oDM, oTarget );                                  break;
            case 04 :    reset_reputation( oDM, oTarget );                          break;
            case 05 :    FadeFromBlack( oTarget );                                  break;
            case 06 :    copy_creature( oDM, oTarget );                             break;
            case 07 :    SetDeity( oTarget, "" );                                   break;
            case 08 :    log_warning( oDM, oTarget );                               break;
            case 09 :    ShowJournal( oDM, oTarget );                               break;
            case 10 :    ListEffects( oDM, oTarget );                               break;
            case 11 :    boot_pc( oDM, oTarget );                                   break;
            case 12 :    ban_pc( oDM, oTarget, FALSE );                             break;
            case 13 :    ban_pc( oDM, oTarget, TRUE );                              break;
            case 14 :    authorise( oDM, oTarget, FALSE );                           break;
            case 15 :    authorise( oDM, oTarget, TRUE );                           break;
            case 16 :    list_items( oDM, oTarget, 1 );                             break;
            case 17 :    list_items( oDM, oTarget, 2 );                             break;
            case 18 :    list_items( oDM, oTarget, 3 );                             break;
            case 19 :    GetFullPCInfo( oTarget, oDM );                             break;
            case 20 :    SetPCKEYValue( oTarget, "bp_1", 0 );                    break;
            case 21 :    SetPCKEYValue( oTarget, "bp_1", 5 );                    break;
            case 22 :    SetPCKEYValue( oTarget, "bp_1", 42 );                    break;
            case 23 :    SetPCKEYValue( oTarget, "bp_1", 6 );                    break;
            case 24 :    SetPCKEYValue( oTarget, "bp_1", 39 );                    break;
            case 25 :    SetPCKEYValue( oTarget, "bp_1", 20 );                    break;
            case 26 :    SetPCKEYValue( oTarget, "bp_1", 9 );                    break;
            case 27 :    SetPCKEYValue( oTarget, "bp_1", 22 );                    break;
            case 28 :    SetPCKEYValue( oTarget, "bp_1", 21 );                    break;
            case 29 :    SetPCKEYValue( oTarget, "bp_1", 9 );                    break;
            case 30 :    list_items( oDM, oTarget, 4 );                          break;
            case 31 :    list_items( oDM, oTarget, 5 );                          break;
            case 32 :    transfer_items( oDM, oTarget, 1 );                      break;
            case 33 :    transfer_items( oDM, oTarget, 2 );                      break;
            case 34 :    transfer_items( oDM, oTarget, 3 );                      break;
            case 35 :    strip_items( oDM, oTarget );                            break;
            case 36 :    transfer_items( oDM, oTarget, 4 );                      break;
            case 37 :    SetPCKEYValue( oTarget, "jj_changed_domain_1", 0 );
                         SetPCKEYValue( oTarget, "jj_changed_domain_2", 0 );     break;
            default:     return; break;
        }
    }
    else if ( nSection == 5 && GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE ){

        switch ( nNode ) {

            case 0:      return; break;

            case 01 :    copy_creature( oDM, oTarget );                             break;
            case 02 :    create_corpse( oDM, oTarget, 1 );                          break;
            case 03 :    create_corpse( oDM, oTarget, 0 );                          break;
            case 04 :    AssignCommand( oTarget, ActionForceFollowObject( oDM ) );  break;
            case 05 :    toggle_npc_immortal_flag( oDM, oTarget );                  break;
            case 06 :    toggle_object_plot_flag( oDM, oTarget );                   break;

            case 19 :    GetNpcInfo( oTarget, oDM );                                break;
            case 21:     SafeDestroyObject( oTarget );                              break;
            case 22:     ChangeToStandardFaction( oTarget, STANDARD_FACTION_COMMONER );  break;
            case 23:     ChangeToStandardFaction( oTarget, STANDARD_FACTION_DEFENDER );  break;
            case 24:     ChangeToStandardFaction( oTarget, STANDARD_FACTION_HOSTILE );   break;
            case 25:     ChangeToStandardFaction( oTarget, STANDARD_FACTION_MERCHANT );  break;

            case 32 :    transfer_items( oDM, oTarget, 1 );                      break;
            case 33 :    transfer_items( oDM, oTarget, 2 );                      break;
            case 34 :    transfer_items( oDM, oTarget, 3 );                      break;
            case 35 :    strip_items( oDM, oTarget );                            break;
            case 36 :    transfer_items( oDM, oTarget, 4 );                      break;

            default:     return; break;
        }
    }
    else if ( nSection == 6 && GetObjectType( oTarget ) == OBJECT_TYPE_DOOR ){

        switch ( nNode ) {

            case 0:      return; break;

            case 01 :    highlight( oDM, oTarget );                                 break;
            case 02 :    lock_key_plc( oDM, oTarget );                              break;
            case 03 :    SetLockKeyRequired( oTarget, TRUE );                       break;
            case 04 :    SetLockKeyRequired( oTarget, FALSE );                      break;
            case 05 :    SetLocalInt( oTarget, "blocked", 1 );                      break;
            case 06 :    SetLocalInt( oTarget, "blocked", 0 );                      break;
            case 07 :    toggle_object_plot_flag( oDM, oTarget );                   break;
            case 08 :    create_key( oDM, oTarget );                                break;
            case 11 :    SetLockUnlockDC( oTarget, 10 );                            break;
            case 12 :    SetLockUnlockDC( oTarget, 20 );                            break;
            case 13 :    SetLockUnlockDC( oTarget, 30 );                            break;
            case 14 :    SetLockUnlockDC( oTarget, 40 );                            break;
            case 15 :    SetLockUnlockDC( oTarget, 60 );                            break;
            case 16 :    SetLockUnlockDC( oTarget, 80 );                            break;
            case 17 :    SetLockUnlockDC( oTarget, 100 );                           break;
            case 19 :    GetDoorInfo( oTarget, oDM );                               break;
            case 21 :    SetHardness( 10, oTarget );                                break;
            case 22 :    SetHardness( 20, oTarget );                                break;
            case 23 :    SetHardness( 30, oTarget );                                break;
            case 24 :    SetHardness( 40, oTarget );                                break;
            case 25 :    SetHardness( 60, oTarget );                                break;
            case 26 :    SetHardness( 80, oTarget );                                break;
            case 27 :    SetHardness( 100, oTarget );                               break;
            case 28:     SafeDestroyObject( oTarget );                              break;

            default:     return; break;
        }
    }
    else if ( nSection == 7 && GetIsDM( oDM ) || GetIsDMPossessed( oDM ) ){

        switch ( nNode ) {

            case 0:      return; break;

            case 01 :    AR_ExportPlayers( );                                       break;
            case 02 :    find_double_ip( oDM );                                     break;
            case 05 :    copy_creature( oDM, oDM );                                 break;
            case 21 :    KillServer( );                                             break;

            default:     return; break;
        }
    }
}

//-------------------------------------------------------------------------------
// functions: general
//-------------------------------------------------------------------------------

//makes plotted object unplotted and vice versa
void toggle_object_plot_flag( object oDM, object oObject ){

    if ( GetPlotFlag( oObject ) ){

        SetPlotFlag( oObject, FALSE );
        SendMessageToPC( oDM, GetName( oObject ) + " is no longer marked as a plot object." );
    }
    else{

        SetPlotFlag( oObject, TRUE );
        SendMessageToPC( oDM, GetName( oObject ) + " is now marked as a plot object." );
    }
}

//-------------------------------------------------------------------------------
// functions: Item manipulation
//-------------------------------------------------------------------------------

//makes undroppable item droppable and vice versa
//nCursed = TRUE makes item cursed (pc droppable/undroppable)
//nCursed = FALSE makes item undroppable (doesn't drop from loot)
void toggle_item_drop_flag( object oDM, object oItem, int nCursed=TRUE ){

    if ( nCursed == TRUE ){

        if ( GetItemCursedFlag( oItem ) ){

            SetItemCursedFlag( oItem, FALSE );
            SendMessageToPC( oDM, "Item set to droppable/uncursed." );
        }
        else{

            SetItemCursedFlag( oItem, TRUE );
            SendMessageToPC( oDM, "Item set to undroppable/cursed." );
        }
    }
    else{

        if ( GetDroppableFlag( oItem ) ){

            SetDroppableFlag( oItem, FALSE );
            SendMessageToPC( oDM, "Item will not appear in loot." );
        }
        else{

            SetDroppableFlag( oItem, TRUE );
            SendMessageToPC( oDM, "Item will appear in loot." );
        }
    }
}

//makes stolen item unstolen and vice versa
void toggle_item_stolen_flag( object oDM, object oItem ){

    if ( GetStolenFlag( oItem ) ){

        SetStolenFlag( oItem, FALSE );
        SendMessageToPC( oDM, "Item is no longer marked as stolen." );
    }
    else{

        SetStolenFlag( oItem, TRUE );
        SendMessageToPC( oDM, "Item is now marked as stolen." );
    }
}

//strips all properties from an item
void strip_item_props( object oDM, object oItem ){

    //Get the first itemproperty on the helmet
    itemproperty ipLoop = GetFirstItemProperty( oItem );

    //Loop for as long as the ipLoop variable is valid
    while ( GetIsItemPropertyValid( ipLoop ) ){

        RemoveItemProperty( oItem, ipLoop );

        //Next itemproperty on the list...
        ipLoop = GetNextItemProperty( oItem );
    }

    SetCustomToken( 4500, GetName( oItem ) );
}


//-------------------------------------------------------------------------------
// functions: PLC manipulation
//-------------------------------------------------------------------------------

//rotates selected PLC
void rotate_plc( object oDM, object oPLC, float fDegrees ){

    float fFacing = GetFacing( oPLC ) + fDegrees;

    AssignCommand( oPLC, SetFacing( fFacing ) );
    SendMessageToPC( oDM, "Rotated "+GetName( oPLC )+"." );
}

//creates a lock on a PLC (if it has an inventory)
//also creates a corresponding key on oDM
void lock_key_plc( object oDM, object oPLC ){

    string sTag = GetPCPublicCDKey( oDM, TRUE ) + "_" + IntToString( Random( 999 ) ) + "_" + IntToString( GetTimeMillisecond() );
    object oKey = CreateItemOnObject( "dm_quest_key", oDM, 1, sTag );

    SetLockLockable( oPLC );
    SetLockKeyRequired( oPLC );
    SetLockKeyTag( oPLC, sTag );
    SetLocked( oPLC, TRUE );

    SetName( oKey, "A mysterious key!" );
}

//creates a corresponding key on oDM
void create_key( object oDM, object oPLC ){

    string sTag = GetLockKeyTag( oPLC );

    if ( sTag != "" ){

        object oKey = CreateItemOnObject( "dm_false_key", oDM, 1, sTag );

        SetName( oKey, "Forged "+GetName( GetArea( oDM ) )+" key" );
    }
    else{

        SendMessageToPC( oDM, "This object has no lock." );
    }
}

//makes activated PLC unactivated and vice versa
void toggle_plc_illuminate_flag( object oDM, object oPLC ){

    if ( GetPlaceableIllumination( oPLC ) ){

        SetPlaceableIllumination( oPLC, FALSE );
        SendMessageToPC( oDM, GetName( oPLC ) + " is no longer illuminated." );
    }
    else{

        SetPlaceableIllumination( oPLC, TRUE );
        SendMessageToPC( oDM, GetName( oPLC ) + " is now illuminated." );
    }

    RecomputeStaticLighting( GetArea( oPLC ) );
}

//makes unusable PLC usable and vice versa
void toggle_plc_usable_flag( object oDM, object oPLC ){

    if ( GetUseableFlag( oPLC ) ){

        SetUseableFlag( oPLC, FALSE );
        SendMessageToPC( oDM, GetName( oPLC ) + " is no longer marked usable." );
    }
    else{

        SetUseableFlag( oPLC, TRUE );
        SendMessageToPC( oDM, GetName( oPLC ) + " is now usable." );
    }
}

void destroy_plcs( object oDM, float fDistance ){

    location lTarget = GetLocalLocation( oDM, "ds_target" );

    object oPlaceable = GetFirstObjectInShape( SHAPE_SPHERE, fDistance, lTarget, FALSE, OBJECT_TYPE_PLACEABLE );

    while ( GetIsObjectValid( oPlaceable ) ) {

        SendMessageToPC( oDM, "Destroying " + GetName( oPlaceable ) + " (plc)" );
        SafeDestroyObject( oPlaceable );

        oPlaceable = GetNextObjectInShape( SHAPE_SPHERE, fDistance, lTarget, FALSE, OBJECT_TYPE_PLACEABLE );
    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------


void authorise( object oDM, object oTarget, int nActivate=FALSE ){

    string sQuery;
    string sMessage;

    if ( nActivate == TRUE ){

        sQuery  = "INSERT INTO player_authentication VALUES ( NULL, ";
        sQuery += "'"+SQLEncodeSpecialChars( GetPCPlayerName( oTarget ) )+"', ";
        sQuery += "'"+ GetPCPublicCDKey( oTarget, TRUE )+"', NOW() ) ";
        sQuery += "ON DUPLICATE KEY UPDATE insert_at=NOW()";

        SQLExecDirect( sQuery );

        SendMessageToPC( oDM, "Authorised this cdkey/account combination" );
    }
    else{

        sQuery = "SELECT account, cdkey,login FROM player_identity WHERE account = '"+SQLEncodeSpecialChars( GetPCPlayerName( oTarget ) )+"'";

        SQLExecDirect( sQuery );

        while( SQLFetch( ) == SQL_SUCCESS ){

            sMessage   = SQLGetData( 1 ) + " : " + SQLGetData( 2 ) + " : " + SQLGetData( 3 );

            SendMessageToPC( oDM, sMessage );
        }
    }
}


void boot_pc( object oDM, object oTarget ){

    if ( !GetIsPC( oTarget ) ){

        return;
    }

    if ( GetIsDM( oTarget ) || GetIsDMPossessed( oTarget ) ){

        return;
    }

    BootPC( oTarget );
    SendMessageToAllDMs( GetName( oTarget ) + " has been booted by " + GetName( oDM ) );
}

void ban_pc( object oDM, object oTarget, int nBoot=FALSE ){

    if ( !GetIsPC( oTarget ) ){

        return;
    }

    if ( GetIsDM( oTarget ) || GetIsDMPossessed( oTarget ) ){

        return;
    }

    object oModule  = GetModule( );
    string sCDKey   = GetPCPublicCDKey( oTarget );

    if ( GetLocalInt(oModule, "Banned_" + sCDKey) ) {

        SendMessageToPC( oDM, "CD key " + sCDKey + " is already banned." );
    }

    else {

        BanPlayer(sCDKey);

        string sPlayer  = SQLEncodeSpecialChars( GetPCPlayerName( oTarget ) );
        string sTag     = SQLEncodeSpecialChars( GetName( oTarget ) );
        string sDM      = SQLEncodeSpecialChars( GetPCPlayerName( oDM ) );

        string sSQL = "INSERT INTO banned (cdkey, login, tag, banned_by)"
                        + " VALUES ('" + sCDKey + "', '" + sPlayer + "', '"
                        + sTag + "', '" + sDM + "')";

        SQLExecDirect( sSQL );

        string sMsg = GetName( oTarget ) + " (" + GetPCPlayerName( oTarget ) + "), CD Key '" + sCDKey + "' has been banned by " + GetName( oDM );

        if ( !GetIsDM( oDM ) ){

            SendMessageToPC( oDM, sMsg );     // Admin, logged in as a player
            }
        if ( !GetIsDM( oDM ) ){

            SendMessageToPC( oDM, sMsg );     // Admin, logged in as a player
			}
		}

    if ( nBoot ){

        boot_pc( oDM, oTarget );
		}
}

//-------------------------------------------------------------------------------
// functions: area
//-------------------------------------------------------------------------------

//destroy items and loot stuff in area
void destroy_trash( object oDM, object oArea ){

    int nType;
    object oObject = GetFirstObjectInArea( oArea );

    while ( GetIsObjectValid(oObject) ) {

        nType = GetObjectType( oObject );

        if ( nType == OBJECT_TYPE_ITEM && GetTag( oObject ) != "prop" ){

             SendMessageToPC( oDM, "Destroying " + GetName( oObject ) + " (item)" );
             SafeDestroyObject( oObject );
        }
        else if ( nType == OBJECT_TYPE_PLACEABLE && GetTag(oObject) == "ds_daloot" ){

             SendMessageToPC( oDM, "Destroying " + GetName( oObject ) + " (plc)" );
             SafeDestroyObject( oObject );
        }

        oObject = GetNextObjectInArea( oArea );
    }
}

//allow critters to spawn or not
void toggle_area_flag( object oDM, object oArea, string sFlag ){

    int nDisabled = GetLocalInt( oArea, sFlag );

    if ( nDisabled == TRUE ){

        SetLocalInt( oArea, sFlag, FALSE );
        SendMessageToPC( oDM, sFlag + " set to OFF." );
   }
    else{

        SetLocalInt( oArea, sFlag, TRUE );
        SendMessageToPC( oDM, sFlag + " set to ON." );
    }

    return;
}

void list_plcs( object oDM ){


    location lTarget = GetLocalLocation( oDM, "ds_target" );
    object oPLC;
    int i;

    for ( i=1; i<6; ++i ){

        oPLC   = GetNearestObjectToLocation( OBJECT_TYPE_PLACEABLE, lTarget, i );

        if ( GetIsObjectValid( oPLC ) ){

            SetCustomToken( ( 4510 + i ), GetName( oPLC ) );
        }
        else{

            SetCustomToken( ( 4510 + i ), "" );
        }
    }
}

void select_plc( object oDM, int nIndex ){

    location lTarget = GetLocalLocation( oDM, "ds_target" );
    object oPLC      = GetNearestObjectToLocation( OBJECT_TYPE_PLACEABLE, lTarget, nIndex );

    SetLocalInt( oDM, "ds_check_2", 1 );
    SetLocalInt( oDM, "ds_check_3", 0 );
    SetLocalInt( oDM, "ds_section", 2 );
    SetLocalObject( oDM, "ds_target", oPLC );
    SetCustomToken( 4500, GetName( oPLC ) );
}

void select_door( object oDM ){

    location lTarget = GetLocalLocation( oDM, "ds_target" );
    object oDoor     = GetNearestObjectToLocation( OBJECT_TYPE_DOOR, lTarget, 1 );

    if (  GetDistanceBetweenLocations( lTarget, GetLocation( oDoor ) ) > 10.0 ){

        SendMessageToPC( oDM, "There's no door within 10 meters." );
        return;
    }

    SetLocalInt( oDM, "ds_check_6", 1 );
    SetLocalInt( oDM, "ds_check_3", 0 );
    SetLocalInt( oDM, "ds_section", 6 );
    SetLocalObject( oDM, "ds_target", oDoor );
    SetCustomToken( 4500, GetName( oDoor ) );
}

void collect_party( object oDM, object oPC ){

    object oMember = GetFirstFactionMember( oPC );

    while ( GetIsPC(oMember) ) {

        AssignCommand( oMember, ClearAllActions() );
        AssignCommand( oMember, JumpToObject( oDM, 0 ) );

        oMember = GetNextFactionMember( oPC );
    }
}

void ShowJournal( object oDM, object oPC ){

    float fDelay        = 0.0;

    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_subrace_activated" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "AR_BardQuest2" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "subrace_authorized" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "HasRespawned" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "QST_ChosenOrc" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "QST_WifeSpirit" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "QST_MainTemple" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "QST_BlindBeggar" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "QST_ManorBook" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "tha_traders" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "tha_quest1" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "tha_quest2" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "tha_quest3" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "tha_quest4" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "tha_quest5" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "tha_quest6" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "tha_quest7" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "tha_quest8" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_1" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_2" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_3" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_4" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_5" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_6" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_7" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_8" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_9" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_10" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_11" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_12" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_13" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_14" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_15" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_16" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_17" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_18" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_19" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_20" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_21" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_22" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "ds_quest_23" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "BlindBeggar" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "qst_gloura" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "qst_ankhremun" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "cs_panthalo_done" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "drow_starter_quest" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "bp_1" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "bp_2" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "bp_3" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "bp_4" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "bp_5" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "bp_6" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "bp_7" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "bp_8" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "bp_9" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "bp_10" ) );
    DelayCommand( (fDelay+0.1), ShowQuest( oDM, oPC, "tha_reputation" ) );
}

void ShowQuest( object oDM, object oPC, string sQuest ){

    int nValue = GetPCKEYValue( oPC, sQuest );

    SendMessageToPC( oDM, sQuest + " = " + IntToString( nValue ) );
}

void trace_pc( object oDM, object oPC ){

    object oCurrentDM = GetLocalObject( oPC, "dm_trace" );

    if ( oCurrentDM == oDM ){

        DeleteLocalObject( oPC, "dm_trace" );
        SendMessageToPC( oDM, "Target is no longer traced by you." );
    }
    else if ( GetIsObjectValid( oCurrentDM ) ){

        SendMessageToPC( oDM, "Target is traced by " + GetName( oCurrentDM ) );
    }
    else{

        SetLocalObject( oPC, "dm_trace", oDM );
        SendMessageToPC( oDM, "Target is now traced by you." );
    }
}

void copy_creature( object oDM, object oTarget ){

    location lWP = GetLocation( GetWaypointByTag( "ds_copy" ) );
    object oNPC  = CopyObjectFixed( oTarget, lWP );
    object oItem;
    int nSlot;
    int nGold;

    //set to non-hostile
    ChangeToStandardFaction( oNPC, STANDARD_FACTION_COMMONER );

    //feedback
    SendMessageToPC( oDM, "Created " + GetName( oNPC ) + " in " + GetName( GetArea( oNPC ) ) );

    //copy vars
    SetLocalString( oNPC, "MyStore", GetLocalString( oTarget, "MyStore" ) );

    //strip NPC made from a PC
    if ( GetIsPC( oTarget ) ){

        object oItem = GetFirstItemInInventory( oNPC );

        while ( GetIsObjectValid( oItem ) == TRUE ){

            DestroyObject( oItem, 2.0 );

            oItem = GetNextItemInInventory( oNPC );
        }
    }

    //make equiped stuff undroppable
    for ( nSlot=0; nSlot<NUM_INVENTORY_SLOTS; nSlot++ ){

        oItem = GetItemInSlot( nSlot, oNPC );

        //unequip if valid
        if ( GetIsObjectValid( oItem ) ){

            SetDroppableFlag( oItem, FALSE );
        }
    }

    //strip gold
    nGold = GetGold( oNPC );\
    AssignCommand( oDM, TakeGoldFromCreature( nGold, oNPC, TRUE ) );
}


void create_corpse( object oDM, object oTarget, int nLootable=1 ){

    SetPlotFlag( oTarget, FALSE );
    SetPlotFlag( oTarget, FALSE );

    if ( nLootable ){

        AssignCommand( oTarget, SetIsDestroyable( FALSE, FALSE, TRUE ) );
        SetLootable( oTarget, TRUE );
    }
    else{

        AssignCommand( oTarget, SetIsDestroyable( FALSE, TRUE, TRUE ) );
        SetLootable( oTarget, FALSE );
    }

    ExecuteScript( "ds_suicide", oTarget );
}


void port_party( object oDM, object oPC ){

    object oMember = GetFirstFactionMember( oPC );

    while ( GetIsPC( oMember ) ) {

        AssignCommand( oMember, ClearAllActions() );
        AssignCommand( oMember, JumpToObject( oDM ) );

        oMember = GetNextFactionMember( oPC );
    }
}

void list_items( object oDM, object oPC, int nType=1 ){

    object oItem = GetFirstItemInInventory( oPC );

    if ( nType == 1 ){

        SendMessageToPC( oDM, "Stolen items:" );
    }
    else if ( nType == 2 ){

        SendMessageToPC( oDM, "Plot items:" );
    }
    else if ( nType == 3 ){

        SendMessageToPC( oDM, "Plot items:" );
    }
    else if ( nType == 4 ){

        SendMessageToPC( oDM, "Volatile items:" );
    }
    else{

        SendMessageToPC( oDM, "Novel length bios:" );
    }

    while ( GetIsObjectValid( oItem ) ) {

        if ( ( GetStolenFlag( oItem ) && nType == 1 ) ||
             ( GetPlotFlag( oItem ) && nType == 2 ) ||
             ( GetItemCursedFlag( oItem ) && nType == 3 ) ){

            SendMessageToPC( oDM, " - " + GetName( oItem ) );
        }
        else if ( nType == 4 && GetLocalInt( oItem, "ds_os" ) > 9 ){

            SendMessageToPC( oDM, " - " + GetName( oItem ) );
        }
        else if ( nType == 5 && GetStringLength( GetDescription( oItem ) ) > 555 ){

            SendMessageToPC( oDM, " - " + GetName( oItem ) );
        }

        oItem = GetNextItemInInventory( oPC );
    }
}

void transfer_items( object oDM, object oPC, int nType=1 ){

    object oItem;
    int i;

    for ( i=0; i<NUM_INVENTORY_SLOTS; ++i ){

        oItem = GetItemInSlot( i, oPC );

        if ( GetIsObjectValid( oItem ) ){

            AssignCommand( oPC, ActionUnequipItem( oItem ) );
        }
    }

    SendMessageToPC( oDM, "Unequipping items." );

    DelayCommand( 1.0, do_transfer( oDM, oPC, nType ) );
}

void do_transfer( object oDM, object oPC, int nType ){

    object oChest;
    object oItem;
    string sVariable = "rebuild_"+GetPCPublicCDKey( oPC, TRUE );
    int nGold;
    int nXP;

    if ( nType == 1 ){

        oChest = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_rebuild", GetLocation( oPC ) );

        SendMessageToPC( oDM, "Copying items." );

        oItem = GetFirstItemInInventory( oPC );

        while ( GetIsObjectValid( oItem ) ) {

            CopyItemFixed( oItem, oChest, TRUE );

            oItem = GetNextItemInInventory( oPC );
        }
    }
    else if ( nType == 2 ){

        nGold = GetGold( oPC );

        SetLocalInt( oDM, sVariable+"_gp", nGold );

        TakeGold( nGold, oPC );

        nXP   = GetXP( oPC );

        SetLocalInt( oDM, sVariable+"_xp", nXP );

        SetXP( oPC, 0 );

        SendMessageToPC( oDM, "Taking items, "+IntToString(nGold)+" gold, and "+IntToString(nXP)+" XP." );

        oItem = GetFirstItemInInventory( oPC );

        while ( GetIsObjectValid( oItem ) ) {

            string sResRef = GetResRef( oItem );

            if ( sResRef == "ds_dicebag" ){

                SendMessageToPC( oDM, "Ignoring dicebag..." );
            }
            else if ( sResRef == "dmfi_pc_emote" ){

                SendMessageToPC( oDM, "Ignoring emote wand..." );
            }
            else if ( sResRef == "ds_pvp_tool" ){

                SendMessageToPC( oDM, "Ignoring pvp tool..." );
            }
            else if ( sResRef == "ds_dc_recom" ){

                SendMessageToPC( oDM, "Ignoring pc dc tool..." );
            }
            else if ( sResRef == "ds_party_item" ){

                SendMessageToPC( oDM, "Ignoring party ball..." );
            }
            else if ( sResRef == "ds_dc_rod" ){

                SendMessageToPC( oDM, "Ignoring dm dc tool..." );
            }
            else if ( sResRef == "ds_dm_tool" ){

                SendMessageToPC( oDM, "Ignoring precious..." );
            }
            else {

                SetLocalInt( oItem, "rebuild", 1 );

                ActionTakeItem( oItem, oPC );
            }

            oItem = GetNextItemInInventory( oPC );
        }
    }
    else if ( nType == 3 ){

        //delete pckey
        object oPCKEY = GetPCKEY( oPC );

        if ( GetIsObjectValid( oPCKEY ) ){

            SendMessageToPC( oDM, "Warning: This PC already has a pckey. Remove it first (or take it back if you already transfered it)." );

            return;
        }

        //remove new portal rod
        object oRod = GetItemPossessedBy( oPC, "ds_porting" );

        if ( GetIsObjectValid( oPCKEY ) ){

            DestroyObject( oRod );

            SendMessageToPC( oDM, "Removed new portal rod..." );
        }

        nGold = GetLocalInt( oDM, sVariable+"_gp" );

        GiveGoldToCreature( oPC, nGold );

        SendMessageToPC( oDM, "Returning items and "+IntToString(nGold)+" gold." );

        DeleteLocalInt( oDM, sVariable+"_gp" );

        oItem = GetFirstItemInInventory( oDM );

        while ( GetIsObjectValid( oItem ) ) {

            if ( GetLocalInt( oItem, "rebuild" ) == 1 ){

                if ( GetItemCursedFlag( oItem ) == TRUE ){

                    SetItemCursedFlag( oItem, FALSE );

                    SendMessageToPC( oDM, "Moving undroppable item: "+GetName( oItem ) );

                    DelayCommand( 1.0, SetItemCursedFlag( oItem, TRUE ) );
                }

                ActionGiveItem( oItem, oPC );

                DeleteLocalInt( oItem, "rebuild" );
            }

            oItem = GetNextItemInInventory( oDM );
        }
    }
    else if ( nType == 4 ){

        nXP = GetLocalInt( oDM, sVariable+"_xp" );

        SetXP( oPC, nXP );

        if ( nXP ){

            SendMessageToPC( oDM, "Returned "+IntToString(nXP)+" XP." );

            DeleteLocalInt( oDM, sVariable+"_xp" );
        }
    }
}

//strips history from items
void strip_items( object oDM, object oPC, int nType=1 ){

    object oItem = GetFirstItemInInventory( oPC );
    int nOwners;
    int i;

    SendMessageToPC( oDM, "Removing Ownership History..." );

    while ( GetIsObjectValid( oItem ) ) {

        nOwners  = GetLocalInt( oItem, "ds_os" );
        i        = 0;

        for( i=1; i<=nOwners; ++i ){

            DeleteLocalString( oItem, "ds_os_"+IntToString( i ) );
        }

        SetLocalInt( oItem, "ds_os", 1 );
        SetLocalString( oItem, "ds_os_1", "Rebuild by "+GetPCPlayerName( oDM ) );

        oItem = GetNextItemInInventory( oPC );
    }
}

void reset_reputation( object oDM, object oPC ){

    SetStandardFactionReputation( STANDARD_FACTION_COMMONER, 50, oPC );
    SetStandardFactionReputation( STANDARD_FACTION_DEFENDER, 50, oPC );
    SetStandardFactionReputation( STANDARD_FACTION_HOSTILE, 0, oPC );
    SetStandardFactionReputation( STANDARD_FACTION_MERCHANT, 50, oPC );

    SendMessageToPC( oDM, GetName( oPC ) + " reset to standard reputation." );
}

void highlight( object oDM, object oTarget ){

    effect eGlow = EffectVisualEffect( VFX_DUR_IOUNSTONE_YELLOW );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eGlow, oTarget, 5.0 );

}

//makes immortal NOC immortal and vice versa
void toggle_npc_immortal_flag( object oDM, object oNPC ){

    if ( GetImmortal( oNPC ) == TRUE ){

        SetImmortal( oNPC, FALSE );
        SendMessageToPC( oDM, GetName( oNPC ) + " is no longer immortal." );
   }
    else{

        SetImmortal( oNPC, TRUE );
        SendMessageToPC( oDM, GetName( oNPC ) + " is now immortal." );
    }

    return;
}

void find_double_ip( object oDM ){

    object oTestWP  = CreateObject( OBJECT_TYPE_WAYPOINT, "ds_storage", GetLocation( oDM ) );
    object oShare;
    string sIP;
    object oPC      = GetFirstPC( );

    while ( GetIsPC( oPC ) ) {

        sIP      = GetPCIPAddress( oPC );
        oShare   = GetLocalObject( oTestWP, sIP );

        if ( GetIsPC( oShare ) ){

            SendMessageToPC( oDM, GetName( oPC )+" shares a connection with "+GetName( oShare ) );
        }

        SetLocalObject( oTestWP, sIP, oPC );

        oPC = GetNextPC( );
    }

    DelayCommand( 5.0, DestroyObject( oTestWP ) );
}

void log_warning( object oDM, object oPC ){

    string sQuery;

    if ( GetIsPC( oPC ) == FALSE ){

        sQuery = "INSERT INTO player_watchlist  VALUES ( NULL, '"
                        +SQLEncodeSpecialChars( GetPCPlayerName(oPC) )+"', '"
                        +SQLEncodeSpecialChars( GetName(GetMaster(oPC) ) )+"', '"
                        +GetPCPublicCDKey(oPC)+"', '"
                        +GetPCIPAddress(oPC)+"', '"
                        +SQLEncodeSpecialChars( GetName( GetArea( oPC ) ) )+"', '"
                        +SQLEncodeSpecialChars( GetName( oDM ) )+"', '', NOW(), NOW() )";
    }
    else {

        sQuery = "INSERT INTO player_watchlist  VALUES ( NULL, '"
                        +SQLEncodeSpecialChars( GetPCPlayerName(oPC) )+"', '"
                        +SQLEncodeSpecialChars( GetName(oPC) )+"', '"
                        +GetPCPublicCDKey(oPC)+"', '"
                        +GetPCIPAddress(oPC)+"', '"
                        +SQLEncodeSpecialChars( GetName( GetArea( oPC ) ) )+"', '"
                        +SQLEncodeSpecialChars( GetName( oDM ) )+"', '', NOW(), NOW() )";
    }

    SQLExecDirect( sQuery );
}

void mark_critters( object oDM, int nRevert ){

    object oArea                = GetArea( oDM );
    object oObject              = GetFirstObjectInArea( oArea );

    while (GetIsObjectValid(oObject) ){

        if ( GetObjectType(oObject) == OBJECT_TYPE_CREATURE ){

            if ( nRevert ){

                SetName( oObject, "" );
            }
            else if ( GetStandardFactionReputation( STANDARD_FACTION_COMMONER, oObject ) > 10 ){

                SetName( oObject, "<c þ >"+GetName( oObject, TRUE )+"</c>" );
            }
            else if ( GetStandardFactionReputation( STANDARD_FACTION_COMMONER, oObject ) <= 10 ){

                SetName( oObject, "<cþ  >"+GetName( oObject, TRUE )+"</c>" );
            }
        }

        oObject = GetNextObjectInArea(oArea);
    }
}

