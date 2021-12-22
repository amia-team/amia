/*  Amia :: DM Item :: Platinum Wand :: Remove : Wings

    --------
    Verbatim
    --------
    This script removes a player's existing Wings.

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


    // Removes existing wing from the player.
    SetCreatureWingType( CREATURE_WING_TYPE_NONE, oPC );

    // Notify the DM.
    SendMessageToPC( oDM, "- You removed " + szPC_CharName + "'s Wings!" );
    // Notify the player.
    SendMessageToPC( oPC, "- You've had your Wings removed by DM " + szDM_GameSpy + "!" );

    return;

}
