// Charming Lute
//
// For 15 rounds, an aura surrounds the user which casts charm monster on
// all hostile creatures in the aura's area.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/10/2012 Mathias          Initial Release.
// 02/20/2012 PaladinOfSune    Updated to Amia script standards; made it an Extraordinary effect.
// 02/20/2012 Mathias          Added OnHeartbeat to catch creatures who spawn in the aura.
//

#include "amia_include"
#include "x2_inc_switches"

void ActivateItem( ) {

    // Get user and bard level
    object oPC          = GetItemActivator( );
    object oWidget      = GetItemActivated( );
    float  fDuration    = RoundsToSeconds( 15 );  // 15 rounds

    // Prevent stacking.
    if ( GetIsBlocked( oPC, "charm_on" ) > 0 ) {
        FloatingTextStringOnCreature( "- This ability is already active! -", oPC, FALSE );
        return;
    }

    // Apply the VFX, AB and AC loss.
    effect eAOE     = EffectAreaOfEffect(AOE_MOB_DRAGON_FEAR, "cs_charmlute_a", "cs_charmlute_b", "****");
    effect eSongVFX = EffectVisualEffect( VFX_DUR_BARD_SONG );
    effect eAOEVFX  = EffectVisualEffect( VFX_DUR_AURA_DRAGON_FEAR );
    effect eLink    = EffectLinkEffects(eAOE, eSongVFX);
    eLink           = EffectLinkEffects(eAOEVFX, eLink);
    eLink           = ExtraordinaryEffect( eLink );

    DelayCommand( 0.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration ) );

    // Set stackage prevention time.
    SetBlockTime( oPC, 0, FloatToInt(fDuration), "charm_on" );
}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
