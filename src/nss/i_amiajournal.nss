// Amia Travel Guide item event script.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 12/29/2003 jpavelch         Initial Release
//

#include "x2_inc_switches"


// Starts the official Amia Travel Guide convo with the activator.
//
void ActivateTravelGuide( )
{
    object oPC = GetItemActivator( );

    AssignCommand( oPC, ActionStartConversation(oPC, "amiajournal", TRUE, FALSE) );
}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateTravelGuide( );
            break;
    }
}
