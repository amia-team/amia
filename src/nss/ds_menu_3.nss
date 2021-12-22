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
                sMenuItem = "Vermicelli with Sweetberry Sauce";
                nItemPrice = 350;
                sResRefNew = "menu_item_3_1";
        break;

        case 02:
                sMenuItem = "Stir Fried Pak Choi";
                nItemPrice = 350;
                sResRefNew = "menu_item_3_2";
        break;

        case 03:
                sMenuItem = "King Prawns Fried Rice";
                nItemPrice = 360;
                sResRefNew = "menu_item_3_3";
        break;

        case 04:
                sMenuItem = "Lemon Chicken";
                nItemPrice = 360;
                sResRefNew = "menu_item_3_4";
        break;

        case 05:
                sMenuItem = "King Pu Chicken";
                nItemPrice = 360;
                sResRefNew = "menu_item_3_5";
        break;

        case 06:
                sMenuItem = "Chicken with Oyster Sauce";
                nItemPrice = 360;
                sResRefNew = "menu_item_3_6";
        break;

        case 07:
                sMenuItem = "Gui-Fei Chicken";
                nItemPrice = 360;
                sResRefNew = "menu_item_3_7";
        break;

        case 08:
                sMenuItem = "Satay Beef";
                nItemPrice = 360;
                sResRefNew = "menu_item_3_8";
        break;

        case 09:
                sMenuItem = "Beef with Mushroom and Bamboo Shoots";
                nItemPrice = 360;
                sResRefNew = "menu_item_3_9";
        break;

        case 10:
                sMenuItem = "Mushroom with Cockatrice, Beef or Prawn";
                nItemPrice = 360;
                sResRefNew = "menu_item_3_10";
        break;

        case 11:
                sMenuItem = "Chicken with Mixed Vegetables";
                nItemPrice = 360;
                sResRefNew = "menu_item_3_11";
        break;

        case 12:
                sMenuItem = "King Prawn Omelette";
                nItemPrice = 400;
                sResRefNew = "menu_item_3_12";
        break;

        case 13:
                sMenuItem = "Chicken Chow Mein";
                nItemPrice = 400;
                sResRefNew = "menu_item_3_13";
        break;

        case 14:
                sMenuItem = "Roast Gull in Special Sauce";
                nItemPrice = 430;
                sResRefNew = "menu_item_3_14";
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
