//::///////////////////////////////////////////////
//:: Pyromantic Cloud: On Enter
//::
//::
//:://////////////////////////////////////////////
/*
    Creates a cloud that will do 1d6 damage to most creatures, 1d6/CL to fire based creatures.
*/
//:://////////////////////////////////////////////
//:: Created By: Bruce
//:: Created On: 2010-11-09
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "inc_dc_spells"
void main()
{

    //Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
    int nCasterLevel = GetCasterLevel(oCaster);
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    int nDam;
    effect eDam;
    float fDelay = GetRandomDelay(1.0, 2.2);
    int nAppearance = GetAppearanceType( oTarget );
    if (nAppearance == APPEARANCE_TYPE_GIANT_FIRE ||
        nAppearance == APPEARANCE_TYPE_GIANT_FIRE_FEMALE ||
        nAppearance == APPEARANCE_TYPE_AZER_MALE ||
        nAppearance == APPEARANCE_TYPE_AZER_FEMALE ||
        nAppearance == APPEARANCE_TYPE_MEPHIT_FIRE ||
        nAppearance == APPEARANCE_TYPE_ELEMENTAL_FIRE ||
        nAppearance == APPEARANCE_TYPE_ELEMENTAL_FIRE_ELDER ||
        nAppearance == APPEARANCE_TYPE_DRAGON_RED ||
        nAppearance == APPEARANCE_TYPE_WYRMLING_RED ||
        nAppearance == APPEARANCE_TYPE_DRAGON_BRASS ||
        nAppearance == APPEARANCE_TYPE_WYRMLING_BRASS ||
        nAppearance == APPEARANCE_TYPE_DOG_HELL_HOUND ){

        nDam = d6(nCasterLevel);
    } else{
        nDam = d6();
    }
    eDam = EffectDamage(nDam, DAMAGE_TYPE_COLD);
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, DC_SPELL_R_3, TRUE));
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            //Apply VFX impact and lowered save effect
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
    }
}
