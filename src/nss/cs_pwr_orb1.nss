/* Orb of Power: Greed

    1. Boss status
    2. Gem status
    3. Set Respawn status
    4. PLC vfx
    5. Other gems status
    6. Unplot boss for 30 seconds, remove gems, Candy

*/

void main(){

    // Variables
    object oOrbOfPower      =   OBJECT_SELF;
    object oBoss            =   OBJECT_INVALID;
    object oGem1            =   OBJECT_INVALID;
    object oGem2            =   OBJECT_INVALID;
    object oGem3            =   OBJECT_INVALID;
    string sBabylonTag      =   GetResRef( GetArea( oOrbOfPower ) ) + "__cs_yuanti_bab";

    // Boss status [ Present and still plotted. ]
    if( ( ( oBoss = GetNearestObjectByTag( sBabylonTag, oOrbOfPower, 1 ) ) != OBJECT_INVALID ) &&
        GetPlotFlag( oBoss )                                                                        ){

        // Gem status
        if( ( oGem1 = GetItemPossessedBy( oOrbOfPower, "NW_IT_GEM003" ) ) != OBJECT_INVALID ){

            // Set Respawn status
            if( !GetLocalInt( oOrbOfPower, "spawned" ) ){

                SetLocalInt( oOrbOfPower, "spawned", 1 );

                DelayCommand( 300.0, SetLocalInt( oOrbOfPower, "spawned", 0 ) );

                // PLC Vfx
                AssignCommand( oOrbOfPower, PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE, 1.0, 0.0 ) );

                ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_LIGHTNING_M ), oOrbOfPower, 0.0 );

                object oOrb2 = GetNearestObjectByTag( "cs_pwr_orb2", oOrbOfPower, 1 );

                // Other gems status
                if( oOrb2 != OBJECT_INVALID )

                    if( ( oGem2 = GetItemPossessedBy( oOrb2, "NW_IT_GEM012" ) ) != OBJECT_INVALID ){

                        object oOrb3 = GetNearestObjectByTag( "cs_pwr_orb3", oOrbOfPower, 1);

                        if( oOrb3 != OBJECT_INVALID )

                            if( ( oGem3 = GetItemPossessedBy( oOrb3, "NW_IT_GEM006" ) ) != OBJECT_INVALID ){

                                // Unplot boss
                                SetPlotFlag( oBoss, FALSE );

                                //DelayCommand( 30.0, SetPlotFlag( oBoss, TRUE ) );

                                // Remove gems
                                DestroyObject( oGem1, 0.0 );
                                DestroyObject( oGem2, 0.0 );
                                DestroyObject( oGem3, 0.0 );

                                // Candy
                                ApplyEffectToObject(
                                    DURATION_TYPE_INSTANT,
                                    EffectVisualEffect( 302, FALSE ),
                                    oBoss,
                                    0.0 );

                            }

                    }

            }

        }

    }

    return;

}
