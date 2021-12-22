// Item event script for Undead Creator.
//

#include "x2_inc_switches"
#include "inc_ds_records"


void ActivateItem( ){


    object oPC = GetItemActivator( );
    AssignCommand( oPC, ClearAllActions() );
    AssignCommand( oPC, ActionStartConversation(oPC, "makeundead", TRUE, FALSE) );

TrackItems( oPC, oPC, "Undead Creator", "used"  );

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
