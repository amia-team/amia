/*  ds_convo_result2

--------
Verbatim
--------
generic conversation result script

---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
11-06-06  Disco       Start of header
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
    object oPC   = GetPCSpeaker();
    string sNPC  = GetName(OBJECT_SELF);

    if( sNPC == "Pirate Captain" ){

        // get money  if not enough attack!
        if ( GetGold( oPC ) > 1000 ){

            TakeGoldFromCreature( 1000, oPC, FALSE );
            DestroyObject( OBJECT_SELF );

        }
        else{

            //we been cheated!
            SpeakString( "You ent got 1000 gold? We been cheated! Git 'em, boys!" );

            // spawn pirates (duh)
            spawn_pirates( oPC );

            //set boss to hostile
            ChangeToStandardFaction( OBJECT_SELF, STANDARD_FACTION_HOSTILE );
            ActionAttack( oPC );

        }
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
