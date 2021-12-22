//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_create_key
//group:   doors
//used as: trigger OnEnter script, generates a key for the key/lock system
//date:    2006
//author:  disco

//Date        Name        Reason
//------------------------------------------------------------------
//2007-01-01  Disco       Disabled "only ignore key spawning if room is locked"
//2007-07-23  Disco       Cleans up key after 60 secs
//------------------------------------------------------------------

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void CleanUp( object oTrigger, object oKey );


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    // variables
    object oPC = GetEnteringObject();

    //no PC no go
    if( GetIsPC(oPC) == FALSE ){

        return;
    }

    if( GetLocalInt( OBJECT_SELF, "blocked" ) != 1 ){

        //block asap
        SetLocalInt( OBJECT_SELF, "blocked", 1 );

        string sTarget = GetLocalString( OBJECT_SELF, "target" );

        object oDoor;

        if ( sTarget != "" ){

            //get door
            oDoor = GetObjectByTag( sTarget );

            //notify
            AssignCommand( oPC, SpeakString( "*You can use the room key to unlock this house. No more keys will be dropped until reset.*", TALKVOLUME_WHISPER ) );
        }
        else {

            //get door
            oDoor = GetNearestObjectByTag( "ds_lock_door" );

            //get room trigger area
            object oTrigger = GetNearestObjectByTag( "ds_room_trigger" );

            //check for people inside
            object oInTrigger = GetFirstInPersistentObject( oTrigger );

            //exit if inhabited
            //if ( oInTrigger != OBJECT_INVALID && GetLocked( oDoor ) ) {
            if ( GetIsPC( oInTrigger ) || GetIsPossessedFamiliar( oInTrigger ) ) {

                //unblock
                DelayCommand(30.0, SetLocalInt( OBJECT_SELF, "blocked", 0 ) );

                AssignCommand( oPC, SpeakString( "*This room is occupied. You'll have to come back later.*", TALKVOLUME_WHISPER ) );

                return;
            }

            //notify
            AssignCommand( oPC, SpeakString( "*You can use the room key to lock this room. No more keys will be dropped as long as you stay inside.*", TALKVOLUME_WHISPER ) );
        }

        //generate tag
        string sKeyTag = "ds_key_" + IntToString( d100() ) + "_" + IntToString( GetTimeMillisecond() );

        //get key WP
        object oWaypoint = GetNearestObjectByTag( "ds_key_wp" );

        //get previous key
        object oPrevKey = GetObjectByTag( GetLockKeyTag( oDoor ) );

        //spawn key
        object oKey = CreateObject( OBJECT_TYPE_ITEM, "ds_lock_key", GetLocation( oWaypoint ), FALSE, sKeyTag );

        //match lock on other side
        if ( sTarget != "" ){

            object oDoor2 = GetTransitionTarget( oDoor );

            SetLockKeyTag( oDoor2, sKeyTag );
        }
        else{

            if ( oPrevKey != OBJECT_INVALID ){

                DestroyObject( oPrevKey );
            }

            //unblock
            DelayCommand( 60.0, CleanUp( OBJECT_SELF, oKey ) );
        }

        //set door key tag
        SetLockKeyTag( oDoor, sKeyTag );
    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void CleanUp( object oTrigger, object oKey ){

    SetLocalInt( oTrigger, "blocked", 0 );

    if ( GetItemPossessor( oKey ) == OBJECT_INVALID ){

        DestroyObject( oKey );
    }
}
