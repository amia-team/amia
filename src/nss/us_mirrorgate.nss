//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  us_mirrorgate
//group:   core
//used as: checks subraces and key status
//date:    nov 12 2007
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "cs_inc_leto"
#include "amia_include"
#include "inc_ds_records"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//checks key status of PC and sets convo checks
void CheckKeyStatus( object oPC );

//gets alternative home location of PC
void CheckNativeHome( object oPC );

//fixes some forgotten journal entries
void FixMissingValues( object oPC, object oKey );

//copies variable from oJournal to oKey if the value in oKey isn't set
void CopyVariable( object oPC, object oJournal, object oKey, string sQuest );


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){


    // Variables.
    object oPC      = GetLastUsedBy( );

    if ( !GetIsPC( oPC ) ) return;

    if( GetPCPublicCDKey( oPC ) == "Q7RREKF3" ) {
        FloatingTextStringOnCreature( "This CD key is only for installation and single player modes. Please email GOG.com for a unique multiplayer CD key, which they give for free with each purchase of this game.", oPC, FALSE );
        return;
    }

    ExecuteScript("subrace_setup", oPC);
    ExecuteScript("subrace_spells",oPC);
    ExecuteScript("monster_check", oPC);


    //key is not available or not checked
    if ( GetIsDM( oPC ) || GetIsDMPossessed( oPC ) ){

        SetPCKEYValue( oPC, "ds_done", 5 );

        object oDest = GetWaypointByTag( "core_travelagency" );

        AssignCommand( oPC, ClearAllActions() );

        DelayCommand( 0.5f, AssignCommand( oPC, JumpToObject( oDest ) ) );

        return;
    }

    string szRace   = GetStringLowerCase( GetSubRace( oPC ) );


    //player key stuff
    object oKey     = GetPCKEY( oPC );
    int nDone       = GetLocalInt( oKey, "ds_done" );

    if ( !GetIsObjectValid( oKey ) || nDone <= 0 ){

        //no key or no set key

        SetLocalString( oPC, "ds_action", "ds_init_pc" );

        CheckKeyStatus( oPC );

        CheckNativeHome( oPC );

        AssignCommand( oPC, ActionStartConversation( oPC, "ds_init_pc", TRUE, FALSE ) );

        return;
    }
    else if ( nDone == 2 && GetName( oKey ) != "Rescue PCKEY" ){

        SendMessageToAllDMs( "Loading quests and mushrooms on rescue key." );

        ImportJournal( oPC, oKey );

        SetPCKEYValue( oPC, "ds_done", 5 );
    }
    else if ( GetName( oKey ) == "Rescue PCKEY" ){

        SendMessageToPC( oPC, "This key needs to be renamed by the DM rebuilding you!" );
        SendMessageToAllDMs( "This key needs to be renamed by the DM rebuilding you!" );
        return;
    }
    //temp fix
    else if ( nDone != 4 && nDone != 5 ){

        FixMissingValues( oPC, oKey );

        ds_create_item( "ds_porting_1", oPC, 1, "ds_porting" );

        SetPCKEYValue( oPC, "ds_done", 5 );
    }
    else if ( nDone == 4 ){

        ds_create_item( "ds_porting_1", oPC, 1, "ds_porting" );

        SetPCKEYValue( oPC, "ds_done", 5 );
    }

    //stamp PC as checked
    SetLocalInt( oPC, "ds_done", 5 );

    //Moved from here to fix platinum race problems
    //SetLocalInt( oPC, "subrace_authorized", GetPCKEYValue( oPC, "subrace_authorized" ) );

    string sStartWP = "core_travelagency";

    if ( sStartWP != "" ){

        object oDest    = GetWaypointByTag( sStartWP );

        AssignCommand( oPC, ClearAllActions() );

        //testing
        //SendMessageToPC( oPC, "<c?  >Test: sStartWP="+sStartWP+"</c>" );
        //SendMessageToPC( oPC, "<c?  >Test: JumpTo="+GetName( GetArea( oDest ) )+"</c>" );

        DelayCommand( 0.2f, AssignCommand( oPC, JumpToObject( oDest ) ) );
    }
    else{

        SendMessageToPC( oPC, "Error: Can't find a valid home or faction to jump you to!" );
    }

    return;
}

void CheckKeyStatus( object oPC ){

    SetLocalInt( oPC, "ds_check_1", 0 );
    SetLocalInt( oPC, "ds_check_2", 0 );
    SetLocalInt( oPC, "ds_check_3", 0 );
    SetLocalInt( oPC, "ds_check_4", 0 );
    SetLocalInt( oPC, "ds_check_11", 0 );
    SetLocalInt( oPC, "ds_check_12", 0 );
    SetLocalInt( oPC, "ds_check_13", 0 );
    SetLocalInt( oPC, "ds_check_14", 0 );
    SetLocalInt( oPC, "ds_check_15", 0 );
    SetLocalInt( oPC, "ds_check_16", 0 );


    //get PC XP (for rebuild/old character check)
    int nXP             = GetXP( oPC );

    //check for key and journal
    object oKey         = GetPCKEY( oPC );
    object oJournal     = GetLocalObject( oPC, "MyJournal" );

    /*
    options:
        2 player has a(n unset) key, a journal, and 4000 XP: old player
        2 player has a(n unset) key, a journal, and not 4000 XP: old player
        3 player has a(n unset) key, no journal, and 4000 XP: error
        3 player has a(n unset) key, no journal, and not 4000 XP: messed up rebuild
        4 player has no key, a journal, and 4000 XP: old player
        4 player has no key, a journal, and not 4000 XP: old player
        1 player has no key, no journal, and 4000 XP: new player
        3 player has no key, no journal, and not 4000 XP: messed up rebuild
    */

    if ( GetIsObjectValid( oKey ) ){

        if ( GetIsObjectValid( oJournal ) ){

            //old player with journal and key
            SetLocalInt( oPC, "ds_check_2", 1 );
        }
        else{

            if ( nXP == 4000 ){

                //error
                SetLocalInt( oPC, "ds_check_3", 1 );
                SendMessageToAllDMs( "Access denied, "+GetName( oPC )+" has a key, no journal, and 4000 XP: messed up rebuild?" );
            }
            else{

                //error
                SetLocalInt( oPC, "ds_check_3", 1 );
                SendMessageToAllDMs( "Access denied, "+GetName( oPC )+" has a key, no journal, and not 4000 XP: messed up rebuild?" );
            }
        }
    }
    else{

        if ( GetIsObjectValid( oJournal ) ){

            //old player with journal but no key
            SetLocalInt( oPC, "ds_check_4", 1 );
        }
        else{

            if ( nXP == 4000 ){

                //new player
                SetLocalInt( oPC, "ds_check_1", 1 );
            }
            else{

                //error
                SetLocalInt( oPC, "ds_check_3", 1 );
                SendMessageToAllDMs( "Access denied, "+GetName( oPC )+" has no key, no journal, and not 4000 XP: messed up rebuild?" );
            }
        }
    }
}

void CheckNativeHome( object oPC ){

    int nRace = GetRacialType(oPC);

    if ( nRace == 0 || nRace == 31){

        // dwarves
        SetLocalInt( oPC, "ds_check_11", 1 );
    }
    else if ( nRace == 1 || nRace == 4 || nRace == 32 || nRace == 34 ||
              nRace == 35 ){

        //(half)elves, fairies
        SetLocalInt( oPC, "ds_check_12", 1 );
    }
    else if ( nRace == 2 || nRace == 3 || nRace == 36 || nRace == 37  ||
              nRace == 40){

        //halflings, gnomes, elfling
        SetLocalInt( oPC, "ds_check_13", 1 );
    }
    else if ( (nRace == 33  && ((GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL) || (GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL))) || nRace == 30 || nRace == 41){

        //drow, duergar, halfdrow, orog (Changed to Cordor: East)
        SetLocalInt( oPC, "ds_check_15", 1 );
    }
    else if ( (nRace == 38) || (nRace == 42) || (nRace == 39) || (nRace == 43) || (nRace == 45) || (nRace == 44)){

        //Greenskin cave
        SetLocalInt( oPC, "ds_check_16", 1 );
    }
    else if ( (nRace == 33) && (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)){

        //Shrine
        SetLocalInt( oPC, "ds_check_17", 1 );
    }/*
    else if ( nRace == 9 ){

        //Quagmire Cave
        SetLocalInt( oPC, "ds_check_18", 1 );
    }
    else {

        //Kampos: rest
        SetLocalInt( oPC, "ds_check_15", 1 );
    }   */
}

void FixMissingValues( object oPC, object oKey ){

    object oJournal     = GetLocalObject( oPC, "MyJournal" );
    object oBrochure    = GetItemPossessedBy( oPC, "tha_brochure" );

    DelayCommand( 0.0, CopyVariable( oPC, oJournal, oKey, "qst_gloura" ) );
    DelayCommand( 0.1, CopyVariable( oPC, oJournal, oKey, "qst_ankhremun" ) );
    DelayCommand( 0.2, CopyVariable( oPC, oJournal, oKey, "cs_panthalo_done" ) );
    DelayCommand( 0.3, CopyVariable( oPC, oJournal, oKey, "drow_starter_quest" ) );
    DelayCommand( 0.4, CopyVariable( oPC, oJournal, oKey, "cs_bgd_booster" ) );
    DelayCommand( 0.5, CopyVariable( oPC, oJournal, oKey, "bc_fortune" ) );
    DelayCommand( 0.6, CopyVariable( oPC, oJournal, oKey, "bc_luis" ) );
    DelayCommand( 0.7, CopyVariable( oPC, oJournal, oKey, "AR_BardQuest1" ) );
    DelayCommand( 0.8, CopyVariable( oPC, oBrochure, oKey, "tha_reputation" ) );
}

void CopyVariable( object oPC, object oJournal, object oKey, string sQuest ){

    int nJournalValue = GetLocalInt( oJournal, sQuest );
    int nKeyValue     = GetPCKEYValue( oPC, sQuest );

    if ( nKeyValue == 0 ){

        if ( nJournalValue == 0 ){

            SetPCKEYValue( oPC, sQuest, -1 );
        }
        else{

            SetPCKEYValue( oPC, sQuest, nJournalValue );
        }
    }
}

int TranslateHome( int nHome ){

    switch ( nHome ) {

        case 0:     return  0;    break;
        case 1:     return  5;    break;
        case 2:     return 42;    break;
        case 3:     return  6;    break;
        case 4:     return 39;    break;
        case 5:     return 20;    break;
        case 6:     return 09;    break;
        case 7:     return 22;    break;
        case 8:     return 21;    break;
        default:    return  0;    break;
    }

    return 0;
}
