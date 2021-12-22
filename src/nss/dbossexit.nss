/*
    Exit Script for Frostspear cave boss encounter
    - Maverick00053 8/12/20

*/

void main()
{
   object oPC = GetLastUsedBy();

   object oHome = GetWaypointByTag("dbossoutside");

   AssignCommand( oPC, ClearAllActions() );

   DelayCommand( 0.2f, AssignCommand( oPC, JumpToObject( oHome ) ) );


}
