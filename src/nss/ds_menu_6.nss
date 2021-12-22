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
    string sResRef      = "ds_menu_item_4";
    string sResRefNew;
    string sMenuItem;
    int nItemPrice;



    switch ( GetLocalInt( oPC, "ds_node" ) ) {

        case 01:
                sMenuItem = "Sweetberry Milk";
                nItemPrice = 44;
                sResRefNew = "menu_item_6_1";
        break;

        case 02:
                sMenuItem = "Sweetberry Juice";
                nItemPrice = 44;
                sResRefNew = "menu_item_6_2";
        break;

        case 03:
                sMenuItem = "Hot Chocolate";
                nItemPrice = 44;
                sResRefNew = "menu_item_6_3";
        break;

        case 04:
                sMenuItem = "Belladee Tea";
                nItemPrice = 44;
                sResRefNew = "menu_item_6_4";
        break;

        case 05:
                sMenuItem = "Coffee";
                nItemPrice = 44;
                sResRefNew = "menu_item_6_5";
        break;

        case 06:
                sMenuItem = "Sake";
                nItemPrice = 132;
                sResRefNew = "menu_item_6_6";
        break;

        case 07:
                sMenuItem = "Wine";
                nItemPrice = 132;
                sResRefNew = "menu_item_6_7";
        break;

        case 08:
                sMenuItem = "Mead";
                nItemPrice = 132;
                sResRefNew = "menu_item_6_8";
        break;

        case 09:
                sMenuItem = "Pale Ale";
                nItemPrice = 132;
                sResRefNew = "menu_item_6_9";
        break;

        case 10:
                sMenuItem = "Spirits";
                nItemPrice = 132;
                sResRefNew = "menu_item_6_10";
        break;

        case 11:
                sMenuItem = "Iced Tea";
                nItemPrice = 132;
                sResRefNew = "menu_item_6_11";
        break;

        case 12:
                sMenuItem = "Fine Red Lager";
                nItemPrice = 132;
                sResRefNew = "menu_item_6_12";
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
