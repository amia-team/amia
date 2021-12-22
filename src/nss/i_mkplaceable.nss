// Timed placeable maker item event script.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 06/25/2003 jpavelch         Initial Release
//

#include "x2_inc_switches"


// Sets the target and location and starts the conversation.
//
void ActivateItem( )
{
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );

    location lTarget = GetItemActivatedTargetLocation( );
    object oTarget = GetItemActivatedTarget( );
    if ( GetIsObjectValid(oTarget) )
        lTarget = GetLocation( oTarget );

    SetLocalObject( oPC, "MKP_Wand", oItem );
    SetLocalLocation( oItem, "MKP_TargetLocation", GetItemActivatedTargetLocation() );

    AssignCommand( oPC, ActionStartConversation(oPC, "mkplaceable", TRUE, FALSE) );
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
