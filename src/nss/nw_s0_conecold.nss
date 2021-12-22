//::///////////////////////////////////////////////
//:: Cone of Cold
//:: NW_S0_ConeCold
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Cone of cold creates an area of extreme cold,
// originating at your hand and extending outward
// in a cone. It drains heat, causing 1d6 points of
// cold damage per caster level (maximum 15d6).
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: 10/18/02000
//:://////////////////////////////////////////////
//:: Last Updated By: Aidan Scanlan On: April 11, 2001
//:: Update Pass By: Preston W, On: July 25, 2001

// 1/30/2017    msheeler    Shades Cone of Cold: Deals half cold and half
//                          negative energy damage, Will Save for half instead
//                          of Reflex. Each Spell Focus adds +2d6 to dice cap
//                          for damage (1d6 of each element). Epic Spell Focus
//                          applies http://nwn.wikia.com/wiki/Freeze on a failed
//                          save, and -3 saves vs Cold and negative energy for 5 rounds.
//
// 09-30-2017   Zoltan      Fixed the logic so that it was correctly calculating damage,
//                          and made sure it was correctly checking for Shades Cone of Cold
//                          for the sake of calculating the damage cap. (Before, it was just being
//                          calculated for evocation, regardless of which version was being cast!)
//
// 10-02-2017   Zoltan      Corrected it so it wasn't rolling will twice. Original logic wasn't calculating
//                          the save for cone of cold initially before checking the condition, so I changed it so that
//                          we checked for a pass or fail of the save preemptively.

float SpellDelay (object oTarget, int nShape);

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

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


    //--------------------------------------------------------------------------
    // Transmutation
    //--------------------------------------------------------------------------
    int nTransmutation    = GetLocalInt( OBJECT_SELF, "ds_spell_"+IntToString( SPELL_CONE_OF_COLD ) );

    //Declare major variables
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    int nDotDamage;
    int nOriginalDamage;
    int nCap = 15;
    int nSpellId = GetSpellId();
    float fDelay;
    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    effect eDotDam;
    effect eDotVFX;
    effect eDotSlow;
    effect eDotStun;
    effect eCold;
    effect eVis;
    effect eReduceSave;

    //determine spell foci bonus
    //determin bonus for spell foci

    if(nSpellId == SPELL_CONE_OF_COLD){
        if (GetHasFeat (FEAT_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
        {
            nCap = 17;
        }
        if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
        {
            nCap = 19;
        }
        if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
       {
            nCap = 21;
        }
    }


    if(nSpellId == SPELL_SHADES_CONE_OF_COLD){

        if(GetHasFeat (FEAT_SPELL_FOCUS_ILLUSION, OBJECT_SELF)){

            nCap = 17;
        }

        if(GetHasFeat (FEAT_SPELL_FOCUS_ILLUSION, OBJECT_SELF)){

            nCap = 19;
        }

        if(GetHasFeat (FEAT_SPELL_FOCUS_ILLUSION, OBJECT_SELF)){

            nCap = 21;
        }
    }
    //Limit Caster level for the purposes of damage.
    if (nCasterLevel > nCap)
    {
        nCasterLevel = nCap;
    }
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
     // March 2003. Removed this as part of the reputation pass
     //            if((GetSpellId() == 340 && !GetIsFriend(oTarget)) || GetSpellId() == 25)
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONE_OF_COLD));
                //Get the distance between the target and caster to delay the application of effects
                fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20.0;
                //Make SR check, and appropriate saving throw(s).
                if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay) && (oTarget != OBJECT_SELF))
                {
                    //Detemine damage
                    nDamage = d6(nCasterLevel);
                    nDotDamage = d6(2);

                    //Enter Metamagic conditions
                    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                    {
                         nDamage = 6 * nCasterLevel;//Damage is at max
                         nDotDamage = 12;
                    }
                    else if (nMetaMagic == METAMAGIC_EMPOWER)
                    {
                         nDamage = nDamage + (nDamage/2); //Damage/Healing is +50% .
                         nDotDamage = nDotDamage + (nDotDamage/2);
                    }

                    nOriginalDamage = nDamage;

                    if (nSpellId == SPELL_CONE_OF_COLD)
                    {
                        //--------------------------------------------------------------------------
                        // Transmutation
                        //--------------------------------------------------------------------------
                        if ( nTransmutation == 2){

                            //Acid
                            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ACID);

                            eCold = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
                            eVis = EffectVisualEffect(VFX_IMP_ACID_L);
                            eReduceSave = EffectSavingThrowDecrease (3, SAVING_THROW_TYPE_ACID);
                            eDotDam = EffectDamage (nDamage/2, DAMAGE_TYPE_ACID);
                            eDotVFX = EffectVisualEffect(VFX_IMP_ACID_S);
                        }
                        else if ( nTransmutation == 3){

                            //Electrical
                            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ELECTRICITY);

                            eCold = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
                            eVis = EffectVisualEffect(VFX_IMP_BREACH);
                            eReduceSave = EffectSavingThrowDecrease (3, SAVING_THROW_TYPE_ELECTRICITY);
                            eDotStun = EffectStunned();
                        }
                        else if ( nTransmutation == 4){

                            //Fire
                            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);

                            eCold = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                            eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
                            eReduceSave = EffectSavingThrowDecrease (3, SAVING_THROW_TYPE_FIRE);
                            eDotDam = EffectDamage (nDotDamage, DAMAGE_TYPE_FIRE);
                            eDotVFX = EffectVisualEffect(VFX_DUR_INFERNO_CHEST);
                        }
                        else
                        {
                            //Cold (default)
                            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_COLD);
                            eCold = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
                            eVis = EffectVisualEffect(VFX_IMP_FROST_L);
                            eDotSlow = EffectSlow();
                            eReduceSave = EffectSavingThrowDecrease (3, SAVING_THROW_TYPE_COLD);
                        }
                    }
                    if ( nSpellId == SPELL_SHADES_CONE_OF_COLD )
                    {
                        //Recalculate the spell save DC for illution feats
                        int nDC = GetSpellSaveDC();
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

                        //It is better to make them roll for half damage before checking the condition
                        //to avoid it rolling twice and calculating the damage twice.
                        int nShadesConeColdSave = WillSave(oTarget, nDC, SAVING_THROW_TYPE_SPELL);


                        //Save was rolled. Get the value of nSave. 0 = failed. 1 = passed. 2 would be immune,
                        //but since nothing happens if it's somehow magically2(as in, this is an unlikely scenario)
                        //then nothing should happen.
                        if (nShadesConeColdSave == 0)
                        {
                            //Shades cone of cold does negative and cold
                            eCold = EffectDamage(nDamage/2, DAMAGE_TYPE_COLD);
                            eVis = EffectVisualEffect(VFX_IMP_FROST_L);
                            eDotDam = EffectDamage (nDamage/2, DAMAGE_TYPE_NEGATIVE);
                            eDotVFX = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
                            eDotSlow = EffectSlow();
                            eReduceSave = EffectSavingThrowDecrease (3, SAVING_THROW_TYPE_COLD);
                        }else if(nShadesConeColdSave == 1){

                            //They made the save for shades cone of cold, so recalculate to adjust.
                            //Shades cone of cold does negative and cold
                            eCold = EffectDamage(nDamage/4, DAMAGE_TYPE_COLD);
                            eVis = EffectVisualEffect(VFX_IMP_FROST_L);
                            eDotDam = EffectDamage (nDamage/4, DAMAGE_TYPE_NEGATIVE);
                            eDotVFX = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
                            eDotSlow = EffectSlow();
                            eReduceSave = EffectSavingThrowDecrease (3, SAVING_THROW_TYPE_COLD);
                        }
                    }

                    if(nDamage > 0)
                    {
                        //backwards math to determin if the save was made or failed.
                        if ((GetHasFeat (FEAT_IMPROVED_EVASION, oTarget) && nDamage >= nOriginalDamage/4) || (nDamage == nOriginalDamage))
                        {
                            if (nSpellId == SPELL_CONE_OF_COLD)
                            {
                                //only apply DoT if caster has epic spell focus
                                if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
                                {
                                    //lets not stack this effect
                                    if (GetHasSpellEffect(GetSpellId(), oTarget) == TRUE)
                                    {
                                        RemoveSpellEffects(GetSpellId(), OBJECT_SELF, oTarget);
                                    }
                                    //apply dot
                                    //backwards math to determin if the save was made or failed
                                    if (nTransmutation == 2)
                                    {
                                        DelayCommand(RoundsToSeconds(1), ApplyEffectToObject(DURATION_TYPE_INSTANT, eDotVFX, oTarget));
                                        DelayCommand(RoundsToSeconds(1), ApplyEffectToObject(DURATION_TYPE_INSTANT, eDotDam, oTarget));
                                        DelayCommand(RoundsToSeconds(2), ApplyEffectToObject(DURATION_TYPE_INSTANT, eDotVFX, oTarget));
                                        DelayCommand(RoundsToSeconds(2), ApplyEffectToObject(DURATION_TYPE_INSTANT, eDotDam, oTarget));
                                    }
                                    else if (nTransmutation == 3)
                                    {
                                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDotStun, oTarget, RoundsToSeconds(1)));
                                    }
                                    else if (nTransmutation == 4)
                                    {
                                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDotVFX, oTarget, RoundsToSeconds(3)));
                                        DelayCommand(RoundsToSeconds(1), ApplyEffectToObject(DURATION_TYPE_INSTANT, eDotDam, oTarget));
                                        DelayCommand(RoundsToSeconds(2), ApplyEffectToObject(DURATION_TYPE_INSTANT, eDotDam, oTarget));
                                        DelayCommand(RoundsToSeconds(3), ApplyEffectToObject(DURATION_TYPE_INSTANT, eDotDam, oTarget));
                                    }
                                    else
                                    {
                                        int nDuration = d3(1);
                                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDotSlow, oTarget, RoundsToSeconds(nDuration)));
                                    }
                                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eReduceSave, oTarget, RoundsToSeconds(5)));
                                }
                            }
                        }
                        if (nSpellId == SPELL_SHADES_CONE_OF_COLD)
                        {
                            //apply DoT affect only if caster has epic spell focus
                            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
                            {
                                int nDuration = d3(1);
                                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDotSlow, oTarget, RoundsToSeconds(nDuration)));

                            }
                        }
                        //Apply delayed effects
                        if (nSpellId == SPELL_SHADES_CONE_OF_COLD)
                        {
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDotVFX, oTarget));
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDotDam, oTarget));
                        }
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCold, oTarget));
                    }
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}

