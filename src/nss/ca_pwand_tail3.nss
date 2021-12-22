/*  Amia :: DM Item :: Platinum Wand :: Give : Devil Tail

    --------
    Verbatim
    --------
    This script gives a Devil Tail to a player.

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
    SetCreatureTailType( CREATURE_TAIL_TYPE_DEVIL, oPC );


    // Notify the DM.
    SendMessageToPC( oDM, "- You gave " + szPC_CharName + " a Devil Tail!" );
    // Notify the player.
    SendMessageToPC( oPC, "- Well-done! You've been given a Devil Tail by DM " + szDM_GameSpy + "!" );

    return;

}
