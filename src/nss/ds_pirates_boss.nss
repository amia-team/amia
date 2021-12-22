/*  ds_pirate_boss

    --------
    Verbatim
    --------
    Checks if pirate boss is around and if the player should trigger him

    ---------
    Changelog
    ---------

    Date    Name        Reason
    ------------------------------------------------------------------
    101006  Disco       Script header started
19-11-2007      disco      Now using inc_ds_records
------------------------------------------------
*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    object oPC = GetEnteringObject();

    //Quit if the entering object isn't a PC
    if ( GetIsPC( oPC ) == FALSE ){

        return;
    }

    //quit if blocked
    if ( GetIsBlocked( OBJECT_SELF ) > 0 ){

        //testing
        SendMessageToPC( GetFirstPC(), "[Debug: trigger blocked]" );

        return;

    }
    else{

        //check quest
        //quest status
        int nQuestStatus = ds_quest( oPC, "ds_quest_4", 0 );


        //testing
        SendMessageToPC( GetFirstPC(), "[Debug: Quest 4 = "+IntToString( nQuestStatus )+"]" );

        if ( nQuestStatus == 2 ){

            //block for 5 minutes  seconds
            SetBlockTime( OBJECT_SELF, 10 );

            //get regular close-by spawnpoint
            object oSpawnpoint = GetObjectByTag( "tsp_luchavi" );

            //run rest of your script
            ds_spawn_critter( oPC, "ds_pirate_1", GetLocation( oSpawnpoint ) );

            ds_quest( oPC, "ds_quest_4", 3 );

            //testing
            SendMessageToPC( GetFirstPC(), "[Debug: Spawning Luchavi, increasing quest status]" );

        }
        else if ( nQuestStatus == 3 ){

            //block for 5 minutes and 30 seconds
            SetBlockTime( OBJECT_SELF, 10 );

            //get regular close-by spawnpoint
            object oSpawnpoint = GetObjectByTag( "tsp_luchavi" );

            //run rest of your script
            ds_spawn_critter( oPC, "ds_pirate_1", GetLocation( oSpawnpoint ) );

            //testing
            SendMessageToPC( GetFirstPC(), "[Debug: Spawning Luchavi]" );
        }
    }
}




