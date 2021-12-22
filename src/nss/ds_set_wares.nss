//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_set_wares
//group:   market
//used as: OnDisturb
//date:    march 22 2008
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC   = GetLastDisturbed();
    object oItem = GetInventoryDisturbItem();
    object oUser = GetLocalObject( OBJECT_SELF, "mkt_user" );


    if ( GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_ADDED ){

        if ( oUser != oPC ){

            SendMessageToPC( oPC, "This is not your shop. Take your stuff out of this box before it gets destroyed!" );
            return;
        }

        if ( GetResRef( oItem ) == "nw_it_gold001" ){

            SendMessageToPC( oPC, "You can't trade gold. Take it out of this box before it gets destroyed!" );
            return;
        }

        if ( GetBaseItemType( oItem ) == BASE_ITEM_LARGEBOX ){

            FloatingTextStringOnCreature( "WARNING! You can't display bags or boxes. Take them out of this box before they get destroyed or stolen!", oPC );
            SendMessageToPC( oPC, "You can't display bags or boxes. Take them out of this box before they get destroyed or stolen!" );
            return;
        }

        CopyItemFixed( oItem, oPC, TRUE );

        object oDummy = CopyObjectFixed( oItem, GetLocation( OBJECT_SELF ), OBJECT_SELF, "mkt_destroy" );

        //SetItemCursedFlag( oDummy, TRUE );

        DestroyObject( oItem );
    }

    if ( GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_REMOVED ){

        if ( GetResRef( oItem ) == "nw_it_gold001" ){

            return;
        }

        if ( GetTag( oItem ) == "mkt_destroy" ){

            DestroyObject( oItem );
        }
    }
}
