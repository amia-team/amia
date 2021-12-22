//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  se_scout_act
//group:   Master Scout stuff
//used as: action script
//date:    july 07 2011
//author:  Selmak

//-----------------------------------------------------------------------------
// changes
//-----------------------------------------------------------------------------
//2010-07-07    selmak  Initial release using ds_harp_act as a guide
//2010-07-10    selmak  Fixed item creation to allow stack incrementing.
//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"
#include "inc_ds_actions"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------

//Create Master Scout item
void CreateScoutItem( object oPC, string sResRef, int nGold=0, int nXP=0, int nAmount=1, string sNeeded="" );

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------

void main( ){

    //variables
    object oPC      = OBJECT_SELF;
    int nSection    = GetLocalInt( oPC, "ds_section" );
    int nNode       = GetLocalInt( oPC, "ds_node" );
    int nItem       = 0;

    clean_vars( oPC, 3 );

    if ( ( nSection > 0 && nSection < 5 ) && nNode > 10 ){

        //second menu choice, continue to create item
        nItem = ( 100 * nSection ) + nNode;
        SendMessageToPC( oPC, "[Master Scout Crafting: Creating Item "+IntToString( nItem )+"]" );
    }
    else if ( nSection == 0 && ( nNode > 0 && nNode < 5 ) ){

        //first menu choice
        SetLocalInt( oPC, "ds_section", nNode );
        return;
    }
    else{

        //error, clean up
        //this can also be nNode == 9, which cleans up after convo exit
        DeleteLocalInt( oPC, "ds_section" );
        return;
    }

    switch ( nItem ) {

        //Potions
        case 111: CreateScoutItem( oPC, "itp_sc_muscle",      500 );    break;
        case 112: CreateScoutItem( oPC, "itp_sc_nimble",      500 );    break;
        case 113: CreateScoutItem( oPC, "itp_sc_fortitude",   500 );    break;

        //Bombs
        case 211: CreateScoutItem( oPC, "itw_scgr_kaleid",   500 );    break;
        case 212: CreateScoutItem( oPC, "itw_scgr_shrap",    600 );    break;
        case 213: CreateScoutItem( oPC, "itw_scgr_comp",     400 );    break;

        //Weapon Essences
        case 311: CreateScoutItem( oPC, "itm_sc_wyvernbil",  500 );    break;
        case 312: CreateScoutItem( oPC, "itm_sc_sourtooth",  500 );    break;
        case 313: CreateScoutItem( oPC, "itm_sc_auricular",  500 );    break;

        //Trap upgrade components
        case 411: CreateScoutItem( oPC, "itm_sc_ecoil",     1000 );    break;
        case 412: CreateScoutItem( oPC, "itm_sc_fivalve",   1000 );    break;
        case 413: CreateScoutItem( oPC, "itm_sc_sintensi",  1000 );    break;
        case 414: CreateScoutItem( oPC, "itm_sc_hatomis",   1000 );    break;
        case 415: CreateScoutItem( oPC, "itm_sc_cxchangr",  1000 );    break;
        case 416: CreateScoutItem( oPC, "itm_sc_aconcent",  1000 );    break;
        case 417: CreateScoutItem( oPC, "itm_sc_ninducer",  1000 );    break;
        case 418: CreateScoutItem( oPC, "itm_sc_gxcan",     1000 );    break;
        case 419: CreateScoutItem( oPC, "itm_sc_trazors",   1000 );    break;
    }
}

//-----------------------------------------------------------------------------
// functions
//-----------------------------------------------------------------------------

//Create Master Scout item
void CreateScoutItem( object oPC, string sResRef, int nGold=0, int nXP=0, int nAmount=1, string sNeeded="" ){

    SendMessageToPC( oPC, "Item sResRef="+sResRef );

    if ( sNeeded != "" ){

        SendMessageToPC( oPC, "Required sResRef="+sNeeded );
    }

    DeleteLocalInt( oPC, "ds_section" );

    if ( sNeeded != "" ){

        object oNeeded = GetItemPossessedBy( oPC, sNeeded );

        if ( GetIsObjectValid( oNeeded ) ){

            int nStack = GetItemStackSize( oNeeded );

            if( nStack > 1 ){

                SetItemStackSize( oNeeded, nStack - 1 );
            }
            else{

                DestroyObject( oNeeded );
            }
        }
        else{

            FloatingTextStringOnCreature( "[Master Scout Crafting: Failed. Requires item component]", oPC );
            return;
        }
    }

    int nGP = GetGold( oPC );
    int nStack, nMaxStack;

    // Sufficient gold, subtract it, and issue item (as Stolen), notify.
    if( nGP >= nGold ){

        object oItem;

        if ( nAmount == 1 ){

            oItem = GetItemPossessedBy( oPC, sResRef );
            if ( GetIsObjectValid( oItem ) ){

                nStack = GetItemStackSize( oItem );
                nMaxStack = StringToInt( Get2DAString( "baseitems", "Stacking", GetBaseItemType( oItem ) ) );

                if ( nStack < nMaxStack ){
                    SetItemStackSize( oItem, nStack + 1 );
                    FloatingTextStringOnCreature( "[Master Scout Crafting: Adding to your existing stack.]", oPC );
                }
                else{

                    // Issue item.
                    oItem = CreateItemOnObject( sResRef, oPC );
                    // Unset stolen.
                    SetItemCursedFlag( oItem, FALSE );
                    SetStolenFlag( oItem, TRUE );

                }
            }
            else{

                // Issue item.
                oItem = CreateItemOnObject( sResRef, oPC );
                // Unset stolen.
                SetItemCursedFlag( oItem, FALSE );
                SetStolenFlag( oItem, TRUE );

            }
        }
        else{

            int nCount = 0;

            for( nCount = 0; nCount < nAmount; nCount++ ){

                oItem = CreateItemOnObject( sResRef, oPC );

                // Stolen.
                SetItemCursedFlag( oItem, FALSE );
                SetStolenFlag( oItem, TRUE );
            }
        }

        if ( GetIsObjectValid( oItem ) ){

            // Subtract gold.
            TakeGoldFromCreature( nGold, oPC, TRUE );

            // Notify.
            FloatingTextStringOnCreature( "[Master Scout Crafting: Successful!]", oPC );

            //decrement feat uses
            DecrementRemainingFeatUses( oPC, 440 );
        }
        else{

            FloatingTextStringOnCreature( "[Master Scout Crafting: Error. Item not available!]", oPC );
        }

    }
    // Insufficient gold, abort, notify.
    else{

        FloatingTextStringOnCreature( "[Master Scout Crafting: Failed. Insufficient gold]", oPC );
    }
}



