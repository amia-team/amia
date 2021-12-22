void main(){

    object oDisturbItem = GetInventoryDisturbItem();
    int nDisturbType    = GetInventoryDisturbType();

    if ( nDisturbType == INVENTORY_DISTURB_TYPE_REMOVED ){

        if ( GetTag( oDisturbItem ) == "ds_put_back" ){

            ActionTakeItem( oDisturbItem, GetLastDisturbed() );
        }
    }
}
