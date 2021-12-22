/*  Amia :: DM Item :: Platinum Wand :: Give : Red Glowy Eyes.

    --------
    Verbatim
    --------
    This script gives Red Glowy Eyes to a player.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    082006  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "amia_include"

/* Constants */
const string TARGET                 = "c_pwand_target";

void main( ){

    // Variables.
    object oDM                      = GetPCSpeaker( );
    string szDM_GameSpy             = GetPCPlayerName( oDM );
    object oPC                      = GetLocalObject( oDM, TARGET );
    string szPC_GameSpy             = GetPCPlayerName( oPC );
    string szPC_CharName            = GetName( oPC );


    // Gives Green Glowy Eyes to a player.
    CreateItemOnObject( "cs_glowy_eyes1", oPC );


    // Notify the DM.
    SendMessageToPC( oDM, "- You gave " + szPC_CharName + " some Red Glowy Eyes!" );
    // Notify the player.
    SendMessageToPC( oPC, "- Well-done! You've been given some Red Glowy Eyes by DM " + szDM_GameSpy + "!" );

    return;

}
