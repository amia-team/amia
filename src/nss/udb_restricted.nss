//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:   udb_corridor
//group:    travel
//used as:  OnClick door script
//date:     jan 17 2009
//author:   disco
//modified: 2014/04/29  msheeler    added support for use of udb_canpass and
//                                  commented out the test msgs.

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
int IsUnderdarkRace( object oPC ) {

    string sSubRace = GetStringLowerCase( GetSubRace( oPC ) );

    if ( sSubRace == "svirfneblin" ||
         sSubRace == "shadow elf" ||
         sSubRace == "drow" ||
         sSubRace == "half-drow" ||
         sSubRace == "duergar" ||
         sSubRace == "orog" ||
         sSubRace == "goblin" ||
         sSubRace == "kobold" ){

//         SendMessageToPC( oPC, "[test: IsUnderdarkRace=1]" );

         return 1;
    }
    int nCanPass = GetLocalInt( oPC, "udb_canpass" );

    if ( nCanPass == 0 ){

        if ( GetIsObjectValid( GetItemPossessedBy( oPC, "udb_canpass" ) ) ){

            nCanPass = 1;
        }
        else{

            nCanPass = -1;
        }

        SetLocalInt( oPC, "udb_canpass", nCanPass );
    }

    if ( nCanPass == 1 ){

//        SendMessageToPC( oPC, "[test: IsUnderdarkRace=1 due to udb_canpass]" );

        return 1;
    }

//    SendMessageToPC( oPC, "[test: IsUnderdarkRace=0]" );

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

