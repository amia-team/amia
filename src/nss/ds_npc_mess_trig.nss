//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:ds_npc_mess_trig
//group: npc announcements
//used as: trigger OnEnter event
//date: 2013-10-27
//author: disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"

//for reference
//type ds_trg_chat   = two npc's chatting to each other on trigger (type 2 in database)
//type ds_trg_herald = herald making announcement on trigger (type 3 in database)


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC      = GetEnteringObject();
    object oTrigger = OBJECT_SELF;
    object oTarget1  = GetLocalObject( oTrigger, "target1" );     //NPC that starts gossip
    object oTarget2 = GetLocalObject( oTrigger, "target2" );    //NPC that comments
    string sChat    = GetLocalString( oTrigger, "chat" );     //Announcement line
    string sAnswer  = GetLocalString( oTrigger, "answer" );    //Comment line
    string sType    = GetTag( oTrigger );


    if ( oTarget1 == OBJECT_INVALID ){

        //get the right NPCs
        if ( sType == "ds_trg_chat" ){

            oTarget1  = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC );
        }
        else{

            oTarget1  = GetObjectByTag( "ds_npc_herald" );
        }

        //destroy trigger if there isn't an npc
        if ( oTarget1 == OBJECT_INVALID ){

            DestroyObject( oTrigger, 0.1 );

            return;
        }

        SetLocalObject( oTrigger, "target1", oTarget1 );

        if ( sType == "ds_trg_chat" ){

            oTarget2 = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oTarget1 );

            //destroy trigger if there isn't a second npc
            if ( oTarget2 == OBJECT_INVALID ){

                DestroyObject( oTrigger, 0.1 );

                return;
            }
        }

        SetLocalObject( oTrigger, "target2", oTarget2 );
    }

    if ( sChat == "" ){

        string sModule  = IntToString( GetLocalInt( GetModule(), "Module" ) );
        string sArea    = GetResRef( GetArea( oPC ) );
        string sSQL     = "SELECT message FROM npc_messages WHERE messenger = 3 AND area='"+sArea+"' AND module="+sModule;

        if ( sType == "ds_trg_chat" ){

            sSQL     = "SELECT message, answer FROM npc_messages WHERE messenger = 2 AND area='"+sArea+"' AND module="+sModule;
        }

        SQLExecDirect( sSQL );

        if ( SQLFetch( ) == SQL_SUCCESS ){

            sChat   = SQLDecodeSpecialChars( SQLGetData( 1 ) );
            sAnswer = SQLDecodeSpecialChars( SQLGetData( 2 ) );
        }

        SetLocalString( oTrigger, "chat", sChat );
        SetLocalString( oTrigger, "answer", sAnswer );
    }

    //don't fire if the trigger has been used less than a minute ago
    if ( GetLocalInt( oTrigger, "used" ) == 0  ){

        SetLocalInt( oTrigger, "used", 1 );

        AssignCommand( oTarget1, SpeakString( sChat ) );

        if ( sType == "ds_trg_chat" ){

            DelayCommand( 1.0, AssignCommand( oTarget1, SpeakString( sChat ) ) );
        }

        DelayCommand( 120.0, SetLocalInt( oTrigger, "used", 0 ) );
    }

}
