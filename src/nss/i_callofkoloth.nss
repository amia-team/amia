// Koloth summoner item event script.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/17/2005  bb/rb           Initial Release
// 11/08/2006  disco           Koloth is summoned as an effect now

//

#include "x2_inc_switches"


void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:

            object oPC = GetItemActivator( );
            object oItem = GetItemActivated( );

            //New Koloth
            ExecuteScript( "summon_koloth", oPC );

            break;
    }
}
