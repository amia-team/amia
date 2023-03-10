/*
  Job System Item Refresh Script - Converts the old, larger Job System PLCs into smaller counterparts

  - Lord-Jyssev
*/


void main()
{
    object oInContainer = GetFirstItemInInventory( OBJECT_SELF );
    object oPC          = GetLastClosedBy();
    object oRefreshedItem;
    string sItemResRef;
    string sName;
    string sMaterial;
    string sType;
    string sWeaponResRef;
    int nWeaponMaterial;
    int nArmorMaterial;
    int nStackSize;
    int nRefreshedItem;

    while (GetIsObjectValid( oInContainer ) == TRUE)
    {
        sItemResRef            = GetResRef(oInContainer);


        //Replace old Artificer storage items and grab the amounts/item types stored
        if( sItemResRef == "ds_j_mythalbox" ||
            sItemResRef == "ds_j_wandcase" ||
            sItemResRef == "ds_j_scrollbox" ||
            sItemResRef == "ds_j_gempouch" ||
            sItemResRef == "ds_j_bandagebox" ||
           (sItemResRef == "js_arca_trca" && GetBaseItemType(oInContainer) == BASE_ITEM_MISCMEDIUM))
        {
            sName               = GetName(oInContainer);
            string sReplaceItem;
            string sStoredItem  = GetDescription( oInContainer, FALSE, FALSE );
            int nStoredCount;

            if(sItemResRef == "ds_j_mythalbox") //Mythal Tube
            {
                sReplaceItem = "js_arca_mytu";
                nStoredCount = StringToInt( GetSubString( GetDescription( oInContainer ), 19, 6 ) );
            }
            if(sItemResRef == "ds_j_wandcase") //Wand Case
            {
                sReplaceItem = "js_arca_wdca";
                nStoredCount = StringToInt( GetSubString( GetDescription( oInContainer ), 16, 6 ) );
            }
            if(sItemResRef == "ds_j_scrollbox") //Scroll Box
            {
                sReplaceItem = "js_arca_scbx";
                nStoredCount = StringToInt( GetSubString( GetDescription( oInContainer ), 18, 6 ) );
            }
            if(sItemResRef == "ds_j_gempouch") //Gem Pouch
            {
                sReplaceItem = "js_arca_gmpo";
                nStoredCount = StringToInt( GetSubString( GetDescription( oInContainer ), 16, 6 ) );
            }
            if(sItemResRef == "ds_j_bandagebox") //Bandage Bag
            {
                sReplaceItem = "js_arca_bdbg";
                nStoredCount = StringToInt( GetSubString( GetDescription( oInContainer ), 20, 6 ) );
            }
            if(sItemResRef == "js_arca_trca") //Trap Case
            {
                sReplaceItem = "js_arca_trca";
                nStoredCount = StringToInt( GetSubString( GetDescription( oInContainer ), 16, 6 ) );
            }

            //Replace the old item with the new job system version
            oRefreshedItem = CreateItemOnObject(sReplaceItem, OBJECT_SELF, 1);

            string sDescription = GetDescription(oRefreshedItem);

            SetName(oRefreshedItem, "<c~Îë>"+sName+"</c>");
            SetDescription( oRefreshedItem, "Number of stored items: "+IntToString(nStoredCount) +"\n\n"+sDescription);

            //Set variables for item counts and refreshed item
            SetLocalString(oRefreshedItem, "StoredItem", sStoredItem);
            SetLocalInt(oRefreshedItem, "ItemCount", nStoredCount);
            if(nRefreshedItem != 0)     { SetLocalInt(oRefreshedItem, "RefreshedItem", 1); }

            //Delete the old item
            DestroyObject( oInContainer, 0.1 );
        }
        //Replacement for old tailor Backpack, Scabbard, and Quiver
        else if( sItemResRef == "ds_j_scabbard" ||
                 sItemResRef == "ds_j_scabbard_a" ||
                 sItemResRef == "ds_j_scabbard_b" ||
                 sItemResRef == "ds_j_backpack" ||
                 sItemResRef == "ds_j_backpack_1" ||
                 sItemResRef == "ds_j_quiver" )
        {
            string sReplaceItem;

            if      ( sItemResRef == "ds_j_scabbard") { sReplaceItem = "js_tai_scbrd1"; }
            else if ( sItemResRef == "ds_j_scabbard_a") { sReplaceItem = "js_tai_scbrd2"; }
            else if ( sItemResRef == "ds_j_scabbard_b") { sReplaceItem = "js_tai_scbrd3"; }
            else if ( sItemResRef == "ds_j_backpack") { sReplaceItem = "js_tai_bpack1"; }
            else if ( sItemResRef == "ds_j_backpack_1") { sReplaceItem = "js_tai_bpack1"; }
            else if ( sItemResRef == "ds_j_quiver") { sReplaceItem = "js_tai_quiver1"; }

            oRefreshedItem = CreateItemOnObject(sReplaceItem, OBJECT_SELF, 1);
            if(nRefreshedItem != 0)     { SetLocalInt(oRefreshedItem, "RefreshedItem", 1); }

            //Delete the old item
            DestroyObject( oInContainer, 0.1 );
        }
        // Disallow equipable items that allow properties/mythal crafting, new storage items, and non-job items
        else if(     GetSubString(sItemResRef, 0, 3) != "js_"
             || sItemResRef == "js_arch_adbt"
             || sItemResRef == "js_arch_irbt"
             || sItemResRef == "js_arch_sibt"
             || sItemResRef == "js_arch_stbt"
             || sItemResRef == "js_arch_adbu"
             || sItemResRef == "js_arch_irbu"
             || sItemResRef == "js_arch_sibu"
             || sItemResRef == "js_arch_stbu"
             || sItemResRef == "js_arch_adar"
             || sItemResRef == "js_arch_irar"
             || sItemResRef == "js_arch_siar"
             || sItemResRef == "js_arch_star"
             || sItemResRef == "js_arch_cbow"
             || sItemResRef == "js_arch_lbow"
             || sItemResRef == "js_arch_bow"
             || sItemResRef == "js_arch_sbow"
             || sItemResRef == "js_arca_bdbg"
             || sItemResRef == "js_arca_gmpo"
             || sItemResRef == "js_arca_mytu"
             || sItemResRef == "js_arca_scbx"
             || sItemResRef == "js_arca_trca"
             || sItemResRef == "js_arca_wdca"
             || GetSubString(sItemResRef, 0, 9) == "js_jew_am"
             || GetSubString(sItemResRef, 0, 9) == "js_jew_ri"
             || GetSubString(sItemResRef, 0, 9) == "js_bla_we"
             || GetSubString(sItemResRef, 0, 9) == "js_bla_ar"
             || GetSubString(sItemResRef, 0, 9) == "js_bla_sh"
             || sItemResRef == "js_bla_helm"
             || sItemResRef == "js_bla_grea"
             || sItemResRef == "js_bla_brac" )
        {
            sName = GetName(oInContainer);
            SendMessageToPC(oPC, "<cþ  >" + sName + " cannot be refreshed.</c>");
        }
        else if( GetSubString(sItemResRef, 0, 3) == "js_")
        {
            //Grab all the necessary details, including name and associated variables
            sName              = GetName(oInContainer);
            sMaterial          = GetLocalString(oInContainer, "material");
            sType              = GetLocalString(oInContainer, "plc");
            sWeaponResRef      = GetLocalString(oInContainer, "weapon");
            nWeaponMaterial    = GetLocalInt(oInContainer, "material");
            nArmorMaterial     = GetLocalInt(oInContainer, "armormaterial");
            nStackSize         = GetNumStackedItems(oInContainer);
            nRefreshedItem     = GetLocalInt(oInContainer, "RefreshedItem");

            //Recreate the item
            oRefreshedItem = CreateItemOnObject(sItemResRef, OBJECT_SELF, nStackSize);

            SetName(oRefreshedItem, sName);

            //Check if variables aren't null and set them on the new item
            if(sMaterial != "")         { SetLocalString(oRefreshedItem, "material", sMaterial); }
            if(sType != "")             { SetLocalString(oRefreshedItem, "plc", sType); }
            if(sWeaponResRef != "")     { SetLocalString(oRefreshedItem, "weapon", sWeaponResRef); }
            if(nWeaponMaterial != 0)    { SetLocalInt(oRefreshedItem, "material", nWeaponMaterial); }
            if(nArmorMaterial != 0)     { SetLocalInt(oRefreshedItem, "armormaterial", nArmorMaterial); }
            if(nRefreshedItem != 0)     { SetLocalInt(oRefreshedItem, "RefreshedItem", 1); }

            //Delete the old item
            DestroyObject( oInContainer, 0.1 );
        }
        else if (sItemResRef == "nw_it_gem008" || // Sapphire
                 sItemResRef == "nw_it_gem006" || // Ruby
                 sItemResRef == "nw_it_gem012" || //Emerald
                 sItemResRef == "nw_it_gem005" ) // Diamond
               {
                    string sReplaceItem;
                    sName = GetName(oInContainer);
                    nStackSize = GetNumStackedItems(oInContainer);

                    if      ( sItemResRef == "nw_it_gem008" && sName == "Sapphire") { sReplaceItem = "js_jew_sapp"; }
                    else if ( sItemResRef == "nw_it_gem006" && sName == "Ruby")     { sReplaceItem = "js_jew_ruby"; }
                    else if ( sItemResRef == "nw_it_gem012" && sName == "Emerald")  { sReplaceItem = "js_jew_emer"; }
                    else if ( sItemResRef == "nw_it_gem005" && sName == "Diamond")  { sReplaceItem = "js_jew_diam"; }

                    oRefreshedItem = CreateItemOnObject(sReplaceItem, OBJECT_SELF, nStackSize);

                    //Delete the old item
                    DestroyObject( oInContainer, 0.1 );
                }

        if(GetLocalInt(GetNextItemInInventory( OBJECT_SELF ), "RefreshedItem") != 1)
        {
            oInContainer = GetNextItemInInventory( OBJECT_SELF );
        }
        else
        {
            break;
        }
    }

}
