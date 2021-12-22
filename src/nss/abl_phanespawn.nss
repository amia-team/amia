/*
    Custom NPC Ability:
    Phane Boss Spawn
    - Sets the Failrate on the spawn trigger to 100 so only one Phane spawns per
    reset of the server.
    - Changes the Temporal Rift in the Null Time area to be unusable so PCs
    cannot escape mid-combat. Changes back at 1% health death function.
*/

void main()
{
    object oCritter = OBJECT_SELF;
    location lCritter = GetLocation( oCritter );

    object oRift = GetNearestObjectByTag( "nulltime_endirshade", oCritter );
    SetUseableFlag( oRift, FALSE );
    object oTrigger = GetNearestObject( OBJECT_TYPE_TRIGGER, oCritter );
    SetLocalInt( oTrigger, "FailRate", 100 );
}
