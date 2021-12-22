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
                sMenuItem = "Satay Squid";
                nItemPrice = 410;
                sResRefNew = "menu_item_4_1";
        break;

        case 02:
                sMenuItem = "Sushi Gei-Fei";
                nItemPrice = 410;
                sResRefNew = "menu_item_4_2";
        break;

        case 03:
                sMenuItem = "Fugu Gei-Fei";
                nItemPrice = 410;
                sResRefNew = "menu_item_4_3";
        break;

        case 04:
                sMenuItem = "Squid with Ginger and Spring Onions";
                nItemPrice = 410;
                sResRefNew = "menu_item_4_4";
        break;

        case 05:
                sMenuItem = "Goblin Shark in Sweetberry and Sour Sauce";
                nItemPrice = 440;
                sResRefNew = "menu_item_4_5";
        break;

        case 06:
                sMenuItem = "Mako Shark in Special Sauce";
                nItemPrice = 440;
                sResRefNew = "menu_item_4_6";
        break;

        case 07:
                sMenuItem = "King Pu King Prawns";
                nItemPrice = 440;
                sResRefNew = "menu_item_4_7";
        break;

        case 08:
                sMenuItem = "Hammerhead Shark in Ginger and Spring Onions";
                nItemPrice = 440;
                sResRefNew = "menu_item_4_8";
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
