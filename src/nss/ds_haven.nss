// Haven

// Works like original GS with a far shorter duration.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/29/2012 PaladinOfSune    Initial Release
//

#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }

    //Declare major variables
    object oTarget  = GetSpellTargetObject();
    effect eVis     = EffectVisualEffect( VFX_DUR_IOUNSTONE_YELLOW );
    effect eHaste   = EffectHaste();
    effect eSanc    = EffectEthereal();

    effect eLink    = EffectLinkEffects( eVis, eSanc );
    eLink           = EffectLinkEffects( eLink, eHaste );

    if( GetLevelByClass( CLASS_TYPE_CLERIC, oTarget ) == 0 )
    {
        FloatingTextStringOnCreature( "Only clerics may cast this spell!", oTarget, FALSE );
        return;
    }

    //Fire cast spell at event for the specified target
    SignalEvent( oTarget, EventSpellCastAt( OBJECT_SELF, SPELL_ETHEREALNESS, FALSE ) );

    //Apply the VFX impact and effects
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds( 5 ) );
}
