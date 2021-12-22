//::///////////////////////////////////////////////
//:: Delayed Blast Fireball: On Enter
//:: NW_S0_DelFireA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster creates a trapped area which detects
    the entrance of enemy creatures into 3 m area
    around the spell location.  When tripped it
    causes a fiery explosion that does 1d6 per
    caster level up to a max of 20d6 damage.
*/
//:://////////////////////////////////////////////
//:: Georg: Removed Spellhook, fixed damage cap
//:: Created By: Preston Watamaniuk
//:: Created On: July 27, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
    location lTarget = GetLocation(OBJECT_SELF);
    int nDamage;
    int nOriginalDamage;
    int nDotDamage1;
    int nDotDamage2;
    int nDotDamage3;
    int nCap = 20;
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetCasterLevel(oCaster);
    int nFire = GetLocalInt(OBJECT_SELF, "NW_SPELL_DELAY_BLAST_FIREBALL");
    effect eDotDam1;
    effect eDotDam2;
    effect eDotDam3;
    effect eDotVFX;

    if ( GetIsBlocked( ) > 0 ){

        return;
    }

    //determin bonus for spell foci
    if (GetHasFeat (FEAT_SPELL_FOCUS_EVOCATION, oCaster))
    {
        nCap = 22;
    }
    if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_EVOCATION, oCaster))
    {
        nCap = 24;
    }
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, oCaster))
    {
        nCap = 26;
    }

    //Limit caster level
    if (nCasterLevel > nCap)
    {
        nCasterLevel = nCap;
    }

    effect eDam;
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);


    //Check the faction of the entering object to make sure the entering object is not in the casters faction
    if(nFire == 0)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //block the AOE from firing a second time
            SetBlockTime( OBJECT_SELF, 0, 30 );

            SetLocalInt(OBJECT_SELF, "NW_SPELL_DELAY_BLAST_FIREBALL",TRUE);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
            //Cycle through the targets in the explosion area
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            while(GetIsObjectValid(oTarget))
            {
                if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
                {
                    //Fire cast spell at event for the specified target
                    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DELAYED_BLAST_FIREBALL));
                    //Make SR check
                    if (!MyResistSpell(oCaster, oTarget))
                    {
                        nDamage = d6(nCasterLevel);
                        nDotDamage1 = d6(2);
                        nDotDamage2 = d6(2);
                        nDotDamage3 = d6(2);
                        //Enter Metamagic conditions
                        if (nMetaMagic == METAMAGIC_EMPOWER)
                        {
                            nDamage = nDamage + (nDamage/2);//Damage/Healing is + 50%
                            nDotDamage1 = nDotDamage1 + (nDotDamage1/2);
                            nDotDamage2 = nDotDamage2 + (nDotDamage2/2);
                            nDotDamage3 = nDotDamage3 + (nDotDamage3/2);
                        }
                        //keep track of original damage amount to determin if a save was successful
                        nOriginalDamage = nDamage;
                        //Change damage according to Reflex, Evasion and Improved Evasion
                        nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE, GetAreaOfEffectCreator());
                        //Set up the damage effect
                        eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                        if(nDamage > 0)
                        {
                            //Apply VFX impact and damage effect
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                            DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                            //backwards math to determin if the save was made or failed
                            if (((GetHasFeat (FEAT_IMPROVED_EVASION, oTarget) && nDamage >= nOriginalDamage/2) || nDamage == nOriginalDamage) && GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, oCaster))
                            {
                                eDotDam1 = EffectDamage (nDotDamage1, DAMAGE_TYPE_FIRE);
                                eDotDam2 = EffectDamage (nDotDamage2, DAMAGE_TYPE_FIRE);
                                eDotDam3 = EffectDamage (nDotDamage3, DAMAGE_TYPE_FIRE);
                                eDotVFX = EffectVisualEffect(VFX_DUR_INFERNO_CHEST);
                                DelayCommand(0.02, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDotVFX, oTarget, RoundsToSeconds(3)));
                                DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDotDam1, oTarget));
                                DelayCommand(12.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDotDam2, oTarget));
                                DelayCommand(18.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDotDam3, oTarget));
                            }
                        }
                    }
                }
                //Get next target in the sequence
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            }
            DestroyObject(OBJECT_SELF, 18.5);
        }
    }
}
