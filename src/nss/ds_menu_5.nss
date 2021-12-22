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
    string sResRef      = "ds_menu_item_3";
    string sResRefNew;
    string sMenuItem;
    int nItemPrice;



    switch ( GetLocalInt( oPC, "ds_node" ) ) {

        case 01:
                sMenuItem = "Apple Pie";
                nItemPrice = 120;
                sResRefNew = "menu_item_5_1";
        break;

        case 02:
                sMenuItem = "Chocolate Fudge Cake";
                nItemPrice = 165;
                sResRefNew = "menu_item_5_2";
        break;

        case 03:
                sMenuItem = "Strawberry Cheese Cake";
                nItemPrice = 165;
                sResRefNew = "menu_item_5_3";
        break;

        case 04:
                sMenuItem = "Iced Cupcakes";
                nItemPrice = 290;
                sResRefNew = "menu_item_5_4";
        break;

        case 05:
                sMenuItem = "Gelatinous Cube Jelly";
                nItemPrice = 300;
                sResRefNew = "menu_item_5_5";
        break;

        case 06:
                sMenuItem = "Iced Cream with Strawberry / Apple / Sweetberry Flavour";
                nItemPrice = 395;
                sResRefNew = "menu_item_5_6";
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
