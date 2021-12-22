/*  Amia :: DM Item :: Platinum Wand :: Give : Bone Tail

    --------
    Verbatim
    --------
    This script gives a Bone Tail to a player.

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
    SetCreatureTailType( CREATURE_TAIL_TYPE_BONE, oPC );

    // Notify the DM.
    SendMessageToPC( oDM, "- You gave " + szPC_CharName + " a Bone Tail!" );
    // Notify the player.
    SendMessageToPC( oPC, "- Well-done! You've been given a Bone Tail by DM " + szDM_GameSpy + "!" );

    return;

}
