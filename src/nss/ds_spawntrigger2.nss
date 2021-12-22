/*
ds_spawntrigger

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
OnEnter event of spawn trigger.
---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
05-14-2006      disco      Start of header
05-19-2006      disco      Added SuperBoss lib
05-20-2006      disco      Added boss delay and spawn chance
05-23-2006      disco      Branched from tha_spawntrigger
2007-04-08      disco      Changed ds_random_spawnpoint
  20071119  disco       Removed CS_ tags
20080801  Disco       Removed some spot calls
20081005  disco    big overhaul
------------------------------------------------
*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "inc_ds_spawns"

void main(){

    // variables
    object oPC      = GetEnteringObject();
    object oTrigger = OBJECT_SELF;
    object oArea    = GetArea( oTrigger );
    int nSpawnTime;

    //no PC no go
    if( GetIsPC( oPC ) == FALSE ){

        return;
    }

    // resolve area spawn activation status
    int nSpawnDisabled  = GetLocalInt( oArea, "no_spawn" );

    if( nSpawnDisabled ){

        return;
    }

    // resolve spawn delay status
    if( GetIsBlocked() > 0 ){

        return;
    }
    else{

        SetBlockTime( oTrigger, 15 );

        ds_spawn_wrapper(oPC,oArea);
    }
}




