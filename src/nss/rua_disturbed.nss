//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_qst"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC      = GetLastDisturbed();
    object oPLC     = OBJECT_SELF;
    object oItem    = GetInventoryDisturbItem();
    string sPLCTag  = GetTag( oPLC );
    string sItemTag = GetTag( oItem );

    if ( GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_REMOVED ){

        if ( sPLCTag == "rua_sarco_1" ||  sPLCTag == "rua_sarco_2" ||
             sPLCTag == "rua_sarco_3" ||  sPLCTag == "rua_sarco_4" ){

            if ( sItemTag == "rua_bones" ){

                qst_update( oPC, OBJECT_INVALID, 23, 2 );
            }
        }
    }

}
