void main(){

    if ( GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_REMOVED ){

        object oPC   = GetLastDisturbed();
        object oItem = GetInventoryDisturbItem();

        AssignCommand( oPC, SpeakString( "*takes " + GetName( oItem ) + " out of the box." ) );
    }
}
