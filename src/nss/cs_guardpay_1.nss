/*  Conversation :: Cordor Guard: Guard Pay: Pay 5000 GP

    --------
    Verbatim
    --------
    This script will pay the designated Guard the designated GP.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    082906  kfw         Initial release.
    ----------------------------------------------------------------------------

*/


/* Includes. */
#include "logger"


/* Constants. */
const string TARGET             = "cs_target";
const int GOLD                  = 5000;


void main( ){

    // Variables.
    object oPC                  = GetPCSpeaker( );
    object oGuard               = GetLocalObject( oPC, TARGET );
    string szPC_name            = GetName( oPC );
    string szGuard_name         = GetName( oGuard );


    // Pay the Guard GOLD amount.
    GiveGoldToCreature( oGuard, GOLD );
    // Notify them.
    SendMessageToPC( oPC, "- You've payed " + szGuard_name + " " + IntToString( GOLD ) + " gold pieces, for Guard Duty. -" );
    SendMessageToPC( oGuard, "- You've been payed " + IntToString( GOLD ) + " gold pieces, by " + szPC_name + ", for Guard Duty. -" );
    // Keep a tab.
    LogInfo( "cs_guardpay_1", "|Cordor Guard Duty Pay| Details: "                   +
                szPC_name + " payed " + IntToString( GOLD ) + " gold pieces to "    +
                szGuard_name + ".|" );

    return;

}
