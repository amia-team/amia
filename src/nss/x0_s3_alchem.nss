//::///////////////////////////////////////////////
//:: Alchemists fire
//:: x0_s3_alchem
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grenade.
    Fires at a target. If hit, the target takes
    direct damage. If missed, all enemies within
    an area of effect take splash damage.

    HOWTO:
    - If target is valid attempt a hit
       - If miss then MISS
       - If hit then direct damage
    - If target is invalid or MISS
       - have area of effect near target
       - everyone in area takes splash damage
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 10, 2002
//:: Modified By: Glim 03/31/13
//::              Duration to 10 Turns, does not
//::              stack with Flame Wep or Darkfire.
//:://////////////////////////////////////////////
//:: GZ: Can now be used to coat a weapon with fire.

#include "X2_I0_SPELLS"
#include "x2_inc_itemprop"
#include "x2_inc_spellhook"

void AddFlamingEffectToWeapon(object oTarget, float fDuration)
{
   // Anti-stacking.
   IPRemoveMatchingItemProperties( oTarget, ITEM_PROPERTY_DAMAGE_BONUS, DURATION_TYPE_TEMPORARY );
   IPRemoveMatchingItemProperties( oTarget, ITEM_PROPERTY_VISUALEFFECT, DURATION_TYPE_TEMPORARY );

   // If the spell is cast again, any previous itemproperties matching are removed.
   IPSafeAddItemProperty(oTarget, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d4), fDuration, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
   IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_FIRE), fDuration,X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
   return;
}

void main()
{
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    object oTarget = GetSpellTargetObject();
    object oMyWeapon;
    int nTarget = GetObjectType(oTarget);
    int nDuration = 10;
    int nCasterLvl = 1;

    if(nTarget == OBJECT_TYPE_ITEM)
    {
        oMyWeapon = oTarget;
        int nItem = IPGetIsMeleeWeapon(oMyWeapon);
        int nType = GetBaseItemType( oMyWeapon );
        if(nItem == TRUE || nType == BASE_ITEM_GLOVES || nType == BASE_ITEM_BRACER )
        {
            if(GetIsObjectValid(oMyWeapon))
            {
                SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

                if (nDuration > 0)
                {
                    // haaaack: store caster level on item for the on hit spell to work properly
                    SetLocalInt(oMyWeapon,"X2_SPELL_CLEVEL_FLAMING_WEAPON",nCasterLvl);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), TurnsToSeconds(nDuration));
                    AddFlamingEffectToWeapon(oMyWeapon, TurnsToSeconds(nDuration));
                }
                    return;
            }
        }
        else
        {
            FloatingTextStrRefOnCreature(100944,OBJECT_SELF);
        }
    }
    else if(nTarget == OBJECT_TYPE_CREATURE || OBJECT_TYPE_DOOR || OBJECT_TYPE_PLACEABLE)
    {
        DoGrenade(d6(1),1, VFX_IMP_FLAME_M, VFX_FNF_FIREBALL,DAMAGE_TYPE_FIRE,RADIUS_SIZE_HUGE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}




