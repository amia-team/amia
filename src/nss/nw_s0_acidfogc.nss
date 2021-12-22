//::///////////////////////////////////////////////
//:: Acid Fog: Heartbeat
//:: NW_S0_AcidFogC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 2d6 acid damage
    per round and upon entering if they fail a Fort Save
    their movement is halved.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//  7/11/2016   msheeler    added damage bonus for spell focus

#include "X0_I0_SPELLS"

void main()
{

    //Declare major variables
    int nDamage;
    int nDice = 2;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    object oTarget;
    object oCaster = GetAreaOfEffectCreator();
    float fDelay;

    //check for spell foci
    if (GetHasFeat (FEAT_SPELL_FOCUS_CONJURATION, oCaster))
    {
        nDice = 3;
    }
    if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_CONJURATION, oCaster))
    {
        nDice = 4;
    }
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_CONJURATION, oCaster))
    {
        nDice = 5;
    }

    //roll damage
    nDamage = MaximizeOrEmpower (6, nDice, GetMetaMagicFeat(), 0);
    //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }


    //Set the damage effect
    eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
    //Start cycling through the AOE Object for viable targets including doors and placable objects.
    oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ACID, GetAreaOfEffectCreator(), fDelay))
            {
                 nDamage = d6();
            }
            fDelay = GetRandomDelay(0.4, 1.2);
            //Fire cast spell at event for the affected target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_ACID_FOG));
            //Spell resistance check
            if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
            {
               //Apply damage and visuals
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }
}
