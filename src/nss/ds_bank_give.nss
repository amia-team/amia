#include "inc_ds_bank"

void main(){

    //------------------------------------------------------------------
    //variables
    //------------------------------------------------------------------
    object oPC              = GetLastClosedBy();
    object oStorage         = OBJECT_SELF;
    object oItem            = GetFirstItemInInventory( oStorage );

    while ( GetIsObjectValid( oItem ) == TRUE ){

        RetreiveItem( oPC, oStorage, oItem );

        oItem       = GetNextItemInInventory( oStorage );
    }

    if ( GetIsObjectValid( oItem ) == TRUE ){

        if ( RetreiveItem( oPC, oStorage, oItem ) == 1 ){

            oItem   = GetNextItemInInventory( oStorage );
        }
    }

    if ( GetIsObjectValid( oItem ) == TRUE ){

        AssignCommand( oPC, ActionStartConversation( oPC, "ds_bank", TRUE, FALSE ) );
    }
}
