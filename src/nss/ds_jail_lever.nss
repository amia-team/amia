//  Changelog:
//
//  25-Oct-2023 Frozen  cleanup and adding tag support



void main(){

    object oDoor = GetLocalObject( OBJECT_SELF, "door" );
    object oPC   = GetLastUsedBy();
    string sTag  = GetLocalString (OBJECT_SELF, "tag");
    object oDoor2 = GetNearestObjectByTag( sTag, OBJECT_SELF );

    //generic bolt
    if ( GetName( OBJECT_SELF ) == "Lock" ){

        if ( oDoor == OBJECT_INVALID ){

            oDoor = GetNearestObject( OBJECT_TYPE_DOOR );
            SetLocalObject( OBJECT_SELF, "door", oDoor );

        }

        if ( GetIsOpen( oDoor ) ){

            AssignCommand( oPC, ActionSpeakString( "You can't lock an open door!" ) );
            return;
        }
        if ( GetLocked( oDoor ) ){

            AssignCommand( oPC, ActionSpeakString( "*Unlocks door*" ) );
            SetLocked( oDoor, FALSE );
        }
        else{

            AssignCommand( oPC, ActionSpeakString( "*Locks door*" ) );
            SetLocked( oDoor, TRUE );
        }
    }
    else {

        if (sTag != "") {oDoor = GetNearestObjectByTag( sTag, OBJECT_SELF );}
        else            {oDoor = GetNearestObjectByTag( "ds_lever_door", OBJECT_SELF );}



        if ( GetIsOpen( oDoor ) ) {

            AssignCommand( oPC, ActionSpeakString( "*pulls lever to close the door*" ) );

            AssignCommand( oDoor, PlayAnimation( ANIMATION_DOOR_CLOSE ) );
            SetLocked( oDoor, TRUE  );


        }
        else{

            AssignCommand( oPC, ActionSpeakString( "*pulls lever to open the door*" ) );

            SetLocked( oDoor, FALSE );
            AssignCommand( oDoor, PlayAnimation( ANIMATION_DOOR_OPEN1 ) );
        }
    }
}
