//::///////////////////////////////////////////////
//:: Druid Punch
//:: amx_csp_drdpunch.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Druidâ€™s Punch (Transmutation)
Level: Druid 8
Components: V,S
Range: Melee
Area of effect: Single
Duration: Instantaneous
Valid Metamagic: Empower, Maximize
Save: Fortitude Special
Spell Resistance: Yes

The caster attempts a punch to utterly destroy the unnatural. The caster makes a melee touch attack. If the attack hits, the victim takes 1d8 points of divine damage per caster level.
If the target is an undead, construct, outsider, or aberration, they must make a fortitude save or be slain instantly. Undead, constructs, outsiders, and aberrations take full damage even if they pass the save.
If the target is any other creature type, they can make a fortitude save to halve the damage taken.
*/
//:://////////////////////////////////////////////
//:: Created By: The1Kobra
//:: Created On: Feb 12, 2024
//:://////////////////////////////////////////////
//::

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_td_shifter"


int isUnnatural(object oCreature) {
    int iRtype = GetRacialType(oCreature);

    if (iRtype == RACIAL_TYPE_ABERRATION || iRtype == RACIAL_TYPE_CONSTRUCT ||
        iRtype == RACIAL_TYPE_OUTSIDER || iRtype == RACIAL_TYPE_UNDEAD) {
        return TRUE;
    }
    return FALSE;
}


void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();

    if ( GetObjectType(oTarget) != OBJECT_TYPE_CREATURE )
        return;

    float fDelay;

    int nCasterLevel = GetNewCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    if (TouchAttackMelee(oTarget)) {
        if (!MyResistSpell(OBJECT_SELF, oTarget)) {
            int nDamage = d8(nCasterLevel);
            if (nMetaMagic == METAMAGIC_MAXIMIZE) {
                nDamage = 8 * nCasterLevel;
            }
            if (nMetaMagic == METAMAGIC_EMPOWER) {
                nDamage = FloatToInt(nDamage * 1.5f);
            }
            if (isUnnatural(oTarget)) {
                // Target is unnatural, fort save or die instantly.
                if (!MySavingThrow(SAVING_THROW_FORT, oTarget, GetShifterDC( OBJECT_SELF, GetSpellSaveDC() ))) {
                    // Bypass Death Immunity for Undead/Construct targets
                    int BOSS_CUTOFF_HD = 40;
                    if ((GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT) || (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)) {
                        if (GetHitDice(oTarget) < BOSS_CUTOFF_HD) {
                            nDamage = nDamage + GetCurrentHitPoints(oTarget);
                        } else {
                           nDamage = nDamage + nDamage;
                        }
                    } else {
                        effect eInstaKill = EffectDeath(TRUE);
                        DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eInstaKill, oTarget));
                    }
                }
            } else {
                // Target is natural, fort save for half damage.
                if (MySavingThrow(SAVING_THROW_FORT, oTarget, GetShifterDC( OBJECT_SELF, GetSpellSaveDC() ))) {
                    nDamage = nDamage / 2;
                }
            }
            effect eDmg = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
            effect eVis = EffectVisualEffect(VFX_IMP_PULSE_HOLY);
            effect eLink = EffectLinkEffects(eVis,eDmg);

            DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));

        }
    }

}