//::///////////////////////////////////////////////
//:: Slaad Chaos Spittle
//:: x2_s1_chaosspit
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature must make a ranged touch attack to hit
    the intended target.

    Damage is 20d4 for black slaad, 10d4 for white
    slaad and hd/2 d4 for any other creature this
    spell is assigned to

    A shifter will do his shifter level /3 d6
    points of damage

2013/11/12 - Glim - Removed Cap on Black and White Slaad and changed damage
                    to a straight d4 per HD instead.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Sept 08  , 2003
//:://////////////////////////////////////////////
#include "x0_i0_spells"
#include "NW_I0_SPELLS"
#include "inc_td_shifter"

void main()
{
    // Expertise/Improved Expertise disabling for Shifters
    if ( GetActionMode( OBJECT_SELF, ACTION_MODE_EXPERTISE ) )
        SetActionMode( OBJECT_SELF, ACTION_MODE_EXPERTISE, FALSE );
    if ( GetActionMode( OBJECT_SELF, ACTION_MODE_IMPROVED_EXPERTISE ) )
        SetActionMode( OBJECT_SELF, ACTION_MODE_IMPROVED_EXPERTISE, FALSE );

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nHD = GetHitDice(OBJECT_SELF);
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);
    effect eVis2 = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eBolt;
    int nCount;
    int nDamage;
    if (GetIsPC(OBJECT_SELF))
    {
        nCount = GetNewCasterLevel( OBJECT_SELF ) / 2;
    }
    else
    {
        nCount = nHD;
    }

    if (nCount == 0)
    {
        nCount = 1;
    }

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        if ( GetIsPC( OBJECT_SELF ) )
        {
            nDamage = d8(nCount);
        }
        else
        {
            nDamage = d4(nCount);
        }
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.

        //Make a ranged touch attack
        int nTouch = TouchAttackRanged(oTarget);
        if(nTouch > 0)
        {
            if(nTouch == 2)
            {
                nDamage *= 2;
            }
            //Set damage effect
            eBolt = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
            if(nDamage > 0)
            {
                //Apply the VFX impact and effects
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eBolt, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
            }
        }
    }
}
