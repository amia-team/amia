// Master Scout: Battle Fortitude. Grants +1 saves per Master Scout level for a
// duration of 1 hour per Master Scout level.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 06/06/2011 PoS              Initial Release.
//

#include "nw_i0_spells"
#include "amia_include"

void main()
{
    //Declare major variables
    object oTarget      = GetSpellTargetObject();
    int nHarperLevel    = GetLevelByClass( CLASS_TYPE_HARPER, oTarget );
    float fDuration     = NewHoursToSeconds( nHarperLevel );

    // Saving throw bonus and VFX
    effect eSaving      = EffectSavingThrowIncrease( SAVING_THROW_ALL, nHarperLevel, SAVING_THROW_TYPE_ALL );
    effect eDur         = EffectVisualEffect( VFX_DUR_FREEDOM_OF_MOVEMENT );
    effect eVis         = EffectVisualEffect( VFX_IMP_STARBURST_GREEN );
    effect eVis2        = EffectVisualEffect( VFX_IMP_PULSE_NATURE );

    // Fire cast spell at event for the specified target
    SignalEvent( oTarget, EventSpellCastAt( oTarget, 478, FALSE ) );

    // Link it together
    effect eLink        = EffectLinkEffects( eSaving, eDur);

    // Prevent dispelling
    eLink = ExtraordinaryEffect( eLink );

    // Prevent stacking
    RemoveEffectsFromSpell( oTarget, GetSpellId( ) );

    // Apply the effects
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis2, oTarget );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration );
}
