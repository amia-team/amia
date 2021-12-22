/*! \file i_arelithdm.nss
 * \brief Arelith DM Rod item event script.
 *
 * DM/admin tool.
 * \verbatim
 * Revision History
 * Date       Name             Description
 * ---------- ---------------- ---------------------------------------------
 * 12/08/2003 jpavelch         Initial release.
 * \endverbatim
 */

#include "x2_inc_switches"


//! Item activation event.
/*!
 * Initializes the DM and selected object and starts the Arelith DM Rod
 * conversation.
 * \par Local Variables
 * \li ADM_Wand Set on the PC to identify the wand used.
 * \li ADM_Target Set on the PC to identify the target.
 * \li ADM_TargetLocation Set on the PC to identify the target location.
 */
void ActivateDMRod( )
{
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );

    SetLocalObject( oPC, "ADM_Wand", oItem );
    SetLocalObject( oPC, "ADM_Target", GetItemActivatedTarget() );
    SetLocalLocation( oPC, "ADM_TargetLocation", GetItemActivatedTargetLocation() );

    AssignCommand( oPC, ActionStartConversation(oPC, "arelithdm", TRUE, FALSE) );
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
            ActivateDMRod( );
            break;
    }
}
