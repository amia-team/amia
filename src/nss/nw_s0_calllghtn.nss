//::///////////////////////////////////////////////
//:: Call Lightning
//:: NW_S0_CallLghtn.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spells smites an area around the caster
    with bolts of lightning which strike all enemies.
    Bolts do 1d10 per level up 10d10
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 22, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_td_shifter"
void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oArea = GetArea (OBJECT_SELF);
    int nCasterLvl = GetNewCasterLevel(oCaster);

    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    int nBonusMaxDice = 0;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();

    //determing bonus for spell foci
    if (GetHasFeat (FEAT_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nBonusMaxDice = 2;
    }
    if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nBonusMaxDice = 4;
    }
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nBonusMaxDice = 6;
    }
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 10 + nBonusMaxDice)
    {
        nCasterLvl = 10 + nBonusMaxDice;
    }


    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.

    //--------------------------------------------------------------------------
    // Transmutation
    //--------------------------------------------------------------------------
    int nTransmutation    = GetLocalInt( OBJECT_SELF, "ds_spell_"+IntToString( SPELL_CALL_LIGHTNING ) );

    if ( GetIsObjectValid( GetSpellCastItem() ) ) {

        nTransmutation = 1;
    }

    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
           //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CALL_LIGHTNING));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetRandomDelay(0.4, 1.75);
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                //Roll damage for each target
                nDamage = d6(nCasterLvl);
                if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF) && GetIsAreaAboveGround(oArea) && GetIsAreaNatural(oArea))
                {
                    nDamage = d8(nCasterLvl);
                }
                //Resolve metamagic
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    if( !GetIsPolymorphed( OBJECT_SELF ) ) {
                        nDamage = 6 * (nCasterLvl + nBonusMaxDice);
                        if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF) && GetIsAreaAboveGround(oArea) && GetIsAreaNatural(oArea))
                        {
                            nDamage = 8 * (nCasterLvl);
                        }
                    }
                }
                else if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                    if( !GetIsPolymorphed( OBJECT_SELF ) ) {
                        nDamage = nDamage + nDamage / 2;
                    }
                }

                //--------------------------------------------------------------------------
                // Transmutation
                //--------------------------------------------------------------------------
                //Set the damage effect
                if ( nTransmutation == 2 ){

                    //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetShifterDC( OBJECT_SELF, GetSpellSaveDC()), SAVING_THROW_TYPE_ACID);

                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
                }
                else if ( nTransmutation == 3 ){

                    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetShifterDC( OBJECT_SELF, GetSpellSaveDC()), SAVING_THROW_TYPE_COLD);

                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
                }
                else if ( nTransmutation == 4 ){

                    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetShifterDC( OBJECT_SELF, GetSpellSaveDC()), SAVING_THROW_TYPE_FIRE);

                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                }
                else {

                    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetShifterDC( OBJECT_SELF, GetSpellSaveDC()), SAVING_THROW_TYPE_ELECTRICITY);

                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
                }


                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
