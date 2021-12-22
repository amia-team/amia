//::///////////////////////////////////////////////
//:: Clairaudience / Clairvoyance
//:: NW_S0_ClairAdVo.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grants the target creature a bonus of +10 to
    spot and listen checks
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 21, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/10/2012 Mathias          Changed to add +2 to spot/listen per level of Divination focus feats.
//

#include "x2_inc_spellhook"

void main()
{

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

    // Major variables.
    int nSpotBonus      = 10;
    int nListenBonus    = 10;

    // Check for divination focus feats.
    if ( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_DIVINATION, OBJECT_SELF ) ) {
        nSpotBonus += 6;
        nListenBonus += 6;
    }
    else if ( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_DIVINATION, OBJECT_SELF ) ) {
        nSpotBonus += 4;
        nListenBonus += 4;
    }
    else if ( GetHasFeat( FEAT_SPELL_FOCUS_DIVINATION, OBJECT_SELF ) ) {
        nSpotBonus += 2;
        nListenBonus += 2;
    }

    //Declare major variables
    effect eSpot = EffectSkillIncrease(SKILL_SPOT, nSpotBonus);
    effect eListen = EffectSkillIncrease(SKILL_LISTEN, nListenBonus);
    effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eSpot, eListen);
    eLink = EffectLinkEffects(eLink, eVis);
    eLink = EffectLinkEffects(eLink, eDur);

    object oTarget = GetSpellTargetObject();
    int nLevel = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();

    //Meta-Magic checks
    if(nMetaMagic == METAMAGIC_EXTEND)
    {
        nLevel *= 2;
    }

    //Make sure the spell has not already been applied
    if(!GetHasSpellEffect(SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE, oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE, FALSE));

         //Apply linked and VFX effects
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nLevel));
    }
}

