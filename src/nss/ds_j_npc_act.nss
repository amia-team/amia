//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_j_npc_act
//group:   Jobs & crafting
//used as: convo action script
//date:    december 2008
//author:  disco

//-----------------------------------------------------------------------------
// changelog
//-----------------------------------------------------------------------------
// 11 Feb 2011 - Selmak added int ds_j_GetTraderSlotsOccupied
//             - Selmak changed node 40 to only allow the job log eater to eat
//               if trade chests are empty.
// 03 Mar 2011 - Selmak moved int ds_j_GetTraderSlotsOccupied to inc_ds_j_lib
//             - Selmak pointed node 40 to ds_j_ClearJobLog in inc_ds_j_lib
//               (common clear routine for both DM using journal and penguin)



//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_j_lib"
#include "inc_ds_actions"



//this harvests materials from animals
void ds_j_CollectFromTarget( object oPC, object oTarget, int nJobUsed, int nKill=0, int nUseResRef=0 );
void ds_j_SetTarget( object oPC, object oNPC, int nJob );

//this harvests materials from animals
void ds_j_CollectFromTarget( object oPC, object oTarget, int nJobUsed, int nKill=0, int nUseResRef=0  ){

    object oOwner = GetLocalObject( oTarget, DS_J_USER );
    string sTag   = GetTag( oTarget );
    string sQuery;
    string sSuffix;
    int i;
    int nJob;
    int nResource;
    int nAltResource;
    int nUses;

    if ( nUseResRef ){

        sTag = GetResRef( oTarget );
    }

    if ( oPC != oOwner && !nKill ){

        SendMessageToPC( oPC, CLR_ORANGE+"You can only harvest things from your own animal (except meat)." );
        return;
    }

    if ( GetLocalInt( oTarget, DS_J_DONE ) != 1 ){

        //Creates only one resource, look for resource and tag
        sQuery = "SELECT id,resref,icon,availability,alt_id,job_id FROM ds_j_resources WHERE source = '"+sTag+"'";

        SQLExecDirect( sQuery );

        while ( SQLFetch( ) == SQL_SUCCESS ){

                nResource       = StringToInt( SQLGetData( 1 ) );
                nAltResource    = StringToInt( SQLGetData( 5 ) );

                if ( nAltResource > 0 ){

                    nResource = nAltResource;
                }

                nJob  = StringToInt( SQLGetData( 6 ) );

                sSuffix = "_" + IntToString( nJob );

                SetLocalInt( oTarget, DS_J_ID+sSuffix, nResource );
                SetLocalString( oTarget, DS_J_RESREF+sSuffix, SQLGetData( 2 ) );
                SetLocalInt( oTarget, DS_J_ICON+sSuffix, StringToInt( SQLGetData( 3 ) ) );
                SetLocalInt( oTarget, DS_J_QUANTITY+sSuffix, StringToInt( SQLGetData( 4 ) ) );
        }

        SetLocalInt( oTarget, DS_J_DONE, 1 );
    }

    //check if the animal got the time to grow the commodity
    int nTime  = GetServerRunTime() - GetLocalInt( oTarget, DS_J_TIME );

    if ( nKill && nTime > DS_J_SOURCEDELAY ){

        nTime = GetServerRunTime() - GetLocalInt( oPC, DS_J_JOB+IntToString( nJobUsed ) );
    }

    if ( nTime > DS_J_SOURCEDELAY ){

        sSuffix = "_" + IntToString( nJobUsed );

        string sProduct = GetLocalString( oTarget, DS_J_RESREF+sSuffix );
        string sMessage;

        if ( sProduct != "" ){

            nUses = GetLocalInt( oTarget, DS_J_QUANTITY+sSuffix ) - 1;

            if ( nUses > 0 ){

                SetLocalInt( oTarget, DS_J_QUANTITY+sSuffix, nUses );


                //check if the procedure is succesful and deal with XP
                int nResult     = ds_j_StandardRoll( oPC, nJobUsed );
                int nRank       = ds_j_GiveStandardXP( oPC, nJobUsed, nResult, 0.5 );

                if ( nResult < 1 ){

                    sMessage = DS_J_FAILURE;
                    //if failure occurs, give an incremented chance of success
                    //next time, but only if animal doesn't die on failure
                    if ( nResult == 0 &&
                            nRank > 0 &&
                               !nKill ){

                        int nFailBonus   = GetLocalInt( oPC, DS_J_FAILBONUS );
                        int nLastJob     = GetLocalInt( oPC, DS_J_LASTJOB );
                        //Only increment bonus when doing the same job again
                        if ( nLastJob == nJobUsed ) nFailBonus += 4+nRank;
                        else                        nFailBonus  = 4+nRank;

                        SetLocalInt( oPC, DS_J_FAILBONUS, nFailBonus );

                    }

                }
                else {

                    SetLocalInt( oPC, DS_J_FAILBONUS, 0 );
                    int nResource   = GetLocalInt( oTarget, DS_J_ID+sSuffix );
                    int nIcon       = GetLocalInt( oTarget, DS_J_ICON+sSuffix );

                    ds_j_CreateItemOnPC( oPC, sProduct, nResource, "", "", nIcon );

                    //hack to make pigs deliver Hide as well
                    if ( nResource == 34 ){

                        ds_j_CreateItemOnPC( oPC, sProduct, 75, "", "", 3 );
                    }

                    sMessage = "Your animal produces some goods.";
                }
            }
            else{

                nKill = 2;

                sMessage = "Your animal drops dead from exhaustion.";
            }


            //feedback
            SendMessageToPC( oPC, CLR_ORANGE+sMessage );

            if ( nKill ){

                int nAnimals = GetLocalInt( oOwner, sTag );

                //remove spawn block on oUser
                SetLocalInt( oOwner, sTag, ( nAnimals - 1 ) );

                if ( nKill == 1 ){

                    effect eGore = EffectVisualEffect( VFX_COM_CHUNK_RED_LARGE );

                    ApplyEffectToObject ( DURATION_TYPE_INSTANT, eGore, oTarget );
                }

                DestroyObject( oTarget, 0.5 );

                //set new time
                SetLocalInt( oPC, DS_J_JOB+IntToString( nJobUsed ), GetServerRunTime() );
            }
            else{

                //set new time
                SetLocalInt( oTarget, DS_J_TIME, GetServerRunTime() );

                //report uses left
                SendMessageToPC( oPC, CLR_ORANGE+IntToString( nUses )+" items left." );
            }
        }
    }
    else{

        SendMessageToPC( oPC, CLR_ORANGE+"You need to wait "+IntToString( DS_J_SOURCEDELAY - nTime )+" seconds before you can collect anything from this animal."+CLR_END );
    }
}

void ds_j_SetTarget( object oPC, object oNPC, int nJob ){

    string sMessage;
    int nDie;

    if ( nJob == 51 || nJob == 52 ){

        if ( GetLocalString( oPC, DS_J_AREA ) != "" ){

            SendMessageToPC( oPC, CLR_ORANGE + "You can only have one investigation task at a time." + CLR_END );
            return;
        }

        string sRegion;
        nDie = d10();

        if ( GetLocalInt( GetModule(), "Module" ) == 1 ){

            switch ( nDie ) {

                case 1:  sRegion = "Cape Slakh"; break;
                case 2:  sRegion = "Forest of Despair"; break;
                case 3:  sRegion = "Gulf of Lumorier"; break;
                case 4:  sRegion = "Mylock Hills"; break;
                case 5:  sRegion = "Nexus Hills"; break;
                case 6:  sRegion = "Lowland Swamps"; break;
                case 7:  sRegion = "Quagmire"; break;
                case 8:  sRegion = "Skull Crags"; break;
                case 9:  sRegion = "Amia Frontier"; break;
                case 10: sRegion = "Amia Forest"; break;
            }

        }
        else{

            switch ( nDie ) {

                case 1:  sRegion = "Frozenfar"; break;
                case 2:  sRegion = "Caraigh"; break;
                case 3:  sRegion = "Forrstakkr"; break;
                case 4:  sRegion = "Brogendenstein"; break;
                case 5:  sRegion = "Khem"; break;
                case 6:  sRegion = "Alambar Sea"; break;
                case 7:  sRegion = "Frozen Wastes"; break;
                case 8:  sRegion = "The 363rd Abyssal Layer"; break;
                case 9:  sRegion = "Forrstakkr"; break;
                case 10: sRegion = "Frozenfar"; break;
            }
        }

        sMessage = CLR_ORANGE+"I want you to search "+sRegion+" and see if you can find anything interesting there.";
        AssignCommand( oNPC, SpeakString( sMessage, TALKVOLUME_WHISPER ) );

        SetLocalInt( oPC, DS_J_NPC, nJob );
        SetLocalString( oPC, DS_J_AREA, sRegion );

        return;
    }

    if ( GetLocalString( oPC, DS_J_NPC ) != "" && nJob != 50 ){

        SendMessageToPC( oPC, CLR_ORANGE + "You can only spawn one target NPC at a time." + CLR_END );
        return;
    }

    object oArea = ds_j_GetSpawnArea( oPC );

    if ( GetIsObjectValid( oArea ) ){

        string sArea   = GetName( oArea );
        string sName;
        int i;

        if ( nJob == 35 || nJob == 36 || nJob == 37 || nJob == 40 || nJob == 42 || nJob == 44 ){

            sMessage = CLR_ORANGE+"I want you to search "+sArea+" for a monster called ";
            sName    = RandomName( NAME_FIRST_HALFORC_MALE );
        }
        else if ( nJob == 50 ){

            sMessage = CLR_ORANGE+"I want you to search "+sArea;
        }
        else{

            sMessage = CLR_ORANGE+"I want you to search "+sArea+" for a man called ";
            sName    = RandomName( NAME_FIRST_HUMAN_MALE ) + " " + RandomName( NAME_LAST_HUMAN );
        }

        sMessage = sMessage + sName;

        if ( nJob == 30 ){ sMessage = sMessage + " and chase the demons out of him."; }
        if ( nJob == 31 ){ sMessage = sMessage + " and see what you can find out about him."; }
        if ( nJob == 32 ){ sMessage = sMessage + ". He is carrying some important letters. Make sure you obtain them."; }
        if ( nJob == 33 ){ sMessage = sMessage + ". He's a notorious heretic. Send him to the Nine Hells!"; }
        if ( nJob == 34 ){ sMessage = sMessage + ". His wife wants this letter to be delivered to him. *hands you a letter*"; }
        if ( nJob == 35 ){ sMessage = sMessage + ". It has been terrorising the local populace for to long."; }
        if ( nJob == 36 ){ sMessage = sMessage + ". Put an arrow in the head of this menace."; }
        if ( nJob == 37 ){ sMessage = sMessage + ". You'll get a good fee for ridding the countryside of this menace."; }
        if ( nJob == 38 ){ sMessage = sMessage + ". He's a rich merchant. Kill him and take his gold."; }
        if ( nJob == 39 ){ sMessage = sMessage + ". He's been seen near the "+RandomName( NAME_LAST_HUMAN )+" massacre. I am sure he did it. Kill him!"; }
        if ( nJob == 40 ){ sMessage = sMessage + ". It is your duty to slay this abomination!"; }
        if ( nJob == 41 ){ sMessage = sMessage + " and kill him."; }
        if ( nJob == 42 ){ sMessage = sMessage + " and make sure it's plain dead as soon as possible. "; }
        if ( nJob == 43 ){ sMessage = sMessage + " and see if you can negotiate this proposal. *hands you a letter*"; }
        if ( nJob == 44 ){ sMessage = sMessage + ". It's been terrorizing the tunnels for days now. Chop-chop-chop!"; }
        if ( nJob == 44 ){ sMessage = sMessage + ". The despicable rothe escaped to the Surface! Dispense punishment on my behalf."; }
        if ( nJob == 50 ){

            nDie = d8();

            switch ( nDie ) {

                case 1:     sName = "a Wyvern"; break;    //wyvernhide
                case 2:     sName = "an Iron Golem"; break; //bone
                case 3:     sName = "a Basilisk"; break;
                case 4:     sName = "an Angered Satyr"; break;
                case 5:     sName = "an Umber Hulk"; break;
                case 6:     sName = "an Ettercap"; break;
                case 7:     sName = "a Fire Beetle"; break;
                case 8:     sName = "a Gargoyle"; break;
            }

            sMessage = sMessage + " for "+sName+". Let's get another trophy on these walls!";

            SetLocalInt( oPC, DS_J_CRITTER, nDie );
        }

        SetLocalString( oPC, DS_J_NPC, sName );

        AssignCommand( oNPC, SpeakString( sMessage, TALKVOLUME_WHISPER ) );

        SetLocalInt( oPC, DS_J_NPC, nJob );
        SetLocalString( oPC, DS_J_AREA, GetResRef( oArea ) );

        log_to_exploits( oPC, "ds_j: create NPC", GetResRef( oArea ), nJob );

    }
    else{

        SendMessageToPC( oPC, CLR_RED+"Sorry, I can't find a valid area for your CR. Try the other server?"+CLR_END );
    }
}

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC       = OBJECT_SELF;
    object oNPC      = GetLocalObject( oPC, "ds_target" );
    int nNode        = GetLocalInt( oPC, "ds_node" );
    int i;
    string sTag      = GetTag( oNPC );

    if ( nNode == 1 ){

        ds_j_TrainPC( oPC, oNPC );
    }
    else if ( nNode == 2 ){

        ds_j_BuyInventory( oPC, OBJECT_INVALID, oNPC );
    }
    else if ( nNode == 3 ){

        ds_j_BuyInventory( oPC, OBJECT_INVALID, oNPC, 1 );
    }
    else if ( nNode == 4 ){

        //milk cow
        ds_j_CollectFromTarget( oPC, oNPC, 20, 0, 1 );
    }
    else if ( nNode == 5 ){

        //collect chicken eggs
        ds_j_CollectFromTarget( oPC, oNPC, 22, 0, 1 );
    }
    else if ( nNode == 6 ){

        //shear sheep
        ds_j_CollectFromTarget( oPC, oNPC, 14, 0, 1 );
    }
    else if ( nNode == 7 ){

        //butcher animal
        ds_j_CollectFromTarget( oPC, oNPC, 18, 1, 1 );
    }
    else if ( nNode == 8 ){

        //remove animal
        SafeDestroyObject( oNPC );
        SetLocalInt( oPC, sTag, ( GetLocalInt( oPC, sTag ) - 1 ) );
    }
    else if ( nNode >= 9 && nNode <= 32 ){

        //Exorcist, Spy, Thief, Witchhunter, Courier
        //Men-at-arms, Archer, Mercenary, Outlaw, Vigilante
        //Templar, Hired Killer, Undead Hunter, Tunnel Fighter, Slaver, 5x reserved,
        //Big Game Hunter, Prospector, Archeologist
        ds_j_SetTarget( oPC, oNPC, ( nNode + 21 ) );
    }
    else if ( nNode == 33 ){

        //shear rothe
        ds_j_CollectFromTarget( oPC, oNPC, 98, 0, 1 );
    }
    else if ( nNode == 34 ){

        //let the animal follow you
        AssignCommand( oNPC, ActionForceFollowObject( oPC, 3.0 ) );
    }
    else if ( nNode == 35 ){

        //milk spider
        ds_j_CollectFromTarget( oPC, oNPC, 89, 0, 1 );
    }
    else if ( nNode == 36 ){

        //servant

    }
    else if ( nNode == 37 ){

        //cleanup
        clean_vars( oPC, 4 );

        //seller
        SetLocalString( oPC, "ds_action", "ds_j_seller_act" );
        SetLocalObject( oPC, "ds_target", oNPC );

        //check amount of items
        int nCount = GetLocalInt( oNPC, DS_J_DONE );

        if ( nCount > 0 ){

            SetLocalInt( oPC, "ds_check_31", 1 );
        }

        if ( nCount > 30 ){

            SetLocalInt( oPC, "ds_check_32", 1 );
        }

        ActionStartConversation( oPC, "ds_j_seller", TRUE, FALSE );
    }
    else if ( nNode == 40 ){

        // We check first to see if the PC has stuff in their trade chests.
        if ( ds_j_GetTraderSlotsOccupied( oPC ) ){

            AssignCommand( oNPC, SpeakString( CLR_ORANGE+"Trader chests not empty!  Job Log can't be eaten!"+CLR_END ) );
            return;

        }
        // If nothing's there, then we can wipe their job log clean.

        ds_j_ClearJobLog( oPC );

        //This prevents more than one job log wipe per reset
        SetLocalInt( oPC, "ds_j_reset", 1 );

        AssignCommand( oNPC, SpeakString( CLR_ORANGE+"*The horrid little monster eats your Job Log!*"+CLR_END ) );
    }

}
