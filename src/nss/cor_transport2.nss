// Electric Castle :: Trigger allows only a certain alignment to pass

void main( ){

    // Variables
    object oTrigger         = OBJECT_SELF;
    int nAlignment_check    = GetLocalInt( oTrigger, "cs_align" );
    object oPC              = GetEnteringObject( );
    int nAlignment          = GetAlignmentGoodEvil( oPC );
    object oDest            = GetWaypointByTag( "wp_cor_death" );
    location lDest          = GetLocation( oDest );

    // Incorrect chosen path, zap 'em!
    if( GetIsPC( oPC ) && !GetIsDM( oPC ) && GetIsObjectValid( oDest ) && nAlignment_check != nAlignment ){

        // Teleport away.
        AssignCommand( oPC, JumpToLocation( lDest ) );

        // Death slap.
        DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDeath( TRUE ), oPC ) );
        DelayCommand( 0.6, ApplyEffectToObject(
                                                DURATION_TYPE_INSTANT,
                                                EffectVisualEffect( VFX_IMP_DEATH ),
                                                oPC ) );

    }

    return;

}
