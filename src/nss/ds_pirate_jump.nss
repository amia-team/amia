void main(){

    object oPC         = GetPCSpeaker();
    location lLocation = GetLocation( GetWaypointByTag("ds_from_pirates" ) );

    AssignCommand( oPC, JumpToLocation( lLocation ) );

}
