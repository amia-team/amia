// Completed by Kungfoowiz on the 24th September 2005.

// Version 1.0.

// This script handles the OnHit of magma elementals.


// Magma paraelemental, singing claw
#include "x2_inc_switches"
#include "x2_inc_toollib"

// prototypes
void MagmaSinging(
    object oMagma,
    object oVictim);

void main()
{
    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {

        case X2_ITEM_EVENT_ONHITCAST:{

            // vars
            object oMagma=OBJECT_SELF;
            object oVictim=GetSpellTargetObject();

            // no stacking
            if(GetLocalInt(
                oVictim,
                "caught_on_fire")>0){

                break;

            }

            // reflex save, DC 30, catch alight
            if(ReflexSave(
                oVictim,
                30,
                SAVING_THROW_TYPE_FIRE,
                oMagma)<1){

                // candy
                effect eScorch=EffectVisualEffect(VFX_DUR_INFERNO_CHEST);
                TLVFXPillar(
                    VFX_IMP_FLAME_M,
                    GetLocation(oVictim),
                    5,
                    0.1f,
                    0.0f,
                    2.0f);


                // magma singing activated
                SetLocalInt(
                    oVictim,
                    "caught_on_fire",
                    1);

                // slap it on
                ApplyEffectToObject(
                    DURATION_TYPE_PERMANENT,
                    eScorch,
                    oVictim,
                    0.0);

                // singing applied each round
                MagmaSinging(
                    oMagma,
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
void MagmaSinging(
    object oMagma,
    object oVictim){

    // fire damage
    effect eSinge=EffectDamage(
        d6(1),
        DAMAGE_TYPE_FIRE);
    // candy
    eSinge=EffectLinkEffects(
        eSinge,
        EffectVisualEffect(VFX_IMP_FLAME_S));

    // slap it on
    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        eSinge,
        oVictim,
        0.0);

    // singing applied each round until reflex save is made
    if(ReflexSave(
        oVictim,
        30,
        SAVING_THROW_TYPE_FIRE,
        oMagma)>0){

        // extinguished
        SetLocalInt(
            oVictim,
            "caught_on_fire",
            0);

        // cancel singing vfx an exit recursive singe func
        effect eRemoveCombust=GetFirstEffect(oVictim);
        while(GetIsEffectValid(eRemoveCombust)==TRUE){

            if(GetEffectCreator(eRemoveCombust)==oMagma){

                RemoveEffect(
                    oVictim,
                    eRemoveCombust);

                break;

            }

            eRemoveCombust=GetNextEffect(oVictim);

        }

        return;

    }

    // apply singe again since reflex save was not made
    DelayCommand(
        6.0,
        MagmaSinging(
            oMagma,
            oVictim));

}
