// maintains RDD hide/property sanity
//
//obsolete?
//

// includes
#include "x2_inc_itemprop"

void main(){

    // vars

    // resolve PC status

    object oPC=GetPCLevellingUp();

    if(oPC==OBJECT_INVALID){

        oPC=OBJECT_SELF;

    }

    // resolve number of RDD levels
    int nRDD_rank=GetLevelByClass(
        CLASS_TYPE_DRAGON_DISCIPLE,
        oPC);

    if(nRDD_rank<1){

        return;

    }

    string szHide="";

    // resolve current hide status
    object oCurrentHide=GetItemInSlot(
        INVENTORY_SLOT_CARMOUR,
        oPC);

    string szCurrentHideTag=GetTag(oCurrentHide);

    // 1st-3rd
    if( (nRDD_rank>0)   &&
        (nRDD_rank<4)   ){

        // clear hide slot if it was a RDD one
        if( (szCurrentHideTag=="rddproperties4")    ||
            (szCurrentHideTag=="rddproperties10")   ){

            DestroyObject(oCurrentHide);

        }
        // purge RDD properties from the hide
        else{

            // remove STR -4
            IPRemoveMatchingItemProperties(
                oCurrentHide,
                ITEM_PROPERTY_DECREASED_ABILITY_SCORE,
                DURATION_TYPE_PERMANENT);

            // remove 50% cold vulnerability
            IPRemoveMatchingItemProperties(
                oCurrentHide,
                ITEM_PROPERTY_DAMAGE_VULNERABILITY,
                DURATION_TYPE_PERMANENT);

        }

    }
    // 4th-9th
    else if(    (nRDD_rank>3)   &&
                (nRDD_rank<10)  ){

        // clear hide slot if it was a RDD one
        if( (szCurrentHideTag=="rddproperties4")    ||
            (szCurrentHideTag=="rddproperties10")   ){

            DestroyObject(oCurrentHide);

            // clear hide slot
            DestroyObject(oCurrentHide);

            // select the appropriate properties
            szHide="rddproperties4";

        }
        else{

            // append 50% cold vulnerability
            IPSafeAddItemProperty(
                oCurrentHide,
                ItemPropertyDamageVulnerability(
                    IP_CONST_DAMAGETYPE_COLD,
                    50),
                0.0);

            // remove STR -4
            IPRemoveMatchingItemProperties(
                oCurrentHide,
                ITEM_PROPERTY_DECREASED_ABILITY_SCORE,
                DURATION_TYPE_PERMANENT);

        }

    }
    // 10th+
    else{

        // clear hide slot if it was a RDD one
        if( (szCurrentHideTag=="rddproperties4")    ||
            (szCurrentHideTag=="rddproperties10")   ){

            // clear hide slot
            DestroyObject(oCurrentHide);

            // select the appropriate properties
            szHide="rddproperties10";

        }
        else{

            // append 50% cold vulnerability
            IPSafeAddItemProperty(
                oCurrentHide,
                ItemPropertyDamageVulnerability(
                    IP_CONST_DAMAGETYPE_COLD,
                    50),
                0.0);

            // append STR -4
            IPSafeAddItemProperty(
                oCurrentHide,
                ItemPropertyDecreaseAbility(
                    IP_CONST_ABILITY_STR,
                    4),
                0.0);

        }

    }

    // issue the properties to the RDD
    if(szHide!=""){

        // the rdd properties
        object oHide=CreateItemOnObject(
            szHide,
            oPC,
            1);

        // equip the rdd properties
        AssignCommand(
            oPC,
            ActionEquipItem(
                oHide,
                INVENTORY_SLOT_CARMOUR));

    }

    return;

}
