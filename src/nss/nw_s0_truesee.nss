//::///////////////////////////////////////////////
//:: True Seeing
//:: NW_S0_TrueSee.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The creature can seen all invisible, sanctuared,
    or hidden opponents.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: [date]
//:://////////////////////////////////////////////
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/29/2004 jpavelch         Changed effect to combo of ultravision and see invis.
// 02/10/2012 Mathias          Changed to add +2 to spot per level of Divination focus feats.
// 05/15/2013 Glim             Fixes for Darkness bugs
//


#include "x2_inc_spellhook"
//#include "nwnx_effects"

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
    object  oTarget     = GetSpellTargetObject();
    int     nSpotBonus  = 10;  // By default, TS raises spot by 10.


    // Check for divination focus feats.
    if ( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_DIVINATION, OBJECT_SELF ) ) {
        nSpotBonus += 6;
    }
    else if ( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_DIVINATION, OBJECT_SELF ) ) {
        nSpotBonus += 4;
    }
    else if ( GetHasFeat( FEAT_SPELL_FOCUS_DIVINATION, OBJECT_SELF ) ) {
        nSpotBonus += 2;
    }

    // Effect variables
    effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
//    effect eSight = EffectTrueSeeing();
    effect eSight = EffectSeeInvisible();
    effect eUltra = EffectUltravision();
    effect eSpot = EffectSkillIncrease( SKILL_SPOT, nSpotBonus );
    effect eLink = EffectLinkEffects(eVis, eSight);
    eLink = EffectLinkEffects(eLink, eUltra);
    eLink = EffectLinkEffects(eLink, eSpot);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = SetEffectScript( eLink, "nw_s0_darknessc" );
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_TRUE_SEEING, FALSE));
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));

    //April 2013: If already affected by Darkness, remove the effect
    effect eAOE = GetFirstEffect(oTarget);

    while (GetIsEffectValid(eAOE))
    {
        //Removes only the Darkness (blindness) portion of the effect, not the Invisibility
        if( GetEffectType( eAOE ) == EFFECT_TYPE_DARKNESS )
        {
            RemoveEffect(oTarget, eAOE);
            /*  True Races vulnerability handling    */
            ApplyAreaAndRaceEffects( oTarget, 0, 2 );
        }
        //Get next effect on the target
        eAOE = GetNextEffect(oTarget);
    }
}

