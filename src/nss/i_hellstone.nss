// Hellstone item event script.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/20/2004 jpavelch         Initial Release
// 12/15/2004 jpavelch         New server include file.
//

#include "x2_inc_switches"
#include "amia_include"


// Starts the emote wand dialog with the PC.
// obsolete
//
void ActivateItem( )
{
    object oPC          = GetItemActivator( );
    object oItem        = GetItemActivated( );
    location lTarget    = GetItemActivatedTargetLocation( );

    DestroyObject( oItem );
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
