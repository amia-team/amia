//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_flush_corpse
//group:   transport
//used as: OnUse script
//date:    feb 02 2007
//author:  disco


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oTrigger = GetObjectByTag( "ds_dump_player" );
    object oPC      = GetFirstInPersistentObject( oTrigger );

    if ( GetIsObjectValid( oPC ) ){

        object oWaypoint = GetObjectByTag( "ds_dumppoint_1" );

        if ( GetIsObjectValid( oWaypoint ) ){

            AssignCommand( oPC, SpeakString( "*Gets flushed into the dirty water!*" ) );
            DelayCommand( 0.5, AssignCommand( oPC, JumpToObject( oWaypoint, 0 ) ) );
        }
        else{

            SendMessageToPC( GetLastUsedBy(), "Can't find dump point" );
        }

    }
    else{

        SendMessageToPC( GetLastUsedBy(), "Can't find a creature inside the trigger" );
    }
}
