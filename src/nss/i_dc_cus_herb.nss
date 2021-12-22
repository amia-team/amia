/*  i_dc_cus_herb

--------
Verbatim
--------
Scripts for the exotic plant widget spawner

---------
Changelog
---------

Date         Name        Reason
------------------------------------------------------------------
2013-09-14   PoS       Start
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x2_inc_itemprop"

//-------------------------------------------------------------------------------
//Prototypes
//-------------------------------------------------------------------------------

void RitualIncense( location lTarget );
void ScorpionPoison( object oPC, object oTarget );
void Curare( object oPC, object oTarget );

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            string sItemName = GetName( oItem );
            location lTarget = GetItemActivatedTargetLocation();

            if ( sItemName == "Ritual Incense" )
            {
                AssignCommand( oPC, RitualIncense( lTarget ) );
            }
            else if ( sItemName == "Giant Scorpion Poison" )
            {
                AssignCommand( oPC, ScorpionPoison( oPC, oTarget ) );
            }
            else if ( sItemName == "Curare" )
            {
                AssignCommand( oPC, Curare( oPC, oTarget ) );
            }

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}


//-------------------------------------------------------------------------------
//Definitions
//-------------------------------------------------------------------------------

void RitualIncense( location lTarget ){

    object oPLC1 = CreateObject( OBJECT_TYPE_PLACEABLE, "x0_plate", lTarget );
    object oPLC2 = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_j_incense", lTarget );

    DelayCommand( 600.0, DestroyObject( oPLC1 ) );
    DelayCommand( 601.0, DestroyObject( oPLC2 ) );
}

void ScorpionPoison( object oPC, object oTarget ){

    object oItem   = GetSpellCastItem();
    object oTarget = GetSpellTargetObject();

    if (oTarget == OBJECT_INVALID || GetObjectType(oTarget) != OBJECT_TYPE_ITEM)
    {
       FloatingTextStrRefOnCreature(83359,oPC);         //"Invalid target "
       return;
    }

    int nType = GetBaseItemType(oTarget);

    if (!IPGetIsMeleeWeapon(oTarget) && !IPGetIsProjectile(oTarget) )
    {
       FloatingTextStrRefOnCreature(83359,oPC);         //"Invalid target "
       return;
    }

    if (IPGetItemHasItemOnHitPropertySubType(oTarget, 19)) // 19 == itempoison
    {
        FloatingTextStrRefOnCreature(83407,oPC); // weapon already poisoned
        return;
    }

    itemproperty ip = ItemPropertyOnHitProps( IP_CONST_ONHIT_ITEMPOISON, 6, 2 );
    IPSafeAddItemProperty(oTarget, ip, TurnsToSeconds(8),X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,TRUE);

     effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
    //technically this is not 100% safe but since there is no way to retrieve the sub
    //properties of an item (i.e. itempoison), there is nothing we can do about it
    if (IPGetItemHasItemOnHitPropertySubType(oTarget, 19))
    {
        FloatingTextStrRefOnCreature(83361,oPC);         //"Weapon is coated with poison"
        IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_ACID),TurnsToSeconds(8),X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,FALSE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
    }
    else
    {
        FloatingTextStrRefOnCreature(83360,oPC);         //"Nothing happens
    }
}

void Curare( object oPC, object oTarget ){

    object oItem   = GetSpellCastItem();
    object oTarget = GetSpellTargetObject();

    if (oTarget == OBJECT_INVALID || GetObjectType(oTarget) != OBJECT_TYPE_ITEM)
    {
       FloatingTextStrRefOnCreature(83359,oPC);         //"Invalid target "
       return;
    }

    int nType = GetBaseItemType(oTarget);

    if (!IPGetIsMeleeWeapon(oTarget) && !IPGetIsProjectile(oTarget) )
    {
       FloatingTextStrRefOnCreature(83359,oPC);         //"Invalid target "
       return;
    }

    if (IPGetItemHasItemOnHitPropertySubType(oTarget, 19)) // 19 == itempoison
    {
        FloatingTextStrRefOnCreature(83407,oPC); // weapon already poisoned
        return;
    }

    itemproperty ip = ItemPropertyOnHitProps( IP_CONST_ONHIT_ITEMPOISON, 6, 0 );
    IPSafeAddItemProperty(oTarget, ip, TurnsToSeconds(8),X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,TRUE);

     effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
    //technically this is not 100% safe but since there is no way to retrieve the sub
    //properties of an item (i.e. itempoison), there is nothing we can do about it
    if (IPGetItemHasItemOnHitPropertySubType(oTarget, 19))
    {
        FloatingTextStrRefOnCreature(83361,oPC);         //"Weapon is coated with poison"
        IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_ACID),TurnsToSeconds(8),X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,FALSE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
    }
    else
    {
        FloatingTextStrRefOnCreature(83360,oPC);         //"Nothing happens
    }
}
