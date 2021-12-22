//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_j_plc_act
//group:   Jobs & crafting
//used as: convo action script
//date:    december 2008
//author:  disco

//-----------------------------------------------------------------------------
// changelog
//-----------------------------------------------------------------------------
// 11 Feb 2011 - Selmak added section 4, allowing deleting of items from slots
//
//



//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_j_lib"


struct Storage ds_j_CheckSlot( object oPC, int nResource, int nRank ){

    struct Storage s_return;

    string sIndex = DS_J_RESOURCE_PREFIX + IntToString( nResource );
    string sSlot;
    int nSlot     = GetPCKEYValue( oPC, sIndex );
    int nAmount;
    int nEnd      = nRank * 10;

    if ( !nEnd ){

        return s_return;
    }

    if ( nSlot > 0 ){

        //this resource has been assigned a slot already
        sSlot   = DS_J_ID + IntToString( nSlot );
        nAmount = GetPCKEYValue( oPC, sSlot );
    }
    else{

        //check for free slots
        nSlot   = 1;
        nAmount = GetPCKEYValue( oPC, sSlot );

        while ( nSlot <= nEnd ){

            sSlot   = DS_J_ID + IntToString( nSlot );
            nAmount = GetPCKEYValue( oPC, sSlot );

            if ( nAmount < 1 ){

                break;
            }

            nSlot  += 1;
        }

        if ( nSlot > nEnd ){

            sSlot   = "";
            nAmount = 0;
        }
    }

    s_return.sIndex  = sIndex;
    s_return.sSlot   = sSlot;
    s_return.nSlot   = nSlot;
    s_return.nAmount = nAmount;

    return s_return;
}

void ds_j_StoreResource( object oPC, object oInventory, object oItem, int nRank ){

    struct Storage s_Storage;
    string sTag = GetTag( oItem );
    int nPrice;
    int nStock;
    int nResult;

    if ( FindSubString( sTag, DS_J_RESOURCE_PREFIX ) != 0 ){

        SendMessageToPC( oPC, "["+CLR_RED+GetName( oItem )+" is not accepted by this merchant."+CLR_END+"]" );
        return;
    }

    //get resource id from the tag
    int nResource = StringToInt( GetSubString( sTag, 9, 15 ) );

    if ( !nResource ){

        //some error
        return;
    }

    nResult = GetLocalInt( oInventory, DS_J_ID + IntToString( nResource ) );

    if ( nResult == 0 ){

        SendMessageToPC( oPC, "["+CLR_RED+GetName( oItem ) + " is not a commodity this merchant trades in!" + CLR_END );
        return;
    }
    else{

        s_Storage = ds_j_CheckSlot( oPC, nResource, nRank );

        if  ( s_Storage.sSlot == "" ){


            SendMessageToPC( oPC, CLR_ORANGE + "You have no free storage slots left." + CLR_END );
        }
        else {

            SendMessageToPC( oPC, CLR_ORANGE + "Adding "+GetName( oItem )+" to slot " + IntToString( s_Storage.nSlot ) + "." + CLR_END );

            SetPCKEYValue( oPC, s_Storage.sIndex, s_Storage.nSlot );
            SetPCKEYValue( oPC, s_Storage.sSlot+"_r", nResource );
            SetPCKEYValue( oPC, s_Storage.sSlot, ( s_Storage.nAmount + 1 ) );

            DestroyObject( oItem );
        }
    }
}

void ds_j_SetStorageSlots( object oPC, int nRank, int nNode ){

    string sSlot;
    string sText;
    int nAmount;
    int nSlot;
    int nResource;
    int nPrice;
    int nEnd = nRank * 10;
    int i;

    if ( !nEnd ){

        return;
    }

    for ( i=1; i<=nRank; ++i ){

        SetLocalInt( oPC, "ds_check_"+IntToString( i ), 1 );
    }

    for ( nSlot=1; nSlot<=nEnd; ++nSlot ){

        sSlot     = DS_J_ID + IntToString( nSlot );
        nAmount   = GetPCKEYValue( oPC, sSlot );
        nResource = GetPCKEYValue( oPC, sSlot+"_r" );

        if ( nAmount > 0 ){

            nPrice = ds_j_GetResourcePrice( nResource );
            sText  = CLR_ORANGE + ds_j_GetResourceName( nResource ) + CLR_END;

            if ( nNode == 33 ){

                sText += " (" + IntToString( nAmount ) + ")";
            }
            else if ( nNode == 34 ){

                sText += " - " + IntToString( nPrice ) + " GP (" + IntToString( nAmount ) + ")";
            }
            else{

                nPrice = FloatToInt( ( 2.0 - ( nRank / 6.0 ) ) * nPrice );

                sText += " - " + IntToString( nPrice ) + " GP (" + IntToString( nAmount ) + ")";
            }

            SetCustomToken( ( 7000 + nSlot ), sText );
        }
        else{

            SetCustomToken( ( 7000 + nSlot ), "..." );
        }
    }
}

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC       = OBJECT_SELF;
    object oPLC      = GetLocalObject( oPC, "ds_target" );
    int nNode        = GetLocalInt( oPC, "ds_node" );
    int nJob         = GetLocalInt( oPLC, DS_J_JOB );
    int nRank        = ds_j_GetJobRank( oPC, nJob );
    int nSection     = GetLocalInt( oPC, "ds_section" );
    int i;

    if ( nSection > 0 && ( nNode > 0 && nNode < 31 ) ){

        string sSlot     = DS_J_ID + IntToString( nNode );
        int nResource    = GetPCKEYValue( oPC, sSlot+"_r" );
        int nAmount      = GetPCKEYValue( oPC, sSlot );
        string sResRef   = GetLocalString( oPLC, DS_J_ID + IntToString( nResource ) );
        //string sName     = ds_j_GetResourceName( nResource );
        //string sTag      = DS_J_RESOURCE_PREFIX + IntToString( nResource );
        int nPrice       = ds_j_GetResourcePrice( nResource );
        int nIcon        = GetLocalInt( oPLC, DS_J_ID + IntToString( nResource ) );

        if ( nSection == 1 ){

            if ( nAmount > 0 && sResRef != "" ){

                ds_j_CreateItemOnPC( oPC, sResRef, nResource, "", "", nIcon );

                --nAmount;

                if ( nAmount == 0 ){

                    DeletePCKEYValue( oPC, sSlot );
                    DeletePCKEYValue( oPC, sSlot + "_r" );
                    DeletePCKEYValue( oPC, DS_J_RESOURCE_PREFIX + IntToString( nResource ) );
                }
                else{

                    SetPCKEYValue( oPC, sSlot, nAmount );
                }

                ds_j_SetStorageSlots( oPC, nRank, 33 );
            }
            else{

                SendMessageToPC( oPC, CLR_ORANGE + "You can only recreate items from the proper trade chest." + CLR_END );
            }
        }
        else if ( nSection == 2 ){

            if ( !GetLocalInt( oPLC, DS_J_RESOURCE_PREFIX + IntToString( nResource ) ) ){

                SendMessageToPC( oPC, CLR_ORANGE + "You can only sell items from the proper trade chest." + CLR_END );
            }
            else if ( nAmount > 0 ){


                DeletePCKEYValue( oPC, sSlot );
                DeletePCKEYValue( oPC, sSlot + "_r" );
                DeletePCKEYValue( oPC, DS_J_RESOURCE_PREFIX + IntToString( nResource ) );

                int nResult = ds_j_StandardRoll( oPC, nJob );
                ds_j_GiveStandardXP( oPC, nJob, nResult, ( nAmount * 0.05 ) );

                if ( nResult > 0 ){

                    //give
                    nPrice += ( ( nPrice * nRank * nResult ) / 20 );
                }

                SendMessageToPC( oPC, CLR_ORANGE + "Selling off " + IntToString( nAmount ) + " items at " + IntToString( nPrice ) + " GP a piece." + CLR_END );

                GiveGoldToCreature( oPC, nAmount * nPrice );

                ds_j_SetStorageSlots( oPC, nRank, 34 );
            }
        }
        else if ( nSection == 3 ){

            if ( nAmount > 0 && sResRef != "" ){

                nPrice = FloatToInt( ( 2.0 - ( nRank / 6.0 ) ) * nPrice );

                if ( nPrice > GetGold( oPC ) ){

                    SendMessageToPC( oPC, CLR_ORANGE + "You don't have enough money to buy the resource." + CLR_END );
                }
                else{

                    ds_j_CreateItemOnPC( oPC, sResRef, nResource, "", "", nIcon );

                    TakeGoldFromCreature( nPrice, oPC, TRUE );
                }

                ds_j_SetStorageSlots( oPC, nRank, 35 );
            }
            else{

                SendMessageToPC( oPC, CLR_ORANGE + "You can only recreate items from the proper trade chest." + CLR_END );
            }
        }
        else if ( nSection == 4 ){

            if ( nAmount > 0 && sResRef != "" ){

                    DeletePCKEYValue( oPC, sSlot );
                    DeletePCKEYValue( oPC, sSlot + "_r" );
                    DeletePCKEYValue( oPC, DS_J_RESOURCE_PREFIX + IntToString( nResource ) );
                    SendMessageToPC( oPC, CLR_ORANGE + "You have deleted all of those items." + CLR_END );
            }
            else{

                SendMessageToPC( oPC, CLR_ORANGE + "Nothing there that needs deleting." + CLR_END );
            }

            ds_j_SetStorageSlots( oPC, nRank, 36 );
        }
    }

    if ( nNode == 31 ){

        //used as normal trade box
        ds_j_BuyInventory( oPC, oPLC, GetLocalObject( oPLC, DS_J_USER ), 0, nJob );
    }
    else if ( nNode == 32 ){

        //store stuff in slots
        SetLocalInt( oPC, DS_J_TOTAL, 0 );

        object oItem = GetFirstItemInInventory( oPLC );

        while ( GetIsObjectValid( oItem ) ){

            ds_j_StoreResource( oPC, oPLC, oItem, nRank );

            oItem = GetNextItemInInventory( oPLC );
        }
    }
    else if ( nNode == 33 || nNode == 34 || nNode == 35 || nNode == 36 ){

        //show stuff in slots
        ds_j_SetStorageSlots( oPC, nRank, nNode );

        //section
        SetLocalInt( oPC, "ds_section", ( nNode - 32 ) );
    }

}
