/*  Dirge spell: onExit
        -   Remove STR and DEX penalties (only way to achieve this is via a lesser restore-like effect,
            best i can do since there is no way to differentiate which decreases belong to various spells.
*/

// includes
#include "x2_i0_spells"

void main(){

    // vars
    object oVictim=GetExitingObject();

    // lesser restore-like vfx (removes STR, DEX penalties, hopefully from Dirge)
    effect eAbilityPenalty=GetFirstEffect(oVictim);

    while(GetIsEffectValid(eAbilityPenalty)==TRUE){

        if( (GetEffectType(eAbilityPenalty)==EFFECT_TYPE_ABILITY_DECREASE)  &&
            (GetEffectSubType(eAbilityPenalty)!=SUBTYPE_SUPERNATURAL)       ){

            RemoveEffect(
                oVictim,
                eAbilityPenalty);

            break;

        }

        eAbilityPenalty=GetNextEffect(oVictim);

    }

    return;

}
