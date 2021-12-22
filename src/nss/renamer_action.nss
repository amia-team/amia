/*  renamer_action

--------
Verbatim
--------
Picks up a name from the talk channel and applies it to items/npcs in the area

---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
12-23-06  Disco       Start of header
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "NW_I0_GENERIC"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oShouter = GetLastSpeaker();
    object oArea    = GetArea( oShouter );
    object oObject  = GetFirstObjectInArea(oArea);
    string sName     = GetMatchedSubstring(0);

    if ( sName != "" ) {
        SendMessageToPC( oShouter, "Setting item and NPC names to '"+sName+"'" );
    }
    else{
        SendMessageToPC( oShouter, "Restoring item and NPC names" );
    }

    while(GetIsObjectValid(oObject)){

         // Destroy any objects tagged "DESTROY"
         if( oObject != OBJECT_SELF && !GetIsPC( oObject ) ){

             SetName(oObject, sName);
         }
         oObject = GetNextObjectInArea(oArea);
    }



    //no clue what this does
    if(GetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT)){
        SignalEvent(OBJECT_SELF, EventUserDefined(1004));
    }
}


