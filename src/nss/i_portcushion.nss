/*! \file i_portcushion.nss
 * \brief Tiger-skin cushions item vent script.
 *
 * Creates a cushion placeable at the target location on which the PC may
 * sit.
 * \verbatim
 * Revision History
 * Date       Name             Description
 * ---------- ---------------- ---------------------------------------------
 * 11/14/2004 jpavelch         Initial release.
 * \endverbatim
 */

#include "x2_inc_switches"


//! Creates a cushion placeable.
/*!
 * \param lLocation Location to create the placeable.
 */
void CreateCushions( location lLocation )
{
    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        "ar_cushions",
        lLocation
    );
}

//! Item activation event.
/*!
 * Has the activator play the 'getting low' animation and then creates the
 * cushion placeable at the target location.
 */
void ActivateItem( )
{
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );
    location lTarget = GetItemActivatedTargetLocation( );

    AssignCommand(
        oPC,
        ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 3.0)
    );
    DelayCommand( 3.0, CreateCushions(lTarget) );
}

//! Script entry point.
/*!
 * Decodes the item event number and calls the appropriate behavior.
 */
void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
