//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_j_copy_act
//group:   Jobs & crafting
//used as: convo action script
//date:    june 2010
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_j_lib"

//copies name and description from oFrom to oTo
void ds_j_CopyText( object oPLC, object oFrom, object oTo ){

    SendMessageToPC( OBJECT_SELF, "Copying name and description from "+GetName( oFrom )+" to "+GetName( oTo )+"." );

    SetName( oTo, GetName( oFrom ) );
    SetDescription( oTo, GetDescription( oFrom ) );
}

//copies name and description from oFrom to oTo
object ds_j_CopyColour( object oPLC, object oFrom, object oTo ){

    SendMessageToPC( OBJECT_SELF, "Copying colour from "+GetName( oFrom )+" to "+GetName( oTo )+"." );

    int nBaseItem     = GetBaseItemType( oTo );
    int i;
    int nColour;

    if ( nBaseItem == BASE_ITEM_ARMOR || nBaseItem == BASE_ITEM_HELMET || nBaseItem == BASE_ITEM_CLOAK ){

        for ( i=0; i<6; ++i ){

            nColour = GetItemAppearance( oFrom, ITEM_APPR_TYPE_ARMOR_COLOR, i );

            oTo = ds_j_CopyReplaceItem( oTo, ITEM_APPR_TYPE_ARMOR_COLOR, i, nColour );
        }
    }
    else if ( IPGetIsMeleeWeapon( oTo ) ){

        for ( i=0; i<3; ++i ){

            nColour = GetItemAppearance( oFrom, ITEM_APPR_TYPE_WEAPON_COLOR, i );

            oTo = ds_j_CopyReplaceItem( oTo, ITEM_APPR_TYPE_WEAPON_COLOR, i, nColour );
        }
    }

    return oTo;
}

//copies name and description from oFrom to oTo
object ds_j_CopyModel( object oPLC, object oFrom, object oTo ){

    SendMessageToPC( OBJECT_SELF, "Copying colour from "+GetName( oFrom )+" to "+GetName( oTo )+"." );

    int nBaseItem     = GetBaseItemType( oTo );
    int i;
    int nModel;

    if ( nBaseItem == BASE_ITEM_ARMOR ){

        for ( i=0; i<19; ++i ){

            nModel = GetItemAppearance( oFrom, ITEM_APPR_TYPE_ARMOR_MODEL, i );

            oTo = ds_j_CopyReplaceItem( oTo, ITEM_APPR_TYPE_ARMOR_MODEL, i, nModel );
        }
    }
    else if ( IPGetIsMeleeWeapon( oTo ) ){

        for ( i=0; i<3; ++i ){

            nModel = GetItemAppearance( oFrom, ITEM_APPR_TYPE_WEAPON_MODEL, i );

            oTo = ds_j_CopyReplaceItem( oTo, ITEM_APPR_TYPE_WEAPON_MODEL, i, nModel );
        }
    }
    else if ( nBaseItem == BASE_ITEM_HELMET ||
              nBaseItem == BASE_ITEM_LARGESHIELD ||
              nBaseItem == BASE_ITEM_SMALLSHIELD ||
              nBaseItem == BASE_ITEM_TOWERSHIELD ||
              nBaseItem == BASE_ITEM_CLOAK ){

        nModel = GetItemAppearance( oFrom, ITEM_APPR_TYPE_SIMPLE_MODEL, i );

        oTo = ds_j_CopyReplaceItem( oTo, ITEM_APPR_TYPE_SIMPLE_MODEL, i, nModel );
    }

    return oTo;
}



/*

int ITEM_APPR_ARMOR_COLOR_LEATHER1      = 0;
int ITEM_APPR_ARMOR_COLOR_LEATHER2      = 1;
int ITEM_APPR_ARMOR_COLOR_CLOTH1        = 2;
int ITEM_APPR_ARMOR_COLOR_CLOTH2        = 3;
int ITEM_APPR_ARMOR_COLOR_METAL1        = 4;
int ITEM_APPR_ARMOR_COLOR_METAL2        = 5;
int ITEM_APPR_ARMOR_NUM_COLORS          = 6;

int ITEM_APPR_ARMOR_MODEL_RFOOT         = 0;
int ITEM_APPR_ARMOR_MODEL_LFOOT         = 1;
int ITEM_APPR_ARMOR_MODEL_RSHIN         = 2;
int ITEM_APPR_ARMOR_MODEL_LSHIN         = 3;
int ITEM_APPR_ARMOR_MODEL_LTHIGH        = 4;
int ITEM_APPR_ARMOR_MODEL_RTHIGH        = 5;
int ITEM_APPR_ARMOR_MODEL_PELVIS        = 6;
int ITEM_APPR_ARMOR_MODEL_TORSO         = 7;
int ITEM_APPR_ARMOR_MODEL_BELT          = 8;
int ITEM_APPR_ARMOR_MODEL_NECK          = 9;
int ITEM_APPR_ARMOR_MODEL_RFOREARM      = 10;
int ITEM_APPR_ARMOR_MODEL_LFOREARM      = 11;
int ITEM_APPR_ARMOR_MODEL_RBICEP        = 12;
int ITEM_APPR_ARMOR_MODEL_LBICEP        = 13;
int ITEM_APPR_ARMOR_MODEL_RSHOULDER     = 14;
int ITEM_APPR_ARMOR_MODEL_LSHOULDER     = 15;
int ITEM_APPR_ARMOR_MODEL_RHAND         = 16;
int ITEM_APPR_ARMOR_MODEL_LHAND         = 17;
int ITEM_APPR_ARMOR_MODEL_ROBE          = 18;
int ITEM_APPR_ARMOR_NUM_MODELS          = 19;

int ITEM_APPR_WEAPON_MODEL_BOTTOM       = 0;
int ITEM_APPR_WEAPON_MODEL_MIDDLE       = 1;
int ITEM_APPR_WEAPON_MODEL_TOP          = 2;

int ITEM_APPR_WEAPON_COLOR_BOTTOM       = 0;
int ITEM_APPR_WEAPON_COLOR_MIDDLE       = 1;
int ITEM_APPR_WEAPON_COLOR_TOP          = 2;

*/

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC       = OBJECT_SELF;
    object oPLC      = GetLocalObject( oPC, "ds_target" );
    int nNode        = GetLocalInt( oPC, "ds_node" );
    string sTag      = GetTag( oPLC );
    string sResRef   = GetResRef( oPLC );
    int nCheck;

    object oFrom     = GetFirstItemInInventory( oPLC );
    object oTo       = GetNextItemInInventory( oPLC );

    if ( sTag == "ds_j_armouranvil" ){

        nCheck = ds_j_CopyCheck( oPC, oPLC, sTag, 53, 0 );

        if ( nCheck < 1 ){

            return;
        }


    }
    else if ( sTag == "ds_j_weaponanvil" ){

        nCheck = ds_j_CopyCheck( oPC, oPLC, sTag, 54, 0 );

        if ( nCheck < 1 ){

            return;
        }
    }
    else if ( sTag == "ds_j_tailorbench" ){

        nCheck = ds_j_CopyCheck( oPC, oPLC, sTag, 56, 0 );

        if ( nCheck < 1 ){

            return;
        }
    }
        else if ( sTag == "ds_j_jeweler" ){

        nCheck = ds_j_CopyCheck( oPC, oPLC, sTag, 57, 0 );

        if ( nCheck < 1 ){

            return;
        }
    }

    if ( nNode == 1 || nNode == 4 || nNode == 5 || nNode == 7 ){

        oTo = ds_j_CopyColour( oPLC, oFrom, oTo );
    }

    if ( nNode == 2 || nNode == 4 || nNode == 6 || nNode == 7 ){

        oTo = ds_j_CopyModel( oPLC, oFrom, oTo );
    }

    if ( nNode == 3 || nNode == 5 || nNode == 6 || nNode == 7 ){

        ds_j_CopyText( oPLC, oFrom, oTo );
    }

    if ( nNode > 0 ){

        DestroyObject( oFrom );

        CopyItemFixed( oTo, oPC );

        DestroyObject( oTo );
    }
}
