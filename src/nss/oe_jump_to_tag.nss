//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:
//group:   generic stuff
//used as: OnEnter script
//date:    jan 16 2008
//author:  disco



//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC = GetEnteringObject();

    if ( GetIsPC( oPC ) || GetIsDMPossessed( oPC ) ){

         object oWaypoint = GetWaypointByTag( GetTag( OBJECT_SELF ) );

        AssignCommand( oPC, ClearAllActions() );
        AssignCommand( oPC, ActionJumpToObject( oWaypoint ) );
    }
}
