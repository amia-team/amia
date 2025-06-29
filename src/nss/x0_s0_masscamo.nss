//::///////////////////////////////////////////////
//:: Mass Camoflage
//:: x0_s0_masscamo.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    +10 hide bonus to all allies in area
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 24, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:
#include "X0_I0_SPELLS"
#include "inc_td_shifter"
#include "x2_inc_spellhook"

void NewDoCamoflage(object oTarget);

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

// End of Spell Cast Hook



    // * now setup benefits for allies
    //Apply Impact
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    location lTarget = GetSpellTargetLocation();
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

    //Get the first target in the radius around the caster
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
    while(GetIsObjectValid(oTarget))
    {
        if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
            NewDoCamoflage(oTarget);
        }
        //Get the next target in the specified area around the caster
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
    }
}

void NewDoCamoflage(object oTarget)
{
    //Declare major variables
    object oCasterItem = GetSpellCastItem();
    int iCL = GetIsObjectValid(oCasterItem)?GetCasterLevel(OBJECT_SELF):GetNewCasterLevel(OBJECT_SELF);
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    int nMetaMagic = GetMetaMagicFeat();

    effect eHide = EffectSkillIncrease(SKILL_HIDE, 10);

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eHide, eDur);

    int nDuration = iCL;
    nDuration = 10 * nDuration; // * Duration 10 turn/level

    if (nMetaMagic == METAMAGIC_EXTEND)    //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(oTarget, GetSpellId(), FALSE));
    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}









