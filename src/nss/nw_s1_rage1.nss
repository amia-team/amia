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

void main()
{
    // Expertise/Improved Expertise disabling for Shifters
    if ( GetActionMode( OBJECT_SELF, ACTION_MODE_EXPERTISE ) )
        SetActionMode( OBJECT_SELF, ACTION_MODE_EXPERTISE, FALSE );
    if ( GetActionMode( OBJECT_SELF, ACTION_MODE_IMPROVED_EXPERTISE ) )
        SetActionMode( OBJECT_SELF, ACTION_MODE_IMPROVED_EXPERTISE, FALSE );

    //Declare major variables
    int nIncrease = 3;
    
    effect eDex = EffectAbilityIncrease(ABILITY_CONSTITUTION, nIncrease);
    effect eCon = EffectAbilityIncrease(ABILITY_STRENGTH, nIncrease);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eCon, eDex);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = ExtraordinaryEffect(eLink);

    int nCon = GetAbilityModifier(ABILITY_CONSTITUTION, OBJECT_SELF);
    float fDuration = nCon > 1 ? RoundsToSeconds(nCon) : RoundsToSeconds(1);
    
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_RAGE_3, FALSE));
        
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration);

    // 2003-07-08, Georg: Rage Epic Feat Handling
    if( !GetIsPolymorphed( OBJECT_SELF ) )
        CheckAndApplyEpicRageFeats(nCon);
}
