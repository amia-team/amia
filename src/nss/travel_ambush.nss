/*  travel_ambush

    --------
    Verbatim
    --------
    Amian Carts transport script

    ---------
    Changelog
    ---------

    Date      Name        Reason
    ------------------------------------------------------------------
    07-28-06  Disco       Start of header
    11-10-06  Disco       Fix
    01-01-07  Disco       Added some candy
    ------------------------------------------------------------------


*/

void main(){


    object oPC          = OBJECT_SELF;
    object oNPC         = GetLocalObject( oPC, "ds_target" );

    //get destination from NPC
    string sAmbush      = GetLocalString( oNPC, "WP_ambush" );
    object oAmbush      = GetWaypointByTag( sAmbush );

    //teleport to ambush
    AssignCommand( oPC, JumpToObject( oAmbush ) );
    AssignCommand( oPC, ActionPlayAnimation( ANIMATION_LOOPING_DEAD_BACK, 1.0, 10.0 ) );
    DelayCommand( 1.0, FadeFromBlack( oPC, FADE_SPEED_SLOWEST ) );
    DelayCommand( 2.0,  ActionSpeakString( "Ouch!" ) );

    //cleanup
    DeleteLocalObject( oPC, "ds_target" );
}
