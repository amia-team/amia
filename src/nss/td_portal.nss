void main(){

    object oPC = GetLastUsedBy();
    AssignCommand( oPC, ActionJumpToLocation( GetLocation( GetWaypointByTag( GetLocalString( OBJECT_SELF, "wp" ) ) ) ) );
}

