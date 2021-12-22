//::///////////////////////////////////////////////
//:: trig_demonhand
//:://////////////////////////////////////////////
/*
    A custom trigger to paralyze the victim for
    5 rounds, if not immune to paralysis.
*/
//:://////////////////////////////////////////////
//:: Created By: PaladinOfSune
//:: Created On: 24th February 2006
//:://////////////////////////////////////////////
// Edit 13th March 2012 by PaladinOfSune - changed visual and reformatted to be less offensive on the eyes

#include "NW_I0_SPELLS"

void main()
{
    object oVictim  = GetEnteringObject();

    if( !GetIsPC( oVictim ) )
        return;

    effect eParal   = EffectParalyze();
    effect eVFX     = EffectVisualEffect( VFX_FNF_DEMON_HAND );
    effect eDur     = EffectVisualEffect( VFX_DUR_PARALYZE_HOLD );

    // If immune to paralysis, return immediately.
    if ( GetIsImmune( oVictim, IMMUNITY_TYPE_PARALYSIS ) || GetHasSpellEffect( 62, oVictim ) )
    {
        return;
    }

    effect eLink    = EffectLinkEffects( eParal, eDur );

    // If saving throw failed, apply the effects.
    if( !MySavingThrow( SAVING_THROW_REFLEX, oVictim, 30, SAVING_THROW_TYPE_CHAOS ) )
    {
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oVictim );
        DelayCommand( 6.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oVictim ) );
        DelayCommand( 12.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oVictim ) );
        DelayCommand( 18.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oVictim ) );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oVictim, RoundsToSeconds( 5 ) );
        FloatingTextStringOnCreature( "*" + GetName( oVictim ) + " is gripped by a demonic hand!*", oVictim );
    }
}
