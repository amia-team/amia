// Item event script for Daybreak. Adds Bless Weapon to a weapon.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/22/2011 PaladinOfSune    Initial release.
//

#include "x2_inc_switches"

void ActivateItem( )
{
    // Major variables.
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );
    int nSpell = SPELL_BLESS_WEAPON;

    // Check if they have Bard Song uses left.
    if ( !GetHasFeat(FEAT_BARD_SONGS, oPC) ) {
        SendMessageToPCByStrRef( oPC, 40063 );
        return;
    }

    // Decrement a use.
    DecrementRemainingFeatUses( oPC, FEAT_BARD_SONGS );
    AssignCommand( oPC, PlaySound( "as_cv_flute2" ) );

    // Cast the spell.
    AssignCommand( oPC,
        ActionCastSpellAtObject( nSpell, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE )
    );
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
