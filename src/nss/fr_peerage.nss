/////////////////////////////////////////////////////////////////////////////////////////////////
//This script it to add the peerage feat to the player                                         //
//                                                                                             //
//created by Frozen-ass                                                                        //
//date: 28-06-2022                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////

#include "inc_ds_records"
#include "nwnx_creature"


void main( )
{

    // Variables.
    object oPC                      = GetPCSpeaker( );
    object oTarget                  = GetObjectByTag("ds_pckey");

        {
    DelayCommand( 5.0, NWNX_Creature_AddFeat( oPC, 1255) );
                {

              // Track and Report modification entry for Security purposes.
              // Variables.
           string szPlayerName     = GetPCPlayerName( oPC );
           string szCharacterName  = GetName( oPC );

              // Notify the Player.
              SendMessageToPC( oPC, "You will be booted for chicken lycan to be added to your feat list." );

              // Update the character.
              ExportSingleCharacter( oPC );
              DelayCommand( 10.0, BootPC( oPC, "Werechicken infection added, we weep for humanity" ));
                }
        }
}
