void main()
{
    object oPC   = GetPCSpeaker();
    object oTarget  = GetWaypointByTag( "amia_entry" );


    DelayCommand( 1.0, AssignCommand( oPC, ClearAllActions() ) );
    DelayCommand( 1.1, AssignCommand( oPC, JumpToObject( oTarget, 0 ) ) );
}
