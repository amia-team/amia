//::///////////////////////////////////////////////
//:: Ferocity 1
//:: NW_S1_Feroc1
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Dex and Str of the target increases
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 13, 2001
//:://////////////////////////////////////////////

void main()
{
    // Expertise/Improved Expertise disabling for Shifters
    if ( GetActionMode( OBJECT_SELF, ACTION_MODE_EXPERTISE ) )
        SetActionMode( OBJECT_SELF, ACTION_MODE_EXPERTISE, FALSE );
    if ( GetActionMode( OBJECT_SELF, ACTION_MODE_IMPROVED_EXPERTISE ) )
        SetActionMode( OBJECT_SELF, ACTION_MODE_IMPROVED_EXPERTISE, FALSE );

    //Declare major variables
    int nIncrease = 6;
    //Determine the duration by getting the con modifier

    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, nIncrease);
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nIncrease);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eStr, eDex);
    eLink = EffectLinkEffects(eLink, eDur);

    //Make effect extraordinary
    eLink = ExtraordinaryEffect(eLink);
    
    int nCon = GetAbilityModifier(ABILITY_CONSTITUTION, OBJECT_SELF);
    float fDuration = nCon > 1 ? RoundsToSeconds(nCon) : RoundsToSeconds(1);

    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_FEROCITY_2, FALSE));
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration);
}
