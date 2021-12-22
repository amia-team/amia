//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: khm_ds_travel_ac
//group: travel
//used as: convo action script
//date: 2008-09-13
//author: disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "amia_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC          = OBJECT_SELF;
    object oNPC         = GetLocalObject( oPC, "ds_target" );
    string sGoal        = GetLocalString( oNPC, "ds_goal" );
    string sWP          = GetLocalString( oNPC, "ds_wp" );
    string sAmbush      = GetLocalString( oNPC, "ds_ambush" );
    int nPrice          = GetLocalInt( oNPC, "ds_price" );
    int nDC             = GetLocalInt( oNPC, "ds_dc" );
    int nNode           = GetLocalInt( oPC, "ds_node" );

    DeleteLocalInt( oPC, "ds_check_1" );
    DeleteLocalInt( oPC, "ds_check_2" );

    if ( nNode == 1 ){

        if ( GetIsSkillSuccessful( oPC, SKILL_BLUFF, nDC ) ){

            SetLocalInt( oPC, "ds_check_1", 1 );
        }
        else {

            SetLocalInt( oPC, "ds_check_2", 1 );
            SetCustomToken( 4903, IntToString( nPrice ) );
        }

        SetLocalInt( oNPC, GetPCPublicCDKey( oPC, TRUE ), 1 );
    }
    else if ( nNode == 2 ){

        if ( GetIsSkillSuccessful( oPC, SKILL_INTIMIDATE, nDC ) ){

            SetLocalInt( oPC, "ds_check_1", 1 );
        }
        else {

            SetLocalInt( oPC, "ds_check_2", 1 );
            SetCustomToken( 4903, IntToString( nPrice ) );
        }

        SetLocalInt( oNPC, GetPCPublicCDKey( oPC, TRUE ), 1 );
    }
    else if ( nNode == 3 ){

        if ( GetIsSkillSuccessful( oPC, SKILL_PERSUADE, nDC ) ){

            SetLocalInt( oPC, "ds_check_1", 1 );
        }
        else {

            SetLocalInt( oPC, "ds_check_2", 1 );
            SetCustomToken( 4903, IntToString( nPrice ) );
        }

        SetLocalInt( oNPC, GetPCPublicCDKey( oPC, TRUE ), 1 );
    }
    else if ( nNode == 4 ){

        if ( nPrice <= GetGold( ) ){

            TakeGoldFromCreature( nPrice, oPC, TRUE );

            if ( d10() == 5 && sAmbush != "" ){


                ds_transport_party( oPC, sAmbush );
            }
            else{

                ds_transport_party( oPC, sWP );
            }
         }
        else {

            SendMessageToPC( oPC, "You don't have enough gold to do this." );
        }
    }
    else if ( nNode == 5 ){

        if ( d10() == 5 && sAmbush != "" ){


            ds_transport_party( oPC, sAmbush );
        }
        else{

            ds_transport_party( oPC, sWP );
        }
    }


}
