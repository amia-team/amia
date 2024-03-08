//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_rebuilder_act
//group:   dm tools
//used as: action script
//date:    oct 25 2009
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_info"
#include "inc_ds_j_lib"

//-------------------------------------------------------------------------------
// prototypes: general
//-------------------------------------------------------------------------------

//transfers inventory
//1 = copies items from oPC to a newly created chest
//2 = moves items, gold, xp from oPC to oDM
//3 = moves items, gold from oDM to oPC
//4 = moves XP from oDM to oPC
void transfer_items( object oDM, object oPC, int nType=1 );

void do_transfer( object oDM, object oPC, int nType );

//strips history from items
void strip_items( object oDM, object oPC );



//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oDM      = OBJECT_SELF;
    object oPC      = GetLocalObject( oDM, "ds_target" );
    int nSection    = GetLocalInt( oDM, "ds_section" );
    int nNode       = GetLocalInt( oDM, "ds_node" );

    if ( nNode == 1 ){

        transfer_items( oDM, oPC, 2 );

        DelayCommand( 1.0, FloatingTextStringOnCreature( "Log out and return with your new character.", oPC ) );
    }
    if ( nNode == 2 ){

        transfer_items( oDM, oPC, 3 );

        DelayCommand( 1.0, FloatingTextStringOnCreature( "Save and go through the mirror/door in the Entry.", oPC ) );
    }
    else if ( nNode >= 11 && nNode <= 16 ){

        string sType = IntToString( nNode - 10 );

        string sQuery = "INSERT INTO player_rebuild VALUES ( NULL, "
                      + "'"+SQLEncodeSpecialChars( GetPCPlayerName( oPC ) )+"', "
                      + "'"+SQLEncodeSpecialChars( GetPCPublicCDKey( oPC, TRUE ) )+"', "
                      + "'"+SQLEncodeSpecialChars( GetName( oPC ) )+"', "
                      + "'"+SQLEncodeSpecialChars( GetPCPlayerName( oDM ) )+"', "
                      + ""+sType+", "
                      + "NOW() )";


        SQLExecDirect( sQuery );

        DelayCommand( 1.0, FloatingTextStringOnCreature( "Recording rebuild.", oPC ) );
    }
    else if ( nNode == 3 ){

        transfer_items( oDM, oPC, 4 );

        DelayCommand( 1.0, FloatingTextStringOnCreature( "Save your character.", oPC ) );
    }
    else if ( nNode == 4 ){

        strip_items( oDM, oPC );
    }
    else if ( nNode == 5 ){

        transfer_items( oDM, oPC, 1 );
    }
    else if ( nNode == 6 ){

        int i;

        for ( i=1; i<=100; ++i ){

            DeletePCKEYValue( oPC, DS_J_JOB+"_"+IntToString( i ) );
        }

        DeletePCKEYValue( oPC, DS_J_JOB );

        SafeDestroyObject( GetItemPossessedBy( oPC, DS_J_JOURNAL ) );

        SendMessageToPC( oDM, CLR_ORANGE+"Erasing Job settings..." );
    }
}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

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
    string sResRef;
    float fDelay;

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

            sResRef = GetResRef( oItem );

            if ( sResRef == "ds_dicebag" ){

                SendMessageToPC( oDM, "Ignoring dicebag..." );
            }
            else if ( sResRef == "dmfi_pc_emote" ){

                SendMessageToPC( oDM, "Ignoring emote wand..." );
            }
            else if ( sResRef == "dmfi_pc_emote2" ){

                SendMessageToPC( oDM, "Ignoring new emote wand..." );
            }
            else if ( sResRef == "ds_pvp_tool" ){

                SendMessageToPC( oDM, "Ignoring pvp tool..." );
            }
            else if ( sResRef == "ds_dc_recom" ){

                SendMessageToPC( oDM, "Ignoring pc dc tool..." );
            }
            else if ( sResRef == "ds_dcrod" ){

                SendMessageToPC( oDM, "Ignoring new pc dc tool..." );
            }
            else if ( sResRef == "ds_party_item" ){

                SendMessageToPC( oDM, "Ignoring party ball..." );
            }
            else if ( sResRef == "ds_dc_rod" ){

                SendMessageToPC( oDM, "Ignoring dm dc tool..." );
            }
            else if ( sResRef == "ds_dm_tool" ){

                SendMessageToPC( oDM, "Ignoring Precious..." );
            }
            else if ( GetBaseItemType( oItem ) == BASE_ITEM_CREATUREITEM ){

                SendMessageToPC( oDM, "Ignoring creature hide..." );
            }
            else {

                if ( GetItemCursedFlag( oItem ) ){

                    SetItemCursedFlag( oItem, FALSE );

                    SetLocalInt( oItem, "rebuild", 2 );
                }
                else{

                    SetLocalInt( oItem, "rebuild", 1 );
                }

                fDelay += 0.1;

                DelayCommand( fDelay, ActionTakeItem( oItem, oPC ) );
            }

            oItem = GetNextItemInInventory( oPC );
        }
    }
    else if ( nType == 3 ){

        //delete pckey
        object oPCKEY = GetPCKEY( oPC );
        int nRebuildFlag;

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

            nRebuildFlag = GetLocalInt( oItem, "rebuild" );

            if ( nRebuildFlag > 0 ){

                if ( nRebuildFlag == 2 ){

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
void strip_items( object oDM, object oPC ){

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


