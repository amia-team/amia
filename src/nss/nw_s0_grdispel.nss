//::///////////////////////////////////////////////
//:: Greater Dispelling
//:: NW_S0_GrDispel.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:: Updated On: Oct 20, 2003, Georg Zoeller
//:: Updated On: May 18, 2021, Maverick00053
//:://////////////////////////////////////////////


void PCCasting(object oTarget, location lLocal, int nCasterLevel);
void OtherCasting(object oTarget, location lLocal, int nCasterLevel);
void StasisAgeCheck( object oTarget );

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "inc_dispel"

void main()
{
    object   oTarget     = GetSpellTargetObject();
    location lLocal      = GetSpellTargetLocation();
    int      nCasterLevel= GetCasterLevel(OBJECT_SELF);
    int nPCVersionSet = GetLocalInt(OBJECT_SELF, "PCDispel");  // You can turn on the PC verson for NPCs, etc by setting the variable to 1

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

    effect   eVis         = EffectVisualEffect( VFX_IMP_BREACH );
    effect   eImpact      = EffectVisualEffect( VFX_FNF_DISPEL_GREATER );

    //--------------------------------------------------------------------------
    // Dispel Magic is capped at caster level 10
    //--------------------------------------------------------------------------

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
        if( GetHasSpellEffect( SPELL_TIME_STOP, oTarget ) )
        {
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_GLOBE_USE ), oTarget );
            return;
        }

        //----------------------------------------------------------------------
        // Targeted Dispel - Dispel all
        //----------------------------------------------------------------------
        spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact);
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
                spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact, FALSE);
                }
            }
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        }
    }

}

void OtherCasting(object oTarget, location lLocal, int nCasterLevel)
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

    effect   eVis         = EffectVisualEffect( VFX_IMP_BREACH );
    effect   eImpact      = EffectVisualEffect( VFX_FNF_DISPEL_GREATER );

    //--------------------------------------------------------------------------
    // Dispel Magic is capped at caster level 10
    //--------------------------------------------------------------------------

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
        if( GetHasSpellEffect( SPELL_TIME_STOP, oTarget ) )
        {
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_GLOBE_USE ), oTarget );
            return;
        }

        //----------------------------------------------------------------------
        // Targeted Dispel - Dispel all
        //----------------------------------------------------------------------

        DispelEffectsAll( OBJECT_SELF, nCasterLevel, oTarget, 4, SPELL_GREATER_DISPELLING );
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
                spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact, FALSE);
                }
            }
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        }
    }

}

void StasisAgeCheck( object oTarget )
{

    int nRace = GetRacialType( oTarget );
    int nDrain = GetLocalInt( oTarget, "AgeDrain" );
    int nBaseAge = GetAge( oTarget );
    int nMiddle;
    int nOld;
    int nVenerable;
    effect eSTR;
    effect eDEX;
    effect eCON;
    effect eLink;

    switch( nRace )
    {
        case 0:     nMiddle = 125;  nOld = 188; nVenerable = 250;   break;  //dwarf
        case 1:     nMiddle = 175;  nOld = 263; nVenerable = 350;   break;  //elf
        case 2:     nMiddle = 100;  nOld = 150; nVenerable = 200;   break;  //gnome
        case 3:     nMiddle = 50;   nOld = 75;  nVenerable = 100;   break;  //halfling
        case 4:     nMiddle = 62;   nOld = 93;  nVenerable = 125;   break;  //half-elf
        case 5:     nMiddle = 30;   nOld = 45;  nVenerable = 60;    break;  //half-orc
        case 6:     nMiddle = 35;   nOld = 53;  nVenerable = 70;    break;  //human
        case 20:    nMiddle = 250;  nOld = 500; nVenerable = 750;   break;  //outsider
    }

    if( ( nBaseAge + nDrain ) >= nVenerable )
    {
        eSTR = EffectAbilityDecrease( ABILITY_STRENGTH, 3 );
        eDEX = EffectAbilityDecrease( ABILITY_DEXTERITY, 3 );
        eCON = EffectAbilityDecrease( ABILITY_CONSTITUTION, 3 );
        eLink = EffectLinkEffects( eSTR, eDEX );
        eLink = EffectLinkEffects( eCON, eLink );
        eLink = ExtraordinaryEffect( eLink );

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oTarget );
    }
    else if( ( nBaseAge + nDrain ) >= nOld )
    {
        eSTR = EffectAbilityDecrease( ABILITY_STRENGTH, 2 );
        eDEX = EffectAbilityDecrease( ABILITY_DEXTERITY, 2 );
        eCON = EffectAbilityDecrease( ABILITY_CONSTITUTION, 2 );
        eLink = EffectLinkEffects( eSTR, eDEX );
        eLink = EffectLinkEffects( eCON, eLink );
        eLink = ExtraordinaryEffect( eLink );

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oTarget );
    }
    else if( ( nBaseAge + nDrain ) >= nMiddle )
    {
        eSTR = EffectAbilityDecrease( ABILITY_STRENGTH, 1 );
        eDEX = EffectAbilityDecrease( ABILITY_DEXTERITY, 1 );
        eCON = EffectAbilityDecrease( ABILITY_CONSTITUTION, 1 );
        eLink = EffectLinkEffects( eSTR, eDEX );
        eLink = EffectLinkEffects( eCON, eLink );
        eLink = ExtraordinaryEffect( eLink );

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oTarget );
    }
}
