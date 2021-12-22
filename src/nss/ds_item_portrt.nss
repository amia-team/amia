//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_item_portrt
//group:
//used as: activation script
//date:    apr 22 2008
//author:  disco

#include "amia_include"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC       = OBJECT_SELF;
    object oItem     = GetLocalObject( oPC, "ds_target" );
    int nNode        = GetLocalInt( oPC, "ds_node" );
    int nMax         = GetLocalInt( oPC, "ds_max" );
    int nAppearance  = GetItemAppearance( oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0 );

    if ( !nNode ){

        return;
    }
    else if ( nNode == 1 ){

        nAppearance = nAppearance + 1;
    }
    else if ( nNode == 2 ){

        nAppearance = nAppearance - 1;
    }

    else if ( nNode == 3 ){

        nAppearance = nAppearance + 10;
    }

    else if ( nNode == 4 ){

        nAppearance = nAppearance - 10;
    }

    if ( nAppearance > nMax ){

        nAppearance = nMax;
    }
    else if ( nAppearance < 1 ){

        nAppearance = 1;
    }

    SetCustomToken( 4601, IntToString( nAppearance ) );
    SetCustomToken( 4602, GetName( oItem ) );
    SetCustomToken( 4603, IntToString( nMax ) );

    object oNewItem = CopyItemAndModifyFixed( oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nAppearance, TRUE );

    if ( GetIsObjectValid( oNewItem ) ){

        SetLocalObject( oPC, "ds_target", oNewItem );
        DestroyObject( oItem );
    }
}


