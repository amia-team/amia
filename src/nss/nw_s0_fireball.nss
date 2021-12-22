//::///////////////////////////////////////////////
//:: Fireball
//:: NW_S0_Fireball                       a
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A fireball is a burst of flame that detonates with
// a low roar and inflicts 1d6 points of damage per
// caster level (maximum of 10d6) to all creatures
// within the area. Unattended objects also take
// damage. The explosion creates almost no pressure.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 18 , 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 6, 2001
//:: Last Updated By: AidanScanlan, On: April 11, 2001
//:: Last Updated By: Preston Watamaniuk, On: May 25, 2001
// 7/25/2016    msheeler    added bonus for spell foci
// 2/1/2017     msheeler    added in new version of Shades: Fireball which is 10d6
//                          +2d6 to the dice cap per spell focus. Epic spell focus
//                          adds d3 round slow and 10% cold vulnerability for 5 rounds.

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_arcanearcher"
#include "inc_td_shifter"

void main()
{

    // Temp var
    int nExtended=0;
    if(GetMetaMagicFeat()==METAMAGIC_EXTEND){

        nExtended=1;

    }

    // Resolve Arcane Archer Status
    if(ImbueArrow(
        OBJECT_SELF,
        GetSpellId(),
        GetSpellTargetObject(),
        GetLastSpellCastClass(),
        nExtended)==TRUE){

        return;

    }

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
    int nCasterLvl = GetNewCasterLevel(oCaster);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    int nBonusMaxDice = 0;
    int nSpellId = GetSpellId();
    int nDC = GetSpellSaveDC();
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eDam;
    effect eImmuneDec;
    effect eSlow;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();

    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 10)
    {
        nCasterLvl = 10;
    }

    //--------------------------------------------------------------------------
    // Transmutation
    //--------------------------------------------------------------------------
    int nTransmutation    = GetLocalInt( OBJECT_SELF, "ds_spell_"+IntToString( SPELL_FIREBALL ) );

    //if cast from an item it's always the normal fireball version.
    if ( GetIsObjectValid( GetSpellCastItem() ) )
    {
        nTransmutation = 1;
    }

    //determin dice cap based on spell id and spell focus feats
    if (nSpellId == SPELL_FIREBALL)
    {
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
    }
    if (nSpellId == SPELL_SHADES_FIREBALL)
    {
        if (GetHasFeat (FEAT_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
        {
            nBonusMaxDice = 2;
        }
        if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
        {
            nBonusMaxDice = 4;
        }
        if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
        {
            nBonusMaxDice = 6;
        }
    }


    //Apply the fireball explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            if((nSpellId == SPELL_SHADES_FIREBALL || nSpellId == SPELL_FIREBALL))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FIREBALL));
                //Get the distance between the explosion and the target to calculate delay
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                {
                    //Roll damage for each target
                    nDamage = d6(nCasterLvl + nBonusMaxDice);
                    //Resolve metamagic
                    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                    {
                        nDamage = 6 * (nCasterLvl + nBonusMaxDice);
                    }
                    else if (nMetaMagic == METAMAGIC_EMPOWER)
                    {
                       nDamage = nDamage + nDamage / 2;
                    }
                       int nOriginalDamage = nDamage;

                    //--------------------------------------------------------------------------
                    // Transmutation
                    //--------------------------------------------------------------------------
                    if (nSpellId == SPELL_FIREBALL)
                    {
                        if ( nTransmutation == 2)
                        {
                            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                            nDamage = GetReflexAdjustedDamage( nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ACID );
                            //Set the damage effect
                            eDam = EffectDamage( nDamage, DAMAGE_TYPE_ACID );
                            eImmuneDec = EffectDamageImmunityDecrease (DAMAGE_TYPE_ACID, 10);
                        }
                        else
                        {
                            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
                            //Set the damage effect
                            eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                            eImmuneDec = EffectDamageImmunityDecrease (DAMAGE_TYPE_FIRE, 10);
                        }
                    }
                    if (nSpellId == SPELL_SHADES_FIREBALL)
                    {
                        //Recalculate the spell save DC for illution feats
                        if (GetHasFeat(FEAT_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
                        {
                            nDC = nDC + 2;
                        }
                        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
                        {
                            nDC = nDC + 2;
                        }
                        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
                        {
                            nDC = nDC + 2;
                        }
                        if (GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
                        {
                            nDC = nDC - 2;
                        }
                        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
                        {
                            nDC = nDC - 2;
                        }
                        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
                        {
                            nDC = nDC - 2;
                        }
                    }

                    if(nDamage > 0)
                    {
                        //backwards math to determin if the save was made or failed
                        if (nSpellId == SPELL_FIREBALL)
                        {
                            if (((GetHasFeat (FEAT_IMPROVED_EVASION, oTarget) && nDamage >= nOriginalDamage/2) || nDamage == nOriginalDamage))
                            {
                                if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
                                {
                                    //lets not stack this effect
                                    if (GetHasSpellEffect(GetSpellId(), oTarget) == TRUE)
                                    {
                                        RemoveSpellEffects(GetSpellId(), OBJECT_SELF, oTarget);
                                    }
                                    //apply vulnerability
                                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImmuneDec, oTarget, RoundsToSeconds(5)));
                                }
                            }
                        }
                        //Shades: Fireball version
                        if (nSpellId == SPELL_SHADES_FIREBALL)
                        {
                            if (WillSave(oTarget, nDC, SAVING_THROW_TYPE_SPELL) == 0)
                            {
                                //if caster has epic spell focus add slow and cold vulnerabilty, non-stacking
                                if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
                                {
                                    eSlow = EffectSlow();
                                    eImmuneDec = EffectDamageImmunityDecrease (DAMAGE_TYPE_COLD, 10);

                                    //lets not stack this effect
                                    if (GetHasSpellEffect(nSpellId, oTarget) == TRUE)
                                    {
                                        RemoveSpellEffects(nSpellId, OBJECT_SELF, oTarget);
                                    }
                                    //apply vulnerability and slow
                                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImmuneDec, oTarget, RoundsToSeconds(5)));
                                    int nDuration = d3(1);
                                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds(nDuration)));
                                }
                            }
                            //spell save must have been made
                            else
                            {
                                nDamage = nDamage/2;
                            }
                        //set shades: fireball damage type to cold
                        eDam = EffectDamage( nDamage, DAMAGE_TYPE_COLD );
                        }
                        // Apply effects to the currently selected target.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                        //This visual effect is applied to the target object not the location as above.  This visual effect
                        //represents the flame that erupts on the target not on the ground.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }
                 }
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}

