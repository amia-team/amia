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

    if ( GetRacialType(oPC) == 36 ||
         sSubRace           == "shadow elf" ||
         GetRacialType(oPC) == 33 ||
         GetRacialType(oPC) == 41 ||
         GetRacialType(oPC) == 30 ||
         GetRacialType(oPC) == 45 ||
         GetRacialType(oPC) == 38 ||
         GetRacialType(oPC) == 43 ||
         GetRacialType(oPC) == 39 ||
         GetRacialType(oPC) == 7 ||
         GetRacialType(oPC) == 11 ||
         GetRacialType(oPC) == 12 ||
         GetRacialType(oPC) == 13 ||
         GetRacialType(oPC) == 14 ||
         GetRacialType(oPC) == 15 ||
         GetRacialType(oPC) == 24 ||
         GetRacialType(oPC) == 42 ||
         GetRacialType(oPC) == 43 ||
         GetRacialType(oPC) == 44 ||
         GetRacialType(oPC) == 55 ){

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

        return 1;
    }

    return 0;
}

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC = GetClickingObject();

    clean_vars( oPC, 4 );

    int nTarget;
    int i;
    int j;
    int nIsUD = IsUnderdarkRace( oPC );

    for ( i=0; i<15; ++i ){

        nTarget = GetLocalInt( OBJECT_SELF, "target_"+IntToString( i ) );

        if ( nTarget > 0 ){

            if ( nIsUD ){

                SetLocalInt( oPC, "ds_check_"+IntToString( nTarget ), 1 );
            }

            ++j;
        }
    }

    if ( !nIsUD ){

        SetLocalInt( oPC, "ds_check_40", 1 );
    }
    else{

        SetLocalInt( oPC, "ds_check_40", 0 );

        if ( !GetLocalInt( oPC, "ds_udb" ) ){

            AddJournalQuestEntry( "ds_udb", 1, oPC, FALSE );

            SetLocalInt( oPC, "ds_udb", TRUE );
        }
    }

    SetLocalString( oPC, "ds_action", "udb_corridor_act" );
    SetLocalObject( oPC, "ds_target", OBJECT_SELF );
    SetLocalInt( OBJECT_SELF, "count", j );

    AssignCommand( oPC, ActionStartConversation( oPC, "udb_corridor", TRUE, FALSE ) );
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

