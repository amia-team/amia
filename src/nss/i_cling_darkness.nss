// Clinging Darkness. Replacement for drow darkness widget; applies Blindness.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 08/02/2011 PoS              Initial Release


// Includes
#include "x2_inc_switches"
#include "NW_I0_SPELLS"

void ActivateItem()
{
    // Get target and user
    object oTarget      = GetItemActivatedTarget();
    object oPC          = GetItemActivator();

    // Used for duration and DC calculation
    int nDuration       = GetHitDice( oPC );
    int nCHA            = GetAbilityModifier( ABILITY_CHARISMA, oPC );

    // Visuals
    effect eVFX1        = EffectVisualEffect( VFX_IMP_BLIND_DEAF_M );
    effect eVFX2        = EffectVisualEffect( VFX_DUR_AURA_PULSE_PURPLE_BLACK );
    effect eVFX3        = EffectVisualEffect( VFX_IMP_REFLEX_SAVE_THROW_USE );

    // Blindness
    effect eBlind       = EffectBlindness();

    // CHA mod + 10 + half HD
    int nDC             = nDuration / 2 + nCHA + 10;

    // Checks to see if object is Creature
    if ( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE ) {
        SendMessageToPC( oPC, "You can't target that!" );
        return;
    }

    // Bring it all together
    effect eLink        = EffectLinkEffects( eVFX2, eBlind );

    // Roll for effect!
    if( ReflexSave ( oTarget, nDC, SAVING_THROW_TYPE_NONE, oPC ) < 1 )
    {
        // Failed, apply the stuff
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oTarget );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds( nDuration ) );
    }
    else {
        // Saved
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX3, oTarget );
    }
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

