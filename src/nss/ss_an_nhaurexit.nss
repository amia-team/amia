//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ss_an_nhauraexit
//group:   Shadowscape Wastes
//used as: OnExit (aura)
//date:    June 2 2014
//author:  Anatida
//
//Clears effects from custom Desecrating Aura for Nightshade, Nighthaunt

void main()
{

object oCreature = GetExitingObject();

if ((GetRacialType(oCreature)==IP_CONST_RACIALTYPE_UNDEAD))
    {
    object oTarget;
    oTarget = oCreature;

    effect eAttackDecrease = EffectAttackDecrease(2);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttackDecrease, oTarget);

    effect eDmgBonus = EffectDamageDecrease(2, DAMAGE_TYPE_MAGICAL);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDmgBonus, oTarget);

    effect eSaveDecrease = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSaveDecrease, oTarget);

    int nTempHP = GetLocalInt(oCreature, "TempHP");
    effect eRemTempHitPoints = EffectDamage(nTempHP, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL );
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRemTempHitPoints, oTarget);

    effect eTurnResistance = EffectTurnResistanceDecrease(6);
    eTurnResistance = SupernaturalEffect(eTurnResistance);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTurnResistance, oTarget);
    }

}
