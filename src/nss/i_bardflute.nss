// Flute, plays 2 tunes from a dialog.

/* Includes */
#include "x2_inc_switches"

void main( ){

    // Variables
    int nEvent              = GetUserDefinedItemEventNumber( );
    object oBook            = GetItemActivated( );
    object oFluter          = GetItemActivator( );

    // Item->Activate
    if( nEvent == X2_ITEM_EVENT_ACTIVATE )

        // Play the flute
        AssignCommand( oFluter, ActionStartConversation( oFluter, "neus_c_flute", TRUE, FALSE ) );

    SetExecutedScriptReturnValue( );

    return;

}
