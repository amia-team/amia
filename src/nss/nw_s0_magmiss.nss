//::///////////////////////////////////////////////
//:: Magic Missile
//:: NW_S0_MagMiss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A missile of magical energy darts forth from your
// fingertip and unerringly strikes its target. The
// missile deals 1d4+1 points of damage.
//
// For every two extra levels of experience past 1st, you
// gain an additional missile.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 10, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: May 8, 2001

// 11/12/2016   msheeler    Shadow Magic Missile: Each missile (max of 5 missiles)
//                          does 1d4+1 cold and 1d4+1 negative energy damage, with no save.
//                          Each spell focus adds +1 cold and +1 negative energy damage to each missile.

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_td_shifter"

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


    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    object oTarget = GetSpellTargetObject();
    object oTargetB = OBJECT_INVALID;
    int nCasterLvl = GetNewCasterLevel(OBJECT_SELF);
    int nDamage = 0;
    int nBonus = 1;
    int nMetaMagic = GetMetaMagicFeat();
    int nTargetFound = 0;
    int nCnt;
    effect eDam;
    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
    effect eBounce;
    int nMissiles = (nCasterLvl + 1)/2;
    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);
    float fDelay2, fTime, fTime2;
    int nSpellId = GetSpellId();

    //determine bonuns for spell foci
    if ((nSpellId == 107 && GetHasFeat (FEAT_SPELL_FOCUS_EVOCATION, OBJECT_SELF)) || (nSpellId == 348 && GetHasFeat (FEAT_SPELL_FOCUS_ILLUSION)))
    {
        nBonus = 2;
    }
    if ((nSpellId == 107 && GetHasFeat (FEAT_GREATER_SPELL_FOCUS_EVOCATION, OBJECT_SELF)) || (nSpellId == 348 && GetHasFeat (FEAT_GREATER_SPELL_FOCUS_ILLUSION)))
    {
        nBonus = 3;
    }
    if ((nSpellId == 107 && GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF)) || (nSpellId == 348 && GetHasFeat (FEAT_EPIC_SPELL_FOCUS_ILLUSION)))
    {
        nBonus = 4;
    }

    //determine main target and possible secondary target
    //oTarget = GetSpellTargetObject();
    oTargetB = GetFirstObjectInShape (SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    eBounce = EffectBeam (VFX_BEAM_SILENT_LIGHTNING, oTarget, BODY_NODE_CHEST);
    while (GetIsObjectValid (oTargetB) && nTargetFound == 0)
    {
        if(GetIsEnemy(oTargetB))
        {
            nTargetFound = 1;
        }
        if (nTargetFound == 0)
        {
        oTargetB =GetNextObjectInShape (SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetSpellTargetLocation());
        }
    }
    if (oTarget == oTargetB)
    {
        oTargetB = OBJECT_INVALID;
    }
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_MISSILE));
        //Limit missiles to five
        if (nMissiles > 5)
        {
            nMissiles = 5;
        }
        //Make SR Check
        if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
        {
            //Apply a single damage hit for each missile instead of as a single mass
            for (nCnt = 1; nCnt <= nMissiles; nCnt++)
            {
                //Roll damage
                int nDam = d4(1) + nBonus;
                //Enter Metamagic conditions
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                      nDam = 5;//Damage is at max
                }
                if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                      nDam = nDam + nDam/2; //Damage/Healing is +50%
                }
                fTime = fDelay;
                fDelay2 += 0.1;
                fTime += fDelay2;
                fTime2 = fTime + 0.1;

                effect eDamCold = EffectDamage (nDam, DAMAGE_TYPE_NEGATIVE);
                effect eDamNeg = EffectDamage (nDam, DAMAGE_TYPE_COLD);
                effect eDamMag = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
                effect eDamShad = EffectLinkEffects (eDamCold, eDamNeg);

                //Set damage effect
                if (nSpellId == 107)
                {
                    eDam = eDamMag;
                }
                if (nSpellId == 348)
                {
                    eDam = eDamShad;
                }

                //Apply the MIRV and damage effect
                DelayCommand(fDelay2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
                DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
                DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF) && oTargetB != OBJECT_INVALID)
                {
                    DelayCommand(fTime2, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBounce, oTargetB, 0.5));
                    DelayCommand(fTime2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTargetB));
                    DelayCommand(fTime2, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTargetB));

                }
             }
         }
         else
         {
            for (nCnt = 1; nCnt <= nMissiles; nCnt++)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
            }
         }
     }
}




