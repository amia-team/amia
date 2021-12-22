/*
tha_aconvo_action

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
this is a universal script to handle conversation actions

---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
04-29-2006      disco      Start of header
06-21-2006      disco      Check if the Priest is still in convo with a PC
06-28-2006      kfw        Possible transient PC object bug. Still needs testing.
05-11-2006      Disco      Added party travel to ferry
19-11-2007      disco      Now using inc_ds_records
2008-01-01      Disco      Updated
------------------------------------------------
*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"
#include "nw_i0_tool"

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    //variables
    object oPC          = GetPCSpeaker();
    string sConvoNPCTag = GetTag( OBJECT_SELF );
    object oArea        = GetArea( OBJECT_SELF );

    //sometimes an NPC reacts to SpeakString from another NPC
    if ( GetIsPC( oPC ) == FALSE ){

        return;
    }

    if ( sConvoNPCTag == "tha_dragonlair" ){

        //transport to waste deposit
        DelayCommand( 1.0, AssignCommand( oPC, JumpToLocation( GetLocation( GetWaypointByTag( "tha_wastedeposit" ) ) ) ) );

        // knockdown and harm
        effect ePain    = EffectDamage( GetCurrentHitPoints( oPC ) - d20(), DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL );
        effect eEffect  = EffectKnockdown();

        DelayCommand( 3.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, ePain, oPC ) );
        DelayCommand( 3.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eEffect, oPC, 10.0 ) );
    }
    else if ( sConvoNPCTag == "tha_npc_to_howness1" ){

        //transport to the island, Traders get a free ride
        if (HasItem( oPC, "tha_trader_papers" ) ){

            ds_transport_party( oPC, "tha_trader_landing" );
        }
        else{
            // Remove some gold from the player
            TakeGoldFromCreature( 250, oPC, TRUE );
            ds_transport_party( oPC, "tha_howness_from_cordor" );
        }
    }
    else if ( sConvoNPCTag == "tha_npc_to_howness2" ){

        // Remove some gold from the player
        TakeGoldFromCreature( 50, oPC, TRUE );

        //transport to the island
        ds_transport_party( oPC, "tha_howness_from_gnomish" );
    }
    else if ( sConvoNPCTag == "tha_npc_to_cordor" ){

        //transport to the island, Traders get a free ride
        if (!HasItem( oPC, "tha_trader_papers" ) ){

            TakeGoldFromCreature( 250, oPC, TRUE );
        }

        ds_transport_party( oPC, "tha_cordor" );
    }
    else if ( sConvoNPCTag == "tha_npc_to_gnomish" ){

        // Remove some gold from the player
        TakeGoldFromCreature( 50, oPC, TRUE );

        //transport to Forrstakkr
        ds_transport_party( oPC, "tha_gnomish" );
    }
    else if ( sConvoNPCTag == "tha_npc_to_thordstein" ){

        //transport to the island, Traders get a free ride
        if (!HasItem( oPC, "tha_trader_papers" ) ){

            TakeGoldFromCreature( 250, oPC, TRUE );
        }

        //transport to the island
        ds_transport_party( oPC, "tha_thordstein" );
    }
    else if ( sConvoNPCTag == "tha_npc_to_uhm" ){

        //transport from the island, Traders get a free ride
        if (!HasItem( oPC, "tha_trader_papers" ) ){

            TakeGoldFromCreature( 250, oPC, TRUE );
        }

        ds_transport_party( oPC, "tha_uhm" );
    }
    else if ( sConvoNPCTag == "rt_dizzy1" ){
    //used for all Dizzy scripts on docks
    //transport to the boat
            ds_transport_party( oPC, "rt_boat" );
    }
    else if ( sConvoNPCTag == "rt_dizzy2" ){
    //moves user to Kampo's
    //transport to the boat
            ds_transport_party( oPC, "rt_docks1" );
    }
        else if ( sConvoNPCTag == "c_redwood" ){
    //transport to Redwood
            ds_transport_party( oPC, "tarksea_rw" );
    }
    else if ( sConvoNPCTag == "cc_flint2" ){
    //transport to Barak Runedar from Chalkcliff
            ds_transport_party( oPC, "cc_flint_br" );
    }
    else if ( sConvoNPCTag == "winyatemple" ){

        int nReputation = tha_reputation( oPC, 0 );
        object oStore   = GetLocalObject( OBJECT_SELF, "MyStore" );

        if ( GetObjectType( oStore ) != OBJECT_TYPE_STORE ) {

            oStore = CreateObject( OBJECT_TYPE_STORE, sConvoNPCTag, GetLocation( OBJECT_SELF ) );
        }

        if( GetObjectType( oStore ) == OBJECT_TYPE_STORE ){

            //store store on object for future use
            SetLocalObject( OBJECT_SELF, "MyStore", oStore );
        }
        else{

            //error
            ActionSpeakStringByStrRef( 53090, TALKVOLUME_TALK);
            return;
        }

        AssignCommand( OBJECT_SELF, SpeakString( "Of course!" ) );
        OpenStore( oStore, oPC, ( 10 - ( 4*nReputation ) ) );
    }
}
