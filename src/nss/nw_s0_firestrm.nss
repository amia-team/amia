//::///////////////////////////////////////////////
//:: Fire Storm
//:: NW_S0_FireStm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a zone of destruction around the caster
    within which all living creatures are pummeled
    with fire.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 11, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 21, 2001

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_td_shifter"
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
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    int nDamage2;
    int nCasterLevel = GetNewCasterLevel(OBJECT_SELF);
    int nCap = 20;
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eFireStorm = EffectVisualEffect(VFX_FNF_FIRESTORM);
    float fDelay;

    //determin bonus for spell foci
    if (GetHasFeat (FEAT_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nCap = 22;
    }
    if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nCap = 24;
    }
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nCap = 26;
    }
    if (nCasterLevel > nCap)
    {
        nCasterLevel = nCap;
    }


    if( GetIsPolymorphed( OBJECT_SELF ) && GetLevelByClass( CLASS_TYPE_SHIFTER, OBJECT_SELF ) > 0 )
    {
       int firestormcd = GetLocalInt(OBJECT_SELF,"firestormcd");

       if(firestormcd == 0)
       {
        SetLocalInt(OBJECT_SELF,"firestormcd",1);
        DelayCommand(6.0,DeleteLocalInt(OBJECT_SELF,"firestormcd"));
       }
       else
       {
         SendMessageToPC(OBJECT_SELF,"Fire Storm is on cool down for 5 rounds. This is a Shifter form only cool down.");
         return;
       }
    }


    //Apply Fire and Forget Visual in the area;
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFireStorm, GetLocation(OBJECT_SELF));
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        //This spell smites everyone who is more than 2 meters away from the caster.
        //if (GetDistanceBetween(oTarget, OBJECT_SELF) > 2.0)
        //{
            if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
            {
                fDelay = GetRandomDelay(1.5, 2.5);
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FIRE_STORM));
                //Make SR check, and appropriate saving throw(s).
                if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                {
                      //Roll Damage
                      nDamage = d6(nCasterLevel);
                      //Enter Metamagic conditions
                      if (nMetaMagic == METAMAGIC_MAXIMIZE)
                      {
                         nDamage = 6 * nCasterLevel;//Damage is at max
                      }
                      else if (nMetaMagic == METAMAGIC_EMPOWER)
                      {
                         nDamage = nDamage + (nDamage/2);//Damage/Healing is +50%
                      }
                      //Save versus both holy and fire damage
                      nDamage2 = GetReflexAdjustedDamage(nDamage/2, oTarget, GetShifterDC( OBJECT_SELF, GetSpellSaveDC()), SAVING_THROW_TYPE_DIVINE);
                      nDamage = GetReflexAdjustedDamage(nDamage/2, oTarget, GetShifterDC( OBJECT_SELF, GetSpellSaveDC()), SAVING_THROW_TYPE_FIRE);
                    if(nDamage > 0)
                    {
                          // Apply effects to the currently selected target.  For this spell we have used
                          //both Divine and Fire damage.
                          effect eDivine = EffectDamage(nDamage2, DAMAGE_TYPE_DIVINE);
                          effect eFire = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                          DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
                          DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDivine, oTarget));
                          DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }
                }
            //}
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }


}
