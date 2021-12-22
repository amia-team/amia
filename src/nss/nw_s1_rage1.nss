//::///////////////////////////////////////////////
//:: Rage 1
//:: NW_S1_Rage1
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Str and Con of the target increases
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 13, 2001
//:: Updated On: Jul 08, 2003, Georg
//:://////////////////////////////////////////////

#include "x2_i0_spells"
#include "inc_td_shifter"

int ShifterAbilityMod( ){

    int nCon = GetAbilityModifier(ABILITY_CONSTITUTION);
    int nStr = GetAbilityModifier(ABILITY_STRENGTH);

    if( GetIsPolymorphed( OBJECT_SELF ) ){
        return nCon > nStr ? nCon : nStr;
    }
    return nCon;
}

void main()
{
    // Expertise/Improved Expertise disabling for Shifters
    if ( GetActionMode( OBJECT_SELF, ACTION_MODE_EXPERTISE ) )
        SetActionMode( OBJECT_SELF, ACTION_MODE_EXPERTISE, FALSE );
    if ( GetActionMode( OBJECT_SELF, ACTION_MODE_IMPROVED_EXPERTISE ) )
        SetActionMode( OBJECT_SELF, ACTION_MODE_IMPROVED_EXPERTISE, FALSE );

    //Declare major variables
    int nIncrease = 3;
    //Determine the duration by getting the con modifier after being modified
    int nCon = ShifterAbilityMod( );
    nCon = nCon + 1;//(((GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION) - 10) + nIncrease )/2) + nCon;
    if(nCon <= 0)
    {
        nCon = 1;
    }
    effect eDex = EffectAbilityIncrease(ABILITY_CONSTITUTION, nIncrease);
    effect eCon = EffectAbilityIncrease(ABILITY_STRENGTH, nIncrease);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eCon, eDex);
    eLink = EffectLinkEffects(eLink, eDur);

    //BH: If polymorphed, whatever they cast is created by their skin
    if(GetIsPolymorphed( OBJECT_SELF ))
    {
        eLink = EffectShifterEffect( eLink, OBJECT_SELF);
    }

    //Make effect extraordinary
    eLink = ExtraordinaryEffect(eLink);
    //effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_RAGE_3, FALSE));
    if (nCon > 0)
    {
        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nCon));
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF) ;

        // 2003-07-08, Georg: Rage Epic Feat Handling
        if( !GetIsPolymorphed( OBJECT_SELF ) )
            CheckAndApplyEpicRageFeats(nCon);
    }
}
