//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ss_an_nhauraenter
//group:   Shadowscape Wastes
//used as: OnEnter (aura)
//date:    June 2 2014
//author:  Anatida
//
//Custom Desecrating Aura for Nightshade, Nighthaunt
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

void main()
{

object oCreature = GetEnteringObject();

if ((GetRacialType(oCreature)==IP_CONST_RACIALTYPE_UNDEAD))
    {
    object oTarget;
    oTarget = oCreature;

    effect eAttackIncrease = EffectAttackIncrease(2);
    eAttackIncrease = SupernaturalEffect(eAttackIncrease);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttackIncrease, oTarget);

    effect eDmgBonus = EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_MAGICAL);
    eDmgBonus = SupernaturalEffect(eDmgBonus);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDmgBonus, oTarget);

    effect eSaveIncrease = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
    eSaveIncrease = SupernaturalEffect(eSaveIncrease);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSaveIncrease, oTarget);

    int nHD = GetHitDice(oCreature);
    int nTempHP = (nHD * 2);
    effect eTempHitPoints = EffectTemporaryHitpoints(nTempHP);
    eTempHitPoints = SupernaturalEffect(eTempHitPoints);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTempHitPoints, oTarget);
    SetLocalInt(oCreature, "TempHP", nTempHP);

    effect eTurnResistance = EffectTurnResistanceIncrease(6);
    eTurnResistance = SupernaturalEffect(eTurnResistance);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTurnResistance, oTarget);
    }
}
