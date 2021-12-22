// Custom item: Brightaxe "Faction" Item - Barak Runedar
//
// An item that, when equiped projects an aura granting:
// 15/- Fire Resistance
// +4 to Will saves vs Fear
// +2 Morale bonus to attack rolls
// +2 Morale bonus to damage rolls
// +4 Concentration
// +4 Discipline
//
// Balanced around going in a main hand slot.
//
// Files:
// i_dwarvenflag - equip/unequip
// i_dwarvenflag_en - aoe onenter script
// i_dwarvenflag_ex - aoe onexit script
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 2015/12/12 BasicHuman       Initial Release.
//

effect EffectDwarvenFlagEffect();

#include "x2_inc_switches"

void main()
{
    object oPC;
    object oItem;
    int nEvent  = GetUserDefinedItemEventNumber();

    switch(nEvent)
    {
        case X2_ITEM_EVENT_EQUIP:
            oPC         = GetPCItemLastEquippedBy();
            oItem       = GetPCItemLastEquipped();
            AssignCommand(oItem,//we make the item itself create the effects, for tracking
                          DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                                                EffectDwarvenFlagEffect(),
                                                                oPC)));
            break;
        case X2_ITEM_EVENT_UNEQUIP:
            oPC         = GetPCItemLastUnequippedBy();
            oItem       = GetPCItemLastUnequipped();
            effect e = GetFirstEffect(oPC);
            while(GetIsEffectValid(e))
            {
                if(GetEffectCreator(e) == oItem)
                {
                    RemoveEffect(oPC, e);
                }
                e = GetNextEffect(oPC);
            }
            break;
    }
}

effect EffectDwarvenFlagEffect()
{
    effect eAOE = EffectAreaOfEffect(36, "i_dwarvenflag_en", "****", "i_dwarvenflag_ex");
    effect eFireResist = EffectDamageResistance(DAMAGE_TYPE_FIRE, 15);
    effect eWillSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_FEAR);
    effect eAttackBonus = EffectAttackIncrease(2, ATTACK_BONUS_MISC);
    effect eDamageIncrease = EffectDamageIncrease(2);
    effect eConcentration = EffectSkillIncrease(SKILL_CONCENTRATION,4);
    effect eDiscipline = EffectSkillIncrease(SKILL_DISCIPLINE,4);

    effect eLinked = EffectLinkEffects(eFireResist, eAOE);
    eLinked = EffectLinkEffects(eLinked, eWillSave);
    eLinked = EffectLinkEffects(eLinked, eAttackBonus);
    eLinked = EffectLinkEffects(eLinked, eDamageIncrease);
    eLinked = EffectLinkEffects(eLinked, eConcentration);
    eLinked = EffectLinkEffects(eLinked, eDiscipline);

    return SupernaturalEffect(eLinked);
}


