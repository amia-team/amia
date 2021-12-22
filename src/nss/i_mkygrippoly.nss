// Monkey Grip polymorph widget. Part of the process to use the Monkey Grip ability.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 07/07/2012 PaladinOfSune    Initial Release
//

#include "x2_inc_switches"

void ActivateItem( )
{
    // Declare variables
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );

    // Variables
    effect ePoly = EffectPolymorph( POLYMORPH_TYPE_TROLL );
    effect eCha  = EffectAbilityIncrease( ABILITY_CHARISMA, 12 );
    effect eWis  = EffectAbilityIncrease( ABILITY_WISDOM, 12 );
    effect eInt  = EffectAbilityIncrease( ABILITY_INTELLIGENCE, 12 );

    effect eLink = EffectLinkEffects( ePoly, eCha );
    eLink = EffectLinkEffects( eWis, eLink );
    eLink = EffectLinkEffects( eInt, eLink );

    eLink = SupernaturalEffect( eLink );

    // Shift 'em!
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oPC );
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
