//::///////////////////////////////////////////////
//:: Isaacs Greater Missile Storm
//:: x0_s0_MissStorm2
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Up to 20 missiles, each doing 2d6 damage to each
 target in area.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 31, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: kfw (Cap missile storms to 10 missiles per foe).

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"


void GreaterMissileStorm(int nD6Dice, int nCap, int nSpell, int nMIRV = VFX_IMP_MIRV, int nVIS = VFX_IMP_MAGBLUE, int nDAMAGETYPE = DAMAGE_TYPE_MAGICAL, int nONEHIT = FALSE, int nReflexSave = FALSE) {
    object oTarget = OBJECT_INVALID;
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
//    int nDamage = 0;
    int nMetaMagic = GetMetaMagicFeat();
    int nCnt = 1;
    effect eMissile = EffectVisualEffect(nMIRV);
    effect eVis = EffectVisualEffect(nVIS);
    float fDist = 0.0;
    float fDelay = 0.0;
    float fDelay2, fTime;
    location lTarget = GetSpellTargetLocation(); // missile spread centered around caster
    int nMissiles = nCasterLvl;

    if (nMissiles > nCap) {
        nMissiles = nCap;
    }

    /* New Algorithm
        1. Count # of targets
        2. Determine number of missiles
        3. First target gets a missile and all Excess missiles
            4. Rest of targets (max nMissiles) get one missile
       */
    int nEnemies = 0;

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) ) {
        // * caster cannot be harmed by this spell
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF)) {
            // GZ: You can only fire missiles on visible targets
            if (GetObjectSeen(oTarget,OBJECT_SELF)) {
                nEnemies++;
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    if (nEnemies == 0) {
        return; // * Exit if no enemies to hit
    }
    int nExtraMissiles = nMissiles / nEnemies;

    // April 2003
    // * if more enemies than missiles, need to make sure that at least
    // * one missile will hit each of the enemies
    if (nExtraMissiles <= 0) {
        nExtraMissiles = 1;
    }

    // by default the Remainder will be 0 (if more than enough enemies for all the missiles)
    int nRemainder = 0;

    if (nExtraMissiles > 0) {
        nRemainder = nMissiles % nEnemies;
    }
    if (nEnemies > nMissiles) {
        nEnemies = nMissiles;
    }
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) && nCnt <= nEnemies) {
        // * caster cannot be harmed by this spell
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF) && (GetObjectSeen(oTarget,OBJECT_SELF))) {
                //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));

            // * recalculate appropriate distances
            fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
            fDelay = fDist/(3.0 * log(fDist) + 2.0);

            int i = 0;
            // Cap to 10 per foe.
            int nNumberOfMissiles = nExtraMissiles + nRemainder;
            if( nNumberOfMissiles > 10 ) {
                nNumberOfMissiles = 10;
            }
                //--------------------------------------------------------------
                // GZ: Moved SR check out of loop to have 1 check per target
                //     not one check per missile, which would rip spell mantels
                //     apart
                //--------------------------------------------------------------
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay)) {
                for (i=1; i <= nNumberOfMissiles; i++) {
                    //Roll damage
                    int nDam = d6(nD6Dice);
                    //Enter Metamagic conditions
                    if (nMetaMagic == METAMAGIC_MAXIMIZE) {
                        nDam = nD6Dice*6;//Damage is at max
                    }
                    if (nMetaMagic == METAMAGIC_EMPOWER)  {
                        nDam = nDam + nDam/2; //Damage/Healing is +50%
                    }

                    fTime = fDelay;
                    fDelay2 += 0.1;
                    fTime += fDelay2;

                    //Set damage effect
                    effect eDam = EffectDamage(nDam, nDAMAGETYPE);
                    //Apply the MIRV and damage effect
                    DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
                    DelayCommand(fDelay2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
                    DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));

                }
            } // fore
            else {  // * apply a dummy visual effect
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
            }
            nCnt++;// * increment count of missiles fired
            nRemainder = 0;
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}

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


    // T1K: Buggy method, doing it my way
    int nDmgDice = 2;
    //DoMissileStorm(2, GetCasterLevel( OBJECT_SELF ), SPELL_ISAACS_GREATER_MISSILE_STORM);
    GreaterMissileStorm(nDmgDice, GetCasterLevel( OBJECT_SELF ), SPELL_ISAACS_GREATER_MISSILE_STORM);


}

