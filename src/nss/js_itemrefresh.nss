/*
  Job System Item Refresh Script - Converts the old, larger Job System PLCs into smaller counterparts

  - Lord-Jyssev



*/

#include "x2_inc_switches"
#include "inc_ds_records"
#include "x0_i0_campaign"
#include "inc_td_itemprop"


void main()
{
    object oInContainer = GetFirstItemInInventory( OBJECT_SELF );
    object oPC          = GetLastClosedBy();
    string sItemResRef;

    SetLockKeyRequired(OBJECT_SELF, TRUE);

    while (GetIsObjectValid( oInContainer ) == TRUE)
    {
        sItemResRef     = GetResRef(oInContainer);

        // Disallow job items that allow properties/mythal crafting
        if(GetSubString(sItemResRef, 0, 3) == "js_" &&
                       ( sItemResRef != "js_arch_adbt"
                      || sItemResRef != "js_arch_irbt"
                      || sItemResRef != "js_arch_sibt"
                      || sItemResRef != "js_arch_stbt"
                      || sItemResRef != "js_arch_adbu"
                      || sItemResRef != "js_arch_irbu"
                      || sItemResRef != "js_arch_sibu"
                      || sItemResRef != "js_arch_stbu"
                      || sItemResRef != "js_arch_adar"
                      || sItemResRef != "js_arch_irar"
                      || sItemResRef != "js_arch_siar"
                      || sItemResRef != "js_arch_star"
                      || sItemResRef != "js_arch_cbow"
                      || sItemResRef != "js_arch_lbow"
                      || sItemResRef != "js_arch_bow"
                      || sItemResRef != "js_arch_sbow"
                      || sItemResRef != "js_jew_amul"
                      || sItemResRef != "js_jew_ring"
                      || GetSubString(sItemResRef, 0, 9) != "js_bla_we"
                      || GetSubString(sItemResRef, 0, 9) != "js_bla_ar"
                      || GetSubString(sItemResRef, 0, 9) != "js_bla_sh"
                      || sItemResRef != "js_bla_helm"
                      || sItemResRef != "js_bla_grea"
                      || sItemResRef != "js_bla_brac" ))
        {
            //Grab all the necessary details, including Name, Description, and variables
            string sName              = GetName(oInContainer);
            //string sDescription       = GetDescription(oInContainer);
            string sMaterial          = GetLocalString(oInContainer, "material");
            string sType              = GetLocalString(oInContainer, "plc");
            string sWeaponResRef      = GetLocalString(oInContainer, "weapon");
            int nWeaponMaterial       = GetLocalInt(oInContainer, "material");
            int nArmorMaterial        = GetLocalInt(oInContainer, "armormaterial");
            int nStackSize            = GetNumStackedItems(oInContainer);
            int nRefreshedItem        = GetLocalInt(oInContainer, "RefreshedItem");

            SendMessageToPC(oPC, "sName = "+sName);                                    ///
            SendMessageToPC(oPC, "sMaterial = "+sMaterial);                            ///
            SendMessageToPC(oPC, "sType = "+sType);                                    ///
            SendMessageToPC(oPC, "sWeaponResRef = "+sWeaponResRef);                    ///
            SendMessageToPC(oPC, "nWeaponMaterial = "+IntToString(nWeaponMaterial));   ///
            SendMessageToPC(oPC, "nArmorMaterial = "+IntToString(nArmorMaterial));     ///
            SendMessageToPC(oPC, "nRefreshedItem = "+IntToString(nRefreshedItem));     ///

            //Delete the item and recreate
            DestroyObject( oInContainer, 0.1 );
            object oRefreshedItem = CreateItemOnObject(sItemResRef, OBJECT_SELF, nStackSize);

            SetName(oRefreshedItem, sName);
            //SetDescription(oRefreshedItem, sDescription);

            //Check if variables aren't null and set them on the new item
            if(sMaterial != "")         { SetLocalString(oRefreshedItem, "material", sMaterial); }
            if(sMaterial != "")      { SetLocalString(oRefreshedItem, "plc", sType); }
            if(sWeaponResRef != "")     { SetLocalString(oRefreshedItem, "weapon", sWeaponResRef); }
            if(nWeaponMaterial != 0)    { SetLocalInt(oRefreshedItem, "material", nWeaponMaterial); }
            if(nArmorMaterial != 0)     { SetLocalInt(oRefreshedItem, "armormaterial", nArmorMaterial); }
            if(nRefreshedItem != 0)     { SetLocalInt(oRefreshedItem, "RefreshedItem", 1); }
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

    SetLockKeyRequired(OBJECT_SELF, FALSE);
}
