/*  Amia Control Panel [ACP] :: Summon & Paralyze :: Summon & Paralyze Player From Inputted Player Name

    --------
    Verbatim
    --------
    This script will summon and paralyze the designated player from her player name (or partial one).

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    070106  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes. */
#include "cs_inc_leto"
#include "logger"

void main( ){

    // Variables.
    object oVault           = OBJECT_SELF;
    object oPC              = GetPCSpeaker( );
    location lDest          = GetLocation( GetWaypointByTag( "wp_treasurevault" ) );

    string szCharacterName  = GetLocalString( oVault, STORAGE_VARIABLE_1 );


    // Cycle the player list.
    object oPC_list         = GetFirstPC( );
    string szPC_list_name   = GetName( oPC_list );

    while( GetIsObjectValid( oPC_list ) ){

        if( TestStringAgainstPattern( "****" + szCharacterName + "****", szPC_list_name ) )
            break;

        oPC_list            = GetNextPC( );
        szPC_list_name      = GetName( oPC_list );

    }


    // Player acquired, Summon & Paralyze.
    if( GetIsObjectValid( oPC_list ) ){

        // Summon.
        AssignCommand( oPC_list, JumpToLocation( lDest ) );

        // Paralyze in 1 second.
        DelayCommand(
            1.0,
            ApplyEffectToObject(
                DURATION_TYPE_PERMANENT,
                EffectLinkEffects(
                    EffectCutsceneParalyze( ),
                    EffectVisualEffect( VFX_DUR_PARALYZE_HOLD ) ),
                oPC_list ) );

    }

    return;

}
