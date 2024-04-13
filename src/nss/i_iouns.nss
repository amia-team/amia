/*
    New Ioun Spell Script

    Citrine Ioun, Moonstone Ioun, Bloodstone Ioun, Obsidian Ioun

  - Maverick00053 4/12/2024
*/


#include "nwnx"
#include "nwnx_creature"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"


void main()
{
    //variables
    effect eVFX, eBonus, eBonus1, eBonus2, eBonus3, eBonus4, eLink, eEffect;
    object oIoun = GetItemActivated();
    object oPC = GetItemActivator();

    //from any ioun stones (including self)
    eEffect = GetFirstEffect(oPC);
    while (GetIsEffectValid(eEffect) == TRUE)
    {
        if (GetEffectTag(eEffect) == "IounStone")
        {
            RemoveEffect(oPC, eEffect);
        }
        eEffect = GetNextEffect(oPC);
    }

    if( GetResRef(oIoun) == "elyon_loot_11")
    {
        eVFX = EffectVisualEffect(694);
        eBonus1 = EffectImmunity(IMMUNITY_TYPE_POISON);
        eBonus2 = EffectImmunity(IMMUNITY_TYPE_DISEASE);
        eLink = EffectLinkEffects( eVFX, eBonus1 );
        eLink = EffectLinkEffects( eBonus2, eLink );
        eLink = SupernaturalEffect( eLink );
        eLink = TagEffect( eLink, "IounStone");
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oPC );
        return;
    }

    if( GetResRef(oIoun) == "elyon_loot_12")
    {
        eVFX = EffectVisualEffect(690);
        eBonus1 = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
        eBonus2 = EffectImmunity(IMMUNITY_TYPE_SLOW);
        eBonus3 = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
        eBonus4 = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);
        eLink = EffectLinkEffects( eVFX, eBonus1 );
        eLink = EffectLinkEffects( eBonus2, eLink );
        eLink = EffectLinkEffects( eBonus3, eLink );
        eLink = EffectLinkEffects( eBonus4, eLink );
        eLink = SupernaturalEffect( eLink );
        eLink = TagEffect( eLink, "IounStone");
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oPC );
        return;
    }

    if( GetResRef(oIoun) == "elyon_loot_13")
    {
        eVFX = EffectVisualEffect(691);
        eBonus1 = EffectBonusFeat(FEAT_EVASION);
        eLink = EffectLinkEffects( eVFX, eBonus1 );
        eLink = SupernaturalEffect( eLink );
        eLink = TagEffect( eLink, "IounStone");
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oPC );
        return;
    }

    if( GetResRef(oIoun) == "elyon_loot_14")
    {
        eVFX = EffectVisualEffect(693);
        eBonus1 = EffectSpellResistanceIncrease(32);
        eLink = EffectLinkEffects( eVFX, eBonus1 );
        eLink = SupernaturalEffect( eLink );
        eLink = TagEffect( eLink, "IounStone");
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oPC );
        return;
    }


}
