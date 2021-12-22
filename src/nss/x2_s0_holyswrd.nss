//::///////////////////////////////////////////////
//:: Holy Sword
//:: X2_S0_HolySwrd
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Grants holy avenger properties.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
// 12/29/2014 Glim             Enabled usage with Unarmed Strike.

#include "nw_i0_spells"
#include "x2_i0_spells"

#include "x2_inc_spellhook"


void  AddHolyAvengerEffectToWeapon(object oMyWeapon, float fDuration, int iCL)
{

    int nDC = 0;

    if( iCL >= 26 )nDC =IP_CONST_ONHIT_SAVEDC_26;
    else if( iCL >= 24 )nDC =IP_CONST_ONHIT_SAVEDC_24;
    else if( iCL >= 22 )nDC =IP_CONST_ONHIT_SAVEDC_22;
    else if( iCL >= 20 )nDC =IP_CONST_ONHIT_SAVEDC_20;
    else if( iCL >= 18 )nDC =IP_CONST_ONHIT_SAVEDC_18;
    else if( iCL >= 16 )nDC =IP_CONST_ONHIT_SAVEDC_16;
    else nDC = IP_CONST_ONHIT_SAVEDC_14;


   //IPSafeAddItemProperty(oMyWeapon,ItemPropertyHolyAvenger(), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,TRUE);
   IPSafeAddItemProperty(oMyWeapon,ItemPropertyOnHitProps(IP_CONST_ONHIT_GREATERDISPEL, nDC), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
   IPSafeAddItemProperty(oMyWeapon,ItemPropertyEnhancementBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 5), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);

   IPSafeAddItemProperty(oMyWeapon,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_1d6), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);

   IPSafeAddItemProperty(oMyWeapon,ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_16), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
   IPSafeAddItemProperty(oMyWeapon,ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);

   return;
}

#include "x2_inc_toollib"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-07-07 by Georg Zoeller
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_GOOD_HELP);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();

   if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }

    object oMyWeapon   =  IPGetTargetedOrEquippedMeleeWeapon();
    int nItem = IPGetIsMeleeWeapon(oMyWeapon);
    object oTarget = GetSpellTargetObject();

    if(GetObjectType(oMyWeapon)!=OBJECT_TYPE_ITEM && GetObjectType(oTarget)==OBJECT_TYPE_CREATURE){

        oMyWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS,oTarget);
    }

    int nType = GetBaseItemType( oMyWeapon );

    if(!IPGetIsMeleeWeapon( oMyWeapon ) && nType != BASE_ITEM_GLOVES)
    {
    SendMessageToPC(OBJECT_SELF, "<cþ  > Invalid target, melee weapons or gloves only.");
    return;
    }

    if(GetIsObjectValid(oMyWeapon) )
    {
        SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if (nDuration>0)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), RoundsToSeconds(nDuration));

            AddHolyAvengerEffectToWeapon(oMyWeapon, RoundsToSeconds(nDuration),GetCasterLevel(OBJECT_SELF));
        }
        TLVFXPillar(VFX_IMP_GOOD_HELP, GetLocation(GetSpellTargetObject()), 4, 0.0f, 6.0f);
        DelayCommand(1.0f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_SUPER_HEROISM),GetLocation(GetSpellTargetObject())));

        return;
    }
        else
    {
        FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
        return;
    }
}
