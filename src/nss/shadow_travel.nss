/*
    Created: 10/24/2025
    Creator: TheLoafyOne
    Description: Script used to initiate a conversation file that teleports
    players to places via the shadowplane.
*/

#include "amia_include"

//Canibalized the amia include party travel script to do whacky cool effects shit
void shadowTransportParty( object oPC, string sWaypoint ){

    object oDest    = GetWaypointByTag( sWaypoint );
    object oTrigger = GetNearestObjectByTag( "party_trigger" );
    object oObject  = GetFirstInPersistentObject( oTrigger );

    effect teleSmoke = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);

    while ( GetIsObjectValid( oObject ) ) {

        if ( ds_check_partymember( oPC, oObject ) ) {

            AssignCommand( oObject, ClearAllActions( TRUE ) );
            ApplyEffectToObject(DURATION_TYPE_INSTANT,teleSmoke, oObject);
            DelayCommand(2.0f,AssignCommand( oObject, ActionJumpToObject( oDest, FALSE ) ) );
        }

        oObject = GetNextInPersistentObject( oTrigger );
    }
}

void main() {
    string tDestination = GetScriptParam("destination");
    object tWaypoint = GetObjectByTag(tDestination);
    object leadPlayer = GetLastSpeaker();

      if ( GetIsDM( leadPlayer ) ){

        AssignCommand( leadPlayer, JumpToObject( tWaypoint ) );

        return;
    }
    shadowTransportParty( leadPlayer, GetTag( tWaypoint ) );

}
