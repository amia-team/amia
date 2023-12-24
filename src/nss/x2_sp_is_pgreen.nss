//::///////////////////////////////////////////////
//:: Name x2_sp_is_pgreen
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Ioun Stone Power: Pink Green
    Gives the user 1 hours worth of +2 Charisma bonus.
    Cancels any other Ioun stone powers in effect
    on the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 13/02
//:://////////////////////////////////////////////
//:: PaladinOfSune: Added new hak visual
//:: Glim: Added name check for new Ioun stone type 02/23/14
//:: Glim: Changed to permanent duration and Supernatural effect.

void main()
{
    //variables
    effect eVFX, eBonus, eBonus1, eBonus2, eBonus3, eBonus4, eLink, eEffect;

    //from any ioun stones (including self)
    eEffect = GetFirstEffect(OBJECT_SELF);
    while (GetIsEffectValid(eEffect) == TRUE)
    {
        if(GetEffectSpellId(eEffect) > 553 && GetEffectSpellId(eEffect) < 561
            || GetEffectSpellId(eEffect) == 918
            || GetEffectSpellId(eEffect) == 919 )
        {
            RemoveEffect(OBJECT_SELF, eEffect);
        }
        eEffect = GetNextEffect(OBJECT_SELF);
    }

    //check first if it's a Labyrinth Ioun Stone
    if( GetResRef( GetSpellCastItem() ) == "is_chryso" )
    {
        eVFX = EffectVisualEffect(692);
        eBonus1 = EffectSkillIncrease(SKILL_HIDE, 5);
        eBonus2 = EffectSkillIncrease(SKILL_MOVE_SILENTLY, 5);
        eLink = EffectLinkEffects( eVFX, eBonus1 );
        eLink = EffectLinkEffects( eBonus2, eLink );
        eLink = SupernaturalEffect( eLink );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF );
        return;
    }

    if( GetResRef( GetSpellCastItem() ) == "is_lavender" )
    {
        eVFX = EffectVisualEffect(691);
        eBonus1 = EffectSkillIncrease(SKILL_DISCIPLINE, 5);
        eBonus2 = EffectSavingThrowIncrease (SAVING_THROW_FORT, 3);
        eLink = EffectLinkEffects( eVFX, eBonus1 );
        eLink = EffectLinkEffects( eBonus2, eLink );
        eLink = SupernaturalEffect( eLink );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF );
        return;
    }

    //Apply new ioun stone effect
    eVFX = EffectVisualEffect(692);
    eBonus = EffectAbilityIncrease(ABILITY_CHARISMA, 2);
    eLink = EffectLinkEffects(eVFX, eBonus);
    eLink = SupernaturalEffect( eLink );
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF);

}
