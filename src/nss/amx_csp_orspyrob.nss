//::///////////////////////////////////////////////
//:: Orson's Pyromagic on Heartbeat
//:://////////////////////////////////////////////
/*
    Prolonged exposure to the aura of the creature
    causes fire damage to all within the aura.
*/

#include "NW_I0_SPELLS"

void main()
{
    int nDamage;
    int nDamSave;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    int nMetaMagic = GetMetaMagicFeat();
    //Get first target in spell area
    object oCaster = OBJECT_SELF;
    object oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget)) {
        if(GetIsEnemy(oTarget, GetAreaOfEffectCreator())) {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), GetSpellId()));
            //Roll damage

            //Make a saving throw check and SR check
            if (!MyResistSpell(oCaster, oTarget)) {
                if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE)) {

                    int nCL = GetCasterLevel(oCaster);
                    nDamage = d6(2) + nCL;

                    if (nMetaMagic == METAMAGIC_MAXIMIZE) {
                        nDamage = 12 + nCL;
                    }
                    if (nMetaMagic == METAMAGIC_EMPOWER) {
                        nDamage = nDamage + (nDamage/2);
                    }

                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                }
            }
            //Set the damage effect
        }

        //Get next target in spell area
        oTarget = GetNextInPersistentObject();
    }
}