//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_rental_locked
//group: rentable housing
//used as: OnFailToOpen door event
//date: 2009-09-04
//author: disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
//#include "inc_ds_rental"
//#include "inc_ds_actions"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    /*//check if this door is owned by somebody
    object oPC         = GetClickingObject();
    object oArea       = GetArea( oPC );
    object oModule     = GetModule();
    object oDoorIn     = OBJECT_SELF;
    object oDoorOut    = GetLocalObject( oDoorIn, RNT_TARGET );
    object oHouse      = GetArea( oDoorOut );
    string sPCKEY      = GetName( GetPCKEY( oPC ) );
    string sOwnerPCKEY;
    string sQuery;
    string sDoorID     = GetResRef( oArea )+"_"+GetTag( oDoorIn );
    int nInitialised   = FALSE;
    int nConnect       = FALSE;
    int nOpen          = FALSE;
    int nTaken         = FALSE;
    int nHours;
    int nType;
    int nIsOwner       = FALSE;
    int nModule        = GetLocalInt( oModule, "Module" );


    //first time this reset, initialise systems
    if ( !GetLocalInt( oModule, RNT_INITIALISED ) ){

        sQuery = "DELETE FROM rental_house WHERE module="+IntToString( nModule )+" AND end_date < NOW()";

        SQLExecDirect( sQuery );

        sQuery = "SELECT CONCAT( area, '_', door ), pckey, type, TIMESTAMPDIFF( HOUR, NOW(), end_date ) as hours FROM rental_house WHERE module="+IntToString( nModule )+" AND end_date > NOW()";

        SQLExecDirect( sQuery );

        while ( SQLFetch() == SQL_SUCCESS ){

            SetLocalString( oModule, SQLGetData( 1 ), SQLGetData( 2 ) );
            SetLocalInt( oModule, SQLGetData( 1 ), StringToInt( SQLGetData( 3 ) ) );
            SetLocalInt( oModule, RNT_PREFIX+SQLGetData( 2 ), StringToInt( SQLGetData( 4 ) ) );
        }

        SetLocalInt( oModule, RNT_INITIALISED, TRUE );
    }

    sOwnerPCKEY = GetLocalString( oModule, sDoorID );
    nType  = GetLocalInt( oModule, sDoorID );
    nHours = GetLocalInt( oModule, RNT_PREFIX+sOwnerPCKEY );

    if ( sOwnerPCKEY == "" ) {

        SendMessageToPC( oPC, "Debug: ds_rental_locked: Door has no owner." );

        if ( sOwnerPCKEY != sPCKEY  && GetLocalInt( oModule, RNT_PREFIX+sPCKEY ) > 0 ){

            SendMessageToPC( oPC, "You already own a house. Can't rent this one." );
        }
        else {

            //this pc isn't the owner of another house,
            //the house isn't taken,
            //let's continue with making him an offer he can refuse
            clean_vars( oPC, 4 );

            SetLocalString( oPC, "ds_action", RNT_DEAL_TAG );
            SetLocalObject( oPC, "ds_target", oDoorIn );

            AssignCommand( oPC, ActionStartConversation( oPC, RNT_DEAL_TAG, TRUE, FALSE ) );
        }
    }
    else if ( GetObjectType( oDoorOut ) == OBJECT_TYPE_DOOR ){

        SendMessageToPC( oPC, "Debug: ds_rental_locked: Door has a target house." );

        //door has proper target
        nTaken       = TRUE;

        if ( sOwnerPCKEY == GetLocalString( oHouse, RNT_OWNER ) ){

            //house owner is recorded on target house
            SendMessageToPC( oPC, "Debug: ds_rental_locked: Door and house have same owner." );

            if ( sOwnerPCKEY == sPCKEY ){

                //oPC owns this house
                SendMessageToPC( oPC, "Debug: ds_rental_locked: PC owns this door." );
                nOpen = TRUE;
            }
            else if ( sOwnerPCKEY == GetLocalString( oPC, RNT_PCKEY ) ){

                //oPC has a key to this house
                SendMessageToPC( oPC, "Debug: ds_rental_locked: PC has a key to this door." );
                nOpen = TRUE;
            }
            else if ( GetLocalInt( oDoorOut, RNT_UNLOCKED ) ){

                //door isn't locked, come in
                SendMessageToPC( oPC, "Debug: ds_rental_locked: PC has no key, is not owner, but door is open." );
                nOpen = TRUE;
            }
            else{

                SendMessageToPC( oPC, "Debug: ds_rental_locked: PC has no key, is not owner, and door is locked." );
            }
        }
        else{

             //incorrect door - house link, cleanup
            SendMessageToPC( oPC, "Debug: ds_rental_locked: incorrect door - house link, cleanup." );
            SendMessageToPC( oPC, "Debug: ds_rental_locked: door owner = "+sOwnerPCKEY+"." );
            SendMessageToPC( oPC, "Debug: ds_rental_locked: house owner = "+GetLocalString( oHouse, RNT_OWNER )+"." );
            nConnect = TRUE;
        }
    }
    else if ( sOwnerPCKEY == sPCKEY ){

        //this pc is the owner of this house
        SendMessageToPC( oPC, "You own this house for another "+IntToString( nHours )+" hours." );
        SendMessageToPC( oPC, "You will keep this house until the end of reset, even if you don't have enough hours left." );

        SetLocalString( oDoorIn, RNT_PCKEY, sOwnerPCKEY );

        nTaken   = TRUE;
        nConnect = TRUE;
        nIsOwner = TRUE;
    }
    else if ( sOwnerPCKEY == GetLocalString( oPC, RNT_PCKEY ) ){

        //this pc has a key this house
        SendMessageToPC( oPC, "Your key to this house is valid for "+IntToString( nHours )+" hours." );
        SendMessageToPC( oPC, "You will be able to access this house until the end of reset, even if you don't have enough hours left." );

        SetLocalString( oDoorIn, RNT_PCKEY, sOwnerPCKEY );

        nTaken   = TRUE;
        nConnect = TRUE;
    }
    else{

        SendMessageToPC( oPC, "Debug: ds_rental_locked: Door has another owner, no target house, and you don't have a key." );
        return;
    }

    //door isn't (properly) linked yet. Only owners and people with a key can create a connection
    if ( nConnect ) {

        SendMessageToPC( oPC, "Debug: ds_rental_locked: Creating connection." );

        oHouse = CreateConnection( oPC, oDoorIn, sOwnerPCKEY, nIsOwner );

        if ( GetIsObjectValid( oHouse ) ){

            //open
            nOpen = TRUE;
        }
        else{

            //no house available atm
            SendMessageToPC( oPC, "At this moment there isn't an interior area available." );
            return;
        }

        nTaken = TRUE;
    }

    if ( nOpen && GetLocalInt( oHouse, RNT_LAYOUT_APPLIED ) == FALSE ){

        SendMessageToPC( oPC, "Debug: ds_rental_locked: Applying Layout." );

        ApplyLayout( oPC, oHouse, sOwnerPCKEY, nType );
    }

    if ( nTaken && nOpen ){

        //open
        PlayAnimation( ANIMATION_DOOR_OPEN1 );

        DelayCommand( 30.0, PlayAnimation( ANIMATION_DOOR_CLOSE ) );
    }*/
}

