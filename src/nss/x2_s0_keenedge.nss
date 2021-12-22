// Keen Edge
//
// Adds the keen property to one melee weapon, increasing its critical
// threat range.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/28/2002 Andrew Nobbs     Initial release.
// 07/07/2003 Georg Zoeller    Stacking Spell Pass
// 07/17/2003 Andrew Nobbs     Complete Rewrite to make use of Item Property
//                             System
// 02/15/2004 jpavelch         Changed duration from turns to rounds.
// 04/01/2004 jpavelch         Spell no longer works with Thayvian crafted
//                             items.
// 10/09/2004 jpavelch         Changed duration back to turns.
//

#include "nw_i0_spells"
#include "x2_i0_spells"
#include "x2_inc_spellhook"
#include "tcs_include"


void  AddKeenEffectToWeapon(object oMyWeapon, float fDuration)
{
   IPSafeAddItemProperty(oMyWeapon,ItemPropertyKeen(), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,TRUE);
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
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
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
        SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if ( TCS_GetIsThayvian(oMyWeapon) ) {
            SendMessageToPC( OBJECT_SELF, "This spell does not work on Thayvian crafted items" );
            return;
        }

        if (nDuration>0)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), TurnsToSeconds(nDuration));
            AddKeenEffectToWeapon(oMyWeapon, TurnsToSeconds(nDuration));
        }
        return;
     }
     else

     {
          FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
          return;
    }



}
