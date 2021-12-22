// Tinder Box item event script.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 12/08/2003 jpavelch         Initial Release
//

#include "x2_inc_switches"

// Creates the campfire object.
//
void CreateCampfire( location lLocation )
{
    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        "campfire",
        lLocation
    );
}


// Creates a cozy campfire that lasts three minutes.
//
void ActivateTinderBox( )
{
    object oPC = GetItemActivator( );
    object oTinderbox = GetItemActivated( );
    location lLocation = GetItemActivatedTargetLocation( );

    AssignCommand(
        oPC,
        ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 3.0)
    );

    // Some old tinderboxes have 3 uses/day.
    if ( GetIsObjectValid(oTinderbox) )
        DestroyObject( oTinderbox, 3.0 );

    DelayCommand( 3.0, CreateCampfire(lLocation) );
}


void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateTinderBox( );
            break;
    }
}
