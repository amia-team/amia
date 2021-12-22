/*  Amia :: DM Item :: Platinum Wand :: Give : Exotic Subrace: Aquatic Elf

    --------
    Verbatim
    --------
    This script makes the targeted player a Aquatic Elf.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    082106  kfw         Initial release.
    20071118  Disco       Using inc_ds_records now
    ------------------------------------------------------------------
*/

//includes
#include "inc_ds_records"
#include "nwnx_creature"


void main( ){

    // Variables.
    object oDM                      = GetPCSpeaker( );
    object oPC                      = GetLocalObject( oDM, "jump_flight_target" );

    object oWidget                  = GetItemPossessedBy( oPC, "flight" );

    string szDM_GameSpy             = GetPCPlayerName( oDM );
    string szPC_GameSpy             = GetPCPlayerName( oPC );
    string szPC_CharName            = GetName( oPC );
    string szModification           = "";


    // Notify
    SendMessageToPC( oDM, "You've added Flight to " + szPC_CharName + "!" );

    DelayCommand( 5.0, NWNX_Creature_AddFeat( oPC, 1209) );


    /*  CHARACTER MODIFICATION  , Shifter protection.*/
    if( szModification != "" && !GetIsPolymorphed( oPC ) ){

        //freeze player
        effect eFreeze = EffectCutsceneImmobilize();
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eFreeze, oPC, 4.0 );

        if( GetIsObjectValid( oWidget ) ) {
            DestroyObject( oWidget, 0.1f );
        }

        // Track and Report modification entry for Security purposes.
        // Variables.
        string szPlayerName     = GetPCPlayerName( oPC );
        string szCharacterName  = GetName( oPC );

        // Notify the Player.
        SendMessageToPC( oPC, "You will be booted for Flight to be added to your feat list." );

        // Update the character.
        ExportSingleCharacter( oPC );
        BootPC( oPC, "Flight added." );
    }
}
