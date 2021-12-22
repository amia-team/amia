//::///////////////////////////////////////////////
//:: Mordenkainen's Disjunction
//:: NW_S0_MordDisj.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Massive Dispel Magic and Spell Breach rolled into one
    If the target is a general area of effect they lose
    6 spell protections.  If it is an area of effect everyone
    in the area loses 2 spells protections.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:: Updated On: Oct 20, 2003, Georg Zoeller
//:: Updated On: December 2, 2020, Heartbleed
//:: Updated On: May 18, 2021, Maverick00053
//:://////////////////////////////////////////////
void StripEffects(int nNumber, object oTarget);
void PCCasting(object oTarget, location lLocal, int nCasterLevel);
void OtherCasting(object oTarget, location lLocal, int nCasterLevel);
#include "X0_I0_SPELLS"
#include "inc_dispel"
#include "x2_inc_spellhook"


void main()
{
    object   oTarget     = GetSpellTargetObject();
    location lLocal      = GetSpellTargetLocation();
    int      nCasterLevel= GetCasterLevel(OBJECT_SELF);
    int nPCVersionSet = GetLocalInt(OBJECT_SELF, "PCDispel"); // You can turn on the PC verson for NPCs, etc by setting the variable to 1

    // If a PC or DM is casting Mords then the new version fires off, if not the old version fires off for Mobs
    if(GetIsPC(OBJECT_SELF) || GetIsDM(OBJECT_SELF) || nPCVersionSet)
    {
      PCCasting(oTarget, lLocal, nCasterLevel);
    }
    else // Mobs only cast the old version to avoid balance issues we have with old dungeons, etc
    {
      OtherCasting(oTarget, lLocal, nCasterLevel);
    }
}

void PCCasting(object oTarget, location lLocal, int nCasterLevel)
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

     effect  eVis        = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    effect   eImpact     = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);


    //--------------------------------------------------------------------------
    // Mord's is not capped anymore as we can go past level 20 now
    //--------------------------------------------------------------------------
    /*
        if(nCasterLevel > 20)
        {
            nCasterLevel = 20;
        }
    */

    SendMessageToPC(OBJECT_SELF, "Starting CL: " + IntToString(nCasterLevel));

    int nBonus = 0;

    // If caster has SF Abjuration:
    if (GetHasFeat(35)) {
        nBonus = 1; // Add 1 to CL
    }
    // If caster has GSF Abjuration:
    if (GetHasFeat(393)) {
        nBonus = 3; // Add 3 to CL
    }
    // If caster has ESF Abjuration:
    if (GetHasFeat(610)) {
        nBonus = 6; // Add 6 to CL
    }

    // Apply bonus to CL.
    nCasterLevel += nBonus;

    // If nCasterLevel is greater than 30
    if (nCasterLevel > 30) {
        nCasterLevel = 30; // Reset CL to 30.
    }

    SendMessageToPC(OBJECT_SELF, "Bonus: " + IntToString(nBonus));
    SendMessageToPC(OBJECT_SELF, "Modified CL: " + IntToString(nCasterLevel));

    if (GetIsObjectValid(oTarget))
    {

        // Can't dispel Time Stopped creatures
        if( GetHasSpellEffect( SPELL_TIME_STOP, oTarget ) ) {
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_GLOBE_USE ), oTarget );
            return;
        }
        //----------------------------------------------------------------------
        // Targeted Dispel - Dispel all
        //----------------------------------------------------------------------
        spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact,TRUE,TRUE);
    }
    else
    {
        //----------------------------------------------------------------------
        // Area of Effect - Only dispel best effect
        //----------------------------------------------------------------------

        //Apply the VFX impact and effects
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE );
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
                spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact, FALSE,TRUE);
                }
            }

           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        }
    }
}

void OtherCasting(object oTarget, location lLocal, int nCasterLevel)
{
    effect  eVis        = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    effect   eImpact     = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);
    int nSR = 0;


    //--------------------------------------------------------------------------
    // Mord's is not capped anymore as we can go past level 20 now
    //--------------------------------------------------------------------------
    /*
        if(nCasterLevel > 20)
        {
            nCasterLevel = 20;
        }
    */

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
        if( GetLocalInt( oTarget, "Temporal_Stasis") == 1)
        {
            effect eLoop = GetFirstEffect( oTarget );
            object oStored = GetLocalObject( oTarget, "Stasis_Caster" );

            while( GetIsEffectValid( eLoop ) )
            {
                object oCreator = GetEffectCreator( eLoop );
                if( oStored == oCreator )
                {
                    RemoveEffect( oTarget, eLoop );
                }
                eLoop = GetNextEffect( oTarget );
            }
            SetLocalInt( oTarget, "Temporal_Stasis", 0 );
            DeleteLocalObject( oTarget, "Stasis_Caster" );
        }

        DispelEffectsAll( OBJECT_SELF, nCasterLevel, oTarget, 6, SPELL_MORDENKAINENS_DISJUNCTION );
        string oTargetSubrace = GetSubRace(oTarget);
        if(oTargetSubrace == "Drow" || oTargetSubrace == "Svirfneblin")
        {
            nSR = 0;
        }
        else
        {
            nSR = 10;
        }
        DoSpellBreach(oTarget, 6, nSR);

        //Manually breach here
        //DoSpellBreach( oTarget, 6, 10, GetSpellId() );
        //New dispel, uncapped, max spells 3
        //DispelEffectsAll( OBJECT_SELF, nCasterLevel, oTarget, 3 );
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    }
    else
    {
        //----------------------------------------------------------------------
        // Area of Effect - Only dispel best effect
        //----------------------------------------------------------------------

        //Apply the VFX impact and effects
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE );
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
                    spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact, FALSE,FALSE);
                    string oTargetSubrace = GetSubRace(oTarget);
                    if(oTargetSubrace == "Drow" || oTargetSubrace == "Svirfneblin")
                    {
                        nSR = 0;
                    }
                    else
                    {
                        nSR = 10;
                    }
                    DoSpellBreach(oTarget, 6, nSR);

                    //Manually breach here
                    //DoSpellBreach( oTarget, 4, 10, GetSpellId() );
                    //New dispel, uncapped, max spells 1 for mord aoe
                    //DispelEffectsAll( OBJECT_SELF, GetCasterLevel(OBJECT_SELF), oTarget, 1 );
                    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }

           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        }
    }
}
