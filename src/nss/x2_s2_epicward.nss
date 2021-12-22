/*  Epic Spell :: Epic Warding!

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



void main(){

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    // requirements
    
    if ( !GetCanCastEpicSpells( OBJECT_SELF ) ) {

        SendMessageToPC( OBJECT_SELF, "You need either 20+ Cha, Int or Wis to cast this spell." );
        return;
    }


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    int nLimit = 50*nDuration;
    effect eDur = EffectVisualEffect(495);
    effect eProt = EffectDamageReduction(50, DAMAGE_POWER_PLUS_TWENTY, nLimit);
    effect eLink = EffectLinkEffects(eDur, eProt);
    eLink = EffectLinkEffects(eLink, eDur);

    // * Brent, Nov 24, making extraodinary so cannot be dispelled
    eLink = ExtraordinaryEffect(eLink);

    RemoveEffectsFromSpell(OBJECT_SELF, GetSpellId());
    //Apply the armor bonuses and the VFX impact
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));

}
