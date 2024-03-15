//::///////////////////////////////////////////////
//:: Name x2_sp_is_dred
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Ioun Stone Power: Deep Red
    Gives the user 1 hours worth of +2 Dexterity bonus.
    Cancels any other Ioun stone powers in effect
    on the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 13/02
//:://////////////////////////////////////////////
//:: PaladinOfSune: Added new hak visual
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
    eVFX = EffectVisualEffect(691);
    eBonus = EffectAbilityIncrease(ABILITY_DEXTERITY, 2);
    eLink = EffectLinkEffects(eVFX, eBonus);
    eLink = SupernaturalEffect( eLink );
    eLink = TagEffect( eLink, "IounStone");
    eLink = TagEffect( eLink, "IounStone");
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF);

}
