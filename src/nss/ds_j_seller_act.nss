//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_j_plc_act
//group:   Jobs & crafting
//used as: convo action script
//date:    december 2008
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_j_lib"
#include "inc_ds_actions"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void ds_j_OfferItems( object oPC, object oNPC, int nPage ){

    int nCount = GetLocalInt( oNPC, DS_J_DONE );
    int i;
    int nStock;
    int nResource;
    int nPrice;

    if ( nPage == 1 ){

        for ( i=1; i<=30; ++i ){

            nResource = GetLocalInt( oNPC, DS_J_ID+IntToString( i ) );
            nStock    = ds_j_GetStock( nResource );

            SetLocalInt( oPC, "ds_check_"+IntToString( i ), 1 );

            if ( nStock && i < 31 ){

                //SpeakString( "I have "+IntToString( nStock )+" "+ds_j_GetResourceName( nResource )+" for sale!" );
                nPrice = ds_j_GetResourcePrice( nResource );
                nPrice = nPrice + ( nPrice/10 );


                SetCustomToken( 7100+i, CLR_ORANGE+ds_j_GetResourceName( nResource )+CLR_END+" ("+IntToString( nStock )+"): "+IntToString( nPrice )+" GP" );
            }
            else if ( nResource ){

                SetCustomToken( 7100+i, CLR_GRAY + ds_j_GetResourceName( nResource )+CLR_END );
            }
            else{

                SetCustomToken( 7100+i, CLR_GRAY + "-"+CLR_END );
            }
        }
    }
    else{

        for ( i=31; i<=60; ++i ){

            nResource = GetLocalInt( oNPC, DS_J_ID+IntToString( i ) );
            nStock    = ds_j_GetStock( nResource );

            SetLocalInt( oPC, "ds_check_"+IntToString( i-30 ), 1 );

            if ( nStock && i < 61 ){

                //SpeakString( "I have "+IntToString( nStock )+" "+ds_j_GetResourceName( nResource )+" for sale!" );
                nPrice = ds_j_GetResourcePrice( nResource );
                nPrice = nPrice + ( nPrice/10 );


                SetCustomToken( 7100+i, CLR_ORANGE+ds_j_GetResourceName( nResource )+CLR_END+" ("+IntToString( nStock )+"): "+IntToString( nPrice )+" GP" );
            }
            else if ( nResource ){

                SetCustomToken( 7100+i, CLR_GRAY + ds_j_GetResourceName( nResource )+CLR_END );
            }
            else{

                SetCustomToken( 7100+i, CLR_GRAY + "-"+CLR_END );
            }
        }
    }
}


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC       = OBJECT_SELF;
    object oNPC      = GetLocalObject( oPC, "ds_target" );
    int nNode        = GetLocalInt( oPC, "ds_node" );
    int nSection     = GetLocalInt( oPC, "ds_section" );
    int i;
    string sTag      = GetTag( oNPC );

    if ( nNode == 31 ){

        ds_j_OfferItems( oPC, oNPC, 1 );

        SetLocalInt( oPC, "ds_section", 1 );
    }
    else if ( nNode == 32 ){

        ds_j_OfferItems( oPC, oNPC, 2 );

        SetLocalInt( oPC, "ds_section", 2 );
    }
    else if ( nNode == 40 ){

        //cleanup
        clean_vars( oPC, 4 );

        //seller
        SetLocalString( oPC, "ds_action", "ds_j_npc_act" );
        SetLocalObject( oPC, "ds_target", oNPC );
        SetLocalInt( oPC, "ds_check_2", 1 );
        SetLocalInt( oPC, "ds_check_37", 1 );

        ActionStartConversation( oPC, "ds_j_npc", TRUE, FALSE );
    }
    else if ( ( nSection == 1 || nSection == 2 ) && ( nNode > 0 && nNode < 31 ) ) {

        if ( nSection == 2 ){

            nNode += 30;
        }

        int nResource    = GetLocalInt( oNPC, DS_J_ID + IntToString( nNode ) );
        string sResRef   = GetLocalString( oNPC, DS_J_ID + IntToString( nNode ) );

        if ( sResRef == "" ){

            SendMessageToPC( oPC, CLR_RED + "Error: there's no template for this item." + CLR_END );

            return;
        }

        int nPrice       = ds_j_GetResourcePrice( nResource );

        if ( !nPrice ){

            SendMessageToPC( oPC, CLR_RED + "Error: can't find a price for this item." + CLR_END );

            return;
        }

        int nStock       = ds_j_GetStock( nResource );

        if ( !nStock ){

            SendMessageToPC( oPC, CLR_ORANGE + "This item is no longer in stock." + CLR_END );

            return;
        }

        nPrice = nPrice + ( nPrice/10 );

        if ( GetGold( oPC ) > nPrice ){

            int nIcon        = GetLocalInt( oNPC, DS_J_ICON + IntToString( nNode ) );
            int nMaterial    = ds_j_GetResourceMaterial( nResource );

            TakeGoldFromCreature( nPrice, oPC, TRUE );

            object oItem = ds_j_CreateItemOnPC( oPC, sResRef, nResource, "", "", nIcon );

            ds_j_AddMaterialProperties( oPC, oItem, nMaterial, 1, 1, 0, 1 );

            ds_j_ChangeStock( nResource, -1 );
        }
        else{

            SendMessageToPC( oPC, CLR_ORANGE + "You don't have enough money to buy the resource." + CLR_END );
        }
    }
}
