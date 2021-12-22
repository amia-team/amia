/*
    Exit Script for Lich  boss encounter
    - Maverick00053 11/17/20

*/

void main()
{
   object oPC = GetLastUsedBy();

   object oHome = GetWaypointByTag("lbossoutside");

   AssignCommand( oPC, ClearAllActions() );

   DelayCommand( 0.2f, AssignCommand( oPC, JumpToObject( oHome ) ) );


}
