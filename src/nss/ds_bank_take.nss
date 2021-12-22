#include "inc_ds_bank"

void main(){

    //------------------------------------------------------------------
    //variables
    //------------------------------------------------------------------
    object oPC              = GetLastClosedBy();
    object oStorage         = OBJECT_SELF;
    object oItem            = GetFirstItemInInventory( oStorage );
    int nStoredItems        = GetStoredItems( oPC );
    int nQuotum             = 20 + GetPCKEYValue( oPC, "ds_storage" );
    int nResult;

    if ( nStoredItems > nQuotum ){

        SendMessageToPC( oPC, "You reached your quotum of "+IntToString( nQuotum )+" items!" );
        return;
    }
    else{

        SendMessageToPC( oPC, "You can store another " + IntToString( nQuotum - nStoredItems ) + " items." );
    }

    if ( GetIsObjectValid( oItem ) == TRUE ){

        SendMessageToPC( oPC, "Storing item!" );

        if ( StoreItem( oPC, oStorage, oItem ) == 1 ){

            DelayCommand( 1.0, SendMessageToPC( oPC, "." ) );
            DelayCommand( 2.0, SendMessageToPC( oPC, ".." ) );
            DelayCommand( 3.0, SendMessageToPC( oPC, "..." ) );
            DelayCommand( 4.0, SendMessageToPC( oPC, "...." ) );

            oItem   = GetNextItemInInventory( oStorage );
        }
    }

    if ( GetIsObjectValid( oItem ) == TRUE ){

        AssignCommand( oPC, ActionStartConversation( oPC, "ds_bank", TRUE, FALSE ) );
    }
}
