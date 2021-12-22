//::///////////////////////////////////////////////
//:: Meteor Swarm
//:: NW_S0_MetSwarm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Everyone in a 50ft radius around the caster
    takes 20d6 fire damage.  Those within 6ft of the
    caster will take no damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 24 , 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001

// corrected and cleaned on 2007-02-07 by disco

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main(){

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode()){
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    int nMetaMagic;
    int nDamage;
    int nFireDamage;
    int nBludgDamage;
    int nCasterLevel = GetCasterLevel( OBJECT_SELF );
    effect eFire;
    effect eBludgeon;
    effect eMeteor = EffectVisualEffect(VFX_FNF_METEOR_SWARM);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    float fDelay;
    float fSafeDistance = 2.0;

    //Apply the meteor swarm VFX area impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eMeteor, GetLocation(OBJECT_SELF));

    //Get first object in the spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));

    while(GetIsObjectValid(oTarget)){

        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF){

            fDelay = GetRandomDelay();

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_METEOR_SWARM));

            //narrow the safe zone for epic focus
            if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
            {
                fSafeDistance = 0.1;
            }
            //Make sure the target is outside the 2m safe zone
            if (GetDistanceBetween(oTarget, OBJECT_SELF) > fSafeDistance){

                //Make SR check
                if (!MyResistSpell(OBJECT_SELF, oTarget, 0.5)){

                      //Roll damage
                      nFireDamage = d4(nCasterLevel);
                      nBludgDamage = d4(nCasterLevel);

                      //Enter Metamagic conditions
                      if (nMetaMagic == METAMAGIC_MAXIMIZE){

                         nFireDamage = 60;//Damage is at max
                         nBludgDamage = 60;//Damage is at max
                      }
                      if (nMetaMagic == METAMAGIC_EMPOWER){

                         nFireDamage = nFireDamage + (nFireDamage/2); //Damage/Healing is +50%
                         nBludgDamage = nBludgDamage + (nBludgDamage/2); //Damage/Healing is +50%
                      }

                      nFireDamage  = GetReflexAdjustedDamage(nFireDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
                      nBludgDamage = GetReflexAdjustedDamage(nBludgDamage, oTarget, GetSpellSaveDC());

                      //Set the damage effect
                      if(nFireDamage > 0){

                          eFire     = EffectDamage(nFireDamage, DAMAGE_TYPE_FIRE);

                          //Apply damage effect and VFX impact.
                          DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
                          DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                      }

                      if (nBludgDamage > 0){

                          eBludgeon = EffectDamage( nBludgDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_FIVE );

                          DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBludgeon, oTarget));
                      }
                 }
            }
        }
        //Get next target in the spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}

