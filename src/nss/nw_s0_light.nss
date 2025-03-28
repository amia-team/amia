//::///////////////////////////////////////////////
//:: Light
//:: NW_S0_Light.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Applies a light source to the target for
    1 hour per level

    XP2
    If cast on an item, item will get temporary
    property "light" for the duration of the spell
    Brightness on an item is lower than on the
    continual light version.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 15, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001
//:: Added XP2 cast on item code: Georg Z, 2003-06-05
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "amia_include"

void main()
{
    CantripRefresh();
   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run
    // this spell.
    if (!X2PreSpellCastCode())
    {
        return;
    }

    //Declare major variables
    object oTarget = GetSpellTargetObject();

    int nDuration;
    int nMetaMagic;

    // Handle spell cast on item....
    if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM && ! CIGetIsCraftFeatBaseItem(oTarget))
    {
        // Do not allow casting on not equippable items
        if (!IPGetIsItemEquipable(oTarget))
        {
         // Item must be equipable...
             FloatingTextStrRefOnCreature(83326,OBJECT_SELF);
            return;
        }

        itemproperty ip = ItemPropertyLight (IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_WHITE);

        if (GetItemHasItemProperty(oTarget, ITEM_PROPERTY_LIGHT))
        {
            IPRemoveMatchingItemProperties(oTarget,ITEM_PROPERTY_LIGHT,DURATION_TYPE_TEMPORARY);
        }

        nDuration = GetCasterLevel(OBJECT_SELF);
        nMetaMagic = GetMetaMagicFeat();
        //Enter Metamagic conditions
        if (nMetaMagic == METAMAGIC_EXTEND)
        {
            nDuration = nDuration *2; //Duration is +100%
        }

        AddItemProperty(DURATION_TYPE_TEMPORARY,ip,oTarget,HoursToSeconds(nDuration));
    }
    else
    {

        int nTransmutation = VFX_DUR_LIGHT_WHITE_20;
        switch( GetLocalInt( OBJECT_SELF, "ds_spell_"+IntToString( SPELL_LIGHT ) ) ){

                case 2: nTransmutation = VFX_DUR_LIGHT_GREY_20; break;
                case 3: nTransmutation = VFX_DUR_LIGHT_BLUE_20; break;
                case 4: nTransmutation = VFX_DUR_LIGHT_ORANGE_20; break;
                case 5: nTransmutation = VFX_DUR_LIGHT_PURPLE_20; break;
                case 6: nTransmutation = VFX_DUR_LIGHT_RED_20; break;
                case 7: nTransmutation = VFX_DUR_LIGHT_YELLOW_20; break;
                case 8: nTransmutation = VFX_DUR_ANTI_LIGHT_10; break;
                default:nTransmutation = VFX_DUR_LIGHT_WHITE_20;break;

        }

        effect eVis = EffectVisualEffect(nTransmutation);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = EffectLinkEffects(eVis, eDur);

        nDuration = GetCasterLevel(OBJECT_SELF);
        nMetaMagic = GetMetaMagicFeat();
        //Enter Metamagic conditions
        if (nMetaMagic == METAMAGIC_EXTEND)
        {
            nDuration = nDuration *2; //Duration is +100%
        }
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LIGHT, FALSE));

        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, NewHoursToSeconds(nDuration));
    }
}

