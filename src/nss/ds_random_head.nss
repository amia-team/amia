void main(){

    //random head
    int nHead   = d20();
    int nGender = GetGender( OBJECT_SELF );
    string sName;

    if ( nGender == GENDER_MALE ){

        sName = RandomName( NAME_LAST_HUMAN );

        if ( nHead == 20 ){

            nHead = 21;
        }
    }
    else{

        sName = RandomName( NAME_LAST_HUMAN );

        if ( nHead == 14 || nHead == 18 ){

            nHead = 22;
        }
    }

    sName = GetName( OBJECT_SELF ) + " " + sName ;

    //SetName
    SetName( OBJECT_SELF, sName );

    //set head
    SetCreatureBodyPart( CREATURE_PART_HEAD, nHead, OBJECT_SELF );

    //unequip items
    if ( GetResRef( OBJECT_SELF ) == "cordoriangaurd" ){
        if ( d2() == 1 ){

            ActionUnequipItem( GetItemInSlot( INVENTORY_SLOT_HEAD , OBJECT_SELF ) );
        }
        if ( d2() == 1 ){

            ActionUnequipItem( GetItemInSlot( INVENTORY_SLOT_CLOAK , OBJECT_SELF ) );
        }
        if ( d3() == 1 ){

            ActionEquipItem( GetItemPossessedBy( OBJECT_SELF, "NW_WPLMHB010" ), INVENTORY_SLOT_RIGHTHAND );
            return;
        }
        if ( d2() == 1 ){

            ActionEquipItem( GetItemPossessedBy( OBJECT_SELF, "NW_WBWMXH008" ), INVENTORY_SLOT_RIGHTHAND );
        }

        return;
    }

    if ( GetResRef( OBJECT_SELF ) == "knightoftheetern" ){

        if ( d2() == 1 ){

            ActionUnequipItem( GetItemInSlot( INVENTORY_SLOT_HEAD , OBJECT_SELF ) );
        }
        if ( d2() == 1 ){

            ActionUnequipItem( GetItemInSlot( INVENTORY_SLOT_CLOAK , OBJECT_SELF ) );
        }
        if ( d2() == 1 ){

            ActionEquipItem( GetItemPossessedBy( OBJECT_SELF, "NW_WBLMHW010" ), INVENTORY_SLOT_RIGHTHAND );
        }

        return;
    }
    if ( GetResRef( OBJECT_SELF ) == "kohlingentrooper" ){

        if ( d2() == 1 ){

            ActionUnequipItem( GetItemInSlot( INVENTORY_SLOT_HEAD , OBJECT_SELF ) );
        }
        if ( d2() == 1 ){

            ActionUnequipItem( GetItemInSlot( INVENTORY_SLOT_CLOAK , OBJECT_SELF ) );
        }
        if ( d2() == 1 ){

            ActionEquipItem( GetItemPossessedBy( OBJECT_SELF, "NW_WPLMHB010" ), INVENTORY_SLOT_RIGHTHAND );
        }

        return;
    }


}

