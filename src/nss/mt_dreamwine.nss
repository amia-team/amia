/*  Trigger :: OnClick : Dream State Teleporter

    --------
    Verbatim
    --------
    This script will teleport a PC with Dream Wine to the selected Way Point

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    112813  MT         Initial release.
    ----------------------------------------------------------------------------

*/


void main( ){

    // Variables.
    object oTrigger     = OBJECT_SELF;
    object oPC          = GetPCSpeaker( );
    object oKey         = GetItemPossessedBy( oPC, "MT_DreamWine" );
    string szDestTag    = GetLocalString( oTrigger, "dream" );

    object oDest        = GetWaypointByTag( szDestTag );
    location lDest      = GetLocation( oDest );

    // Destination and teleporting player valid; and player has Dream Wine, then teleport the player


        if ((GetRacialType(oPC)==RACIAL_TYPE_ELF) ||
        (GetRacialType(oPC)==RACIAL_TYPE_HALFELF) ||
        (GetRacialType(oPC)==RACIAL_TYPE_FEY)) {
         if( GetIsObjectValid( oDest ) && GetIsPC( oPC ) && GetIsObjectValid( oKey ) ){
      DelayCommand( 0.3, AssignCommand( oPC, JumpToLocation( lDest ) ) );
      int nStack = GetItemStackSize( oKey );
            if ( nStack == 1 )
            {
                DestroyObject( oKey );
            }
            else
            {
                SetItemStackSize( oKey, nStack - 1 );
            }
            AssignCommand( oPC, ActionPlayAnimation(  ANIMATION_LOOPING_DEAD_FRONT, 1.0, 60.0 ));
            FadeToBlack( oPC);
            DelayCommand( 5.0, FadeFromBlack(oPC));

            FloatingTextStringOnCreature( " - You rest your head and drift off into reverie - ", oPC, FALSE );
            return;
   }
}

    else

        FloatingTextStringOnCreature( " - You rest your head - ", oPC, FALSE );
        AssignCommand( oPC, ActionPlayAnimation(  ANIMATION_LOOPING_DEAD_FRONT, 1.0, 60.0 ));
}
