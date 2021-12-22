// Aura of Weave Annihilation

// Activates an aura which strips spell effects every round.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 30/09/2012 PaladinOfSune    Initial Release
//

#include "x2_inc_switches"
#include "x2_inc_spellhook"

void ActivateItem()
{
    // Variables.
    object oPC          = GetItemActivator();
    object oItem        = GetItemActivated();

    int    nHP          = GetCurrentHitPoints( oPC );
    int    nAuraOn;

    // For storing who activated the aura...
    object oModule      = GetModule();

    effect eAOE         = EffectAreaOfEffect( 47, "****", "cs_weaveanni_a", "****" );
    effect eMovement    = EffectMovementSpeedDecrease( 60 );
    effect eSpellFailure = EffectSpellFailure();

    // Visual variables.
    effect eVFX         = EffectVisualEffect( 302 );
    effect eEffectToRemove;

    // No dispels please!
    effect eLink        = EffectLinkEffects( eAOE, eMovement );

    eLink               = ExtraordinaryEffect( eLink );
    eSpellFailure       = ExtraordinaryEffect( eSpellFailure );

    effect eEffect = GetFirstEffect( oPC );
    while( GetIsEffectValid( eEffect ) )
    {
        if( GetEffectSubType( eEffect ) == SUBTYPE_EXTRAORDINARY )
        {
            if( GetEffectType( eEffect ) == EFFECT_TYPE_AREA_OF_EFFECT )
            {
                nAuraOn = 1;
                eEffectToRemove = eEffect;
            }
        }
        eEffect = GetNextEffect( oPC );
    }

    if ( nAuraOn == 1 )
    {
        RemoveEffect( oPC, eEffectToRemove );
        DeleteLocalObject( oModule, "weaveanni_user" );
        DeleteLocalObject( oModule, "weaveanni_item" );
        DeleteLocalInt( oItem, "current_hp" );
    }
    else
    {
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oPC );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oPC );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSpellFailure, oPC, 5.5 );
        SetLocalObject( oModule, "weaveanni_user", oPC );
        SetLocalObject( oModule, "weaveanni_item", oItem );
        SetLocalInt( oItem, "current_hp", nHP );
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
