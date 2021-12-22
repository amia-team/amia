//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_access_area
//group:   navigation
//used as: OnClick/OnEnter script
//date:    apr 02 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
int GetConditionIsTrue( object oPC, string sTag );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC        = GetClickingObject();
    object oTarget    = GetTransitionTarget( OBJECT_SELF );

    SetAreaTransitionBMP( AREA_TRANSITION_RANDOM );

    if ( GetConditionIsTrue( oPC, GetTag( OBJECT_SELF ) ) == TRUE ){

        AssignCommand( oPC, JumpToObject( oTarget ) );
    }
    else{

        SendMessageToPC( oPC, "-- You need to perform a certain action, or the right key, to use this transition. -- " );
    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

int GetConditionIsTrue( object oPC, string sTag ){

    if ( sTag == "oc_bottom_to_chasm" ){

        if ( GetLocalInt( OBJECT_SELF, "open" ) == 1 ){

            return TRUE;
        }

        object oRightSocket = GetObjectByTag( "oc_right_socket" );
        object oRightEye    = GetItemPossessedBy( oRightSocket, "oc_right_eye" );
        object oLeftSocket  = GetObjectByTag( "oc_left_socket" );
        object oLeftEye     = GetItemPossessedBy( oLeftSocket, "oc_left_eye" );

        if ( GetIsObjectValid( oRightEye ) && GetIsObjectValid( oLeftEye ) ){

            int nDie          = d4();

            if ( nDie == 1 ){

                DestroyObject( oRightEye );
            }
            else if ( nDie == 2 ){

                DestroyObject( oLeftEye );
            }
            else if ( nDie == 3 ){

                DestroyObject( oLeftEye );
                DestroyObject( oRightEye );
            }

            SetLocalInt( OBJECT_SELF, "open", 1 );

            DelayCommand( 60.0, DeleteLocalInt( OBJECT_SELF, "open" ) );

            SendMessageToPC( oPC, "This entrance will be open during the next minute. Make sure your whole party gets through in time!" );

            //call fw_instance
            ExecuteScript("fw_instance", OBJECT_SELF);

            return TRUE;

        }

        return FALSE;
    }

    return FALSE;
}
