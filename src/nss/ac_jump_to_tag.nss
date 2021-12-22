//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ac_jump_to_tag
//group:   Jumps convo user to waypoint GetTag(OBJECT_SELF)
//used as: convo action script
//date:    jan 12 2008
//author:  disco


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC      = GetPCSpeaker();
    object oTarget  = GetWaypointByTag( GetTag( OBJECT_SELF ) );

    DelayCommand( 1.0, AssignCommand( oPC, JumpToObject( oTarget, 0 ) ) );
}



