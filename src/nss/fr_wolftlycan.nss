//This script it to add the wolf lycan feat to the player

#include "inc_ds_records"
#include "nwnx_creature"


void main( ){

    // Variables.
    object oPC                      = GetPCSpeaker( );

    DelayCommand( 5.0, NWNX_Creature_AddFeat( oPC, 1249) );

    {
    object oTarget;

    // Get the PC who is in this conversation.
    object oPC = GetPCSpeaker();

    // Set a local integer.
    oTarget = GetObjectByTag("ds_pckey");
    SetLocalInt(oTarget, "Lycanapproved", 1);

    // Set a local integer.
    SetLocalInt(oPC, "Prereq_Lycan", 1);
}

        // Track and Report modification entry for Security purposes.
        // Variables.
        string szPlayerName     = GetPCPlayerName( oPC );
        string szCharacterName  = GetName( oPC );

        // Notify the Player.
        SendMessageToPC( oPC, "You will be booted for wolf lycan to be added to your feat list." );

        // Update the character.
        ExportSingleCharacter( oPC );
        DelayCommand( 10.0, BootPC( oPC, "Flight added." ));
    }
