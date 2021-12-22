//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: i_ds_dm_port
//group: dm tools
//used as: item activation script
//date: 2008-12-16
//author: disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_ds_records"
#include "inc_ds_actions"
#include "inc_nwnx_events"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void ActivateRodOfPorting( );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main( ){

    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_INSTANT:
        case X2_ITEM_EVENT_ACTIVATE:

            if(nEvent==X2_ITEM_EVENT_INSTANT)
                EVENTS_Bypass();

            ActivateRodOfPorting( );
            break;
    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void ActivateRodOfPorting( ){

    object oPC          = InstantGetItemActivator( );
    object oTarget      = InstantGetItemActivatedTarget( );
    object oItem        = InstantGetItemActivated();
    int PCStatus        = GetDMStatus( GetPCPlayerName( oPC ) , GetPCPublicCDKey( oPC, TRUE ) );

    //swap with new version
    if ( PCStatus == 0 ){

        SendMessageToPC( oPC, "This item is only useable by DMs." );
        DestroyObject( oItem );
        return;
    }

    clean_vars( oPC, 4 );

    if ( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE ){

        if ( oTarget != oPC ){

            //PCs have a home location
            SetLocalInt( oPC, "ds_check_2", 1 );
        }

        object oArea = GetAreaFromLocation( GetLocalLocation( oTarget, "ds_back" ) );

        if ( GetIsObjectValid( oArea ) ){

            //This PC can be placed back
            SetLocalInt( oPC, "ds_check_1", 1 );
            SetCustomToken( 201, "Back to "+GetName( oArea ) );
        }

        SetLocalObject( oPC, "ds_target", oTarget );
        SetLocalString( oPC, "ds_action", "ds_dm_port_act" );

        AssignCommand( oPC, ActionStartConversation( oPC, "ds_dm_port", TRUE, FALSE ) );
    }

    return;
}
