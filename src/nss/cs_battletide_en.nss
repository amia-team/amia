/*  Battletide spell: onEnter
        -   Mind-affecting spell
        -   No saving throw
        -   Spell Resistance check only
        -   AB -2, Damage -2, Saves -2
*/

// includes
#include "x2_i0_spells"

void main(){

    // vars
    object oPC=GetAreaOfEffectCreator();
    object oVictim=GetEnteringObject();
    int nCasterLevel=GetCasterLevel(oPC);
    float fDuration=RoundsToSeconds(nCasterLevel);

    // resolve Victim status [not a creature, not an enemy, immune to mind-affecting spells -> do nothing]
    if( (GetObjectType(oVictim)!=OBJECT_TYPE_CREATURE)  ||
        (GetIsEnemy(
            oVictim,
            oPC)==FALSE)                                ||
        (GetIsImmune(
            oVictim,
            IMMUNITY_TYPE_MIND_SPELLS,
            oPC)==TRUE)                                 ){

            return;

    }

    // Victim failed a Spell Resistance check
    if(MyResistSpell(
        oPC,
        oVictim,
        0.0)<1){

        // vars
        // AB -2
        effect eAttackPenalty=EffectAttackDecrease(2);

        // Damage -2
        effect eDamagePenalty=EffectDamageDecrease(2);

        // Universal saving throw penalty -2
        effect eSavingThrowPenalty=EffectSavingThrowDecrease(
            SAVING_THROW_ALL,
            2,
            SAVING_THROW_TYPE_ALL);

        // Battletide VFX
        effect eBattletideVFX=EffectVisualEffect(VFX_IMP_SUNSTRIKE);

        // pull it all together
        effect eBattletide=EffectLinkEffects(
            eAttackPenalty,
            eDamagePenalty);
        eBattletide=EffectLinkEffects(
            eBattletide,
            eSavingThrowPenalty);
        eBattletide=EffectLinkEffects(
            eBattletide,
            eBattletideVFX);

        // slap it on [these -will- not stack, so no need to check for it]
        ApplyEffectToObject(
            DURATION_TYPE_TEMPORARY,
            eBattletide,
            oVictim,
            fDuration);

    }

    return;

}
