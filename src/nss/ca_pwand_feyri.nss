/*  Amia :: DM Item :: Platinum Wand :: Give : Exotic Subrace: Fey'ri

    --------
    Verbatim
    --------
    This script makes the targeted player a Fey'ri.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    082106  kfw         Initial release.
    20071118  Disco       Using inc_ds_records now
    20110319  PoS       Fey'ri are allowed now!
    ------------------------------------------------------------------
*/

//includes
#include "inc_ds_records"
#include "cs_inc_leto"

/* Constants */
const string TARGET                 = "c_pwand_target";

void main( ){

    // Variables.
    object oDM                      = GetPCSpeaker( );
    object oPC                      = GetLocalObject( oDM, TARGET );

    if ( !GetIsObjectValid( GetPCKEY( oPC ) ) ){

        SendMessageToPC( oDM, "Creating PCKEY on PC." );
        SendMessageToPC( oPC, "Creating PCKEY." );

        object oKey = CreatePCKEY( oPC );

        FinishExport( oPC, oKey );
    }

    string szDM_GameSpy             = GetPCPlayerName( oDM );
    string szPC_GameSpy             = GetPCPlayerName( oPC );
    string szPC_CharName            = GetName( oPC );

    // Notify
    SendMessageToPC( oDM, "- You've made " + szPC_CharName + " a Fey'ri!" );
    SendMessageToPC( oPC, "- Stay put, you will be transformed into an Fey'ri!" );

    // Makes the targeted player a Fey'ri.
    DelayCommand( 1.0, SetPCKEYValue( oPC, SUBRACE_AUTHORIZED, TRUE ) );
    DelayCommand( 1.0, SetPCKEYValue( oPC, "ds_subrace_activated", 1 ) );
    DelayCommand( 1.0, SetPCKEYValue( oPC, "ds_done", 4 ) );
    DelayCommand( 3.0, AddFeyriAbilitiesToBicFile( oPC ) );
    return;
}
