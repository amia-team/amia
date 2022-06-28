//This script it to add the wolf lycan feat to the player

#include "inc_ds_records"
#include "nwnx_creature"


void main( )
{

    // Variables.
    object oPC                      = GetPCSpeaker( );
    object oTarget                   = GetObjectByTag("ds_pckey");

        {
    DelayCommand( 5.0, NWNX_Creature_AddFeat( oPC, 1249) );
    SetLocalInt(oTarget, "lycanapproved", 1);
    SetLocalInt(oPC, "Prereq_Lycan", 1);
                {

              // Track and Report modification entry for Security purposes.
              // Variables.
           string szPlayerName     = GetPCPlayerName( oPC );
           string szCharacterName  = GetName( oPC );

              // Notify the Player.
              SendMessageToPC( oPC, "You will be booted for wolf lycan to be added to your feat list." );

              // Update the character.
              ExportSingleCharacter( oPC );
              DelayCommand( 10.0, BootPC( oPC, "Lycan feat added" ));
                }
        }
}
