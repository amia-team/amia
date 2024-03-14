/*
    Chromatic Crystal Item Script

    Creates an ioun-like effect on the player based on their
    highest ability score. The ability score is only +1 instead
    of the traditional +2.

    Cannot be stacked with itself or other ioun stones,
    but will stack with other ability boosts.

    3/14/24 - Lord-Jyssev; created script
 */

void main()
{
    //variables
    effect eVFX, eBonus, eLink, eEffect;
    object oPC = GetItemActivator();
    object oItem = GetItemActivated();



    //from any ioun stones (including self)
    eEffect = GetFirstEffect(oPC);
    while (GetIsEffectValid(eEffect) == TRUE)
    {
        if (GetEffectTag(eEffect) == "IounStone")
        {
            RemoveEffect(oPC, eEffect);
        }

        if(GetEffectSpellId(eEffect) > 553 && GetEffectSpellId(eEffect) < 561
            || GetEffectSpellId(eEffect) == 918
            || GetEffectSpellId(eEffect) == 919 )
        {
            RemoveEffect(oPC, eEffect);
        }
        eEffect = GetNextEffect(oPC);
    }

    //Find highest ability score
    int nHighestScore = -1; // Initialize to a value lower than any possible ability score
    int nAbilityScore;
    int nHighestScoreIndex;

    // Loop through each ability score and compare
    int i;
    for (i = ABILITY_STRENGTH; i <= ABILITY_CHARISMA; i++)
    {
        // Get the ability score of the player
        nAbilityScore = GetAbilityScore(oPC, i, TRUE);

        // Check if the current ability score is higher than the highest recorded score
        if (nAbilityScore > nHighestScore)
        {
            nHighestScore = nAbilityScore;
            nHighestScoreIndex = i;
        }
    }

    //Randomize VFX color
    int nVFXIndex = Random(4)+499;

    //Apply new ioun stone effect
    eVFX = EffectVisualEffect(nVFXIndex);
    eBonus = EffectAbilityIncrease(nHighestScoreIndex, 1);
    eLink = EffectLinkEffects(eVFX, eBonus);
    eLink = SupernaturalEffect( eLink );
    eLink = TagEffect( eLink, "IounStone");
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);

}
