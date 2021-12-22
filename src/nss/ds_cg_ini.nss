/*

    The idea: a PC gets a task which he has to complete within a session.
    One task can be done a week.

    Needed stored vars: week, status
    Needed local vars: NPC or package name, area resref, type of quest

    Status:
    0 = uninitialised
    1 = got quest
    2 = spawned NPC/Crate
    3 = found NPC/Crate
    4 = NPC to jail
    5 = NPC jailed
    6 = quest completed
    7 = quest declined
    8 = NPC killed
    9 = NPC escaped
   10 = quest failed because of 8 or 9

    Quests: find NPC, find Package in sewers.
    Misdemeanor: NPCs can do: pickpocketing, burglary, arson, assault, theft, robbery.

    Scripting: use en_spawntrigger and chat triggers for spawning.
*/

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_actions"
#include "inc_ds_records"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void CreateQuest( object oPC );
string GetQuestType( int nQuest );
string GetQuestArea( int nArea );
string GetQuestName( int nName );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    //variables
    object oPC;
    int nQuestStatus;
    int nQuestType;
    string sName;

    //this is for the contraband PLC
    if ( GetResRef( OBJECT_SELF ) == "cg_ds_contraband" ){

        oPC             = GetLastUsedBy();
        nQuestStatus    = GetPCKEYValue( oPC, "cg_status" );
        nQuestType      = GetLocalInt( oPC, "cg_type" );
        sName           = GetLocalString( oPC, "cg_name" );

        //cleanup vars
        clean_vars( oPC, 1 );

        //set action script
        SetLocalString( oPC, "ds_action", "ds_cg_act" );

        if ( GetTag( OBJECT_SELF ) == "cg_"+GetPCPublicCDKey( oPC, TRUE ) && nQuestStatus > 0 && nQuestStatus < 5 ){

            SetLocalInt( oPC, "ds_check_1", 1 );
            SetLocalObject( oPC, "ds_target", OBJECT_SELF );
            SetCustomToken( 4711, GetQuestType( nQuestType ) );
            SetCustomToken( 4712, sName );
        }

        AssignCommand( oPC, ActionStartConversation( oPC, "cg_ds_crate", TRUE, FALSE ) );

        return;
    }

    //rest of the options works through a convo
    oPC             = GetLastSpeaker();
    nQuestStatus    = GetPCKEYValue( oPC, "cg_status" );
    nQuestType      = GetLocalInt( oPC, "cg_type" );
    sName           = GetLocalString( oPC, "cg_name" );

    //cleanup vars
    clean_vars( oPC, 1 );

    //set action script
    SetLocalString( oPC, "ds_action", "ds_cg_act" );

    //this part is for the fugitive
    if ( GetResRef( OBJECT_SELF ) == "cg_ds_criminal" && nQuestStatus > 0 && nQuestStatus < 4 ){

        SetLocalInt( oPC, "ds_check_10", 1 );
        SetLocalObject( oPC, "ds_target", OBJECT_SELF );

        int nSwitch = d6() + nQuestType;

        if ( nSwitch < 5 ){

            SetLocalInt( oPC, "ds_check_11", 1 );
        }
        else if ( nSwitch < 9 ){

            SetLocalInt( oPC, "ds_check_12", 1 );
        }
        else{

            SetLocalInt( oPC, "ds_check_13", 1 );
        }

        SetCustomToken( 4707, GetQuestType( nQuestType ) );
        SetCustomToken( 4706, sName );

        if ( GetName( OBJECT_SELF ) != sName ){

            SetLocalInt( oPC, "ds_check_14", 1 );
            SetCustomToken( 4708, GetName( OBJECT_SELF ) );
        }

        DelayCommand( 0.0, ActionStartConversation( oPC, "", FALSE, TRUE ) );

        return;
    }

    //this is for the dungeon master NPC
    if ( GetTag( OBJECT_SELF ) == "cg_ds_jailer" && nQuestStatus == 4 ){

        SetLocalInt( oPC, "ds_check_1", 1 );
        SetLocalObject( oPC, "ds_target", OBJECT_SELF );

        SetCustomToken( 4709, GetQuestType( nQuestType ) );
        SetCustomToken( 4710, sName );

        DelayCommand( 1.0, ActionStartConversation( oPC, "", FALSE, TRUE ) );

        return;
    }


    //this part is for the corporal

    //a quest has been given this week

    int nWeek           = GetPCKEYValue( oPC, "cg_week" );
    int nCurrentWeek    = GetLocalInt( GetModule(), "ds_week" );

    if ( nWeek == nCurrentWeek ){

        if ( nQuestStatus == 5 ){

            //reporting
            if ( nQuestType < 7 ){

                SetLocalInt( oPC, "ds_check_4", 1 );
                SetCustomToken( 4702, sName );
            }
            else{

                SetLocalInt( oPC, "ds_check_5", 1 );
            }
        }
        else if ( nQuestStatus == 6 ){

            //quest done
            SetLocalInt( oPC, "ds_check_6", 1 );
        }
        else if ( nQuestStatus == 7 ){

            //quest declined
            SetLocalInt( oPC, "ds_check_7", 1 );
        }
        else if ( nQuestStatus == 8 ){

            //npc killed
            SetLocalInt( oPC, "ds_check_8", 1 );
        }
        else if ( nQuestStatus == 9 ){

            //npc escaped
            SetLocalInt( oPC, "ds_check_9", 1 );
        }
        else if ( nQuestStatus == 10 ){

            //quest failed
            SetLocalInt( oPC, "ds_check_10", 1 );
        }
        else{

            //quest busy
            SetLocalInt( oPC, "ds_check_11", 1 );
        }
    }
    else{
        /*
        if ( nQuestStatus ){

            //quest busy
            SetLocalInt( oPC, "ds_check_3", 1 );
            //quest busy
            SetLocalInt( oPC, "ds_check_11", 1 );
        }
        else{

        */

        //free to do a quest!

        SetPCKEYValue( oPC, "cg_status", 0 );
        CreateQuest( oPC );

    }

    DelayCommand( 0.0, ActionStartConversation( oPC, "", FALSE, TRUE ) );
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void CreateQuest( object oPC ){

    //determine type and subtype
    int nMainType     = d2();
    int nType;
    int nSwitch;
    string sName;
    string sType;
    string sArea;

    //Set type
    SetLocalInt( oPC, "cg_type", nType );

    //create names
    if ( nMainType == 1 ){

        //NPC
        sName = RandomName( NAME_FIRST_GENERIC_MALE ) + " " + RandomName( NAME_LAST_HUMAN );

        //quest type and area
        nType = d6();
        sType = GetQuestType( nType );
        sArea = GetQuestArea( d6() );

    }
    else{

        //contraband
        nType = 6+d6();
        sType = GetQuestType( nType );
        sName = GetQuestName( d6() );
        sArea = GetQuestArea( 6+d4() );

    }

    SetCustomToken( 4700, sName );
    SetCustomToken( 4701, sType );

    SetLocalInt( oPC, "ds_check_3", 1 );
    SetLocalInt( oPC, "ds_check_"+IntToString( nMainType ), 1 );
    SetLocalInt( oPC, "cg_type", nType );
    SetLocalString( oPC, "cg_name", sName );
    SetLocalString( oPC, "cg_area", sArea );


}

string GetQuestType( int nQuest ){

    string sType;

    switch ( nQuest ) {

        case 1:   sType = "Slander";                  break;
        case 2:   sType = "Pickpocketing";            break;
        case 3:   sType = "Burglary";                 break;
        case 4:   sType = "Cart Theft";               break;
        case 5:   sType = "Arson";                    break;
        case 6:   sType = "Assault";                  break;

        case 7:   sType = "Barely Legal Pipeherbs";   break;
        case 8:   sType = "Orphan Tongues";           break;
        case 9:   sType = "Books on Demonology";      break;
        case 10:  sType = "Dirty Scrolls";            break;
        case 11:  sType = "Slanderous Pamphlets";     break;
        case 12:  sType = "Explosives";               break;
    }

    return sType;
}

string GetQuestArea( int nArea ){

    string sArea;

    switch ( nArea ) {

        case 1:   sArea = "cordor_central";     break;
        case 2:   sArea = "cordor_east";     break;
        case 3:   sArea = "cordor_south";     break;
        case 4:   sArea = "cordor_west";     break;
        case 5:   sArea = "cordor_south";     break;
        case 6:   sArea = "cordor_noutskirt";     break;

        case 7:   sArea = "cordor_lostsewer";     break;
        case 8:   sArea = "cordor_newsewer";     break;
        case 9:   sArea = "cordor_mainsewer";     break;
        case 10:  sArea = "cordor_oldsewer";     break;
    }

    return sArea;
}

string GetQuestName( int nName ){

    string sName;

    switch ( nName ) {

        case 1:   sName = "the Black Flag";             break;
        case 2:   sName = "the Sharrans";               break;
        case 3:   sName = "the Banites";                break;
        case 4:   sName = "the Bloodmoons";             break;
        case 5:   sName = "certain Traders";            break;
        case 6:   sName = "shady people"; break;
    }

    return sName;
}

