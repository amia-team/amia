/*  ds_convo_result1

--------
Verbatim
--------
generic conversation result script

---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
11-02-06  Disco       Start of header
11-07-06  Disco       Added new party transport
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void spawn_pirates( object oPC );
void spawn_pirate( object oPC, string sTag, location lSpawnpoint );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------


void main(){

    //variables
    object oPC    = GetPCSpeaker();
    string sNPC   = GetName(OBJECT_SELF);

    if(sNPC=="Lemonade Lady" && GetGold(oPC)>20){

        // sell lemonade
        CreateItemOnObject("ds_lemonade", oPC, 1);
        TakeGoldFromCreature(20, oPC, TRUE);
    }
    else if(sNPC=="Sausage Vendor" && GetGold(oPC)>20){

        // sell sausage
        CreateItemOnObject("ds_sausage", oPC, 1);
        TakeGoldFromCreature(20, oPC, TRUE);
    }
    else if(sNPC=="Ferry to Moribund"){

        // jump PC to graveyard isle
        DelayCommand( 1.0, ds_transport_party( oPC, "ds_cordor_ferry" ) );

    }
    else if(sNPC=="Ferry to Cordor"){

        // jump PC to cordor
        DelayCommand( 1.0, ds_transport_party( oPC, "ds_coast2_ferry" ) );

    }
    else if( sNPC == "Pirate Captain" ){

        // spawn pirates (duh)
        spawn_pirates( oPC );

        //set boss to hostile
        ChangeToStandardFaction( OBJECT_SELF, STANDARD_FACTION_HOSTILE );
        ActionAttack( oPC );

    }

}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void spawn_pirates( object oPC ){

    //variables
    object oSpawnpoint   = GetNearestObjectByTag("ds_spawn_pirates", OBJECT_SELF, d3());
    location lSpawnpoint = GetLocation( oSpawnpoint );
    int i;
    float fDelay;

    //spawn pirates
    for ( i=0; i< d3(); ++i ){

        fDelay = IntToFloat( i/10 );

        DelayCommand( fDelay, spawn_pirate( oPC, "Pirate", lSpawnpoint ) );

    }
    for ( i=0; i< d3(); ++i ){

        fDelay = IntToFloat( i/10 );

        DelayCommand( fDelay, spawn_pirate( oPC, "PirateArcher", lSpawnpoint ) );

    }


}

void spawn_pirate( object oPC, string sTag, location lSpawnpoint ){

    ds_spawn_critter( oPC, sTag, lSpawnpoint );

}
