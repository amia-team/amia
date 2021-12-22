//::///////////////////////////////////////////////
//:: Mestil's Acid Breath
//:: X2_S0_AcidBrth
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You breathe forth a cone of acidic droplets. The
// cone inflicts 1d6 points of acid damage per caster
// level (maximum 10d6).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov, 22 2002
//:://////////////////////////////////////////////
//  7/11/2016   msheeler    added bonus damage for spell focus and secondary damage for epic focus

//float SpellDelay (object oTarget, int nShape);

#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "inc_arcanearcher"

void main()
{

    // Temp var
    int nExtended=0;
    if(GetMetaMagicFeat()==METAMAGIC_EXTEND){

        nExtended=1;

    }

    // Resolve Arcane Archer Status
    if(ImbueArrow(
        OBJECT_SELF,
        GetSpellId(),
        GetSpellTargetObject(),
        GetLastSpellCastClass(),
        nExtended)==TRUE){

        return;

    }

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
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    int nMaxDice = 10;
    float fDelay;
    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    //added checkj for spell foci
    if (GetHasFeat (FEAT_SPELL_FOCUS_CONJURATION, OBJECT_SELF))
    {
       nMaxDice = 11;
    }
    if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_CONJURATION, OBJECT_SELF))
    {
       nMaxDice = 12;
    }
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_CONJURATION, OBJECT_SELF))
    {
       nMaxDice = 13;
    }

    //Limit Caster level for the purposes of damage.
    if (nCasterLevel > nMaxDice)
    {
        nCasterLevel = nMaxDice;
    }
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Get the distance between the target and caster to delay the application of effects
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20.0;
            //Make SR check, and appropriate saving throw(s).
            if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay) && (oTarget != OBJECT_SELF))
            {
                //Detemine damage
                nDamage = d6(nCasterLevel);
                //Enter Metamagic conditions
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nDamage = 6 * nCasterLevel;//Damage is at max
                }
                else if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                    nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                }
                //Adjust damage according to Reflex Save, Evasion or Improved Evasion
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ACID);

                // Apply effects to the currently selected target.
                effect eAcid = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
                effect eAcid2 = EffectDamage (nDamage/2, DAMAGE_TYPE_ACID);
                effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);
                if(nDamage > 0)
                {
                    //Apply delayed effects
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eAcid, oTarget));
                    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_CONJURATION, OBJECT_SELF))
                    {
                       float fDelay2 = fDelay + 6.0;
                       DelayCommand (fDelay2, ApplyEffectToObject (DURATION_TYPE_INSTANT, eVis, oTarget));
                       DelayCommand (fDelay2, ApplyEffectToObject (DURATION_TYPE_INSTANT, eAcid2, oTarget));
                    }
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
