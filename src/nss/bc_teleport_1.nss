/*  Bardic College - OnUsed Painting teleport script to College

    --------
    Verbatim
    --------
    Allows for porting and other events when the player clicks on an object.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    012707  kfw         Initial.
    ----------------------------------------------------------------------------

*/

void main( ){

    // Variables.
    object oPC          = GetLastUsedBy( );
    object oDest        = GetWaypointByTag( "wp_Triumvir" );

    //SendMessageToPC( oPC, "*This link has been disabled. The Bard's College needs a bit more debugging.*" )



    // VFX.
    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect( VFX_FNF_LOS_HOLY_10 ),
        oPC );
    // Teleport the player in 3 seconds.
    DelayCommand( 3.0, AssignCommand( oPC, JumpToLocation( GetLocation( oDest ) ) ) );



    return;

}
