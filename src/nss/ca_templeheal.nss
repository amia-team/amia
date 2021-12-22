// 2008/07/05 disco               new blindness/underwater system
// 2008/07/05 disco               new racial trait system


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "pp_utils"
#include "amia_include"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void FakeRestore(object oTarget);


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main()
{
    object oPC = GetPCSpeaker();
    object oAnimal = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION,oPC);
    object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR,oPC);
    object oSummoned = GetAssociate(ASSOCIATE_TYPE_SUMMONED,oPC);

    ActionPauseConversation();
    ActionCastFakeSpellAtObject(SPELL_GREATER_RESTORATION, OBJECT_SELF);
    ActionDoCommand(FakeRestore(oPC));

    if ( GetIsObjectValid(oAnimal) )
        ActionDoCommand(FakeRestore(oAnimal));

    if ( GetIsObjectValid(oFamiliar) )
        ActionDoCommand(FakeRestore(oFamiliar));

    if ( GetIsObjectValid(oSummoned) )
        ActionDoCommand(FakeRestore(oSummoned));

    ActionResumeConversation();
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void FakeRestore(object oTarget)
{
    effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION_GREATER);

    effect eBad = GetFirstEffect(oTarget);
    //Search for negative effects
    while(GetIsEffectValid(eBad))
    {
        if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
            GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
            GetEffectType(eBad) == EFFECT_TYPE_CURSE ||
            GetEffectType(eBad) == EFFECT_TYPE_DISEASE ||
            GetEffectType(eBad) == EFFECT_TYPE_POISON ||
            GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
            GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL){

            //remove if it isn't a custom spell effect
            if ( GetName( GetEffectCreator( eBad ) ) != "ds_norestore" ){

                RemoveEffect( oTarget, eBad );
            }
        }
        eBad = GetNextEffect(oTarget);
    }

    if(GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)  {

        //Apply the VFX impact and effects
        int nHeal = GetMaxHitPoints(oTarget) - GetCurrentHitPoints(oTarget);
        effect eHeal = EffectHeal(nHeal);
        if (nHeal > 0)
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
    }

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);

    //racial traits & area effects
    ApplyAreaAndRaceEffects( oTarget );


    return;

}
