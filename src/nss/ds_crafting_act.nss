//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_crafting_act
//group: armour crafting
//used as: activation script
//date:  2008-06-06
//author: Disco

// 2010-10-27 disco            update weapon system
// 2012-02-09 Selmak           recompiled for changed chest pieces

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_crafting"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC          = OBJECT_SELF;
    object oItem;
    int nNode           = GetLocalInt( oPC, "ds_node" );
    int nItemType       = GetLocalInt( oPC, "crft_it_type" );
    int nModelType      = GetLocalInt( oPC, "crft_it_model" ) - 10;
    int nCurrentPart;
    int nPartID         = -1;
    int nOptions;
    int nNextPart;
    int nNextOption;
    int nNextIndex;
    int nOption;

    if ( nItemType == 0 && nNode < 1 && nNode > 8 ){

        //error
        DeleteLocalInt( oPC, "ds_node" );
        return;
    }
    else if ( nItemType == 0 && nNode > 0 && nNode < 10 ){

        SetLocalInt( oPC, "crft_it_type", nNode );
        nItemType = nNode;
    }
    else if ( nNode == 30 ){

        //leaving a menu
        DeleteLocalInt( oPC, "crft_it_model" );
        return;
    }

    if ( nItemType == 9 ){

        //weapon painting
        oItem           = GetCraftingItem( oPC, nItemType );

        if ( !GetIsObjectValid( oItem ) ){

            SetLocalInt( oPC, "ds_check_10", 1 );
            return;
        }

        if ( GetBaseItemType( oItem ) == BASE_ITEM_WHIP ||
             GetBaseItemType( oItem ) == BASE_ITEM_DART ||
             GetBaseItemType( oItem ) == BASE_ITEM_SHURIKEN ||
             GetBaseItemType( oItem ) == BASE_ITEM_SLING ||
             GetBaseItemType( oItem ) == 92 || //lance
             GetBaseItemType( oItem ) == 93 || //trumpet
             GetBaseItemType( oItem ) == 94 || //moononastick
             GetBaseItemType( oItem ) == 94 || //moononastick
             GetBaseItemType( oItem ) > 111 ){ //tools

            SetLocalInt( oPC, "ds_check_11", 1 );
            return;
        }

        SetLocalInt( oPC, "ds_check_4", 1 );

        nCurrentPart    = GetItemAppearance( oItem, ITEM_APPR_TYPE_WEAPON_COLOR, nModelType );

        if ( nModelType == -10 && nNode > 9 && nNode < 13 ){

            //choosing a model
            SetLocalInt( oPC, "crft_it_model", nNode );

            nModelType      = nNode - 10;

            nCurrentPart    = GetItemAppearance( oItem, ITEM_APPR_TYPE_WEAPON_COLOR, nModelType );

            FloatingTextStringOnCreature( "Current Colour: "+IntToString( nCurrentPart ), oPC, FALSE );

            return;
        }
        else if ( nModelType == -10  ){

            return;
        }
        else if ( nNode == 31 ){

            //next part
            nNextPart       = nCurrentPart + 1;

            if ( nNextPart > 4 ){

                nNextPart   = 1;
            }

            UpdateItem( oPC, oItem, ITEM_APPR_TYPE_WEAPON_COLOR, nModelType, nNextPart );
        }
        else if ( nNode == 32 ){

            //previous part
            nNextPart       = nCurrentPart - 1;

            if ( nNextPart < 1 ){

                nNextPart   = 4;
            }

            UpdateItem( oPC, oItem, ITEM_APPR_TYPE_WEAPON_COLOR, nModelType, nNextPart );
        }

        FloatingTextStringOnCreature( "Colour set to: "+IntToString( nNextPart )+"/4", oPC, FALSE );
    }
    else if ( nItemType == 8 ){

        //weapon crafting
        oItem           = GetCraftingItem( oPC, nItemType );

        if ( GetTag( oItem ) == "no_crafting" ){

            SetLocalInt( oPC, "ds_check_11", 1 );
            return;
        }

        if ( GetBaseItemType( oItem ) == BASE_ITEM_WHIP ||
             GetBaseItemType( oItem ) == BASE_ITEM_DART ||
             GetBaseItemType( oItem ) == BASE_ITEM_SHURIKEN ||
             GetBaseItemType( oItem ) == BASE_ITEM_SLING ||
             GetBaseItemType( oItem ) == BASE_ITEM_KUKRI ||
             GetBaseItemType( oItem ) == BASE_ITEM_SICKLE ||
             GetBaseItemType( oItem ) == BASE_ITEM_KAMA ||
             GetBaseItemType( oItem ) == 92 || //lance
             GetBaseItemType( oItem ) == 93 || //trumpet
             GetBaseItemType( oItem ) == 94 || //moononastick
             GetBaseItemType( oItem ) == 94 || //moononastick
             GetBaseItemType( oItem ) > 111  ){ //tools

            SetLocalInt( oPC, "ds_check_11", 1 );
            return;
        }

        if ( !GetIsObjectValid( oItem ) ){

            SetLocalInt( oPC, "ds_check_10", 1 );
            return;
        }

        SetCustomToken( 5306, "Weapon Appearance" );

        SetLocalInt( oPC, "ds_check_4", 1 );

        object oStorage = GetLocalObject( GetModule(), "ds_crft_options" );

        if ( !GetIsObjectValid( oStorage ) ){

            oStorage = CreateObject( OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation( oPC ), FALSE, "ds_crft_options" );

            SetLocalObject( GetModule(), "ds_crft_options", oStorage );
        }

        if ( nModelType == -10 && nNode > 9 && nNode < 13 ){

            //choosing a model
            SetLocalInt( oPC, "crft_it_model", nNode );

            nModelType      = nNode - 10;
            nCurrentPart    = GetItemAppearance( oItem, ITEM_APPR_TYPE_WEAPON_MODEL, nModelType );

            if ( GetLocalObject( oPC, "crft_item" ) != oItem ){

                //FloatingTextStringOnCreature( "Fee for this item: "+IntToString( 1 + ( GetGoldPieceValue( oItem ) / 10 ) ), oPC, FALSE );
                //FloatingTextStringOnCreature( "DC for this item: "+IntToString( 10 + ( GetGoldPieceValue( oItem ) / 8500 ) ), oPC, FALSE );
            }

            FloatingTextStringOnCreature( "Current Part: "+IntToString( nCurrentPart+1 ), oPC, FALSE );

            return;
        }
        else if ( nModelType == -10  ){

            return;
        }
        else if ( nNode == 31 ){

            //next part
            nNextPart       = GetNextWeaponModel( oPC, oItem, nModelType, oStorage );
        }
        else if ( nNode == 32 ){

            //previous part
            nNextPart       = GetPreviousWeaponModel( oPC, oItem, nModelType, oStorage );
        }

        UpdateItem( oPC, oItem, ITEM_APPR_TYPE_WEAPON_MODEL, nModelType, nNextPart );

        FloatingTextStringOnCreature( "Part set to: "+IntToString( nNextPart ), oPC, FALSE );
    }
    else if ( nItemType == 7 || nItemType == 3 || nItemType== 5 ){

        //cloak & helmet crafting
        //shield crafting
        oItem           = GetCraftingItem( oPC, nItemType );

        if ( !GetIsObjectValid( oItem ) ){

            SetLocalInt( oPC, "ds_check_10", 1 );
            return;
        }

        if ( nItemType == 7 ){

            SetCustomToken( 5306, "Shield Appearance" );
            nOption = GetShieldOptionFromPart( oItem, GetItemAppearance( oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0 ) );
        }
        else if ( nItemType == 3 ){

            SetCustomToken( 5306, "Cloak Appearance" );
            nOption = GetCloakOptionFromPart( oItem, GetItemAppearance( oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0 ) );
        }
        else{

            SetCustomToken( 5306, "Helmet Appearance" );
            nOption = GetHelmetOptionFromPart( oItem, GetItemAppearance( oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0 ) );
        }

        nOptions = GetSimpleModelOptions( oItem, nItemType );

        SetLocalInt( oPC, "ds_check_2", 1 );
        SetLocalInt( oPC, "ds_check_3", 1 );

        if ( nNode < 31 ){

            //FloatingTextStringOnCreature( "Fee for this item: "+IntToString( 1 + ( GetGoldPieceValue( oItem ) / 10 ) ), oPC, FALSE );
            //FloatingTextStringOnCreature( "DC for this item: "+IntToString( 10 + ( GetGoldPieceValue( oItem ) / 8500 ) ), oPC, FALSE );
            FloatingTextStringOnCreature( "Current Part: "+IntToString( nOption ), oPC, FALSE );
            return;
        }

        if ( nNode == 31 ){

            //next part
            nNextOption       = nOption + 1;

            if ( nNextOption > nOptions ){

                nNextOption   = 1;
            }
        }
        else if ( nNode == 32 ){

            //previous part
            nNextOption       = nOption - 1;

            if ( nNextOption < 1 ){

                nNextOption   = nOptions;
            }
        }
        else if ( nNode == 33 ){

            //previous part
            nNextOption       = nOption + 5;

            if ( nNextOption > nOptions ){

                nNextOption   = nNextOption - nOptions;
            }
        }
        else if ( nNode == 34 ){

            //previous part
            nNextOption       = nOption - 5;

            if ( nNextOption < 1 ){

                nNextOption   = nOptions + nNextOption;
            }
        }
        else{

            return;
        }

        if ( nItemType == 7 ){

            nNextPart = GetShieldPartFromOption( oItem, nNextOption );
        }
        else if ( nItemType == 3 ){

            nNextPart = GetCloakPartFromOption( oItem, nNextOption );
        }
        else{

            nNextPart = GetHelmetPartFromOption( oItem, nNextOption );
        }

        UpdateItem( oPC, oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nNextPart );

        FloatingTextStringOnCreature( "Model set to: "+IntToString( nNextOption )+"/"+IntToString( nOptions ), oPC, FALSE );
    }
    else if ( nItemType == 2 || nItemType == 4 || nItemType == 6  ){

        //armour, cloak & helmet painting
        oItem           = GetCraftingItem( oPC, nItemType );

        if ( !GetIsObjectValid( oItem ) ){

            SetLocalInt( oPC, "ds_check_10", 1 );
            return;
        }

        nCurrentPart    = GetItemAppearance( oItem, ITEM_APPR_TYPE_ARMOR_COLOR, nModelType );


        SetLocalInt( oPC, "ds_check_3", 1 );

        if ( nModelType == -10 && nNode > 9 && nNode < 16 ){

            //choosing a model
            SetLocalInt( oPC, "crft_it_model", nNode );

            nModelType      = nNode - 10;
            nCurrentPart    = GetItemAppearance( oItem, ITEM_APPR_TYPE_ARMOR_COLOR, nModelType );

            FloatingTextStringOnCreature( "Current Colour type: "+GetColourTypeName( nModelType ), oPC, FALSE );
            FloatingTextStringOnCreature( "Current Colour: "+DyeName( nCurrentPart, nModelType )+" ("+IntToString( nCurrentPart )+")", oPC, FALSE );
            return;
        }
        else if ( nModelType == -10  ){

            return;
        }
        else if ( nNode == 31 ){

            //next part
            nNextPart       = nCurrentPart + 1;

            if ( nNextPart > 175 ){

                nNextPart   = 0;
            }
        }
        else if ( nNode == 32 ){

            //previous part
            nNextPart       = nCurrentPart - 1;

            if ( nNextPart < 0 ){

                nNextPart   = 175;
            }
        }
        else if ( nNode == 33 ){

            //previous part
            nNextPart       = nCurrentPart + 10;

            if ( nNextPart > 175 ){

                nNextPart   = 1 + ( nNextPart - 174 );
            }
        }
        else if ( nNode == 34 ){

            //previous part
            nNextPart       = nCurrentPart - 10;

            if ( nNextPart < 0 ){

                nNextPart   = 175 + nNextPart;
            }
        }
        else if ( nNode == 35 ){

            //previous part
            nNextPart       = nCurrentPart + 50;

            if ( nNextPart > 175 ){

                nNextPart   = nNextPart - 175;
            }
        }
        else if ( nNode == 36 ){

            //previous part
            nNextPart       = nCurrentPart - 50;

            if ( nNextPart < 0 ){

                nNextPart   = 175 + nNextPart;
            }
        }

        UpdateItem( oPC, oItem, ITEM_APPR_TYPE_ARMOR_COLOR, nModelType, nNextPart );

        FloatingTextStringOnCreature( "Current Colour type: "+GetColourTypeName( nModelType ), oPC, FALSE );
        FloatingTextStringOnCreature( "Colour set to: "+DyeName( nNextPart, nModelType )+" ("+IntToString( nNextPart )+")", oPC, FALSE );
    }
    else if ( nItemType == 1 ){

        //armour crafting
        oItem           = GetCraftingItem( oPC, nItemType );
        nCurrentPart    = GetItemAppearance( oItem, ITEM_APPR_TYPE_ARMOR_MODEL, nModelType );

        if ( !GetIsObjectValid( oItem ) ){

            SetLocalInt( oPC, "ds_check_10", 1 );
            return;
        }


        SetLocalInt( oPC, "ds_check_1", 1 );
        SetLocalInt( oPC, "ds_check_3", 1 );

        if ( nModelType == -10 && nNode > 9 && nNode < 29 ){

            //choosing a model
            SetLocalInt( oPC, "crft_it_model", nNode );

            nModelType      = nNode - 10;
            nCurrentPart    = GetItemAppearance( oItem, ITEM_APPR_TYPE_ARMOR_MODEL, nModelType );
            nOptions        = GetArmourOptions( nCurrentPart, nModelType );

            if ( GetLocalObject( oPC, "crft_item" ) != oItem ){

                //FloatingTextStringOnCreature( "Fee for this item: "+IntToString( 1 + ( GetGoldPieceValue( oItem ) / 10 ) ), oPC, FALSE );
                //FloatingTextStringOnCreature( "DC for this item: "+IntToString( 10 + ( GetGoldPieceValue( oItem ) / 8500 ) ), oPC, FALSE );
            }

            FloatingTextStringOnCreature( "Current part: "+IntToString( GetArmourOptionFromPart( nCurrentPart, GetArmourOptionType( nModelType ) ) ), oPC, FALSE );

            SetCustomToken( 5306, GetArmourModelName( nModelType ) );

            return;
        }
        else if ( nModelType == -10  ){

            return;
        }
        else if ( nNode == 31 ){

            //next part
            nNextPart       = GetNextArmourPart( nModelType, nCurrentPart );
        }
        else if ( nNode == 32 ){

            //previous part
            nNextPart       = GetPrevArmourPart( nModelType, nCurrentPart );
        }
        else if ( nNode == 33 ){

            //previous part
            nNextPart       = GetNextArmourPart( nModelType, nCurrentPart, 5 );
        }
        else if ( nNode == 34 ){

            //previous part
            nNextPart       = GetPrevArmourPart( nModelType, nCurrentPart, 5 );
        }

        if ( nNextPart > -1 ){

            UpdateItem( oPC, oItem, ITEM_APPR_TYPE_ARMOR_MODEL, nModelType, nNextPart );
        }

        SetCustomToken( 5306, GetArmourModelName( nModelType ) );

        nOption  = GetArmourOptionFromPart( nNextPart, GetArmourOptionType( nModelType ) );
        nOptions = GetArmourOptions( nCurrentPart, nModelType );

        FloatingTextStringOnCreature( "Current part: "+IntToString( nOption )+"("+IntToString( nOptions )+")", oPC, FALSE );
    }
}
