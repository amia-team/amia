//::///////////////////////////////////////////////
//:: Name x2_sp_is_drose
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Ioun Stone Power: Dusty Rose
    Gives the user 1 hours worth of +1 AC bonus Dodge
    Cancels any other Ioun stone powers in effect
    on the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 13/02
//:://////////////////////////////////////////////
//:: PaladinOfSune: Added new hak visual, changed AC to Dodge
//:: Glim: Changed to permanent duration and Supernatural effect.

void main()
{
    //variables
    effect eVFX, eBonus, eLink, eEffect;

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

    //Apply new ioun stone effect
    eVFX = EffectVisualEffect(694);
    eBonus = EffectACIncrease(1, AC_DODGE_BONUS);
    eLink = EffectLinkEffects(eVFX, eBonus);
    eLink = SupernaturalEffect( eLink );
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF);

}
