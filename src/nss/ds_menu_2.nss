/*  ds_menu_set_#

    --------
    Verbatim
    --------
    Creates menu items for the Okappa restaurant

    ---------
    Changelog
    ---------

    Date      Name        Reason
    ------------------------------------------------------------------
    22-10-06  Disco       Start of header
    07-07-13  PoS         Fixed gold stacking issue
    ------------------------------------------------------------------


*/

void main(){

    object oPC          = OBJECT_SELF;
    object oWaiter      = GetObjectByTag( "ds_waiter" );
    string sResRef      = "ds_menu_item_2";
    string sResRefNew;
    string sMenuItem;
    int nItemPrice;



    switch ( GetLocalInt( oPC, "ds_node" ) ) {

        case 01:
                sMenuItem = "Baked Potato Chips";
                nItemPrice = 135;
                sResRefNew = "menu_item_2_1";
        break;

        case 02:
                sMenuItem = "Boiled Rice";
                nItemPrice = 150;
                sResRefNew = "menu_item_2_2";
        break;

        case 03:
                sMenuItem = "Egg Fried Rice";
                nItemPrice = 200;
                sResRefNew = "menu_item_2_3";
        break;

        case 04:
                sMenuItem = "Plain Omelette";
                nItemPrice = 220;
                sResRefNew = "menu_item_2_4";
        break;

        case 05:
                sMenuItem = "Bean Sprouts Chow Mein";
                nItemPrice = 230;
                sResRefNew = "menu_item_2_5";
        break;

        case 06:
                sMenuItem = "Beef Fried Rice";
                nItemPrice = 280;
                sResRefNew = "menu_item_2_6";
        break;

        case 07:
                sMenuItem = "Mixed Vegetabled Fried Rice";
                nItemPrice = 280;
                sResRefNew = "menu_item_2_7";
        break;

        case 08:
                sMenuItem = "Chicken Fried Rice";
                nItemPrice = 280;
                sResRefNew = "menu_item_2_8";
        break;

        case 09:
                sMenuItem = "Mushroom Foo Yung";
                nItemPrice = 280;
                sResRefNew = "menu_item_2_9";
        break;

        case 10:
                sMenuItem = "Lo Ho Cai Vegetables";
                nItemPrice = 280;
                sResRefNew = "menu_item_2_10";
        break;

        case 11:
                sMenuItem = "Stir Fried To Fu";
                nItemPrice = 290;
                sResRefNew = "menu_item_2_11";
        break;

        case 12:
                sMenuItem = "Special Foo Yung";
                nItemPrice = 300;
                sResRefNew = "menu_item_2_12";
        break;

        case 13:
                sMenuItem = "Cockatrice Foo Yung";
                nItemPrice = 300;
                sResRefNew = "menu_item_2_13";
        break;

        case 14:
                sMenuItem = "Beef Chow Mein";
                nItemPrice = 300;
                sResRefNew = "menu_item_2_14";
        break;

        default:

                sMenuItem = "";
                nItemPrice = 0;
        break;

    }

    if (  sMenuItem!="" && nItemPrice >0 ){

        object oItem = CreateItemOnObject( sResRef, oPC, 1, sResRefNew );
        SetName( oItem, sMenuItem );
        TakeGoldFromCreature( nItemPrice, oPC, TRUE );
        AssignCommand( oWaiter, ActionSpeakString( "Your "+sMenuItem + ", Honourable Customer." ) );

    }


}
