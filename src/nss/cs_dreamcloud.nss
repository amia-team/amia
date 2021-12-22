// Custom spell: Dreamcloud
//
// Dream cloud creates a bank of fog. All caught within the area of effect
// must win against a will save or fall into a comatose slumber (Sleep)
// for 1d6 rounds. If the victim is not a sleep, they are required to
// roll again for the effect.
//
//
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 2015/12/14 BasicHuman       Initial Release.
// 2018/06/15 Elyon            Fix in sleep roll

#include "X0_I0_SPELLS"
#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "inc_dc_spells"

void DoAoeEnter();
void DoSlumber(int iDC, object oCaster, object oVictim, int bIsFirstCheck, object oAOE, effect eSleep);

void main()
{
    //using this same script to do the aoe enter
    if(GetIsObjectValid(GetAreaOfEffectCreator()))
    {
        DoAoeEnter();
        return;
    }

    int nMetaMagic = GetMetaMagicFeat();
    int iCL = GetCasterLevel(OBJECT_SELF);
    location lTargetLoc = GetSpellTargetLocation();
    int iDur = 2 + iCL/3;

    if(nMetaMagic == METAMAGIC_EXTEND)
    {
        iDur = iDur*2;
    }

    effect eVFX = EffectVisualEffect(VFX_IMP_CHARM);
    effect eAOE = EffectAreaOfEffect(39, "cs_dreamcloud", "****", "****");
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTargetLoc, RoundsToSeconds(iDur));
    DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF));
}

void DoAoeEnter()
{
    object oCaster = GetAreaOfEffectCreator();
    object oVictim = GetEnteringObject();
    int iDC = GetSpellSaveDC()+ SetSpellSchool(oCaster, 2);
    effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);
    effect eLink = EffectLinkEffects(eVis, EffectSleep());

    if(GetIsEnemy(oVictim, oCaster))
     DoSlumber(iDC, oCaster, oVictim, 1, OBJECT_SELF, eLink);

}

void DoSlumber(int iDC, object oCaster, object oVictim, int bIsFirstCheck, object oAOE, effect eSleep)
{
    int bStillHasSleep = FALSE;
    effect e = GetFirstEffect(oVictim);
    //loop all effects to see if victim is sleeping
    while(GetIsEffectValid(e))
    {
    if(e == eSleep)
    {
        bStillHasSleep = TRUE;
        break;
    }
        e = GetNextEffect(oVictim);
    }

    // if victim is not sleeping, roll.
    if(!bStillHasSleep){
    // using saving throw type poison, mind immunity will stop the effect itself
    int iSave = MySavingThrow(SAVING_THROW_WILL, oVictim, iDC, SAVING_THROW_TYPE_POISON, oCaster,0.1);
    if(!iSave&&GetIsImmune(oVictim, IMMUNITY_TYPE_POISON, oCaster))
    {
        iSave = TRUE;
        SendMessageToPC(oCaster, GetName(oVictim)+": is immune to the spell.");
        if(GetIsPC(oVictim))
            SendMessageToPC(oVictim, GetName(oVictim)+": poison immunity.");
    }
    if(iSave == FALSE)
    {
        int iDur = d6();
        AssignCommand(oCaster, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, oVictim, RoundsToSeconds(iDur)));
        bStillHasSleep = TRUE;
    }
    }

    // if sleeping still, give an extra round recovery period for victim incase they wake up. Otherwise roll again as rounds per usual.
    if(bStillHasSleep){
        DelayCommand(12.0, DoSlumber(iDC, oCaster, oVictim, 0, oAOE, eSleep));
    } else {
        DelayCommand(6.0, DoSlumber(iDC, oCaster, oVictim, 0, oAOE, eSleep));
    }
}
