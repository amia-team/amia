//::///////////////////////////////////////////////
//:: Name x2_sp_is_purp
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Ioun Stone Power: Purple
    Gives the user 1 hours worth of +2 Regeneration bonus.
    Cancels any other Ioun stone powers in effect
    on the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: PaladinOfSune
//:: Created On: Oct 05/11
//:://////////////////////////////////////////////
//
//:: Glim: Added name check for new Ioun stone type 02/23/14
//:: Glim: Changed to permanent duration and Supernatural effect.
//:: Lord-Jyssev: (3/15/24) Used TagEffect to make ioun check modular.

void main()
{
    //variables
    effect eVFX, eBonus, eBonus1, eBonus2, eBonus3, eLink, eEffect;

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

    //check first if it's a Labyrinth Ioun Stone
    if(GetTag(GetSpellCastItem()) == "epx_ioun_iolit" ||
        GetResRef(GetSpellCastItem()) == "is_iol")
    {
        eVFX = EffectVisualEffect(693);
        eBonus1 = EffectSkillIncrease(SKILL_LORE, 5);
        eBonus2 = EffectSkillIncrease(SKILL_SPELLCRAFT, 5);
        eBonus3 = EffectAreaOfEffect( AOE_MOB_DRAGON_FEAR, "ioldiskenter", "****", "iouldiskexit" );
        eLink = EffectLinkEffects( eVFX, eBonus1 );
        eLink = EffectLinkEffects( eBonus2, eLink );
        eLink = EffectLinkEffects( eBonus3, eLink );
        eLink = SupernaturalEffect( eLink );
        eLink = TagEffect( eLink, "IounStone");
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF );
        return;
    }

    //Apply new ioun stone effect
    eVFX = EffectVisualEffect(693);
    eBonus = EffectRegenerate(2, 6.0);
    eLink = EffectLinkEffects(eVFX, eBonus);
    eLink = SupernaturalEffect( eLink );
    eLink = TagEffect( eLink, "IounStone");
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF);

}
