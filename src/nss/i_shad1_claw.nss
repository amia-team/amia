// Completed by Kungfoowiz on the 24th September 2005.

// Version 1.0.

// This script handles the OnHit of the summoned shadow.

// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
//2012-05-27  Naivatkal        Altered claw attack for Epic Shadowlord

// Shadow strength draining claw
#include "x2_inc_switches"
#include "nw_i0_spells"

// prototypes
void DoShadowDrain(object oVictim, object oSD);

void main()
{
    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;
    object oSD = GetMaster(OBJECT_SELF);

    switch (nEvent)
    {
        case X2_ITEM_EVENT_ONHITCAST:
        {
            // vars
            object oShadow=OBJECT_SELF;
            object oVictim=GetSpellTargetObject();

            // those immune to level drain remain unaffected, as are undead an constructs
            int nRacialType=GetRacialType(oVictim);
            if(     (nRacialType==RACIAL_TYPE_UNDEAD)     ||
                    (nRacialType==RACIAL_TYPE_CONSTRUCT)  ||
                    (GetIsImmune(oVictim, IMMUNITY_TYPE_ABILITY_DECREASE, oShadow)==TRUE))
            {
                break;
            }

            // do a touch attack to see if the shadow's strength-draining claw hits
            if(TouchAttackMelee(oVictim, TRUE)>0)
            {
                // drain the target
                DelayCommand(0.1, DoShadowDrain(oVictim, oSD));

                // Checking for Epic Shadowlord
                if (GetHasFeat(FEAT_EPIC_EPIC_SHADOWLORD, oSD) == TRUE)
                {
                    // if the creature is reduced to a CON score of 3, it is instantly slain by the shadow
                    if(GetAbilityScore(oVictim, ABILITY_CONSTITUTION)<4)
                    {
                        // reduce the victim below -10 hp
                        int nCurrentHP=GetCurrentHitPoints(oVictim);
                        effect eShadowSmite=EffectDamage(nCurrentHP+50);

                        // candy
                        eShadowSmite=EffectLinkEffects(eShadowSmite, EffectVisualEffect(VFX_IMP_DEATH));

                        // lights out!
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eShadowSmite, oVictim, 0.0);
                    }
                }
                else
                {
                    // if the creature is reduced to a STR score of 3, it is instantly slain by the shadow
                    if(GetAbilityScore(oVictim, ABILITY_STRENGTH)<4)
                    {
                        // reduce the victim below -10 hp
                        int nCurrentHP=GetCurrentHitPoints(oVictim);
                        effect eShadowSmite=EffectDamage(nCurrentHP+50);

                        // candy
                        eShadowSmite=EffectLinkEffects(eShadowSmite, EffectVisualEffect(VFX_IMP_DEATH));

                        // lights out!
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eShadowSmite, oVictim, 0.0);
                    }
                }
            }

            break;
        }
        default:
        {
            break;
        }
    }
    SetExecutedScriptReturnValue(nResult);
}

void DoShadowDrain(object oVictim, object oSD)
{
    int nShadowRank = GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oSD);

    // Check if SD has Epic Shadowlord
    if (GetHasFeat(FEAT_EPIC_EPIC_SHADOWLORD, oSD) == TRUE)
    {
        switch(nShadowRank)
        {
            case 13:
            {
                // 1d4 CON drain
                effect eCON_drain = EffectAbilityDecrease(ABILITY_CONSTITUTION, d4(1));

                // Declare saving throw
                int CONdrainDC = MySavingThrow(SAVING_THROW_FORT, oVictim, 36, SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, 0.0);

                // Visual
                eCON_drain = EffectLinkEffects(eCON_drain, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE));

                // Apply
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCON_drain, oVictim, 0.0);

                break;
            }
            case 14:
            {
                // 1d4 CON drain
                effect eCON_drain = EffectAbilityDecrease(ABILITY_CONSTITUTION, d4(1));

                // Declare saving throw
                int CONdrainDC = MySavingThrow(SAVING_THROW_FORT, oVictim, 36, SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, 0.0);

                // Visual
                eCON_drain = EffectLinkEffects(eCON_drain, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE));

                // Apply
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCON_drain, oVictim, 0.0);

                break;
            }
            case 15:
            {
                // 1d4 CON drain
                effect eCON_drain = EffectAbilityDecrease(ABILITY_CONSTITUTION, d4(1));

                // Declare saving throw
                int CONdrainDC = MySavingThrow(SAVING_THROW_FORT, oVictim, 38, SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, 0.0);

                // Visual
                eCON_drain = EffectLinkEffects(eCON_drain, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE));

                // Apply
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCON_drain, oVictim, 0.0);

                break;
            }
            case 16:
            {
                // 1d6 CON drain
                effect eCON_drain = EffectAbilityDecrease(ABILITY_CONSTITUTION, d6(1));

                // Declare saving throw
                int CONdrainDC = MySavingThrow(SAVING_THROW_FORT, oVictim, 38, SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, 0.0);

                // Visual
                eCON_drain = EffectLinkEffects(eCON_drain, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE));

                // Apply
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCON_drain, oVictim, 0.0);

                break;
            }
            case 17:
            {
                // 1d6 CON drain
                effect eCON_drain = EffectAbilityDecrease(ABILITY_CONSTITUTION, d6(1));

                // Declare saving throw
                int CONdrainDC = MySavingThrow(SAVING_THROW_FORT, oVictim, 40, SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, 0.0);

                // Visual
                eCON_drain = EffectLinkEffects(eCON_drain, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE));

                // Apply
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCON_drain, oVictim, 0.0);

                break;
            }
            case 18:
            {
                // 1d6 CON drain
                effect eCON_drain = EffectAbilityDecrease(ABILITY_CONSTITUTION, d6(1));

                // Declare saving throw
                int CONdrainDC = MySavingThrow(SAVING_THROW_FORT, oVictim, 40, SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, 0.0);

                // Visual
                eCON_drain = EffectLinkEffects(eCON_drain, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE));

                // Apply
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCON_drain, oVictim, 0.0);

                break;
            }
            case 19:
            {
                // 1d6 CON drain and 1d2 STR drain
                effect eCON_drain = EffectAbilityDecrease(ABILITY_CONSTITUTION, d6(1));
                effect eSTR_drain = EffectAbilityDecrease(ABILITY_STRENGTH, d2(1));

                // Declare saving throws
                int CONdrainDC = MySavingThrow(SAVING_THROW_FORT, oVictim, 40, SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, 0.0);
                int STRdrainDC = MySavingThrow(SAVING_THROW_FORT, oVictim, 40, SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, 0.0);

                // Visual
                eCON_drain = EffectLinkEffects(eCON_drain, eSTR_drain);
                eCON_drain = EffectLinkEffects(eCON_drain, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE));

                // Apply
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCON_drain, oVictim, 0.0);

                break;
            }
            case 20:
            {
                // 1d8 CON drain and 1d2 STR drain
                effect eCON_drain = EffectAbilityDecrease(ABILITY_CONSTITUTION, d8(1));
                effect eSTR_drain = EffectAbilityDecrease(ABILITY_STRENGTH, d2(1));

                // Declare saving throws
                int CONdrainDC = MySavingThrow(SAVING_THROW_FORT, oVictim, 42, SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, 0.0);
                int STRdrainDC = MySavingThrow(SAVING_THROW_FORT, oVictim, 42, SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, 0.0);

                // Visual
                eCON_drain = EffectLinkEffects(eCON_drain, eSTR_drain);
                eCON_drain = EffectLinkEffects(eCON_drain, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE));

                // Apply
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCON_drain, oVictim, 0.0);

                break;
            }
        }
    }
    else
    {
        // 1d8 STR drain
        effect eSTR_drain=EffectAbilityDecrease(ABILITY_STRENGTH, d8(1));

        // Visual
        eSTR_drain=EffectLinkEffects(eSTR_drain, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE));

        // Apply
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSTR_drain, oVictim, 0.0);
    }
}
