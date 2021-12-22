// Item event script for the Organic Negative Energy Recipe.
// Spawns a Organic Negative Energy Potion when used.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 22/01/2011 PaladinOfSune    Initial Release

#include "x2_inc_switches"

void ActivateItem()
{
    // Major variables.
    object oPC      = GetItemActivator();
    object oBottle1 = GetItemPossessedBy( oPC, "x2_it_cfm_pbottl" );
    object oBottle2 = GetItemPossessedBy( oPC, "x2_it_pcpotion" );
    effect eVFX1    = EffectVisualEffect( VFX_IMP_PULSE_NEGATIVE );
    effect eVFX2    = EffectVisualEffect( VFX_COM_HIT_NEGATIVE );

    // Each bottle costs 4000 to brew.
    if( GetGold( oPC ) < 4000 ) {
        FloatingTextStringOnCreature( "<cþ>- You lack the necessary funds to procure the components needed. -</c>", oPC, FALSE );
        return;
    }

    // For some reason, Bioware put in two crafting bottles... there's a check for each.
    if( GetIsObjectValid( oBottle1 ) ) {
        DestroyObject( oBottle1, 0.1f );
    }
    else if ( GetIsObjectValid( oBottle2 ) ) {
        DestroyObject( oBottle2, 0.1f );
    }
    else {
        FloatingTextStringOnCreature( "<cþ>- You must possess an empty bottle to brew this mixture. -</c>", oPC, FALSE );
        return;
    }

    // Remove that gold!
    AssignCommand( oPC, TakeGoldFromCreature( 4000, oPC, TRUE ) );

    // Apply fancy visuals.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oPC );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oPC );

    // Create bottle and inform the PC it succeeeded.
    CreateItemOnObject( "organic_potion", oPC, 1 );
    FloatingTextStrRefOnCreature( 8502, oPC );
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
