// Completed by Kungfoowiz on the 24th September 2005.

// Version 1.0.

// This script handles the OnHit of the summoned shadow.


// Shadow of the Void constitution draining claw
#include "x2_inc_switches"

// prototypes
void DoShadowVoidBlight(object oVictim);

void main()
{
    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {

        case X2_ITEM_EVENT_ONHITCAST:{

            // vars
            object oShadow=OBJECT_SELF;
            object oVictim=GetSpellTargetObject();

            // those immune to level drain remain unaffected, as are undead an constructs
            int nRacialType=GetRacialType(oVictim);
            if(     (nRacialType==RACIAL_TYPE_UNDEAD)     ||
                    (nRacialType==RACIAL_TYPE_CONSTRUCT)  ||
                    (GetIsImmune(
                        oVictim,
                        IMMUNITY_TYPE_ABILITY_DECREASE,
                        oShadow)==TRUE)                      ){

                break;

            }

            // do a touch attack to see if the shadow of the void's con-draining claw hits
            if(TouchAttackMelee(
                oVictim,
                TRUE)>0){

                // drain the target
                DelayCommand(
                    0.1,
                    DoShadowVoidBlight(oVictim));

                // if the creature is reduced to a CON score of 3, it is instantly slain by the shadow of the void
                if(GetAbilityScore(
                    oVictim,
                    ABILITY_CONSTITUTION)<4){

                    // reduce the victim below -10 hp
                    int nCurrentHP=GetCurrentHitPoints(oVictim);
                    effect eShadowSmite=EffectDamage(nCurrentHP+50);

                    // candy
                    eShadowSmite=EffectLinkEffects(
                        eShadowSmite,
                        EffectVisualEffect(VFX_IMP_DEATH));

                    // lights out!
                    ApplyEffectToObject(
                        DURATION_TYPE_INSTANT,
                        eShadowSmite,
                        oVictim,
                        0.0);

                }
            }

            break;
        }
        default:{
            break;
        }
    }
    SetExecutedScriptReturnValue(nResult);
}
void DoShadowVoidBlight(object oVictim){


    // fortitude saving throw, DC 35
    if(FortitudeSave(
        oVictim,
        35,
        SAVING_THROW_TYPE_NEGATIVE,
        OBJECT_SELF)==0){

        // 1d6 Constitution drain
        effect eCON_drain=EffectAbilityDecrease(
            ABILITY_CONSTITUTION,
            d6(1));

        // candy
        eCON_drain=EffectLinkEffects(
            eCON_drain,
            EffectVisualEffect(VFX_IMP_FLAME_M));

        // slap it on
        ApplyEffectToObject(
            DURATION_TYPE_PERMANENT,
            eCON_drain,
            oVictim,
            0.0);

    }
}
