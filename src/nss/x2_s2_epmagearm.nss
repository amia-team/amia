/* Epic Mage Armor

    --------
    Verbatim
    --------
    You need 20 Ch or 20 Int to cast this spell

    ---------
    Changelog
    ---------
    Date        Name        Reason
    ----------------------------------------------------------------------------
    20070301    disco       Int and Cha check
    20100705    james       Enforce Right Ability Check
    ----------------------------------------------------------------------------
*/

// Includes.
#include "x2_i0_spells"
#include "x2_inc_spellhook"
#include "amia_include"

void main()
{

    /*
      Spellcast Hook Code
      Added 2003-06-20 by Georg
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

        if (!X2PreSpellCastCode())
        {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
            return;
        }

    // requirements

    if ( !GetCanCastEpicSpells( OBJECT_SELF ) ) {

        SendMessageToPC( OBJECT_SELF, "You need either 20+ Cha, Int or Wis to cast this spell." );
        return;
    }

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    effect eVis = EffectVisualEffect(495);
    effect eAC1, eAC2, eAC3, eAC4;
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }
    //Set the four unique armor bonuses
    eAC1 = EffectACIncrease(5, AC_ARMOUR_ENCHANTMENT_BONUS);
    eAC2 = EffectACIncrease(5, AC_DEFLECTION_BONUS);
    eAC3 = EffectACIncrease(5, AC_DODGE_BONUS);
    eAC4 = EffectACIncrease(5, AC_NATURAL_BONUS);
    effect eDur = EffectVisualEffect(VFX_DUR_SANCTUARY);

    effect eLink = EffectLinkEffects(eAC1, eAC2);
    eLink = EffectLinkEffects(eLink, eAC3);
    eLink = EffectLinkEffects(eLink, eAC4);
    eLink = EffectLinkEffects(eLink, eDur);

    RemoveEffectsFromSpell(oTarget, GetSpellId());

    // * Brent, Nov 24, making extraodinary so cannot be dispelled
    eLink = ExtraordinaryEffect(eLink);

    //Apply the armor bonuses and the VFX impact
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, NewHoursToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget,1.0);
}
