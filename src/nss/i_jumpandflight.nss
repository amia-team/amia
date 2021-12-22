/*  i_shadowport

    --------
    Verbatim
    --------
    Custom item for shadowdancers, to teleport short distances.

    ---------
    Changelog
    ---------

    Date    Name        Reason
    ------------------------------------------------------------------
    050106  Disco       Corrected OnActivate event
    ------------------------------------------------------------------


*/

#include "x2_inc_switches"
#include "inc_ds_records"

void ActivateItem(){

    object oWand            = GetItemActivated( );
    object oDM              = GetItemActivator( );
    object oTarget          = GetItemActivatedTarget( );
    string szTargetName     = GetName( oTarget );
    int nDMstatus           = GetIsDM( oDM );

    // DM-only Wand user.
    if ( GetIsDM(oDM) == FALSE ){
        SendMessageToPC( oDM, "- Bad! No! Go away!" );
        return;
    }

    // PC-only Target.
    if( !GetIsPC( oTarget ) ){
        // Notify
        SendMessageToPC( oDM, "- Error: Target may only be a player character. -" );
        // Exit.
        return;
    }

    // Store target pointer.
    SetLocalObject( oDM, "jump_flight_target", oTarget );
    // Initialize conversation and it's variables.
    SetCustomToken( 17894, szTargetName );
    AssignCommand( oDM, ActionStartConversation( oDM, "c_jump_flight", TRUE, FALSE ) );
}



void main( ){
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
