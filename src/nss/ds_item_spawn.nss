//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_item_spawn
//group:
//used as: action script
//date:    apr 02 2008
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void RestoreItem( object oPC, string sItemKey, int nItems );


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC      = OBJECT_SELF;
    object oItem    = GetLocalObject( oPC, "ds_target" );
    int nNode       = GetLocalInt( oPC, "ds_node" );
    string sItemKey = GetLocalString( oItem, "is_key" );
    int nItems      = 1;
    int nIndex      = nNode;



    if ( !nNode ){

        return;
    }
    else if ( nNode > 10 ){

        nItems = 5;
        nIndex = nNode - 10;
    }
    else if ( nNode > 20 ){

        nItems = 10;
        nIndex = nNode - 20;
    }

    sItemKey = sItemKey + "_" + IntToString( nIndex );

    RestoreItem( oPC, sItemKey, nItems );

    //clear vars

}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void RestoreItem( object oPC, string sItemKey, int nItems ){

    string sQuery = "SELECT item_data FROM object_storage WHERE item_key = '" + sItemKey + "' LIMIT 1";

    //execute
    SetLocalString( GetModule(), "NWNX!ODBC!SETSCORCOSQL", sQuery );

    //sql hooks into BioWare campaign DB stuff
    object oItem  =  RetrieveCampaignObject ("NWNX", "-", GetLocation( oPC ), oPC );

    int nFee      = FloatToInt( GetGoldPieceValue( oItem ) / 1.5 ) * nItems;

    //take gold
    TakeGoldFromCreature( nFee, oPC, TRUE );

    if ( nItems > 1 ){

        int i;

        for ( i=1; i<nItems; ++i ){

            CopyItemFixed( oItem, oPC, TRUE );
        }
    }
}

