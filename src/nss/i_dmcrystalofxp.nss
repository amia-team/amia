// DM Crystal of XP item event script.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 12/08/2003 jpavelch         Initial Release
// 01/25/2004 jpavelch         Removed DM/Admin check so anyone can use.
//

#include "x2_inc_switches"
#include "amia_include"
#include "logger"

// Gives the target PC 100 experience points.  The activator cannot give
// gold to himself.
//
void ActivateItem( )
{
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );
    object oTarget = GetItemActivatedTarget( );

    if ( oTarget == oPC )
        SendMessageToPC( oPC, "You cannot give yourself experience!" );
    else
        GiveCorrectedXP( oTarget, 100, "DMXP" );

    LogInfo( "i_dmcrystalofxp", GetName(oPC) + " has used a DM Crystal of XP on "
           + GetName(oTarget) + "." );

    if ( GetItemCharges(oItem) == 0 )
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
