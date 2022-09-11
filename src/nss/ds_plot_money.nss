//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_plot_money
//group:
//used as: OnUse and action script
//date:    june 25 2007
//author:  disco


//-----------------------------------------------------------------------------
// changes
//-----------------------------------------------------------------------------


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"
#include "inc_ds_actions"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
int CreateItemList( object oPC );
int GetPlotItemPrice( object oPC, object oItem );


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){


    object oPC      = GetPCSpeaker();

    if ( oPC == OBJECT_INVALID ){

        oPC = OBJECT_SELF;
    }

    int nNode       = GetLocalInt( oPC, "ds_node" );
    object oItem    = GetLocalObject( oPC, "ds_item_" + IntToString( nNode ) );
    int i           = 0;

    //clean variables
    clean_vars( oPC, 4 );

    //set action script
    SetLocalString( oPC, "ds_action", "ds_plot_money" );

    //list or sell
    if ( nNode > 0 && nNode < 11 ){

        //sell item
        int nValue      = GetPlotItemPrice( oPC, oItem );

        if ( nValue && GetItemPossessor( oItem ) == oPC ){

            GiveGoldToCreature( oPC, nValue );

            DestroyObject( oItem );
        }
    }
    else{

        //make item list
        CreateItemList( oPC );
    }
}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

int CreateItemList( object oPC ){

    object oItem    = GetFirstItemInInventory( oPC );
    string sCustom  = "";
    int nCustom     = 4200;
    int nValue      = 0;
    int i;
    int n;

    while ( GetIsObjectValid( oItem ) == TRUE ) {

        nValue = GetPlotItemPrice( oPC, oItem );

        if ( nValue > 0 ){

            ++nCustom;
            ++n;

            sCustom = "Sell " + GetName( oItem ) + " (" + IntToString( GetItemCharges( oItem ) ) + " charges) for " + IntToString( nValue ) + " GP";

            SetCustomToken( nCustom, sCustom );

            SetLocalInt( oPC, "ds_check_" + IntToString( n ), 1 );
            SetLocalObject( oPC, "ds_item_" + IntToString( n ), oItem );
        }

        oItem = GetNextItemInInventory( oPC );
    }

    if ( nCustom > 4200 ){

        SetLocalInt( oPC, "ds_check_11", 1 );
    }
    else{

        SpeakString( "You have nothing that I am interested in right now!" );
    }

    return 1;

}

int GetPlotItemPrice( object oPC, object oItem ){

    string sTag = GetTag( oItem );
    int nValue;

    if( sTag == "BonksLoinCloth" ||
        sTag == "ChieftonsBattleDrum" ||
        sTag == "FireChieftonsBelt" ||
        sTag == "MaximussLegBone" ||
        sTag == "XavierBoneShield" ||
        sTag == "SpiderWebbingBag" ||
        sTag == "cs_bunded_flmstf" ||
        sTag == "AngelsFolly" ||
        sTag == "HighOrcGauntlets" ||
        sTag == "DaedalussRage" ||
        sTag == "qst_trex" ){

        if ( GetPlotFlag( oItem ) == TRUE ){

            SetPlotFlag( oItem, FALSE );
            nValue = GetGoldPieceValue( oItem );
            SetPlotFlag( oItem, TRUE );
        }
        else{

            nValue = GetGoldPieceValue( oItem );
        }

        if (  GetHasInventory( oItem ) ){

            if ( GetFirstItemInInventory( oItem ) != OBJECT_INVALID ){

                return 0;
            }
        }

        if ( nValue > 100000 ){

            nValue = 100000;
        }

        return nValue/10;
    }
    return 0;

}
