/*  i_ds_customitem2

--------
Verbatim
--------


---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
06-14-06  Disco       Start of header
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
//#include ""

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
int poison_ingredient( object oPC, int nPoison, int nRemove );
void poison_create_ammo( object oPC, int nPoison, int nNode );
void poison_create_drink( object oPC, int nPoison, int nNode );
string poison_name( int nPoison );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){


    // Variables
    object oPC      = OBJECT_SELF;
    int nNode       = GetLocalInt( oPC, "ds_node" );
    int nPoison     = GetLocalInt( oPC, "ds_poison" );

//testing
//SendMessageToPC( oPC, IntToString( nPoison ) );
//testing
//SendMessageToPC( oPC, IntToString( nNode ) );

    if ( nNode > 0 && nNode <7 ) {

        SetLocalInt( oPC, "ds_poison", nNode );
    }
    else if ( nNode > 9 && nNode <15 ) {

        poison_create_ammo( oPC, nPoison, nNode );
    }
    else if ( nNode > 14 && nNode <18 ){

        poison_create_drink( oPC, nPoison, nNode );
    }
}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

int poison_ingredient( object oPC, int nPoison, int nRemove ){

    string sIngredientTag = "poi_ing_00" + IntToString( nPoison );
    object oIngredient    = GetItemPossessedBy( oPC, sIngredientTag ) ;


    if ( oIngredient != OBJECT_INVALID ){

        if (nRemove ){

            DestroyObject( oIngredient );
            SetLocalInt( oPC, "ds_check_" + IntToString( nPoison ), 0 );
            return 1;
        }
        else{

            SetLocalInt( oPC, "ds_check_" + IntToString( nPoison ), 1 );
            return 1;
        }
    }
    else {

        SetLocalInt( oPC, "ds_check_" + IntToString( nPoison ), 0 );
        return 0;
    }
}

void poison_create_ammo( object oPC, int nPoison, int nNode ){

    int nResult = poison_ingredient( oPC, nPoison, 1 );
    object oItem;

    if ( nResult == 1) {

        if ( nNode == 10) {

            oItem = CreateItemOnObject( "ds_poi_arrow", oPC, 5 , "ds_poison_"+IntToString(nPoison) );
            SetName( oItem, "Poisoned Arrows (" + poison_name( nPoison ) + ")" );

        }
        else if ( nNode == 11) {

            oItem = CreateItemOnObject( "ds_poi_bolt", oPC, 5 , "ds_poison_"+IntToString(nPoison) );
            SetName( oItem, "Poisoned Bolts (" + poison_name( nPoison ) + ")" );
         }
        else if ( nNode == 12) {

            oItem = CreateItemOnObject( "ds_poi_dart", oPC, 5 , "ds_poison_"+IntToString(nPoison) );
            SetName( oItem, "Poisoned Darts (" + poison_name( nPoison ) + ")" );
         }
        else if ( nNode == 13) {

            oItem = CreateItemOnObject( "ds_poi_shuriken", oPC, 5 , "ds_poison_"+IntToString(nPoison) );
            SetName( oItem, "Poisoned Shuriken (" + poison_name( nPoison ) + ")" );
         }
        else if ( nNode == 14) {
            oItem = CreateItemOnObject( "ds_poi_axe", oPC, 5 , "ds_poison_"+IntToString(nPoison) );
            SetName( oItem, "Poisoned Axes (" + poison_name( nPoison ) + ")" );
        }
        //SetLocalInt( oItem, "ds_poison", nPoison );
    }
}

void poison_create_drink( object oPC, int nPoison, int nNode ){

    int nResult = poison_ingredient( oPC, nPoison, 1 );
    object oItem;

    if ( nResult == 1) {

        if ( nNode == 15) {
            oItem = CreateItemOnObject( "ds_poi_ale", oPC, 1 , "ds_poison_"+IntToString(nPoison) );
        }
        else if ( nNode == 16) {
            oItem = CreateItemOnObject( "ds_poi_spirits", oPC, 1 , "ds_poison_"+IntToString(nPoison) );
        }
        else if ( nNode == 17) {
            oItem = CreateItemOnObject( "ds_poi_wine", oPC, 1 , "ds_poison_"+IntToString(nPoison) );
        }
        //SetLocalInt( oItem, "ds_poison", nPoison );
    }
}

string poison_name( int nPoison ){

    switch ( nPoison ) {
        case 0:     return "";              break;
        case 1:     return "Thornapple";    break;
        case 2:     return "Aconite";       break;
        case 3:     return "Poison Ivy";    break;
        case 4:     return "Calotropis";    break;
        case 5:     return "Foxglove";      break;
        case 6:     return "Stavesacre";    break;
        default:    return "";              break;
    }
    return "";

}


