void main(){

    object oPC   = GetEnteringObject();
    string sTag  = GetTag( OBJECT_SELF );

    if ( sTag == "udb_beh_vent" ){

        object oDoor = GetLocalObject( OBJECT_SELF, "door" );
        object oWP   = GetLocalObject( OBJECT_SELF, "wp" );

        if ( !GetIsObjectValid( oDoor ) ){

            oDoor = GetNearestObjectByTag( "udb_beh_vent_door" );
            oWP   = GetNearestObjectByTag( "udb_beh_vent_wp" );

            SetLocalObject( OBJECT_SELF, "door", oDoor );
            SetLocalObject( OBJECT_SELF, "wp", oWP );
        }

        AssignCommand( oDoor, PlayAnimation( ANIMATION_DOOR_OPEN1 ) );
        DelayCommand( 1.0, AssignCommand( oPC, JumpToObject( oWP ) ) );
        DelayCommand( 2.0, AssignCommand( oDoor, PlayAnimation( ANIMATION_DOOR_CLOSE ) ) );
    }
    else if ( sTag == "udb_kill" ){

        effect eKill = EffectDamage( 5000 );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eKill, oPC );
    }
}
