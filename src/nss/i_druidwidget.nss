//::///////////////////////////////////////////////
//:: Druid Widget
//:: ds_druidwidget
//:: Maverick00053
//:://////////////////////////////////////////////

#include "x2_inc_itemprop"
#include "amia_include"
#include "inc_ds_actions"

void main()
{
    //Declare major variables


    object oPC = GetItemActivator();

    AssignCommand( oPC, ActionStartConversation( oPC, "c_druidwidget", TRUE, FALSE ) );

    int iNode = GetLocalInt( oPC , "ds_node" );

    int nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly;
    int nPoly;
    int nMetaMagic = GetMetaMagicFeat();
    int nDruid      = GetLevelByClass(CLASS_TYPE_DRUID);
    int nShifter    = GetLevelByClass(CLASS_TYPE_SHIFTER);
    int nDuration   = nDruid;

    if( nShifter > nDruid ){
        nDuration = nShifter;
    }

      switch (iNode)
        {
        case 1:nPoly =235; break;
        case 2:nPoly =230; break;
        case 3:nPoly =232; break;
        case 4:nPoly =227; break;
        case 5:nPoly =234; break;
        case 6: nPoly =229; break;
        case 7:nPoly =236; break;
        case 8:nPoly =231; break;
        case 9:nPoly =233; break;
        case 10:nPoly =228; break;
        }
      clean_vars(oPC, 4);





    //--------------------------------------------------------------------------
    // Monk nerf
    //--------------------------------------------------------------------------

    ePoly           = EffectPolymorph( nPoly );

    /*
    //Has monk Wis mod -> AC
    effect  eNegAC;

    if ( GetHasFeat( 260 ) ){

        eNegAC  = EffectACDecrease( GetAbilityModifier( ABILITY_WISDOM , OBJECT_SELF ) );
        ePoly   = EffectLinkEffects( eNegAC, ePoly );
    }
    */

    ePoly = ExtraordinaryEffect(ePoly);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_WILD_SHAPE, FALSE));

    int bWeapon = StringToInt(Get2DAString("polymorph","MergeW",nPoly)) == 1;
    int bArmor  = StringToInt(Get2DAString("polymorph","MergeA",nPoly)) == 1;
    int bItems  = StringToInt(Get2DAString("polymorph","MergeI",nPoly)) == 1;

    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmorOld = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
    object oRing1Old = GetItemInSlot(INVENTORY_SLOT_LEFTRING,OBJECT_SELF);
    object oRing2Old = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,OBJECT_SELF);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,OBJECT_SELF);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,OBJECT_SELF);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,OBJECT_SELF);
    object oBeltOld = GetItemInSlot(INVENTORY_SLOT_BELT,OBJECT_SELF);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,OBJECT_SELF);
    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);

    if (GetIsObjectValid(oShield)){

        if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
        {
            oShield = OBJECT_INVALID;
        }
    }

    int nCannotDrown = ds_check_uw_items( OBJECT_SELF );

    /*if(nPoly == 223)
    {
      ePoly = EffectLinkEffects(ePoly,eSpeed);
    }*/


    //Apply the VFX impact and effects
    ClearAllActions(); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, OBJECT_SELF, NewHoursToSeconds(nDuration));

    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);

    SetLocalInt( OBJECT_SELF, "CannotDrown", nCannotDrown );

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

}
