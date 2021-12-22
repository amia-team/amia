/*  Amia :: DM Item :: Platinum Wand :: Remove : Tail

    --------
    Verbatim
    --------
    This script removes a player's existing Tail.

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
    SetCreatureTailType( CREATURE_TAIL_TYPE_NONE, oPC );

    // Notify the DM.
    SendMessageToPC( oDM, "- You removed " + szPC_CharName + "'s Tail!" );
    // Notify the player.
    SendMessageToPC( oPC, "- You've had your Tail removed by DM " + szDM_GameSpy + "!" );

    return;

}
