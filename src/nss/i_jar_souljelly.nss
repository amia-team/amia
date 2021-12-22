/* Jar of Trapped Souls Custom Power

Calls the Graveyard Sludge's Fear Howl ability.

Revision History
Date     Name             Description
-------- ---------------- ---------------------------------------------
30/06/14 Glim             Initial Release

*/
#include "amia_include"
#include "x2_inc_switches"

void ActivateItem()
{
    object oPC = GetItemActivator();

    ExecuteScript( "abl_grvsldghowl", oPC );
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
