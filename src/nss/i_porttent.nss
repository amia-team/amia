// Item event script for portable tent.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/22/2004 jpavelch         Initial release.
//

#include "x2_inc_switches"



void CreateTent( location lLocation )
{
    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        "pctent",
        lLocation
    );
}

void ActivateItem( )
{
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );
    location lTarget = GetItemActivatedTargetLocation( );

    AssignCommand(
        oPC,
        ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 3.0)
    );
    DelayCommand( 3.0, CreateTent(lTarget) );
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
