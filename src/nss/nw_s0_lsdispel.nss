//::///////////////////////////////////////////////
//:: Lesser Dispel
//:: NW_S0_LsDispel.nss
//:: Copyright (c) 2001 Bioware Corp.
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


    //Declare major variables
    effect    eVis         = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
    effect    eImpact      = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    object    oTarget      = GetSpellTargetObject();
    location  lLocal       = GetSpellTargetLocation();
    int       nCasterLevel = GetCasterLevel(OBJECT_SELF);

    //--------------------------------------------------------------------------
    // Lesser Magic is capped at caster level 5
    //--------------------------------------------------------------------------
    if(nCasterLevel > 5)
    {
        nCasterLevel = 5;
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

         //New dispel, uncapped, max spells 1 for lesser aoe
        //if( GetPCPlayerName( OBJECT_SELF ) == "RaveN" ) {
            DispelEffectsAll( OBJECT_SELF, GetCasterLevel(OBJECT_SELF), oTarget, 2, SPELL_LESSER_DISPEL );
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
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        while (GetIsObjectValid(oTarget))
        {
            if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
            {
                //--------------------------------------------------------------
                // Handle Area of Effects
                //--------------------------------------------------------------
                spellsDispelAoE(oTarget, OBJECT_SELF,nCasterLevel);

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
                    //New dispel, uncapped, max spells 1 for mord aoe
                    //if( GetPCPlayerName( OBJECT_SELF ) == "RaveN" ) {
                        DispelEffectsAll( OBJECT_SELF, GetCasterLevel(OBJECT_SELF), oTarget, 1, SPELL_LESSER_DISPEL );
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
