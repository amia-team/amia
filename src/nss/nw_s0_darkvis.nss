//::///////////////////////////////////////////////
//:: Darkvision
//:: NW_S0_DarkVis
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Rundown:
    Step 1 - Checks for any existing Darkness (blindness only) effect and removes.
    Note: Does not remove the Darkness (invisibility) portion. Must be this way.
          When UV effect expires, calls a removal of any extraneous effects and
            a re-application of the proper Darkness effects (both).
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 13, 2001
//:://////////////////////////////////////////////
//Needed: New effect

#include "x2_inc_spellhook"
#include "amia_include"
#include "nwnx_effects"

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


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eUltra = EffectUltravision();
    effect eVis = EffectVisualEffect(VFX_DUR_ULTRAVISION);
    effect eVis2 = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eVis, eDur);
           eLink = EffectLinkEffects(eLink, eVis2);
           eLink = EffectLinkEffects(eLink, eUltra);
           eLink = SetEffectScript( eLink, "nw_s0_darknessc" );

    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DARKVISION, FALSE));
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, NewHoursToSeconds(nDuration));

    //April 2013: If already affected by Darkness, remove the effect
    effect eAOE = GetFirstEffect(oTarget);

    while (GetIsEffectValid(eAOE))
    {
        //Removes only the Darkness (blindness) portion of the effect, not the Invisibility
        if( GetEffectSpellId(eAOE) == 36 )
        {
            RemoveEffect(oTarget, eAOE);
            /*  True Races vulnerability handling    */
            ApplyAreaAndRaceEffects( oTarget, 0, 2 );
        }
        //Get next effect on the target
        eAOE = GetNextEffect(oTarget);
    }
}
