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
    string sResRef      = "ds_menu_item_1";
    string sResRefNew;
    string sMenuItem;
    int nItemPrice;



    switch ( GetLocalInt( oPC, "ds_node" ) ) {

        case 01:
                sMenuItem = "Prawn Crackers";
                nItemPrice = 120;
                sResRefNew = "menu_item_1_1";
        break;

        case 02:
                sMenuItem = "Wasabi Dips";
                nItemPrice = 120;
                sResRefNew = "menu_item_1_2";
        break;

        case 03:
                sMenuItem = "Crispy Pancake Roll";
                nItemPrice = 120;
                sResRefNew = "menu_item_1_3";
        break;

        case 04:
                sMenuItem = "Hot and Sweetberry Soup";
                nItemPrice = 200;
                sResRefNew = "menu_item_1_4";
        break;

        case 05:
                sMenuItem = "Crab Meat Soup";
                nItemPrice = 210;
                sResRefNew = "menu_item_1_5";
        break;

        case 06:
                sMenuItem = "Crispy Seaweed";
                nItemPrice = 260;
                sResRefNew = "menu_item_1_6";
        break;

        case 07:
                sMenuItem = "Crispy Won Ton";
                nItemPrice = 270;
                sResRefNew = "menu_item_1_7";
        break;

        case 08:
                sMenuItem = "Aromatic Seagull";
                nItemPrice = 280;
                sResRefNew = "menu_item_1_8";
        break;

        case 09:
                sMenuItem = "Chicken Pau with Wings";
                nItemPrice = 290;
                sResRefNew = "menu_item_1_9";
        break;

        case 10:
                sMenuItem = "Sweetberry and Sour Chicken Balls";
                nItemPrice = 350;
                sResRefNew = "menu_item_1_10";
        break;

        case 11:
                sMenuItem = "Sweetberry and Sour King Prawns";
                nItemPrice = 430;
                sResRefNew = "menu_item_1_11";
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
