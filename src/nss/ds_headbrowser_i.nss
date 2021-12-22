//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:       ds_headbrowser_i
//used for:     pc customisation
//used as:      npc convo script
//date:         2010-09-26
//author:       disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"
#include "inc_ds_records"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    //this means the NPC is busy
    if ( GetLocalInt( OBJECT_SELF, "ds_head" ) == 1 ){

        return;
    }

    //this locks the NPC
    SetLocalInt( OBJECT_SELF, "ds_head", 1 );

    //variables
    object oPC      = GetLastSpeaker();
    object oKey     = GetPCKEY( oPC );
    int nHeadCheck  = GetPCKEYValue( oPC, "ds_head" );
    int nRace       = GetRacialType( oPC );
    string sSubrace = GetStringLowerCase( GetSubRace( oPC ) );


//testing
SendMessageToPC( oPC, "nHeadCheck="+IntToString( nHeadCheck ) );



//testing
SendMessageToPC( oPC, "oKey="+GetName( oKey ) );


    //kobos, gobbos, and fairies don't swap heads
    if ( nRace != RACIAL_TYPE_DWARF &&
         nRace != RACIAL_TYPE_ELF &&
         nRace != RACIAL_TYPE_GNOME &&
         nRace != RACIAL_TYPE_HALFELF &&
         nRace != RACIAL_TYPE_HALFLING &&
         nRace != RACIAL_TYPE_HALFORC &&
         nRace != RACIAL_TYPE_HUMAN ){

        SpeakString( "You can only change the heads of dynamic model races." );

        SetLocalInt( OBJECT_SELF, "ds_head", 0 );

        return;
    }
    else if ( sSubrace == "goblin" || sSubrace == "kobold" ){

        SpeakString( "Kobolds or goblins change their heads at the other side of this room." );

        SetLocalInt( OBJECT_SELF, "ds_head", 0 );

        return;
    }

    //action script stuff
    clean_vars( oPC, 4 );
    SetLocalString( oPC, "ds_action", "ds_headbrowser_a" );
    SetLocalObject( oPC, "ds_target", OBJECT_SELF );

    //no pckey means a fresh character. let 'em swap 'till they drop.
    if ( oKey == OBJECT_INVALID ){

        SetLocalInt( oPC, "nokey", 1 );

        SetLocalInt( oPC, "ds_check_3", 1 );

        SetLocalInt( oPC, "ds_head", GetCreatureBodyPart( CREATURE_PART_HEAD, oPC ) );
    }
    else{

        SetLocalInt( oPC, "nokey", 0 );

        //nHeadcheck is -99 means that this character already swapped its head
        //and has a pckey
        if ( nHeadCheck == -99  ){

            SetLocalInt( oPC, "ds_check_1", 1 );
        }
        else if ( nHeadCheck == 0 ){

            SetLocalInt( oPC, "ds_check_2", 1 );

            SetLocalInt( oPC, "ds_head", 0 );

            SetPCKEYValue( oPC, "ds_head", GetCreatureBodyPart( CREATURE_PART_HEAD, oPC ) );
        }
    }

    ActionStartConversation( oPC, "ds_headbrowser", TRUE, FALSE );
}


