// Universal VFX'er
void main( ){

    // Variables
    object oTrigger     = OBJECT_SELF;
    object oPC          = GetEnteringObject( );

    if( GetLocalInt( oPC, "spawned" ) )
        return;

    // Refresh spawn status
    SetLocalInt( oPC, "spawned", 1 );

    // VFX index
    int nVFX            = GetLocalInt( oTrigger, "cs_vfx" );
    if( nVFX > 0 ){

        // Origin object tag
        string szObjectTag = GetLocalString( oTrigger, "cs_tag" );
        if( szObjectTag != "" ){

            object oOrigin = GetNearestObjectByTag( szObjectTag );
            if( GetIsObjectValid( oOrigin ) )

                // Apply customized VFX to PLC
                ApplyEffectToObject(
                                    DURATION_TYPE_PERMANENT,
                                    SupernaturalEffect( EffectVisualEffect( nVFX ) ),
                                    oOrigin );

        }

    }

    return;

}
