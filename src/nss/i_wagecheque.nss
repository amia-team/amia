// Wage cheque to give guardsmen their wages.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/04/2005 bbillington      Initial Release
//

#include "x2_inc_switches"
#include "amia_include"


// Gives the targeted PC 1000 gold. The activator can't use it on himself.

void ActivateItem( )
{
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );
    object oTarget = GetItemActivatedTarget( );

    if ( oTarget == oPC )
        SendMessageToPC( oPC, "Tsk, you can't pay yourself wages." );
    else
        GiveGoldToCreature( oTarget, 1000 );
        UpdateModuleVariable( "JobGold", 1000 );

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
