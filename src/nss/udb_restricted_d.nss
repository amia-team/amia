//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  udb_corridor
//group:   travel
//used as: OnClick door script
//date:    jan 17 2009
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
int IsUnderdarkRace( object oPC ) {

    string sSubRace = GetStringLowerCase( GetSubRace( oPC ) );

    if ( sSubRace == "drow" ){

         SendMessageToPC( oPC, "[test: IsUnderdarkRace=1]" );

         return 1;
    }

    SendMessageToPC( oPC, "[test: IsUnderdarkRace=0]" );

    return 0;
}

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    int nType     = GetObjectType( OBJECT_SELF );
    object oPC;

    if ( nType == OBJECT_TYPE_PLACEABLE ){

        oPC = GetLastUsedBy();
    }
    else if ( nType == OBJECT_TYPE_CREATURE ){

        oPC = GetLastSpeaker();
    }

    clean_vars( oPC, 4 );

    int nResult    = IsUnderdarkRace( oPC );
    string sConvo  = GetLocalString( OBJECT_SELF, "convo" );
    string sAction = GetLocalString( OBJECT_SELF, "action" );
    int nGold      = GetLocalInt ( OBJECT_SELF, "Gold" );

    if ( sConvo != "" ){

        ActionStartConversation( oPC, sConvo, TRUE, FALSE );

        if ( nResult ){

            SetLocalInt( oPC, GetLocalString( OBJECT_SELF, "check_y" ), 1 );
        }
        else {

            SetLocalInt( oPC, GetLocalString( OBJECT_SELF, "check_n" ), 1 );
        }
    }

    if ( sAction != "" ){

        TakeGoldFromCreature( nGold, oPC, TRUE );
        SetLocalString( oPC, "ds_action", sAction );
        SetLocalObject( oPC, "ds_target", OBJECT_SELF );
    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

