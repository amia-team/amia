// Rod of the Amorous Inmate item event script.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/20/2004 jpavelch         Initial Release
// 05/29/2005 bbillington      Edited it for new prison, removed Bubba.

#include "x2_inc_switches"
#include "inc_ds_records"



// Sends the target to a randomly chosen jail cell.
//
void ActivateItem( )
{
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );
    object oTarget = GetItemActivatedTarget( );

    TrackItems( oPC, oTarget, GetName( oItem ), "Used jailrod" );

    if ( !GetIsPC(oTarget) ) {
        SendMessageToPC( oPC, "You must target PCs with this device." );
        return;
    }

    if ( GetIsDM(oTarget) ) {
        SendMessageToPC( oPC, "You may not send DMs to jail!" );
        return;
    }

    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_LIGHTNING_M),
        GetLocation(oTarget)
    );

    object oDest = GetWaypointByTag( "wp_jail" + IntToString(d4()) );
    location lDest = GetLocation( oDest );

    AssignCommand( oTarget, ClearAllActions(TRUE) );
    AssignCommand( oTarget, JumpToLocation(lDest) );


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
