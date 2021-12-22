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

    object oWidget                  = GetItemPossessedBy( oPC, "shadowport" );

    string szDM_GameSpy             = GetPCPlayerName( oDM );
    string szPC_GameSpy             = GetPCPlayerName( oPC );
    string szPC_CharName            = GetName( oPC );
    int nShadowdancerLevel          = GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oPC );
    int nHasShadowJump1             = GetHasFeat( 1207, oPC );
    int nHasShadowJump2             = GetHasFeat( 1208, oPC );
    string szModification           = "";

    if( nHasShadowJump1 || nHasShadowJump2 ) {
        SendMessageToPC( oDM, "You will need to remove Shadow Jump from " + szPC_CharName + " first!" );
        return;
    }

    // Notify
    SendMessageToPC( oDM, "You've added Shadow Jump to " + szPC_CharName + "!" );

    if( nShadowdancerLevel > 3 && nShadowdancerLevel < 10 ){

        DelayCommand( 5.0, NWNX_Creature_AddFeat( oPC, 1207) );
    }

    else if( nShadowdancerLevel > 9 ){

        DelayCommand( 5.0, NWNX_Creature_AddFeat( oPC, 1208) );
    }

    /*  CHARACTER MODIFICATION  , Shifter protection.*/
    if( szModification != "" && !GetIsPolymorphed( oPC ) ){

        //freeze player
        effect eFreeze = EffectCutsceneImmobilize();
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eFreeze, oPC, 4.0 );

        if( GetIsObjectValid( oWidget ) ) {
            DestroyObject( oWidget, 0.1f );
        }

        // Notify the Player.
        SendMessageToPC( oPC, "You will be booted so that Shadow Jump will appear in your feat list." );

        // Update the character.
        ExportSingleCharacter( oPC );
        BootPC( oPC, "Shadow Jump Added");
    }
}
