 // Completed by Kungfoowiz on the 24th September 2005.

// Version 1.0.

// This script handles the OnHit of the ice paraelemental.


// Ice paraelemental, chilling claw
#include "x2_inc_switches"
#include "x2_inc_toollib"

// prototypes
void IceChilling(
    object oIce,
    object oVictim);

void main()
{
    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {

        case X2_ITEM_EVENT_ONHITCAST:{

            // vars
            object oIce=OBJECT_SELF;
            object oVictim=GetSpellTargetObject();

            // no stacking
            if(GetLocalInt(
                oVictim,
                "ice_chilled")>0){

                break;

            }

            // will save, DC 30, chill touch
            if(WillSave(
                oVictim,
                32,
                SAVING_THROW_TYPE_COLD,
                oIce)<1){

                // candy
                effect eChilled=EffectVisualEffect(VFX_DUR_PARALYZED);
                effect eFrostBlast=EffectVisualEffect(VFX_IMP_FROST_L);

                // chill touch activated
                SetLocalInt(
                    oVictim,
                    "ice_chilled",
                    1);

                // chill impact
                ApplyEffectToObject(
                    DURATION_TYPE_INSTANT,
                    eFrostBlast,
                    oVictim,
                    0.0);
                // slap it on
                ApplyEffectToObject(
                    DURATION_TYPE_PERMANENT,
                    eChilled,
                    oVictim,
                    0.0);

                // chill applied each round
                IceChilling(
                    oIce,
                    oVictim);

            }

            break;
        }
        default:{
            break;
        }
    }
    SetExecutedScriptReturnValue(nResult);
}
void IceChilling(
    object oIce,
    object oVictim){

    // chill damage
    effect eFrost=EffectDamage(
        d6(2),
        DAMAGE_TYPE_COLD);
    // candy
    eFrost=EffectLinkEffects(
        eFrost,
        EffectVisualEffect(VFX_IMP_FROST_S));

    // slap it on
    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        eFrost,
        oVictim,
        0.0);

    // chill applied each round until will save is made
    if(WillSave(
        oVictim,
        32,
        SAVING_THROW_TYPE_COLD,
        oIce)>0){

        // thawed
        SetLocalInt(
            oVictim,
            "ice_chilled",
            0);

        // cancel chill vfx an exit recursive chill func
        effect eRemoveChill=GetFirstEffect(oVictim);
        while(GetIsEffectValid(eRemoveChill)==TRUE){

            if(GetEffectCreator(eRemoveChill)==oIce){

                RemoveEffect(
                    oVictim,
                    eRemoveChill);

                break;

            }

            eRemoveChill=GetNextEffect(oVictim);

        }

        return;

    }

    // apply chill again since will save was not made
    DelayCommand(
        6.0,
        IceChilling(
            oIce,
            oVictim));

}
