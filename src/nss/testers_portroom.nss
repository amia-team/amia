void main()
{
    object oPC   = GetPCSpeaker();
    object oTarget  = GetWaypointByTag( "testers_room" );


    DelayCommand( 1.0, AssignCommand( oPC, ClearAllActions() ) );
    DelayCommand( 1.1, AssignCommand( oPC, JumpToObject( oTarget, 0 ) ) );
}
