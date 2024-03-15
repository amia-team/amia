//::///////////////////////////////////////////////
//:: Name x2_sp_is_whit
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Ioun Stone Power: White
    Gives the user 1 hours worth of +1 universal saves bonus.
    Cancels any other Ioun stone powers in effect
    on the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: PaladinOfSune
//:: Created On: Oct 05/11
//:://////////////////////////////////////////////
//
//:: Glim: Changed to permanent duration and Supernatural effect.
//:: Lord-Jyssev: (3/15/24) Used TagEffect to make ioun check modular.

void main()
{
    //variables
    effect eVFX, eBonus, eLink, eEffect;

    //from any ioun stones (including self)
    eEffect = GetFirstEffect(OBJECT_SELF);
    while (GetIsEffectValid(eEffect) == TRUE)
    {
        if (GetEffectTag(eEffect) == "IounStone")
        {
            RemoveEffect(OBJECT_SELF, eEffect);
        }
        eEffect = GetNextEffect(OBJECT_SELF);
    }

    //Apply new ioun stone effect
    eVFX = EffectVisualEffect(695);
    eBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
    eLink = EffectLinkEffects(eVFX, eBonus);
    eLink = SupernaturalEffect( eLink );
    eLink = TagEffect( eLink, "IounStone");
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF);

}
