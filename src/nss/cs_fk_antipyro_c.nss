//::///////////////////////////////////////////////
//:: Pyromantic Cloud: On Heartbeat
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
    object oTarget;
    float fDelay;
    object oCaster = GetAreaOfEffectCreator();
    int nCasterLevel = GetCasterLevel(oCaster);
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eDam;
    int nDam;
    int nAppearance;
    string sPlcName;

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


    //Get the first object in the persistant AOE
    oTarget = GetFirstInPersistentObject( OBJECT_SELF, OBJECT_TYPE_ALL );
    while(GetIsObjectValid(oTarget))
    {
        fDelay = GetRandomDelay();
        nAppearance = GetAppearanceType( oTarget );
        sPlcName = GetSubString( GetName( oTarget ), 0, 5 );


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
        }
        else if( sPlcName == "Flame" && GetObjectType( oTarget ) == OBJECT_TYPE_PLACEABLE ) {
            DestroyObject( oTarget );
        }
        else{
            nDam = d6();
        }
        eDam = EffectDamage(nDam, DAMAGE_TYPE_COLD);

        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
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
        oTarget = GetNextInPersistentObject( OBJECT_SELF, OBJECT_TYPE_ALL );
    }
}
