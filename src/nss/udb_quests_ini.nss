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

    string sCreate  = GetLocalString( OBJECT_SELF, "give_item" );
    string sDestroy = GetLocalString( OBJECT_SELF, "take_item" );
    string sCheck_Y = GetLocalString( OBJECT_SELF, "check_y" );
    string sCheck_N = GetLocalString( OBJECT_SELF, "check_n" );


    SetLocalInt( oPC, sCheck_Y, 0 );
    SetLocalInt( oPC, sCheck_N, 0 );

    if ( GetHitDice( oPC ) > 2 ){

        //must be done within level range
        SetLocalInt( oPC, "ds_check_39", 1 );
    }
    else if ( GetLocalInt( oPC, sCreate ) == 1 || GetLocalInt( oPC, sDestroy ) == 1 ){

        //only once a reset!
        SetLocalInt( oPC, "ds_check_40", 1 );
    }
    else if ( sDestroy != "" ){

        object oDestroy = GetItemPossessedBy( oPC, sDestroy );

        if ( GetIsObjectValid( oDestroy ) ){

            SetLocalInt( oPC, sCheck_Y, 1 );
            SetLocalInt( oPC, sDestroy, 1 );

            DestroyObject ( oDestroy );

            GiveGoldToCreature( oPC, 250 );
            GiveXPToCreature( oPC, 250 );
        }
        else {

            SetLocalInt( oPC, sCheck_N, 1 );
        }
    }
    else if ( sCreate != "" ){

        object oCreate = GetItemPossessedBy( oPC, sCreate );

        if ( GetIsObjectValid( oCreate ) ){

            SetLocalInt( oPC, sCheck_N, 1 );
        }
        else {

            SetLocalInt( oPC, sCheck_Y, 1 );
            CreateItemOnObject( sCreate, oPC );
        }
    }
    else{

        //error
    }

    ActionStartConversation( oPC, "udb_quests", TRUE );
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

