//::///////////////////////////////////////////////
//:: Magic Circle Against Good
//:: NW_S0_CircGood.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: [Description of File]
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 18, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001

#include "x2_inc_spellhook"
#include "amia_include"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    int nVersus = ALIGNMENT_GOOD;
    int nPulse  = VFX_IMP_PULSE_FIRE;
    int nVFX    = VFX_DUR_PROTECTION_EVIL_MINOR;

    int nTransmutation    = GetLocalInt( OBJECT_SELF, "ds_spell_"+IntToString( SPELL_MAGIC_CIRCLE_AGAINST_GOOD ) );
    if( nTransmutation == 2 )
    {
    nVersus = ALIGNMENT_LAWFUL;
    nPulse  = VFX_IMP_PULSE_NEGATIVE;
    nVFX    = VFX_DUR_AURA_PULSE_PURPLE_BLACK;
    }
    // circle vfx
    effect eCircle  = EffectVisualEffect(nPulse);

    effect eVFX     = EffectVisualEffect(nVFX);

    // +2 AC deflection vs. good
    effect eAC=EffectACIncrease( 2, AC_DEFLECTION_BONUS);


    // +2 universal saving throws vs. good
    effect eSave=EffectSavingThrowIncrease( SAVING_THROW_ALL, 2);


    // immunity to mind-affecting spells vs. good
    effect eImmunity=EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);


    // combine aura, AC, saving throw and mind-affecting immunity into one effect

    eAC=VersusAlignmentEffect( eAC, ALIGNMENT_ALL, nVersus);
    eSave=VersusAlignmentEffect( eSave, ALIGNMENT_ALL,nVersus);
    eImmunity=VersusAlignmentEffect( eImmunity, ALIGNMENT_ALL, nVersus);

    effect eProtection=EffectLinkEffects( eVFX, eAC);
    eProtection=EffectLinkEffects( eProtection, eSave);
    eProtection=EffectLinkEffects( eProtection, eImmunity);



    object oTarget = GetSpellTargetObject();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration *2;    //Duration is +100%
    }

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eCircle, oTarget);

    location lLocation = GetLocation(oTarget);

    object oAoeTarget = GetFirstObjectInShape(SHAPE_SPHERE,10.0,lLocation,FALSE,OBJECT_TYPE_CREATURE);
    while( GetIsObjectValid( oAoeTarget ) )
    {
        if( GetIsReactionTypeFriendly(oAoeTarget,OBJECT_SELF) )
        {
        SignalEvent(oAoeTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_CIRCLE_AGAINST_GOOD, FALSE));
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eProtection, oAoeTarget,NewHoursToSeconds(nDuration));
        }
    oAoeTarget = GetNextObjectInShape(SHAPE_SPHERE,10.0,lLocation,FALSE,OBJECT_TYPE_CREATURE);
    }

}
