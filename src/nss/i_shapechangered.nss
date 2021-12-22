/*
*   Creator: ZoltanTheRed
*
*   Last Updated: 10-05-2017
*
*   Description: This script is supposed to check to see if the user has any
*   valid(prepared and ready to cast) uses of Shapechange, then applies the default
*   red dragon shapechange to the user if it succeeds. Otherwise, it prints
*   a floating message above the user telling them that the spell failed.
 */

//BEGIN MAIN
void main()
{

    //Get the target. In this case, it should always be the activator.
    object oTarget = GetItemActivator();

    //Get caster level, calculate duration based on this, then get whether
    //they actually have the spell prepared or not.
    int nCasterLevel = GetCasterLevel(oTarget);
    float fDur = TurnsToSeconds(nCasterLevel);
    int nGetSpell = GetHasSpell(SPELL_SHAPECHANGE, oTarget);

    //Effects
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
    effect ePoly = EffectPolymorph(POLYMORPH_TYPE_RED_DRAGON);

    //Was the check successful? If it was, decrement uses of shapechange and then
    //apply the effect. Else, inform the user that their spell failed.
    if(nGetSpell == 1){

        DecrementRemainingSpellUses(oTarget, SPELL_SHAPECHANGE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oTarget, fDur);
    }else{

        FloatingTextStringOnCreature("Spell failed.", oTarget, FALSE);
    }

//END MAIN
}
