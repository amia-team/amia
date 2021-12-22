//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_init_pc
//group:   chewcks and initialises (new) PCs
//used as: runs from the mirror convo in the entry
//date:    nov 19 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void TransportPC( object oPC );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){


    //get PC
    object oPC          = OBJECT_SELF;

    //cleanup vars
    DeleteLocalString( oPC, "ds_action" );

    //get PC XP (for rebuild/old character check)
    int nXP             = GetXP( oPC );

    //action script node
    int nNode           = GetLocalInt( oPC, "ds_node" );

    //check for key and journal
    object oKey         = GetPCKEY( oPC );
    object oJournal     = GetLocalObject( oPC, "MyJournal" );


    if ( nNode == 1 || ( nNode > 10 && nNode < 20 ) ){

        //player has no key, no journal, and 2000 XP: new player

        //create key
        oKey = CreatePCKEY( oPC );

        //finish
        FinishExport( oPC, oKey );

        if ( nNode > 10 ){

            SetPCKEYValue( oPC, "bp_1", TranslateStartWaypoint( nNode - 10 ) );
        }
    }
    else if ( nNode == 2 ){

        //player has a(n unset) key, a journal, and 2000 XP: old player
        //player has a(n unset) key, a journal, and not 2000 XP: old player

        //cache key
        oKey = CachePCKEY(  oPC, oKey );

        if ( !GetIsObjectValid( oKey ) ){

            SendMessageToPC( oPC, "Error: No PCKEY." );
            return;
        }

        //save journal
        ExportJournal( oPC, oKey );
    }
    else if ( nNode == 3 ){

        //player has a(n unset) key, no journal, and 2000 XP: error
        //player has a(n unset) key, no journal, and not 2000 XP: messed up rebuild
        //player has no key, no journal, and not 2000 XP: messed up rebuild

        //error
        SendMessageToPC( oPC, "Error: No Journal." );

        return;
    }
    else if ( nNode == 4 ){

        //player has no key, a journal, and 2000 XP: old player
        //player has no key, a journal, and not 2000 XP: old player

        //create key
        oKey = CreatePCKEY( oPC );

        //save journal
        ExportJournal( oPC, oKey );
    }
    else{

        //error
        SendMessageToPC( oPC, "Error: No Clue." );
        return;
    }

    if ( GetLocalInt( oPC, "ds_subrace_activated" ) == 1 ){

        SetPCKEYValue( oPC, "ds_subrace_activated", 1 );
    }

    //make sure people see their quests
    DelayCommand( 10.0, ImportJournal( oPC, oKey ) );

    //clean up
    DeleteLocalInt( oPC, "ds_node" );

    //port
    DelayCommand( 1.0, TransportPC( oPC ) );
}

void TransportPC( object oPC ){

    object oHome = GetWaypointByTag( GetStartWaypoint( oPC ) );

    AssignCommand( oPC, ClearAllActions() );

    DelayCommand( 0.2f, AssignCommand( oPC, JumpToObject( oHome ) ) );
}



