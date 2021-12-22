//::///////////////////////////////////////////////
//:: Acid Splash
//:: [X0_S0_AcidSplash.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
1d3 points of acid damage to one target.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 17 2002
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

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

   //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDamageCount =1;
    int nDamage;
    int nMeta = GetMetaMagicFeat();

    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 424));
        //Make SR Check
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {

            //check for epic spell focus
                     if (GetHasFeat( FEAT_SPELL_FOCUS_CONJURATION, OBJECT_SELF ))
                     {
                        nDamageCount += 1;
                     }
                     if (GetHasFeat( FEAT_GREATER_SPELL_FOCUS_CONJURATION, OBJECT_SELF ))
                     {
                        nDamageCount += 1;
                     }
                     if (GetHasFeat( FEAT_EPIC_SPELL_FOCUS_CONJURATION, OBJECT_SELF ))
                     {
                        nDamageCount += 1;
                     }

                    // roll damage
                    nDamage= d3(nDamageCount)+nDamageCount*1;
                    //Make metamagic  check
                    if (nMeta == METAMAGIC_MAXIMIZE)
                    {
                       nDamage= 3*nDamageCount+nDamageCount*1;
                    }
                    else if (nMeta == METAMAGIC_EMPOWER)
                    {
                        nDamage+= nDamage + nDamage/2;
                    }

            //Set damage effect

            effect eBad = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
            //Apply the VFX impact and damage effect
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eBad, oTarget);
        }
    }
}




