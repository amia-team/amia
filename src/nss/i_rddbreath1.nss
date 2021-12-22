// Replicates Knock, for usage of one Shadow Evade.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/28/2011 PaladinOfSune    Initial Release
//

#include "x2_inc_switches"
#include "nw_i0_spells"

#include "x2_inc_spellhook"

void ActivateItem()
{
    // Declare the variables.
    object oPC = GetItemActivator();

    if( GetLocalInt( oPC, "special_breath_1" ) > 0 ) // For custom request breathes, may or may not be expanded later
    {
        DeleteLocalInt( oPC, "special_breath_1" );
        FloatingTextStringOnCreature( "Dragon Disciple breath set to default!", oPC, FALSE );
    }
    else
    {
        SetLocalInt( oPC, "special_breath_1", 1 );
        FloatingTextStringOnCreature( "Dragon Disciple breath set to Slow!", oPC, FALSE );
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
