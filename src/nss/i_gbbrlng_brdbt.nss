// Gibberling Broodling OnHit bite to infect target with Gibberslugs
#include "x2_inc_switches"

// prototypes
void DoInjectGibberslug(object oVictim);
void DoGibberslugHatch(object oVictim);

void main()
{
    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {

        case X2_ITEM_EVENT_ONHITCAST:
        {
            // vars
            object oVictim=GetSpellTargetObject();

            // those immune to disease remain unaffected, as are undead an constructs
            int nRacialType=GetRacialType(oVictim);
            if((nRacialType==RACIAL_TYPE_UNDEAD) ||
               (nRacialType==RACIAL_TYPE_CONSTRUCT) ||
               (GetIsImmune(oVictim, IMMUNITY_TYPE_DISEASE)==TRUE))
            {
                break;
            }

            // check to see if they're already infected and stop if they are (can't double infect)
            if(GetLocalInt(oVictim, "Gibberslugs") > 0)
            {
                break;
            }

            // otherwise infect the target
            DelayCommand(0.1, DoInjectGibberslug(oVictim));
        }
        default:
        {
            break;
        }
    }
    SetExecutedScriptReturnValue(nResult);
}
void DoInjectGibberslug(object oVictim)
{
    // fortitude saving throw, DC 15
    if(FortitudeSave(oVictim, 16, SAVING_THROW_TYPE_DISEASE, OBJECT_SELF) == 0)
    {
        effect eVFX = EffectVisualEffect(VFX_IMP_DISEASE_S);
        string sName = GetName(oVictim, FALSE);
        string sInfect = "<c¥  >**As the Gibberling bites "+sName+", it injects something under their skin!**</c>";

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oVictim);
        SpeakString(sInfect, TALKVOLUME_TALK);
        FloatingTextStringOnCreature(sInfect, oVictim, FALSE);

        SetLocalInt(oVictim, "Gibberslugs", 1);

        AssignCommand(oVictim, DelayCommand(18.0, DoGibberslugHatch(oVictim)));
    }
}

void DoGibberslugHatch(object oVictim)
{
    //double check infection status, just in case
    if(GetLocalInt(oVictim, "Gibberslugs") != 1)
    {
        return;
    }

    effect eIchor = EffectVisualEffect(VFX_COM_CHUNK_GREEN_SMALL);
    effect eBlood = EffectVisualEffect(VFX_COM_BLOOD_LRG_RED);
    effect eDamage = EffectDamage(d4(1), DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL);
    location lVictim = GetLocation(oVictim);
    string sBurst = "<c¥  >**A Gibberslug bursts from your body and starts to slither away, growing...**</c>";

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eBlood, oVictim);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oVictim);
    DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eIchor, oVictim));

    CreateObject(OBJECT_TYPE_CREATURE, "gibberling_slug", lVictim, FALSE, "");

    object oSlug = GetNearestObjectByTag("gibberling_slug", oVictim);

    DelayCommand(0.5, AssignCommand(oSlug, ActionMoveAwayFromObject(oVictim, TRUE, 60.0f)));
    DelayCommand(2.5, AssignCommand(oSlug, ActionMoveAwayFromObject(oVictim, TRUE, 60.0f)));
    DelayCommand(5.0, AssignCommand(oSlug, ActionMoveAwayFromObject(oVictim, TRUE, 60.0f)));
    DelayCommand(7.5, AssignCommand(oSlug, ActionMoveAwayFromObject(oVictim, TRUE, 60.0f)));
    DelayCommand(10.0, AssignCommand(oSlug, ActionMoveAwayFromObject(oVictim, TRUE, 60.0f)));

    SpeakString(sBurst, TALKVOLUME_TALK);
    FloatingTextStringOnCreature(sBurst, oVictim, FALSE);

    SetLocalInt(oVictim, "Gibberslugs", 0);
}
