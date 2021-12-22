void CreateBeam( object oSource, object oTarget, int nBeam ){

   effect eBeam    = EffectBeam( nBeam, oSource, BODY_NODE_CHEST );
   ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oTarget, 3.0 );
}

void LightSeat( int nVFX ){

    object oSeat     = GetNearestObjectByTag( "mt_seat" );
    object oVictim   = GetSittingCreature( oSeat );
    object oReadOut  = GetNearestObjectByTag( "mt_readout" );
    effect eLight    = EffectVisualEffect( nVFX );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLight, oSeat, 3.0 );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLight, oVictim, 3.0 );

    string sMessage  = "tr_id: "+IntToString( GetTimeMillisecond( ) );
           sMessage += ", vuz: "+IntToString( GetAlignmentLawChaos( oVictim ) )+"."+IntToString( d100() );
           sMessage += ", vaz: "+IntToString( GetAlignmentGoodEvil( oVictim ) )+"."+IntToString( d100() );
           sMessage += ", kat-i: "+IntToString( d6() + GetRacialType( oVictim ) );

    DelayCommand( 1.3, AssignCommand( oReadOut, SpeakString( sMessage ) ) );

}

void main(){

    // * note that nActive == 1 does  not necessarily mean the placeable is active
    // * that depends on the initial state of the object
    int nActive = GetLocalInt (OBJECT_SELF,"X2_L_PLC_ACTIVATED_STATE");
    // * Play Appropriate Animation
    if (!nActive)
    {
      ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
    }
    else
    {
      ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
    }
    // * Store New State
    SetLocalInt(OBJECT_SELF,"X2_L_PLC_ACTIVATED_STATE",!nActive);

    string sTag = GetLocalString( OBJECT_SELF, "target" );
    object oTarget = GetNearestObjectByTag( sTag );

    if ( sTag == "mt_beam_1" ){

        if ( !nActive ){

            object oTarget2 = GetNearestObjectByTag( "mt_lens_1" );
            object oTarget3 = GetNearestObjectByTag( "mt_lens_4" );
            object oTarget4 = GetNearestObjectByTag( "mt_lens_5" );

            CreateBeam( oTarget, oTarget2, VFX_BEAM_LIGHTNING );
            DelayCommand( 1.0, CreateBeam( oTarget2, oTarget3, VFX_BEAM_COLD ) );
            DelayCommand( 2.0, CreateBeam( oTarget3, oTarget4, VFX_BEAM_MIND ) );
            DelayCommand( 2.0, LightSeat( VFX_DUR_GLOW_WHITE ) );
        }
    }
    else if ( sTag == "mt_beam_2" ){

        if ( !nActive ){

            object oTarget2 = GetNearestObjectByTag( "mt_lens_2" );
            object oTarget3 = GetNearestObjectByTag( "mt_lens_4" );
            object oTarget4 = GetNearestObjectByTag( "mt_lens_5" );

            CreateBeam( oTarget, oTarget2, VFX_BEAM_LIGHTNING );
            DelayCommand( 1.0, CreateBeam( oTarget2, oTarget3, VFX_BEAM_EVIL ) );
            DelayCommand( 2.0, CreateBeam( oTarget3, oTarget4, VFX_BEAM_ODD ) );
            DelayCommand( 2.0, LightSeat( VFX_DUR_GLOW_PURPLE ) );
        }
    }
    else if ( sTag == "mt_beam_3" ){

        if ( !nActive ){

            object oTarget2 = GetNearestObjectByTag( "mt_lens_3" );
            object oTarget3 = GetNearestObjectByTag( "mt_lens_4" );
            object oTarget4 = GetNearestObjectByTag( "mt_lens_5" );

            CreateBeam( oTarget, oTarget2, VFX_BEAM_LIGHTNING );
            DelayCommand( 1.0, CreateBeam( oTarget2, oTarget3, VFX_BEAM_FIRE ) );
            DelayCommand( 2.0, CreateBeam( oTarget3, oTarget4, VFX_BEAM_HOLY ) );
            DelayCommand( 2.0, LightSeat( VFX_DUR_GLOW_ORANGE ) );


        }
    }
    else {

        if ( !nActive ){

            AssignCommand( oTarget, ActionPlayAnimation( ANIMATION_PLACEABLE_ACTIVATE ) );
        }
        else {

            AssignCommand( oTarget, ActionPlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );
        }
    }
}
