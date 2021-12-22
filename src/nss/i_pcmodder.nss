#include "inc_nwnx_events"
#include "x2_inc_switches"
#include "inc_ds_records"

void BackToBaseTree( object oPC ){

    object oTarget = GetLocalObject( oPC, "ds_target" );

    SetCustomToken( 64710, GetName( oTarget ) + " [" + ObjectToString( oTarget ) + "] " + GetPCPlayerName( oTarget ) );
    SetLocalInt( oPC, "ds_tree", 0 );
}

void main(){

    if( GetUserDefinedItemEventNumber() == X2_ITEM_EVENT_INSTANT ){
        EVENTS_Bypass();
    }

    object oPC = InstantGetItemActivator();

    if( GetDMStatus( GetPCPlayerName( oPC ), GetPCPublicCDKey( oPC ) ) <= 0 &&
        GetPCPlayerName( oPC ) != "Terra_777" ){

        DestroyObject( InstantGetItemActivated() );
        return;
    }

    object oTarget = InstantGetItemActivatedTarget();

    if( !GetIsObjectValid( oTarget ) )
        return;

    SetLocalString( oPC, "ds_action", "td_act_pcmodder" );
    SetLocalObject( oPC, "ds_target", oTarget );
    BackToBaseTree( oPC );
    AssignCommand( oPC, ActionStartConversation( oPC, "td_pcmodder", TRUE, FALSE ) );
}
