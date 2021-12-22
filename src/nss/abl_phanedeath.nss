/*
    Custom NPC Ability:
    Phane Boss Death
    - Changes the Temporal Rift in the Null Time area to be usable again so PCs
    can leave after the Phane has been killed successfully.
*/

void main()
{
    object oCritter = OBJECT_SELF;
    location lCritter = GetLocation( oCritter );

    object oRift = GetNearestObjectByTag( "nulltime_endirshade", oCritter );
    SetUseableFlag( oRift, TRUE );
}
