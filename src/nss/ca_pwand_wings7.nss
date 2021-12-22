/*  Amia :: DM Item :: Platinum Wand :: Give : Red Dragon Wings.

    --------
    Verbatim
    --------
    This script gives Red Dragon Wings to a player.

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


    // Removes existing tail from the player.
    SetCreatureWingType( CREATURE_WING_TYPE_DRAGON, oPC );

    // Notify the DM.
    SendMessageToPC( oDM, "- You gave " + szPC_CharName + " some Red Dragon Wings!" );
    // Notify the player.
    SendMessageToPC( oPC, "- Well-done! You've been given some Red Dragon Wings by DM " + szDM_GameSpy + "!" );

    return;

}
