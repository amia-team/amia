//::///////////////////////////////////////////////
//:: Wild Shape
//:: NW_S2_WildShape
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allows the Druid to change into animal forms.

    Updated: Sept 30 2003, Georg Z.
      * Made Armor merge with druid to make forms
        more useful.
    Updated: Nov 14, 2016. Maverick00053
      * Adding in Epic Wildshape forms at 25 druid.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 22, 2002
//:://////////////////////////////////////////////

#include "x2_inc_itemprop"
#include "amia_include"

void main()
{
    //Declare major variables
    int nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly;
    int nPoly;
    int nMetaMagic = GetMetaMagicFeat();
    int nDruid      = GetLevelByClass(CLASS_TYPE_DRUID);
    int nShifter    = GetLevelByClass(CLASS_TYPE_SHIFTER);
    int nDuration   = nDruid;
    effect eSpeed = ExtraordinaryEffect(EffectMovementSpeedIncrease(20));

    if(GetIsPolymorphed(OBJECT_SELF))
    {
      SendMessageToPC(OBJECT_SELF,"You must unpolymorph first!");
      return;
    }

    if(GetLocalInt(OBJECT_SELF,"POLY_COOLDOWN") == 1)
    {
      SendMessageToPC(OBJECT_SELF,"Slow down! You are polymorphing too fast!");
      return;
    }

    int nElderAt = 12;
    if( nShifter > nDruid ){

        nElderAt = 10;
        nDuration = nShifter;
    }

    // Adding in the variables for epic forms.
    int nEpicForms = 25;

    //Determine Polymorph subradial type
    if(nSpell == 401)
    {
        nPoly = 232;

        if ((nDuration >= nEpicForms) && (nShifter <= 5))
        {
            nPoly = 222;
        }
        else if (nDuration >= nElderAt)
        {
            nPoly = 227;
        }
    }
    else if (nSpell == 402)
    {
        nPoly = 233;
        if ((nDuration >= nEpicForms) && (nShifter <= 5))
        {
            nPoly = 223;
        }
        else if (nDuration >= nElderAt)
        {
            nPoly = 228;
        }
    }
    else if (nSpell == 403)
    {
        nPoly = 234;

        if ((nDuration >= nEpicForms) && (nShifter <= 5))
        {
            nPoly = 224;
        }
        else if (nDuration >= nElderAt)
        {
            nPoly = 229;
        }
    }
    else if (nSpell == 404)
    {
        nPoly = 235;

        if ((nDuration >= nEpicForms) && (nShifter <= 5))
        {
            nPoly = 225;
        }
        else if (nDuration >= nElderAt)
        {
            nPoly = 230;
        }
    }
    else if (nSpell == 405)
    {
        nPoly = 236;

        if ((nDuration >= nEpicForms) && (nShifter <= 5))
        {
            nPoly = 226;
        }
        else if (nDuration >= nElderAt)
        {
            nPoly = 231;
        }
    }

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

    if(nPoly == 223)
    {
      ePoly = EffectLinkEffects(ePoly,eSpeed);
    }


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


    //Poly cool down
    SetLocalInt( OBJECT_SELF, "POLY_COOLDOWN", 1 );
    DelayCommand(30.0,DeleteLocalInt(OBJECT_SELF,"POLY_COOLDOWN"));
    DelayCommand(30.0,SendMessageToPC(OBJECT_SELF,"You may now shift to another form!"));

}
