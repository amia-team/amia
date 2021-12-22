//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: _ini
//group:
//used as:
//date:
//author: disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"
#include "inc_ds_j_lib"
#include "inc_ds_actions"
#include "x2_inc_switches"

//checks if oPC has the right job to open a door, and
//also checks if it's the right type of area
int ds_j_DoorCheck( object oPC, object oDoor, int nJob ){

    //only works on permalock doors
    if ( GetLockKeyRequired( oDoor ) && GetLockKeyTag( oDoor ) == "" ){

        if ( ds_j_GetJobRank( oPC, nJob ) == 0 ){

            return FALSE;
        }

        //only works in certain areas
        string sAreaType = GetTilesetResRef( GetArea( oPC ) );

        if ( sAreaType != TILESET_RESREF_CITY_EXTERIOR &&
             sAreaType != TILESET_RESREF_RURAL &&
             sAreaType != TILESET_RESREF_RURAL_WINTER &&
             sAreaType != TILESET_RESREF_DESERT ){

            SendMessageToPC( oPC, CLR_ORANGE+"You can't use that job in this area!" );
            return FALSE;
        }

        if ( nJob == 67 ){       //burglar

            if ( GetIsDay() ){

                SendMessageToPC( oPC, CLR_ORANGE+"You can only use this job during night time" );
                return FALSE;
            }

            return TRUE;
        }

        if ( nJob == 68 ){       //undertaker

            if ( !GetIsDay() ){

                SendMessageToPC( oPC, CLR_ORANGE+"You can only use this job during day time" );
                return FALSE;
            }

            return TRUE;
        }
    }

    return FALSE;
}


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------


void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;



    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oTarget   = GetItemActivatedTarget();
            location lTarget = GetItemActivatedTargetLocation();
            int nOption      = 0;
            string sKey      = GetPCPublicCDKey( oPC, TRUE );
            int nTest        = 0;

            if ( GetStringLeft( GetResRef( GetArea( oPC ) ), 5 ) == "ds_j_" ){

                nTest = 1;
            }

            clean_vars( oPC, 4 );

            SetLocalString( oPC, "ds_action", "ds_j_journal_act" );
            SetLocalObject( oPC, "ds_target", oTarget );
            SetLocalLocation( oPC, "ds_target", lTarget );

            //I have put most checks within a few mutually exclusive conditions
            //to cut down on unnecessary cycles
            if ( oPC == oTarget ){

                SetLocalInt( oPC, "ds_check_39", 1 );
                nOption = 1;
            }
            else if ( GetLocalString( oTarget, DS_J_USER ) == sKey ){

               if ( GetLocalInt( oTarget, DS_J_JOB ) == 30 ) {

                    //exorcist
                    SetLocalInt( oPC, "ds_check_9", 1 );
                    nOption = 1;
               }

               if ( GetLocalInt( oTarget, DS_J_JOB ) == 31 ) {

                    //spy
                    SetLocalInt( oPC, "ds_check_10", 1 );
                    nOption = 1;
               }

               if ( GetLocalInt( oTarget, DS_J_JOB ) == 32 ) {

                    //thief
                    SetLocalInt( oPC, "ds_check_11", 1 );
                    nOption = 1;
               }

               if ( GetLocalInt( oTarget, DS_J_JOB ) == 33 ) {

                    //witchhunter
                    SetLocalInt( oPC, "ds_check_12", 1 );
                    nOption = 1;
               }

               if ( GetLocalInt( oTarget, DS_J_JOB ) == 34 ) {

                    //messenger
                    SetLocalInt( oPC, "ds_check_13", 1 );
                    nOption = 1;
                }

                if ( ds_j_GetJobRank( oPC, 43) > 0 ) {

                    //diplomat
                    SetLocalInt( oPC, "ds_check_21", 1 );
                    nOption = 1;
                }
            }
            else if ( GetObjectType( oTarget ) == OBJECT_TYPE_PLACEABLE ){

                //observe
                SetLocalInt( oPC, "ds_check_31", 1 );
                nOption = 1;
            }
            else if ( GetObjectType( oTarget ) == OBJECT_TYPE_DOOR ){

                if ( ds_j_DoorCheck( oPC, oTarget, 67 ) ){
                    string sBlock = DS_J_BUSY + "_" + IntToString( 67 );
                    int nCaught   = GetIsBlocked( oPC, sBlock);
                    //burglar
                    if(nCaught < 1)
                    {
                        SetLocalInt( oPC, "ds_check_17", 1 );
                    }
                    else
                    {
                        SendMessageToPC( oPC, CLR_ORANGE+"You need to lay low for "+IntToString( nCaught )+" more seconds!" );
                    }

                    nOption = 1;
                }

                if ( ds_j_DoorCheck( oPC, oTarget, 68 ) ){

                    //gravedigger
                    SetLocalInt( oPC, "ds_check_18", 1 );
                    nOption = 1;
                }
            }
            else if ( GetIsPC( oTarget ) ){

                //this part needs a check on PCs
                if ( ds_j_GetJobRank( oPC, 23 ) > 0 ) {

                    //ability boosters
                    SetLocalInt( oPC, "ds_check_23", 1 );
                    nOption = 1;
                }
                else if ( ds_j_GetJobRank( oPC, 24 ) > 0 ) {

                    //ability boosters
                    SetLocalInt( oPC, "ds_check_24", 1 );
                    nOption = 1;
                }
                else if ( ds_j_GetJobRank( oPC, 25 ) > 0 ) {

                    //ability boosters
                    SetLocalInt( oPC, "ds_check_25", 1 );
                    nOption = 1;
                }
                else if ( ds_j_GetJobRank( oPC, 26 ) > 0 ) {

                    //ability boosters
                    SetLocalInt( oPC, "ds_check_26", 1 );
                    nOption = 1;
                }
                else if ( ds_j_GetJobRank( oPC, 27 ) > 0 ) {

                    //ability boosters
                    SetLocalInt( oPC, "ds_check_27", 1 );
                    nOption = 1;
                }
                else if ( ds_j_GetJobRank( oPC, 28 ) > 0 ) {

                    //ability boosters
                    SetLocalInt( oPC, "ds_check_28", 1 );
                    nOption = 1;
                }

                if ( ds_j_GetJobRank( oPC, 72 ) > 0 ) {

                    //painter
                    SetLocalInt( oPC, "ds_check_22", 1 );
                    nOption = 1;
                }

                if ( GetIsDM( oPC ) > 0 ) {

                    //DM, reset jobs
                    SetLocalInt( oPC, "ds_check_40", 1 );
                    nOption = 1;
                }

                //observe
                SetLocalInt( oPC, "ds_check_31", 1 );
                nOption = 1;
            }
            else if ( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE ){

                if ( ds_j_GetJobRank( oPC, 72 ) > 0 ) {

                    //painter
                    SetLocalInt( oPC, "ds_check_22", 1 );
                    nOption = 1;
                }

                //observe
                SetLocalInt( oPC, "ds_check_31", 1 );
                nOption = 1;
            }
            else if ( !GetIsObjectValid( oTarget ) ){

                if ( ds_j_GetJobRank( oPC, 5 ) > 0 ) {

                    //hunter
                    SetLocalInt( oPC, "ds_check_2", 1 );
                    nOption = 1;
                }

                if ( ds_j_GetJobRank( oPC, 8 ) > 0 ) {

                    //market gardener
                    SetLocalInt( oPC, "ds_check_3", 1 );
                    nOption = 1;
                }

                if ( ds_j_GetJobRank( oPC, 20 ) > 0 ) {

                    //dairy farmer
                    SetLocalInt( oPC, "ds_check_4", 1 );
                    nOption = 1;
                }

                if ( ds_j_GetJobRank( oPC, 21 ) > 0 ) {

                    //Pig Farmer
                    SetLocalInt( oPC, "ds_check_5", 1 );
                    nOption = 1;
                }

                if ( ds_j_GetJobRank( oPC, 14 ) > 0 ) {

                    //Shepherd
                    SetLocalInt( oPC, "ds_check_6", 1 );
                    nOption = 1;
                }

                if ( ds_j_GetJobRank( oPC, 22 ) > 0  ){

                    //Poultry Farmer
                    SetLocalInt( oPC, "ds_check_7", 1 );
                    nOption = 1;
                }

                if ( ds_j_GetJobRank( oPC, 29 ) > 0 ) {

                    //priest
                    SetLocalInt( oPC, "ds_check_8", 1 );
                    nOption = 1;
                }

                if ( ds_j_GetJobRank( oPC, 51 ) > 0 ) {

                    if ( GetLocalString( oPC, DS_J_AREA ) != "" && GetLocalInt( oPC, DS_J_NPC ) == 51 ) {

                        //prospector
                        SetLocalInt( oPC, "ds_check_14", 1 );
                        nOption = 1;
                    }
                }

                if ( ds_j_GetJobRank( oPC, 52 ) > 0 ) {

                    if ( GetLocalString( oPC, DS_J_AREA ) != "" && GetLocalInt( oPC, DS_J_NPC ) == 52 ) {

                        //archeologist
                        SetLocalInt( oPC, "ds_check_15", 1 );
                        nOption = 1;
                    }
                }

                if ( ds_j_GetJobRank( oPC, 60 ) > 0 ||
                     ds_j_GetJobRank( oPC, 61 ) > 0 ||
                     ds_j_GetJobRank( oPC, 62 ) > 0 ||
                     ds_j_GetJobRank( oPC, 63 ) > 0 ||
                     ds_j_GetJobRank( oPC, 64 ) > 0 ||
                     ds_j_GetJobRank( oPC, 65 ) > 0 ||
                     ds_j_GetJobRank( oPC, 66 ) > 0 ||
                     ds_j_GetJobRank( oPC, 99 ) > 0 ||
                     ds_j_GetJobRank( oPC, 100 ) > 0  ){

                    //trader
                    SetLocalInt( oPC, "ds_check_16", 1 );
                    nOption = 1;
                }

                if ( ds_j_GetJobRank( oPC, 92 ) > 0 ) {

                    //beggar
                    SetLocalInt( oPC, "ds_check_20", 1 );
                    nOption = 1;
                }

                if ( ds_j_GetJobRank( oPC, 94 ) > 0 ) {

                    //mushroom farmer
                    SetLocalInt( oPC, "ds_check_29", 1 );
                    nOption = 1;
                }

                if ( ds_j_GetJobRank( oPC, 98 ) > 0 ) {

                    //rothe herder
                    SetLocalInt( oPC, "ds_check_30", 1 );
                    nOption = 1;
                }

                if ( ds_j_GetJobRank( oPC, 13 ) > 0 ) {

                    //performer
                    SetLocalInt( oPC, "ds_check_32", 1 );
                    nOption = 1;
                }

                if ( ds_j_GetJobRank( oPC, 90 ) > 0 ) {

                    //gambler
                    SetLocalInt( oPC, "ds_check_33", 1 );
                    nOption = 1;
                }

                if ( ds_j_GetJobRank( oPC, 89 ) > 0  ){

                    //Spider Keeper
                    SetLocalInt( oPC, "ds_check_34", 1 );
                    nOption = 1;
                }

                if ( ds_j_GetJobRank( oPC, 101 ) > 0 ) {

                    //explorer
                    SetLocalInt( oPC, "ds_check_35", 1 );
                    nOption = 1;
                }
            }


            //the ones below are rather specific
            if ( GetLocalString( GetArea( oPC ), "ds_announcer" ) != "" ){

                if ( ds_j_GetJobRank( oPC, 91 ) > 0 ) {

                    //towncrier
                    SetLocalInt( oPC, "ds_check_19", 1 );
                    nOption = 1;
                }
            }

            if ( nOption > 0 ){

                SetLocalInt( oPC, "ds_check_1", 1 );
            }

            AssignCommand( oPC, ActionStartConversation( oPC, "ds_j_journal", TRUE, FALSE ) );

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------





