// Shifts the user in a custom lion shape permanently.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/23/2012 PaladinOfSune    Initial Release
// 05/07/2015 Faded Wings      Update for Conversation
//

#include "x2_inc_switches"
#include "amia_include"
#include "x2_inc_itemprop"

void PlantForm(object oPC, int nNode)
{
    int tempPolyID;
    switch(nNode)
    {
        case 1: tempPolyID = 196; break;
        case 2: tempPolyID = 217; break;
        case 3: tempPolyID = 218; break;
        case 4: tempPolyID = 219; break;
        case 5: tempPolyID = 220; break;
        case 6: tempPolyID = 221; break;
        default: tempPolyID = 196; break;
    }

    // Visual effect
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_ENTANGLE ), oPC, 3.0 );
    DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_POLYMORPH ), oPC ) );

    // Variables
    effect ePoly = EffectPolymorph( tempPolyID );
    ePoly = SupernaturalEffect( ePoly );

    int bWeapon = StringToInt(Get2DAString("polymorph","MergeW",tempPolyID)) == 1;
    int bArmor  = StringToInt(Get2DAString("polymorph","MergeA",tempPolyID)) == 1;
    int bItems  = StringToInt(Get2DAString("polymorph","MergeI",tempPolyID)) == 1;

    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oArmorOld = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
    object oRing1Old = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oPC);
    object oRing2Old = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oPC);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,oPC);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,oPC);
    object oBeltOld = GetItemInSlot(INVENTORY_SLOT_BELT,oPC);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);

    if (GetIsObjectValid(oShield)){

        if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
        {
            oShield = OBJECT_INVALID;
        }
    }

    int nCannotDrown = ds_check_uw_items( oPC );

    //Apply the VFX impact and effects
    ClearAllActions(); // prevents an exploit
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePoly, oPC );

    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);

    SetLocalInt( oPC, "CannotDrown", nCannotDrown );

    if (bWeapon)
    {
        IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);
    }
    if (bArmor)
    {
        IPWildShapeCopyItemProperties(oShield,oArmorNew);
        IPWildShapeCopyItemProperties(oHelmetOld,oArmorNew);
        IPWildShapeCopyItemProperties(oArmorOld,oArmorNew);
    }
    if (bItems)
    {
        IPWildShapeCopyItemProperties(oRing1Old,oArmorNew);
        IPWildShapeCopyItemProperties(oRing2Old,oArmorNew);
        IPWildShapeCopyItemProperties(oAmuletOld,oArmorNew);
        IPWildShapeCopyItemProperties(oCloakOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBootsOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBeltOld,oArmorNew);
    }
    SetLocalString( oPC, "ds_action", "" );
}

void main(){
    // Declare variables
    object oPC = OBJECT_SELF;
    object oItem = GetItemActivated( );

    string scriptCalled = GetLocalString(oPC, "ds_action");
    if(scriptCalled != "")
    {
        int nNode = GetLocalInt( oPC, "ds_node" );
        PlantForm(oPC, nNode);
    }
    else
    {
        //event variables
        int nEvent  = GetUserDefinedItemEventNumber();
        int nResult = X2_EXECUTE_SCRIPT_END;

        switch (nEvent){

            case X2_ITEM_EVENT_ACTIVATE:
                object oPC = GetItemActivator();
                object oItem = GetItemActivated();
                object oTarget   = GetItemActivatedTarget();
                location lLocation = GetItemActivatedTargetLocation();
                location lPcLocation = GetLocation( oPC );

                SetLocalString( oPC, "ds_action", "i_plantform" );
                SetLocalObject( oPC, "ds_target", oTarget );
                SetLocalLocation( oPC, "ds_location", lLocation);

                AssignCommand( oPC, ActionStartConversation( oPC, "plantform", TRUE, FALSE ) );

            break;
        }
        //Pass the return value back to the calling script
        SetExecutedScriptReturnValue(nResult);
   }
}
