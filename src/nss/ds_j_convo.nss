//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_j_convo
//group:   Jobs & crafting
//used as: OnConversation event of an NPC
//date:    december 2008
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"
#include "inc_ds_j_lib"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oNPC    = OBJECT_SELF;
    object oPC     = GetLastSpeaker();
    string sTag    = GetTag( oNPC );
    string sResRef = GetResRef( oNPC );
    string sConvo  = DS_J_NPC;
    string sAction = "ds_j_npc_act";
    int nNPCjob    = GetLocalInt( oNPC, DS_J_JOB );

    //if ( GetStringLeft( GetResRef( GetArea( oPC ) ), 5 ) != "ds_j_" ){

        //SendMessageToPC( oPC, "Sorry, the job system isn't ready yet." );
        //return;
    //}

    clean_vars( oPC, 4 );

    if ( sTag == DS_J_NPC || sTag == DS_J_UNDEAD || sTag == DS_J_CRITTER ){

        return;
    }
    else if ( sTag == "ds_j_trainer" ){

        SetLocalInt( oPC, "ds_check_1", 1 );
    }
    else if ( sTag == "ds_j_merchant" ){

        if ( GetLocalInt( oNPC, DS_J_JOB ) > 0 ){

            SetLocalInt( oPC, "ds_check_2", 1 );

            if ( GetLocalInt( oNPC, DS_J_SELLER ) > 0 ){

                SetLocalInt( oPC, "ds_check_37", 1 );
            }
        }
        else{

            SetLocalInt( oPC, "ds_check_32", 1 );
        }
    }
    else if ( sResRef == "ds_j_cow" ){

        ClearAllActions();

        if ( ds_j_GetJobRank( oPC, 18 ) > 0 ){

            //butcher
            SetLocalInt( oPC, "ds_check_7", 1 );
            SetLocalInt( oPC, "ds_check_3", 1 );
        }

        if ( ds_j_GetJobRank( oPC, 20 ) > 0 ){

            //dairy farmer
            SetLocalInt( oPC, "ds_check_4", 1 );
            SetLocalInt( oPC, "ds_check_34", 1 );
            SetLocalInt( oPC, "ds_check_3", 1 );
        }
    }
    else if ( sResRef == "ds_j_pig" ){

        ClearAllActions();

        if ( ds_j_GetJobRank( oPC, 18 ) > 0 ){

            //butcher
            SetLocalInt( oPC, "ds_check_7", 1 );
            SetLocalInt( oPC, "ds_check_3", 1 );
        }

        if ( ds_j_GetJobRank( oPC, 21 ) > 0 ){

            //pig farmer
            SetLocalInt( oPC, "ds_check_34", 1 );
            SetLocalInt( oPC, "ds_check_3", 1 );
        }
    }
    else if ( sResRef == "ds_j_chicken" ){

        ClearAllActions();

        if ( ds_j_GetJobRank( oPC, 18 ) > 0 ){

            //butcher
            SetLocalInt( oPC, "ds_check_7", 1 );
            SetLocalInt( oPC, "ds_check_3", 1 );
        }

        if ( ds_j_GetJobRank( oPC, 22 ) > 0 ){

            //poultry farmer
            SetLocalInt( oPC, "ds_check_5", 1 );
            SetLocalInt( oPC, "ds_check_34", 1 );
            SetLocalInt( oPC, "ds_check_3", 1 );
        }
    }
    else if ( sResRef == "ds_j_muskox" ){

        ClearAllActions();

        if ( ds_j_GetJobRank( oPC, 18 ) > 0 ){

            //butcher
            SetLocalInt( oPC, "ds_check_7", 1 );
            SetLocalInt( oPC, "ds_check_3", 1 );
        }

        if ( ds_j_GetJobRank( oPC, 14 ) > 0 ){

            //shepherd
            SetLocalInt( oPC, "ds_check_6", 1 );
            SetLocalInt( oPC, "ds_check_34", 1 );
            SetLocalInt( oPC, "ds_check_3", 1 );
        }
    }
    else if ( sResRef == "ds_j_rothe" ){

        ClearAllActions();

        if ( ds_j_GetJobRank( oPC, 18 ) > 0 ){

            //butcher
            SetLocalInt( oPC, "ds_check_7", 1 );
            SetLocalInt( oPC, "ds_check_3", 1 );
        }

        if ( ds_j_GetJobRank( oPC, 98 ) > 0 ){

            //rothe shepherd
            SetLocalInt( oPC, "ds_check_33", 1 );
            SetLocalInt( oPC, "ds_check_34", 1 );
            SetLocalInt( oPC, "ds_check_3", 1 );
        }
    }
    else if ( sResRef == "ds_j_spider" ){

        ClearAllActions();

        if ( ds_j_GetJobRank( oPC, 89 ) > 0 ){

            //spider shepherd
            SetLocalInt( oPC, "ds_check_35", 1 );
            SetLocalInt( oPC, "ds_check_34", 1 );
            SetLocalInt( oPC, "ds_check_3", 1 );
        }
    }
    else if ( sResRef == "ds_j_servant" ){

        ClearAllActions();

        if ( GetLocalObject( oNPC, DS_J_USER ) == oPC ){

            //my servant
            SetLocalInt( oPC, "ds_check_36", 1 );
        }
    }
    else if ( nNPCjob >= 30 && nNPCjob <= 52 ){

        //Exorcist, Spy, Thief, Witchhunter, Courier
        //Men-at-arms, Archer, Mercenary, Outlaw, Vigilante
        //Templar, Hired Killer, Undead Hunter, Diplomat, Tunnel Fighter, 5x reserved,
        //Big Game Hunter, Prospector, Archeologist
        SetLocalInt( oPC, "ds_check_8", 1 );

        if ( ds_j_GetJobRank( oPC, nNPCjob ) > 0 &&
             GetLocalString( oPC, DS_J_NPC ) == "" ){

            SetLocalInt( oPC, "ds_check_" + IntToString( nNPCjob - 21 ), 1 );
        }
    }
    else if ( sTag == "ds_j_reset" && !GetLocalInt( oPC, "ds_j_reset" ) ){

        //the eraser penguin
        SetLocalInt( oPC, "ds_check_40", 1 );
    }
    else{

        return;
    }

    SetLocalString( oPC, "ds_action", sAction );
    SetLocalObject( oPC, "ds_target", oNPC );

    ActionStartConversation( oPC, sConvo, TRUE, FALSE );
}


