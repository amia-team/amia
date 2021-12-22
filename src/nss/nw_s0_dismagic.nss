//::///////////////////////////////////////////////
//:: Dispel Magic
//:: NW_S0_DisMagic.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: Attempts to dispel all magic on a targeted
//:: object, or simply the most powerful that it
//:: can on every object in an area if no target
//:: specified.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:: Updated On: Oct 20, 2003, Georg Zoeller
//:://////////////////////////////////////////////
//  7/15/2016   msheeler    added bonus to max level for spell foci

#include "x0_i0_spells"
#include "x2_inc_spellhook"

//Can be found in the dynamic folder you found this script in
#include "inc_dispel"

void main()
{

    //--------------------------------------------------------------------------
    /*
      Spellcast Hook Code
      Added 2003-06-20 by Georg
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more
    */
    //--------------------------------------------------------------------------
    if (!X2PreSpellCastCode())
    {
        return;
    }
    // End of Spell Cast Hook

    effect    eVis         = EffectVisualEffect(VFX_IMP_BREACH);
    effect    eImpact      = EffectVisualEffect(VFX_FNF_DISPEL);
    object    oTarget      = GetSpellTargetObject();
    location  lLocal       = GetSpellTargetLocation();
    int       nCasterLevel = GetCasterLevel(OBJECT_SELF);

    //--------------------------------------------------------------------------
    // Dispel Magic is capped at caster level 10
    //--------------------------------------------------------------------------
    if(nCasterLevel > 10)
    {
        nCasterLevel = 10;
    }
    if (GetHasFeat (FEAT_SPELL_FOCUS_ABJURATION, OBJECT_SELF))
    {
        nCasterLevel += 2;
    }
    if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_ABJURATION, OBJECT_SELF))
    {
        nCasterLevel += 2;
    }
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_ABJURATION, OBJECT_SELF))
    {
        nCasterLevel += 2;
    }


    if (GetIsObjectValid(oTarget))
    {
        //----------------------------------------------------------------------
        // Targeted Dispel - Dispel all
        //----------------------------------------------------------------------

        // Can't dispel Time Stopped creatures
        if( GetHasSpellEffect( SPELL_TIME_STOP, oTarget ) ) {
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_GLOBE_USE ), oTarget );
            return;
        }

        //New dispel, uncapped, max spells 1 for aoe
        //if( GetPCPlayerName( OBJECT_SELF ) == "RaveN" ) {
            DispelEffectsAll( OBJECT_SELF, GetCasterLevel(OBJECT_SELF), oTarget, 0, SPELL_DISPEL_MAGIC );
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        /*
        } else {
            spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact);
        }
        */
    }
    else
    {
        //----------------------------------------------------------------------
        // Area of Effect - Only dispel best effect
        //----------------------------------------------------------------------

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE );
        while (GetIsObjectValid(oTarget))
        {
            if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
            {
                //--------------------------------------------------------------
                // Handle Area of Effects
                //--------------------------------------------------------------
                spellsDispelAoE(oTarget, OBJECT_SELF, nCasterLevel);
            }
            else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            }
            else
            {
                // Can't dispel Time Stopped creatures
                if( GetHasSpellEffect( SPELL_TIME_STOP, oTarget ) ) {
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_GLOBE_USE ), oTarget );
                }
                else {
                    //New dispel, uncapped, max spells 1 for aoe
                    //if( GetPCPlayerName( OBJECT_SELF ) == "RaveN" ) {
                        DispelEffectsAll( OBJECT_SELF, GetCasterLevel(OBJECT_SELF), oTarget, 0, SPELL_DISPEL_MAGIC );
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    /*
                    } else {
                        spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact, FALSE,TRUE);
                    }
                    */
                }
            }

           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        }
    }
}



