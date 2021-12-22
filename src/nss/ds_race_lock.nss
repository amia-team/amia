//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_race_lock
//group:   utilities
//used as: locks a door for a specific race or allows just one race to pass
//         see cs_inc_xp for race integers
//date:    july 05 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "cs_inc_xp"
#include "inc_ds_records"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
int IsBanned( object oPC, object oDoor );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oDoor        = OBJECT_SELF;
    object oPC          = GetClickingObject();
    object oGuard1;
    object oGuard2;
    object oKey         = GetItemPossessedBy( oPC, "GateException" );
    int nInitialised    = GetLocalInt( oDoor, "init" );
    object oHelmet = GetItemInSlot( INVENTORY_SLOT_HEAD, oPC );


    // Guards nearby speaking
    if ( nInitialised == 0 ){

        oGuard1       = GetNearestObjectByTag( "gate_guard1", oPC );
        oGuard2       = GetNearestObjectByTag( "gate_guard2", oPC );

        DelayCommand( 0.1, SetLocalObject( oDoor, "guard1", oGuard1 ) );
        DelayCommand( 0.2, SetLocalObject( oDoor, "guard2", oGuard2 ) );
        DelayCommand( 0.3, SetLocalInt( oDoor, "init", 1 ) );
    }
    else{

        oGuard1       = GetLocalObject( oDoor, "guard1" );
        oGuard2       = GetLocalObject( oDoor, "guard2" );

    }

    // Checking for Helmet
    if ( (oHelmet != OBJECT_INVALID) && (GetHiddenWhenEquipped(oHelmet) == FALSE)){

        DelayCommand( 0.0, AssignCommand( oGuard1, SpeakString( "Show your face!" ) ) );

        return;
    }


    if ( IsBanned( oPC, oDoor ) && !GetIsObjectValid( oKey ) ){

        DelayCommand( 0.0, AssignCommand( oGuard2, SpeakString( "Begone, this door will stay closed for you!" ) ) );

     }
     else{

        DelayCommand( 0.0, AssignCommand( oGuard1, SpeakString( "Continue your travels..." ) ) );
        DelayCommand( 1.0, AssignCommand( oGuard2, SpeakString( "Yes, yes... *moves to open the gate...*" ) ) );
        DelayCommand( 2.0, PlayAnimation( ANIMATION_DOOR_OPEN1 ) );
        DelayCommand( 10.0, ActionCloseDoor( oDoor ) );
     }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------
int IsBanned( object oPC, object oDoor ){

    if ( GetIsPolymorphed( oPC ) || GetIsPossessedFamiliar( oPC ) ){

        SendMessageToPC( oPC, "You will never pass this gate while being polymorphed or possessing a familiar." );
        return TRUE;
    }

    int nRacialType     = GetRacialType(oPC);
    string sSubRace     = GetSubRace(oPC);
    int nRaceSlot       = GetLocalInt( oDoor, "race_"+IntToString( nRacialType ) );

    if(sSubRace != "")
    {
      nRaceSlot       = GetLocalInt( oDoor, "race_"+sSubRace);
    }

    string sType        = GetLocalString( oDoor, "type" );
    string sInsignia    = GetLocalString( GetInsigniaB( oPC ), "HouseName" );
    int nBindpoint      = GetLocalInt( oDoor, "ds_bindpoint" );
    object oItem        = GetItemPossessedBy( oPC, GetLocalString( oDoor, "ItemName" ) );

    // This is checking key for door
    if( GetLocalString( oDoor, "ItemName" ) != "" )
    {
        if( GetIsObjectValid( oItem ) ) {

            return FALSE;
        }
    }

    // Old faction stuff checks, HasBindPoint doesnt work anymore
    if ( nBindpoint && HasBindPoint( oPC, nBindpoint ) ){

        return FALSE;
    }

    // Maybe faction related
    if ( GetLocalInt( oDoor, sInsignia ) == 1 ){

        return FALSE;
    }

    //
    if ( GetLocalInt( oPC, GetTag( oDoor ) ) == 1 ){

        return FALSE;
    }


    if (  nRaceSlot == 1 && sType == "ban" ){

        //not allowed to enter
        return TRUE;
    }

    if (  nRaceSlot == 0 && sType == "allow"  ){

        //not allowed to enter
        return TRUE;
    }

    return FALSE;
}
