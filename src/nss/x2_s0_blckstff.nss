//::///////////////////////////////////////////////
//:: Blackstaff
//:: X2_S0_Blckstff
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Adds +4 enhancement bonus, On Hit: Dispel.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 29, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 07, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-15: Complete Rewrite to make use of Item Property System

#include "nw_i0_spells"
#include "x2_i0_spells"

#include "x2_inc_spellhook"


void AddBlackStaffEffectOnWeapon (object oTarget, float fDuration, int iCL)
{
    if ( fDuration == 0.0 ){

        return;
    }
    /*int nDC = 0;

    if( iCL >= 26 )nDC =IP_CONST_ONHIT_SAVEDC_26;
    else if( iCL >= 24 )nDC =IP_CONST_ONHIT_SAVEDC_24;
    else if( iCL >= 22 )nDC =IP_CONST_ONHIT_SAVEDC_22;
    else if( iCL >= 20 )nDC =IP_CONST_ONHIT_SAVEDC_20;
    else if( iCL >= 18 )nDC =IP_CONST_ONHIT_SAVEDC_18;
    else if( iCL >= 16 )nDC =IP_CONST_ONHIT_SAVEDC_16;
    else nDC = IP_CONST_ONHIT_SAVEDC_14;*/

   //IPSafeAddItemProperty(oTarget, ItemPropertyEnhancementBonus(4), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE, TRUE);
   //IPSafeAddItemProperty(oTarget, ItemPropertyOnHitProps(IP_CONST_ONHIT_DISPELMAGIC, IP_CONST_ONHIT_SAVEDC_16), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
   //IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_EVIL), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );

   IPSafeAddItemProperty(oTarget, ItemPropertyVampiricRegeneration(iCL/6), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
   //IPSafeAddItemProperty(oTarget,ItemPropertyOnHitProps(IP_CONST_ONHIT_GREATERDISPEL, nDC), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
   IPSafeAddItemProperty(oTarget,ItemPropertyVisualEffect(ITEM_VISUAL_EVIL), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
   return;
}

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
    effect eVis = EffectVisualEffect(VFX_IMP_EVIL_HELP);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();

    object oMyWeapon   =  IPGetTargetedOrEquippedMeleeWeapon();

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }

    if(GetIsObjectValid(oMyWeapon) )
    {
        SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if (IPGetIsMeleeWeapon( oMyWeapon ))
        {
            if (nDuration>0)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), TurnsToSeconds(nDuration));
                AddBlackStaffEffectOnWeapon(oMyWeapon, TurnsToSeconds(nDuration),GetCasterLevel(OBJECT_SELF));
            }
            return;
        }
        else
        {
           //FloatingTextStrRefOnCreature(83620, OBJECT_SELF);  // not a qstaff
           SendMessageToPC(OBJECT_SELF, "<cþ  > Invalid target, melee weapons only.");
           return;
        }
    }
        else
    {
           FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
           return;
    }
}
